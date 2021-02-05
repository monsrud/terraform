
# Create a VM using Terraform and libvirt


Use Terraform to create a Centos 7 cloud vm on libvirt.

Edit meta-data and user-data to match your requirements. The included password is "password" for the lab user.
Ssh keys are provided for convenience.

Generate the commoninit.iso image using the following command:

genisoimage -output commoninit.iso -V cidata -r -J user-data meta-data

Helpful documentation and training:

* [Libvirt package tricks](https://github.com/dmacvicar/terraform-provider-libvirt/issues/747)
