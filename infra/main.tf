resource "tls_private_key" "provision_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

locals {
  generated_files = "${path.root}/generated"
}

resource "local_sensitive_file" "provision_ssh_key" {
  filename = "${local.generated_files}/id_rsa"
  content  = tls_private_key.provision_ssh_key.private_key_openssh
}
