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

resource "libvirt_volume" "centos7-qcow2" {
  name   = "centos7.qcow2"
  source = "http://kickstart.onsrud.home/CentOS-7-x86_64-GenericCloud.qcow2"
  format = "qcow2"
}

data "template_file" "user_data" {
  template = file("${path.module}/user-data")
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "commoninit.iso"
  user_data = data.template_file.user_data.rendered
}

resource "libvirt_domain" "testlab" {
  name   = "testlab"
  memory = "2048"
  vcpu   = 2

  network_interface {
    macvtap = "eno1"
  }

  disk {
    volume_id = libvirt_volume.centos7-qcow2.id
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

terraform {
  required_version = ">= 0.13"
}
