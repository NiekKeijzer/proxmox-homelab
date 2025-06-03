variable "proxmox_vm_template" {
  type    = string
  default = "pckr-tmpl-debian-12"
}

variable "proxmox_node" {
  type = string
}

variable "provision_user" {
  type = string
}

variable "provision_ssh_public_key" {
  type = string
}

variable "proxmox_iso_storage_pool" {
  type    = string
  default = "iso-store"
}

variable "vm_count" {
  type    = number
  default = 1
}

variable "vm_prefix" {
  type = string
}


variable "vm_cores" {
  type    = number
  default = 2

}

variable "vm_memory" {
  type    = number
  default = 4096
}

variable "vm_node_disk_size" {
  type    = string
  default = "20G"
}

variable "vm_node_storage_pool" {
  type    = string
  default = "local-lvm"
}

variable "base_ip" {
  type = string
}

variable "gateway" {
  type = string
}

