
# Make a clone of a vmware virtual machine from a stored template.
# This is vsphere with 3 hosts connected and not clustered.

provider "vsphere" {
  user                 = "lab@vsphere.local"
  password             = "lab"
  vsphere_server       = "photon-machine.local"
  allow_unverified_ssl = true
}

variable "servername" {
  description = "Server Name"
}

data "vsphere_datacenter" "dc" {
  name = "Datacenter"
}

data "vsphere_datastore" "datastore" {
  name          = "test"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  # Use govc to figre out the resource pool
  #name = "/Datacenter/host/esx1.local/Resources"
  #name = "/Datacenter/host/esx2.local/Resources"
  name          = "/Datacenter/host/esx3.local/Resources"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network1" {
  name          = "VLAN 80"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network2" {
  name          = "VLAN 1691"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = "ubuntu18-thin-esx3-template"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {

  name             = var.servername
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  memory   = 2048

  guest_id  = data.vsphere_virtual_machine.template.guest_id
  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network1.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  network_interface {
    network_id   = data.vsphere_network.network2.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = var.servername
        domain    = "test.lab"
      }
      network_interface {}
      network_interface {}
    }
  }

}

output "ip" {
   value = vsphere_virtual_machine.vm.*.default_ip_address
} 
