provider "proxmox" {
  pm_tls_insecure = true
  pm_api_url      = "https://${var.proxmox_host}:${var.proxmox_port}/api2/json"
  pm_api_token_id = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
}
