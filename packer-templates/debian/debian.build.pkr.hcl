
build {
    sources = ["source.proxmox-iso.debian"]

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox 
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

    # Remove DHCP configuration from network interfaces
    provisioner "shell" {
        inline = [
            "sed -i '/allow-hotplug ens18/d' /etc/network/interfaces",
            "sed -i '/iface ens18 inet dhcp/d' /etc/network/interfaces"
        ]
    }

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox 
    provisioner "file" {
        source = "packer-templates/debian/files/99-pve.cfg"
        destination = "/tmp/99-pve.cfg"
    }

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox 
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