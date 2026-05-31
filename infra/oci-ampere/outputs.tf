output "public_ip" {
  description = "Public IPv4 address assigned to the instance's primary VNIC."
  value       = oci_core_instance.ampere.public_ip
}

output "instance_ocid" {
  description = "OCID of the provisioned instance — useful for `oci compute instance` CLI calls."
  value       = oci_core_instance.ampere.id
}

output "ssh_command" {
  description = "Ready-to-paste SSH command. cloud-init takes ~3–5 minutes after `terraform apply` returns before the host is fully provisioned; if `ssh` hangs, wait and retry."
  value       = "ssh ubuntu@${oci_core_instance.ampere.public_ip}"
}

output "image_id_used" {
  description = "OCID of the Ubuntu 24.04 aarch64 image the instance was launched from. Pin this in tfvars if you want reproducible re-creates."
  value       = data.oci_core_images.ubuntu_2404_arm.images[0].id
}
