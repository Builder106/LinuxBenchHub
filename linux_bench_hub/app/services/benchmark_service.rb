require 'azure_mgmt_compute'
require 'azure_mgmt_network'
require 'azure_mgmt_resources'
require 'net/ssh'
require 'timeout'
require 'securerandom'

class BenchmarkService
  def self.run_benchmark(performance_benchmark)
    begin
      # Configure Azure credentials
      client_id = ENV['AZURE_CLIENT_ID']
      client_secret = ENV['AZURE_CLIENT_SECRET']
      tenant_id = ENV['AZURE_TENANT_ID']
      subscription_id = ENV['AZURE_SUBSCRIPTION_ID']

      # Ensure location is set
      location = 'eastus'

      # Create Azure clients
      provider = MsRestAzure::ApplicationTokenProvider.new(tenant_id, client_id, client_secret)
      credentials = MsRest::TokenCredentials.new(provider)

      compute_client = Azure::Compute::Profiles::Latest::Mgmt::Client.new(credentials: credentials)
      compute_client.subscription_id = subscription_id

      network_client = Azure::Network::Profiles::Latest::Mgmt::Client.new(credentials: credentials)
      network_client.subscription_id = subscription_id

      resource_client = Azure::Resources::Profiles::Latest::Mgmt::Client.new(credentials: credentials)
      resource_client.subscription_id = subscription_id

      # Define unique resource group and VM parameters
      unique_id = SecureRandom.hex(4)
      resource_group_name = "LinuxBenchHub-#{unique_id}"
      vm_name = "benchmark-vm-#{unique_id}"
      vnet_name = "vnet-#{unique_id}"
      subnet_name = "subnet-#{unique_id}"
      public_ip_name = "publicIP-#{unique_id}"
      nic_name = "nic-#{unique_id}"
      vm_size = 'Standard_B1s'

      # Define image reference
      image_reference = Azure::Compute::Profiles::Latest::Mgmt::Models::ImageReference.new
      image_reference.publisher = 'Canonical'
      image_reference.offer = 'UbuntuServer'
      image_reference.sku = '18.04-LTS'
      image_reference.version = 'latest'

      # Create resource group
      resource_group_params = Azure::Resources::Profiles::Latest::Mgmt::Models::ResourceGroup.new
      resource_group_params.location = location
      puts "Creating resource group with location: #{location}"
      Timeout.timeout(300) do
        resource_client.resource_groups.create_or_update(resource_group_name, resource_group_params)
      end
      puts "Resource group created: #{resource_group_name}"

      # Create virtual network
      vnet_params = Azure::Network::Profiles::Latest::Mgmt::Models::VirtualNetwork.new
      vnet_params.location = location
      vnet_params.address_space = Azure::Network::Profiles::Latest::Mgmt::Models::AddressSpace.new
      vnet_params.address_space.address_prefixes = ['10.0.0.0/16']
      puts "Creating virtual network: #{vnet_name}"
      Timeout.timeout(300) do
        network_client.virtual_networks.create_or_update(resource_group_name, vnet_name, vnet_params)
      end
      puts "Virtual network created: #{vnet_name}"

      # Create subnet
      subnet_params = Azure::Network::Profiles::Latest::Mgmt::Models::Subnet.new
      subnet_params.address_prefix = '10.0.0.0/24'
      puts "Creating subnet: #{subnet_name}"
      subnet = Timeout.timeout(300) do
        network_client.subnets.create_or_update(resource_group_name, vnet_name, subnet_name, subnet_params)
      end
      puts "Subnet created: #{subnet_name}"

      # Create Network Security Group
      nsg_params = Azure::Network::Profiles::Latest::Mgmt::Models::NetworkSecurityGroup.new
      nsg_params.location = location
      nsg_name = "nsg-#{unique_id}"
      puts "Creating Network Security Group: #{nsg_name}"
      Timeout.timeout(300) do
        network_client.network_security_groups.create_or_update(resource_group_name, nsg_name, nsg_params)
      end
      puts "Network Security Group created: #{nsg_name}"

      # Reuse existing public IPs
      puts "Listing existing public IPs in resource group: #{resource_group_name}"
      existing_public_ips = network_client.public_ipaddresses.list(resource_group_name)
      public_ip = existing_public_ips.find { |ip| ip.name == public_ip_name }

      unless public_ip
        # Create new public IP address
        public_ip_params = Azure::Network::Profiles::Latest::Mgmt::Models::PublicIPAddress.new
        public_ip_params.location = location
        public_ip_params.public_ipallocation_method = 'Static'
        public_ip_params.dns_settings = Azure::Network::Profiles::Latest::Mgmt::Models::PublicIPAddressDnsSettings.new
        public_ip_params.dns_settings.domain_name_label = "vm-#{unique_id}"
        puts "Creating public IP address: #{public_ip_name}"
        public_ip = Timeout.timeout(300) do
          network_client.public_ipaddresses.create_or_update(resource_group_name, public_ip_name, public_ip_params)
        end
        puts "Public IP address created: #{public_ip_name}"
      else
        puts "Reusing existing public IP address: #{public_ip_name}"
      end

      # Create network interface
      nic_params = Azure::Network::Profiles::Latest::Mgmt::Models::NetworkInterface.new
      nic_params.location = location
      nic_params.ip_configurations = [
        Azure::Network::Profiles::Latest::Mgmt::Models::NetworkInterfaceIPConfiguration.new.tap do |ip_config|
          ip_config.name = 'ipconfig1'
          ip_config.public_ipaddress = public_ip
          ip_config.subnet = Azure::Network::Profiles::Latest::Mgmt::Models::Subnet.new.tap do |s|
            s.id = subnet.id
          end
        end
      ]
      puts "Creating network interface: #{nic_name}"
      nic = Timeout.timeout(300) do
        network_client.network_interfaces.create_or_update(resource_group_name, nic_name, nic_params)
      end
      puts "Network interface created: #{nic_name}"

      # Open port 5901 for VNC
      security_rule = Azure::Network::Profiles::Latest::Mgmt::Models::SecurityRule.new
      security_rule.name = "Allow-VNC"
      security_rule.description = "Allow VNC inbound traffic"
      security_rule.protocol = 'Tcp'
      security_rule.direction = 'Inbound'
      security_rule.priority = 1001
      security_rule.source_address_prefix = '*'
      security_rule.source_port_range = '*'
      security_rule.destination_address_prefix = '*'
      security_rule.destination_port_range = '5901'
      security_rule.access = 'Allow'
      puts "Creating security rule: #{security_rule.name}"
      Timeout.timeout(300) do
        network_client.security_rules.create_or_update(
          resource_group_name,
          nsg_name,
          security_rule.name,
          security_rule
        )
      end
      puts "Security rule created: #{security_rule.name}"

      # Create virtual machine
      vm_params = Azure::Compute::Profiles::Latest::Mgmt::Models::VirtualMachine.new
      vm_params.location = location
      vm_params.hardware_profile = Azure::Compute::Profiles::Latest::Mgmt::Models::HardwareProfile.new
      vm_params.hardware_profile.vm_size = vm_size

      vm_params.storage_profile = Azure::Compute::Profiles::Latest::Mgmt::Models::StorageProfile.new
      vm_params.storage_profile.image_reference = image_reference
      vm_params.storage_profile.os_disk = Azure::Compute::Profiles::Latest::Mgmt::Models::OSDisk.new
      vm_params.storage_profile.os_disk.name = 'osdisk'
      vm_params.storage_profile.os_disk.caching = 'ReadWrite'
      vm_params.storage_profile.os_disk.create_option = 'FromImage'
      vm_params.storage_profile.os_disk.disk_size_gb = 30

      vm_params.os_profile = Azure::Compute::Profiles::Latest::Mgmt::Models::OSProfile.new
      vm_params.os_profile.computer_name = vm_name
      vm_params.os_profile.admin_username = 'azureuser'
      vm_params.os_profile.admin_password = 'Password123!'

      vm_params.network_profile = Azure::Compute::Profiles::Latest::Mgmt::Models::NetworkProfile.new
      vm_params.network_profile.network_interfaces = [
        Azure::Compute::Profiles::Latest::Mgmt::Models::NetworkInterfaceReference.new.tap do |nic_ref|
          nic_ref.id = nic.id
          nic_ref.primary = true
        end
      ]
      puts "Creating virtual machine: #{vm_name}"
      Timeout.timeout(600) do
        compute_client.virtual_machines.create_or_update(resource_group_name, vm_name, vm_params)
      end
      puts "Virtual machine created: #{vm_name}"

      # Get the public IP address of the VM
      puts "Retrieving public IP address for VM: #{vm_name}"
      public_ip = network_client.public_ipaddresses.get(resource_group_name, public_ip_name)
      vm_ip = public_ip.ip_address
      puts "VM Public IP Address: #{vm_ip}"

      # Update the performance_benchmark with vm_ip
      performance_benchmark.update(vm_ip: vm_ip)

      # Wait for the VM to be ready
      puts "Waiting for VM to initialize..."
      sleep 60

      # Connect to the VM and run the benchmark
      puts "Connecting to VM via SSH to run benchmarks..."
      Timeout.timeout(600) do
        Net::SSH.start(vm_ip, 'azureuser', password: 'Password123!') do |ssh|
          # Define package installation commands based on Linux OS
          install_commands = case performance_benchmark.linux_os.downcase
                            when 'ubuntu', 'debian'
                              "sudo apt-get update && sudo apt-get install -y phoronix-test-suite ubuntu-desktop tightvncserver"
                            when 'fedora'
                              "sudo dnf install -y phoronix-test-suite @workstation-agent tightvnc-server"
                            else
                              raise "Unsupported Linux OS: #{performance_benchmark.linux_os}"
                            end
          
          # Install Phoronix Test Suite and GUI/VNC server
          ssh.exec!(install_commands)
          puts "Installed necessary packages for #{performance_benchmark.linux_os}"

          # Set up VNC server
          ssh.exec!("echo 'Password123!' | vncpasswd -f > ~/.vnc/passwd")
          ssh.exec!("chmod 600 ~/.vnc/passwd")
          ssh.exec!("tightvncserver :1 -geometry 1280x800 -depth 24")
          puts "Configured TightVNC Server"

          # Define supported benchmarks
          supported_benchmarks = {
            'CPU' => "c-ray",
            'Memory' => "tinymembench",
            'Network' => "aircrack-ng"
          }

          # Run the selected benchmarks
          performance_benchmark.benchmarks.each do |benchmark|
            next if benchmark.strip.empty? # Skip empty strings

            test = supported_benchmarks[benchmark]
            if test
              puts "Running benchmark: #{benchmark} using test: #{test}"
              ssh.exec!("echo 'y' | phoronix-test-suite batch-benchmark #{test}")
              puts "Completed benchmark: #{benchmark}"
            else
              raise "Unsupported benchmark: #{benchmark}"
            end
          end
        end
      end
      puts "Benchmarking completed successfully."

    rescue Timeout::Error => e
      puts "Operation timed out: #{e.message}"
      raise
    rescue StandardError => e
      puts "Error running benchmark: #{e.message}"
      puts e.backtrace.join("\n")
      raise
    ensure
      begin
        puts "Starting cleanup of Azure resources."
        Timeout.timeout(300) do
          compute_client.virtual_machines.delete(resource_group_name, vm_name)
          network_client.network_interfaces.delete(resource_group_name, nic_name)
          network_client.public_ipaddresses.delete(resource_group_name, public_ip_name)
          network_client.subnets.delete(resource_group_name, vnet_name, subnet_name)
          network_client.virtual_networks.delete(resource_group_name, vnet_name)
          network_client.network_security_groups.delete(resource_group_name, nsg_name)
          resource_client.resource_groups.delete(resource_group_name)
        end
        puts "Cleanup completed successfully."
      rescue Timeout::Error => e
        puts "Cleanup operation timed out: #{e.message}"
      rescue StandardError => e
        puts "Error during cleanup: #{e.message}"
      end
    end
  end
end