variable "proxmox_host" {
  default = "192.168.1.178"
}

variable "proxmox_port" {
  default = 8006
  type = number
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  sensitive = true
  type = string
}

variable "proxmox_node" {
  default = "pve01"
}

variable "provision_user" {
  type = string
  default = "mrrobot"
}

variable "gateway" {
  type = string
  default = "192.168.1.1"
}