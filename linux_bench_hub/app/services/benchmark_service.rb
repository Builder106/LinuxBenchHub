require 'azure_mgmt_compute'
require 'azure_mgmt_network'
require 'azure_mgmt_resources'
require 'net/ssh'
require 'timeout'

class BenchmarkService
  def self.run_benchmark(performance_benchmark)
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

    # Define resource group and VM parameters
    resource_group_name = 'LinuxBenchHub'
    vm_name = "benchmark-vm-#{SecureRandom.hex(4)}"
    vm_size = 'Standard_B1s'

    # Map the selected Linux OS to the corresponding image reference
    image_reference = case performance_benchmark.linux_os
                      when 'Ubuntu'
                        { publisher: 'Canonical', offer: 'UbuntuServer', sku: '18.04-LTS', version: 'latest' }
                      when 'Fedora'
                        { publisher: 'Fedora', offer: 'Fedora-Cloud', sku: '32', version: 'latest' }
                      when 'Debian'
                        { publisher: 'Debian', offer: 'debian-10', sku: '10', version: 'latest' }
                      else
                        raise "Unsupported Linux OS: #{performance_benchmark.linux_os}"
                      end

    location ||= 'eastus'
    raise "Location cannot be nil" if location.nil?
    # Create resource group
    resource_client.resource_groups.create_or_update(resource_group_name, { location: location })

    # Create virtual network and subnet
    vnet_params = {
      location: location,
      address_space: { address_prefixes: ['10.0.0.0/16'] }
    }
    vnet = network_client.virtual_networks.create_or_update(resource_group_name, 'vnet', vnet_params)

    subnet_params = {
      address_prefix: '10.0.0.0/24'
    }
    subnet = network_client.subnets.create_or_update(resource_group_name, 'vnet', 'subnet', subnet_params)

    # Create public IP address
    public_ip_params = {
      location: location,
      public_ip_allocation_method: 'Dynamic'
    }
    public_ip = network_client.public_ipaddresses.create_or_update(resource_group_name, 'publicIP', public_ip_params)

    # Create network interface
    nic_params = {
      location: location,
      ip_configurations: [{
        name: 'ipconfig1',
        public_ipaddress: public_ip,
        subnet: subnet
      }]
    }
    nic = network_client.network_interfaces.create_or_update(resource_group_name, 'nic', nic_params)

    # Create virtual machine
    vm_params = {
      location: location,
      hardware_profile: {
        vm_size: vm_size
      },
      storage_profile: {
        image_reference: image_reference,
        os_disk: {
          name: 'osdisk',
          caching: 'ReadWrite',
          create_option: 'FromImage',
          disk_size_gb: 30
        }
      },
      os_profile: {
        computer_name: vm_name,
        admin_username: 'azureuser',
        admin_password: 'Password123!'
      },
      network_profile: {
        network_interfaces: [{
          id: nic.id,
          primary: true
        }]
      }
    }
    vm = compute_client.virtual_machines.create_or_update(resource_group_name, vm_name, vm_params)

    # Get the public IP address of the VM
    public_ip = network_client.public_ipaddresses.get(resource_group_name, 'publicIP')
    vm_ip = public_ip.ip_address

    # Wait for the VM to be ready
    sleep 60

    # Connect to the VM and run the benchmark
    Net::SSH.start(vm_ip, 'azureuser', password: 'Password123!') do |ssh|
      # Install Phoronix Test Suite
      ssh.exec!("sudo apt-get update && sudo apt-get install -y phoronix-test-suite")

      # Run the selected benchmarks
      performance_benchmark.benchmarks.each do |benchmark|
        case benchmark
        when 'CPU'
          ssh.exec!("echo 'y' | phoronix-test-suite batch-benchmark c-ray")
        when 'Memory'
          ssh.exec!("echo 'y' | phoronix-test-suite batch-benchmark tinymembench")
        when 'Network'
          ssh.exec!("echo 'y' | phoronix-test-suite batch-benchmark aircrack-ng")
        else
          raise "Unsupported benchmark: #{benchmark}"
        end
      end
    end
  end
end