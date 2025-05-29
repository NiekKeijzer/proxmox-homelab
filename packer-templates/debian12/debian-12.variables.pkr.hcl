variable "iso_url" {
  type    = string
  default = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.11.0-amd64-netinst.iso"
}

variable "iso_checksum" {
  type    = string
  default = "sha512:0921d8b297c63ac458d8a06f87cd4c353f751eb5fe30fd0d839ca09c0833d1d9934b02ee14bbd0c0ec4f8917dde793957801ae1af3c8122cdf28dde8f3c3e0da"
}

variable "iso_storage_pool" {
  type    = string
  default = "iso-store"
}

variable "template_vmid" {
  type        = string
  default     = "9100"
  description = "Proxmox Template ID"
}

variable "cpu_type" {
  type    = string
  default = "kvm64"
}

variable "cores" {
  type    = string
  default = "2"
}

variable "disk_format" {
  type    = string
  default = "raw"
}

variable "disk_size" {
  type    = string
  default = "16G"
}

variable "storage_pool" {
  type    = string
  default = "local-lvm"
}

variable "memory" {
  type    = string
  default = "2048"
}

variable "network_vlan" {
  type    = string
  default = "10"
}

variable "proxmox_api_user" {
  type = string
}

variable "proxmox_api_password" {
  type      = string
  sensitive = true
}


variable "proxmox_host" {
  type = string
}

variable "proxmox_node" {
  type = string
}