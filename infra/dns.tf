locals {
  dns_vm_count = 1
}


resource "proxmox_virtual_environment_vm" "dns_vm" {
  count       = local.dns_vm_count
  name        = format("dns-%02s", count.index + 1)
  description = "Managed by OpenTofu"
  tags        = ["opentofu", "dns", "debian", "debian-13"]
  node_name   = var.proxmox_node

  stop_on_destroy = true

  agent {
    enabled = true
  }

  clone {
    vm_id = var.proxmox_template_vm_id
  }

  cpu {
    cores = 1
  }

  memory {
    dedicated = 512
  }

  initialization {
    ip_config {
      ipv4 {
        address = "192.168.20.${10 + count.index}/24"
        gateway = var.gateway
      }
    }

    dns {
      servers = ["1.1.1.1"]
    }

    user_account {
      username = var.provision_user
      password = "password"
      keys     = [tls_private_key.provision_ssh_key.public_key_openssh]
    }
  }

  disk {
    size      = 20
    interface = "virtio0"
    iothread  = true
    discard   = "on"
  }

  network_device {
    bridge  = "vmbr0"
    vlan_id = var.vlan_id
    model   = "virtio"
  }

  operating_system {
    type = "l26"
  }
}

resource "ansible_host" "dns" {
  depends_on = [proxmox_virtual_environment_vm.dns_vm]

  count = local.dns_vm_count

  groups = ["dns", ]

  name = proxmox_virtual_environment_vm.dns_vm[count.index].name
  variables = {
    ansible_host                 = proxmox_virtual_environment_vm.dns_vm[count.index].ipv4_addresses[1][0]
    ansible_user                 = var.provision_user
    ansible_ssh_private_key_file = abspath(local_sensitive_file.provision_ssh_key.filename)
  }
}
