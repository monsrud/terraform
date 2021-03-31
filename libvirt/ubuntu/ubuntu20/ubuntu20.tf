terraform {
  required_version = ">= 0.14"
}

terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.3"
    }
  }
}

provider "libvirt" {
  uri = "qemu+ssh://root@virty.onsrud.home/system"
}

resource "libvirt_volume" "os_image_ubuntu20" {
  name   = "os_image_ubuntu20"
  source = "http://kickstart.onsrud.home/focal-server-cloudimg-amd64.img"
  #format = "qcow2"
  pool           = "default"
}


resource "libvirt_volume" "os_image_ubuntu20_resized" {
  name           = "os_image_ubuntu20_resized"
  base_volume_id = libvirt_volume.os_image_ubuntu20.id
  pool           = "default"
  size           = 93613931520
}


data "template_file" "user_data" {
  template = file("${path.module}/user-data")
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "ubuntu20-commoninit.iso"
  user_data = data.template_file.user_data.rendered
  pool  = "default"
}

resource "libvirt_domain" "db1" {
  name   = "ubuntu20"
  memory = "4096"
  vcpu   = 4
  qemu_agent = true

  network_interface {
    network_name = "bridge0"
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.os_image_ubuntu20_resized.id
  }

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}


output "ipv4" {
  value = libvirt_domain.db1.*.network_interface.0.addresses
}


