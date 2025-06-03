terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc9"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }

    ansible = {
      source  = "ansible/ansible"
      version = "1.3.0"
    }
  }
}