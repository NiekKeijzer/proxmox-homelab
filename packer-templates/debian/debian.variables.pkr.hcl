# Proxmox VE variables for Packer templates
variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}

variable "proxmox_host" {
  type = string
}

variable "proxmox_port" {
  type = number
  default = 8006
}

variable "proxmox_node" {
  type = string
}

variable "proxmox_pool" {
  type    = string
  default = "packer-vms"
}


variable "storage_pool" {
  type    = string
  default = "local-lvm"
}

variable "iso_storage_pool" {
  type    = string
  default = "iso-store"
}


variable "iso_url" {
  type    = string
  default = "https://cdimage.debian.org/debian-cd/current/amd64/iso-dvd/debian-13.1.0-amd64-DVD-1.iso"
}

variable "iso_checksum" {
  type    = string
  default = "sha256:4f7b3e2f4d2e8e4f5c3e6e8f7b3e2f4d2e8e4f5c3e6e8f7b3e2f4d2e8e4f5c3e6"
}

variable "vm_id" {
  type    = string
  default = "9001"
}

variable "vm_name" {
  type    = string
  default = "debian-template"
}

variable "vm_tags" {
  type    = list(string)
  default = ["debian", "template", "packer"]
}