provider "proxmox" {
  endpoint      = "https://${var.proxmox_host}:${var.proxmox_port}/api2/json"
  api_token = "${var.proxmox_api_token_id}=${var.proxmox_api_token_secret}"
  insecure = true
}