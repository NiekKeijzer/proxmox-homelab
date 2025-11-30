source "proxmox-iso" "debian" {
    
    # Proxmox Settings
    proxmox_url = "https://${var.proxmox_host}:${var.proxmox_port}/api2/json"
    username    = var.proxmox_api_token_id
    token       = var.proxmox_api_token_secret
    insecure_skip_tls_verify = true  # Set to true for self-signed certificates
    node        = var.proxmox_node
    pool = var.proxmox_pool

    # VM General Settings
    vm_id                = "${var.vm_id}"
    vm_name              = "${var.vm_name}"
    template_description = "${title(replace(trimsuffix(var.vm_name, "-template"), "-", " "))} Packer Template -- Created: ${formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())}"
    tags = join(";", var.vm_tags)
    os                   = "l26"
    machine              = "q35"
    cores                = "2"
    memory               = "2048"
    bios                 = "ovmf"
    qemu_agent           = true
    scsi_controller      = "virtio-scsi-pci"
    
    efi_config {
        efi_storage_pool  = "${var.storage_pool}"
        pre_enrolled_keys = true
        efi_format        = "raw"
        efi_type          = "4m"
    }

    boot_iso {
        iso_storage_pool = var.iso_storage_pool
        iso_download_pve = true
        iso_target_path = "${var.vm_name}"
        iso_url          = var.iso_url
        iso_checksum     = var.iso_checksum
        unmount  = true
    }

    disks {
        disk_size = "16G"
        format = "raw"
        storage_pool = "${var.storage_pool}"
        type = "virtio"
    }

    network_adapters {
        bridge = "vmbr0"
        model  = "virtio"
        firewall = false
    } 

    # VM Cloud-Init Settings
    cloud_init              = true
    cloud_init_storage_pool = "${var.storage_pool}"


    # Increase the task timeout to allow enough time for a large ISO download.
    task_timeout = "10m"

    # PACKER Boot Commands
    boot_command = [
        "c<wait>",
        "linux /install.amd/vmlinuz auto-install/enable=true priority=critical ",
        "DEBIAN_FRONTEND=text preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg noprompt<enter>",
        "initrd /install.amd/initrd.gz<enter>",
        "boot<enter>"
    ]

    # PACKER Autoinstall Settings
    http_directory = "packer-templates/debian/http" 

    ssh_username = "root"
    ssh_password = "packer"
    ssh_timeout = "20m"
}