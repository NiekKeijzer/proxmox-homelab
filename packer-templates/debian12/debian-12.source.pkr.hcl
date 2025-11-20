source "proxmox-iso" "debian-12" {
  proxmox_url = "https://${var.proxmox_host}:${var.proxmox_port}/api2/json"
  username    = var.proxmox_api_token_id
  token       = var.proxmox_api_token_secret
  insecure_skip_tls_verify = true  # Set to true for self-signed certificates
  node        = var.proxmox_node

  template_name        = var.template_name
  template_description = "Debian 12 Bookworm Packer Template -- Created: ${formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())}"
  vm_id                = var.template_vmid
  tags                  = "debian;debian-12;bookworm;packer;template"

  os                      = "l26"
  cpu_type                = var.cpu_type
  sockets                 = "1"
  cores                   = var.cores
  memory                  = var.memory
  machine                 = "q35"
  bios                    = "seabios"
  scsi_controller         = "virtio-scsi-pci"
  qemu_agent              = true
  cloud_init              = true
  cloud_init_storage_pool = var.storage_pool

  network_adapters {
    bridge   = "vmbr0"
    firewall = true
    model    = "virtio"
    # vlan_tag = var.network_vlan
  }

  disks {
    disk_size    = var.disk_size
    format       = var.disk_format
    storage_pool = var.storage_pool
    type         = "scsi"
  }

  iso_storage_pool = var.iso_storage_pool
  iso_url          = var.iso_url
  iso_checksum     = var.iso_checksum

  unmount_iso = true

  http_directory = "packer-templates/debian12/http"
  http_port_min  = 8100
  http_port_max  = 8100

  boot      = "order=scsi0;ide2;net0"
  boot_wait = "10s"
  boot_command = ["<esc><wait>auto url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<enter>"]

  ssh_username = "root"
  ssh_password = "packer"
  ssh_timeout  = "20m"
}