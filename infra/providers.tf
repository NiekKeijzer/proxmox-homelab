provider "proxmox" {
  pm_tls_insecure = true
  pm_api_url      = "https://${var.proxmox_host}:8006/api2/json"
  pm_user         = var.proxmox_api_user
  pm_password     = var.proxmox_api_password
}
