build {
  sources = ["source.proxmox-iso.debian-12"]

  # Install cloud-init and qemu-guest-agent (and other utilities)
  provisioner "shell" {
    inline = [
      "apt update",
      "apt -y upgrade",
      "apt -y install qemu-guest-agent cloud-init sudo curl",
      "systemctl enable qemu-guest-agent",
      "systemctl start qemu-guest-agent"
    ]
  }

  # Clean up the machine for cloud-init
  provisioner "shell" {
    inline = [
      "sudo rm /etc/ssh/ssh_host_*",
      "sudo truncate -s 0 /etc/machine-id",
      "sudo apt -y autoremove --purge",
      "sudo apt -y clean",
      "sudo apt -y autoclean",
      "sudo cloud-init clean",
      "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
      "sudo sync"
    ]
  }
}