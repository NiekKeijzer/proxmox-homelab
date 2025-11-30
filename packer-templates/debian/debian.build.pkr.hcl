
build {
    sources = ["source.proxmox-iso.debian"]

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #1
    provisioner "shell" {
        inline = [
            "rm /etc/ssh/ssh_host_*",
            "truncate -s 0 /etc/machine-id",
            "apt -y autoremove --purge 2> /dev/null",
            "apt -y clean 2> /dev/null",
            "apt -y autoclean 2> /dev/null",
            "cloud-init clean",
            "rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
            "sync"
        ]
    }

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #2
    provisioner "file" {
        source = "packer-templates/debian/files/99-pve.cfg"
        destination = "/tmp/99-pve.cfg"
    }

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #3
    provisioner "shell" {
        inline = [ "sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg" ]
    }

    provisioner "shell" {
        inline = [ "sed -i '/cdrom/d' /etc/apt/sources.list" ]
    }
    
    provisioner "file" {
        source = "packer-templates/debian/files/debian.sources"
        destination = "/etc/apt/sources.list.d/debian.sources"
    }
}