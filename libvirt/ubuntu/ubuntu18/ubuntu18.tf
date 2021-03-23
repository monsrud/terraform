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

resource "libvirt_volume" "os_image_ubuntu" {
  name   = "os_image_ubuntu"
  source = "http://kickstart.onsrud.home/bionic-server-cloudimg-amd64.img"
  pool = "default"
}

resource "libvirt_volume" "disk_ubuntu_resized" {
  name           = "disk"
  base_volume_id = libvirt_volume.os_image_ubuntu.id
  pool           = "default"
  size           = 9361393152
}

data "template_file" "user_data" {
  template = file("${path.module}/user-data")
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "ubunt18-foo-commoninit.iso"
  user_data = data.template_file.user_data.rendered
}

resource "libvirt_domain" "db1" {
  name   = "ubuntu18-foo"
  memory = "8192"
  vcpu   = 4
  qemu_agent = true

  network_interface {
    network_name = "bridge0"
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.disk_ubuntu_resized.id
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


