# LinuxBenchHub — Oracle Cloud Always-Free Ampere A1 Flex instance.
#
# Provisions a single aarch64 VM that the benchmark capture pipeline can SSH
# into to run Phoronix Test Suite natively on Arm. Stays within the OCI free
# tier (4 OCPUs / 24 GB / 200 GB block storage per region, indefinite) so
# `terraform apply` should not produce a bill — but verify your tenancy's
# quota usage page before applying if you have other A1 workloads.

locals {
  # Tag every resource so it's obvious in the OCI console which project owns
  # it, and so a stray `terraform destroy` can be confirmed against the
  # display name.
  resource_prefix = var.instance_name
}

# Pick the first Always-Free-eligible availability domain. Free Ampere A1
# capacity isn't uniformly available across ADs — if `terraform apply` fails
# with "Out of host capacity", change `index = 0` to 1 or 2 and re-run, or
# switch region entirely. Capacity comes and goes; persistence helps.
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

# Latest Canonical Ubuntu 24.04 LTS image for the aarch64 architecture.
# Oracle publishes Ubuntu cloud images directly in the OCI image catalog;
# we filter by OS + version + shape compatibility so the data source returns
# only Arm-compatible images, sorted newest first.
data "oci_core_images" "ubuntu_2404_arm" {
  compartment_id           = var.tenancy_ocid
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "24.04"
  shape                    = "VM.Standard.A1.Flex"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

# --- Network ---

resource "oci_core_vcn" "main" {
  compartment_id = var.compartment_ocid
  cidr_blocks    = ["10.0.0.0/16"]
  display_name   = "${local.resource_prefix}-vcn"
  dns_label      = "lbhvcn"
}

resource "oci_core_internet_gateway" "main" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${local.resource_prefix}-igw"
  enabled        = true
}

resource "oci_core_default_route_table" "main" {
  manage_default_resource_id = oci_core_vcn.main.default_route_table_id

  route_rules {
    network_entity_id = oci_core_internet_gateway.main.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}

resource "oci_core_security_list" "main" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${local.resource_prefix}-sl"

  # Egress: all traffic out. Standard for a host that needs to clone PTS,
  # apt-get install, and curl OpenBenchmarking mirrors.
  egress_security_rules {
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
    stateless        = false
  }

  # Ingress: SSH only, from the configured CIDR. Phoronix outputs leave the
  # host via `scp` in the GitHub Action, so no extra ports are needed.
  ingress_security_rules {
    source      = var.ssh_ingress_cidr
    source_type = "CIDR_BLOCK"
    protocol    = "6" # TCP
    stateless   = false

    tcp_options {
      min = 22
      max = 22
    }
  }
}

resource "oci_core_subnet" "main" {
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_vcn.main.id
  cidr_block          = "10.0.1.0/24"
  display_name        = "${local.resource_prefix}-subnet"
  dns_label           = "lbhsubnet"
  security_list_ids   = [oci_core_security_list.main.id]
  route_table_id      = oci_core_vcn.main.default_route_table_id
  dhcp_options_id     = oci_core_vcn.main.default_dhcp_options_id
  prohibit_public_ip_on_vnic = false
}

# --- Compute ---

resource "oci_core_instance" "ampere" {
  compartment_id      = var.compartment_ocid
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  display_name        = local.resource_prefix
  shape               = "VM.Standard.A1.Flex"

  shape_config {
    ocpus         = var.ocpus
    memory_in_gbs = var.memory_in_gbs
  }

  source_details {
    source_type             = "image"
    source_id               = data.oci_core_images.ubuntu_2404_arm.images[0].id
    boot_volume_size_in_gbs = var.boot_volume_size_in_gbs
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.main.id
    assign_public_ip = true
    hostname_label   = "lbh-ampere"
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    # cloud-init runs once on first boot to install PTS + R + benchmark deps.
    # Re-running `terraform apply` after editing cloud-init.yml will NOT
    # re-run cloud-init on the existing instance — destroy + recreate, or
    # SSH in and re-execute the relevant blocks manually.
    user_data = base64encode(file("${path.module}/cloud-init.yml"))
  }
}
