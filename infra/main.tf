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

module "k3s_server_vms" {
  source = "./modules/qemu_vms"

  vm_count = 3
  vm_prefix = "k3s-server-"

  provision_user = var.provision_user
  provision_ssh_public_key = tls_private_key.provision_ssh_key.public_key_openssh

  proxmox_node = var.proxmox_node

  base_ip = "192.168.1.200"
  gateway = var.gateway
}

module "k3s_agent_vms" {
  source = "./modules/qemu_vms"

  vm_count = 0
  vm_prefix = "k3s-agent-"

  provision_user = var.provision_user
  provision_ssh_public_key = tls_private_key.provision_ssh_key.public_key_openssh

  proxmox_node = var.proxmox_node

  base_ip = "192.168.1.210"
  gateway = var.gateway
}

# Add the created VMs to Ansible inventory
resource "ansible_host" "k3s_server" {
  depends_on = [module.k3s_server_vms]
  for_each = module.k3s_server_vms.vm
  groups = ["k3s", "k3s_server"]

  name = each.key

  variables = {
    ansible_host = each.value.ipv4_address
    ansible_user = var.provision_user
    ansible_ssh_private_key_file = abspath(local_sensitive_file.provision_ssh_key.filename)
  }
}