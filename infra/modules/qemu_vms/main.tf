# This seems like a rather crude way to assign IPs to VMs, but it works for now.
# Maybe in the future a dedicated IP management system can be created to handle
# IP assignments more dynamically and avoid hardcoding IPs in the module.
locals {
  # Convert base IP to a list of 4 octets
  base_ip_octets = split(".", var.base_ip)
  base_ip_last   = tonumber(local.base_ip_octets[3])
  base_ip_prefix = join(".", slice(local.base_ip_octets, 0, 3))

  vm_ips = {
    for i in range(var.vm_count) :
    "${var.vm_prefix}${i}" => "${local.base_ip_prefix}.${local.base_ip_last + i}"
  }
}

resource "proxmox_vm_qemu" "vm" {
  count = var.vm_count

  name = "${var.vm_prefix}${format("%02d", count.index + 1)}"
  desc = "Node managed by OpenTofu"

  clone       = var.proxmox_vm_template
  full_clone  = true
  target_node = var.proxmox_node

  cpu {
    cores   = var.vm_cores
    sockets = 1
  }

  memory = var.vm_memory

  disks {
    scsi {
      scsi0 {
        disk {
          size    = var.vm_node_disk_size
          storage = var.vm_node_storage_pool
        }
      }
    }
    ide {
      ide3 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
  }

  network {
    id       = 0
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = true
  }

  # Cloud init configuration
  ciuser    = var.provision_user
  sshkeys   = var.provision_ssh_public_key
  ipconfig0 = "ip=${local.base_ip_prefix}.${local.base_ip_last + count.index}/24,gw=${var.gateway}"

  # alternatively a cloud-init disk can be used using the proxmox_cloud_init_disk
  # and mounting it to the VM's IDE controller giving more flexibility without
  # having to manage snippets on Proxmox.
  #ide {
  #  ide2 {
  #    cdrom {
  #      iso = proxmox_cloud_init_disk.ci[count.index].id
  #    }
  #  }
  #}
}

output "vm" {
  value = {
    for vm in proxmox_vm_qemu.vm :
    vm.name => {
      ipv4_address = vm.default_ipv4_address
    }
  }
}
