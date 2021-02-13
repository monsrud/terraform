
# Create a VM using Terraform and libvirt


Use Terraform to create a virtual machines on libvirt.

Download the latest release of the libvirt provider and install it.

* [Terraform Provider](https://github.com/dmacvicar/terraform-provider-libvirt/releases/)


For versions of terraform after 0.13, the provider goes in this directory:

/home/myusername/.local/share/terraform/
└── plugins
    └── registry.terraform.io
        └── dmacvicar
            └── libvirt
                └── 0.6.3
                    └── linux_amd64
                        └── terraform-provider-libvirt


In the tf file specify the provider to use:

terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.3"
    }
  }
}

# use the provider
provider "libvirt" {
  uri = "qemu:///virty.onsrud.home"
}


Enable tcp for libvirtd.

Add "--listen" option to libvirtd args in /etc/sysconfig/libvirtd.

Edit /etc/libvirt/libvirtd.conf and ensure the following:
listen_tcp = 1
listen_tls = 1
tcp_port = "16509"
listen_addr = "0.0.0.0"


Edit meta-data and user-data to match your requirements. The included password is "password" for the lab user.
Enter an ssh key into the  user_data for convenience.

Generate the commoninit.iso image using the following command:

genisoimage -output commoninit.iso -V cidata -r -J user-data meta-data

terraform init
terraform plan 
terraform apply

Helpful documentation and training:

* [Libvirt package tricks](https://github.com/dmacvicar/terraform-provider-libvirt/issues/747)
