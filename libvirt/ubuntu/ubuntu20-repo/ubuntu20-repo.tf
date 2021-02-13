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

resource "libvirt_volume" "ubuntu20-qcow2" {
  name   = "ubuntu20.qcow2"
  source = "http://kickstart.onsrud.home/focal-server-cloudimg-amd64.img"
  format = "qcow2"
}

# extra disk for the repo itself
resource "libvirt_volume" "data-qcow2" {
  name   = "data-qcow2"
  pool   = "default"
  format = "qcow2"
  size   = 100000000000
}

data "template_file" "user_data" {
  template = file("${path.module}/user-data")
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "ubunt20-commoninit.iso"
  user_data = data.template_file.user_data.rendered
}

resource "libvirt_domain" "db1" {
  name   = "ubuntu20"
  memory = "2048"
  vcpu   = 2

  network_interface {
    macvtap = "eno1"
  }

  disk {
    volume_id = libvirt_volume.ubuntu20-qcow2.id
  }

  disk {
    volume_id = libvirt_volume.data-qcow2.id
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


