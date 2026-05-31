# Provider credentials. The fingerprint + private key pair authenticate this
# Terraform run as an API user; generate them once in OCI Console under
# Identity > Users > <you> > API Keys. The four values below are also what
# `oci setup config` writes to ~/.oci/config.

variable "tenancy_ocid" {
  description = "OCID of the OCI tenancy (root compartment)."
  type        = string
}

variable "user_ocid" {
  description = "OCID of the API user this run authenticates as."
  type        = string
}

variable "fingerprint" {
  description = "Fingerprint of the API signing key uploaded for the user."
  type        = string
}

variable "private_key_path" {
  description = "Filesystem path to the PEM private key matching the fingerprint."
  type        = string
}

variable "region" {
  description = "OCI region identifier (e.g. us-ashburn-1, us-phoenix-1, uk-london-1). Pick the region where you signed up — Always Free quota is per-region."
  type        = string
}

variable "compartment_ocid" {
  description = "OCID of the compartment to drop the VM and its network into. Use the tenancy OCID to land in the root compartment, or create a dedicated compartment in OCI Console first."
  type        = string
}

# Workload inputs.

variable "ssh_public_key" {
  description = "SSH public key (the full `ssh-ed25519 AAAA... user@host` line) that will be injected into the instance's authorized_keys."
  type        = string
}

variable "ssh_ingress_cidr" {
  description = "CIDR allowed to reach port 22. Default 0.0.0.0/0 works but you should narrow this to your own IP — `curl ifconfig.me` then append /32. Public SSH on a wide-open CIDR is a magnet for bots even with key auth."
  type        = string
  default     = "0.0.0.0/0"
}

variable "instance_name" {
  description = "Display name + hostname for the instance."
  type        = string
  default     = "linuxbenchhub-ampere"
}

# Always-Free quota: 4 OCPUs total + 24 GB RAM total across up to 4 Ampere A1
# instances per region. Defaults below claim the full allocation in one VM,
# which gives PTS the most room to run.

variable "ocpus" {
  description = "OCPUs for the Ampere A1 Flex instance. Free tier ceiling is 4 OCPUs total across all your A1 instances."
  type        = number
  default     = 4
}

variable "memory_in_gbs" {
  description = "Memory in GB for the Ampere A1 Flex instance. Free tier ceiling is 24 GB total across all your A1 instances."
  type        = number
  default     = 24
}

variable "boot_volume_size_in_gbs" {
  description = "Boot volume size in GB. Free tier covers up to 200 GB of block storage across all volumes; 50 GB is plenty for PTS + cached test artifacts."
  type        = number
  default     = 50
}
