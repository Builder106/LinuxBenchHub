require 'azure_mgmt_compute'
require 'azure_mgmt_network'
require 'azure_mgmt_resources'

class BenchmarkService
  def self.run_benchmark(name, linux_os)
    # Configure Azure credentials
    client_id = ENV['AZURE_CLIENT_ID']
    client_secret = ENV['AZURE_CLIENT_SECRET']
    tenant_id = ENV['AZURE_TENANT_ID']
    subscription_id = ENV['AZURE_SUBSCRIPTION_ID']

    # Create Azure clients
    provider = MsRestAzure::ApplicationTokenProvider.new(tenant_id, client_id, client_secret)
    credentials = MsRest::TokenCredentials.new(provider)

    compute_client = Azure::Compute::Profiles::Latest::Mgmt::Client.new(credentials)
    compute_client.subscription_id = subscription_id

    network_client = Azure::Network::Profiles::Latest::Mgmt::Client.new(credentials)
    network_client.subscription_id = subscription_id

    resource_client = Azure::Resources::Profiles::Latest::Mgmt::Client.new(credentials)
    resource_client.subscription_id = subscription_id

    # Define resource group and VM parameters
    resource_group_name = 'your-resource-group'
    vm_name = "benchmark-vm-#{SecureRandom.hex(4)}"
    location = 'eastus'
    vm_size = 'Standard_B1s'

    # Map the selected Linux OS to the corresponding image reference
    image_reference = case linux_os
                      when 'Ubuntu'
                        { publisher: 'Canonical', offer: 'UbuntuServer', sku: '18.04-LTS', version: 'latest' }
                      when 'Fedora'
                        { publisher: 'Fedora', offer: 'Fedora-Cloud', sku: '32', version: 'latest' }
                      when 'Debian'
                        { publisher: 'Debian', offer: 'debian-10', sku: '10', version: 'latest' }
                      else
                        raise "Unsupported Linux OS: #{linux_os}"
                      end

    # Create resource group
    resource_client.resource_groups.create_or_update(resource_group_name, { location: location })

    # Create virtual network and subnet
    vnet_params = {
      location: location,
      address_space: { address_prefixes: ['10.0.0.0/16'] }
    }
    network_client.virtual_networks.create_or_update(resource_group_name, 'vnet', vnet_params)

    subnet_params = { address_prefix: '10.0.0.0/24' }
    network_client.subnets.create_or_update(resource_group_name, 'vnet', 'subnet', subnet_params)

    # Create public IP address
    public_ip_params = {
      location: location,
      public_ipallocation_method: 'Dynamic'
    }
    public_ip = network_client.public_ipaddresses.create_or_update(resource_group_name, 'publicIP', public_ip_params)

    # Create network interface
    nic_params = {
      location: location,
      ip_configurations: [{
        name: 'ipconfig1',
        public_ipaddress: public_ip,
        subnet: { id: subnet_params[:id] }
      }]
    }
    nic = network_client.network_interfaces.create_or_update(resource_group_name, 'nic', nic_params)

    # Create virtual machine
    vm_params = {
      location: location,
      hardware_profile: { vm_size: vm_size },
      storage_profile: {
        image_reference: image_reference,
        os_disk: {
          name: 'osdisk',
          caching: 'ReadWrite',
          create_option: 'FromImage',
          managed_disk: { storage_account_type: 'Standard_LRS' }
        }
      },
      os_profile: {
        computer_name: vm_name,
        admin_username: 'azureuser',
        admin_password: 'Password123!' # Replace with a secure password
      },
      network_profile: {
        network_interfaces: [{ id: nic.id }]
      }
    }
    compute_client.virtual_machines.create_or_update(resource_group_name, vm_name, vm_params)

    # Optionally, you can add code to monitor the instance and retrieve the benchmark results
  end
end