variable "proxmox_host" {
  default = "192.168.1.178"
}

variable "proxmox_api_user" {

}

variable "proxmox_api_password" {
  sensitive = true
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