
# Create a VM using Terraform and libvirt


Use Terraform to create a Centos 7 cloud vm on libvirt.

Edit meta-data and user-data to match your requirements. The included password is "password" for the lab user.
Ssh keys are provided for convenience.


Generate the commoninit.iso image using the following command:

genisoimage -output commoninit.iso -V cidata -r -J user-data meta-data

Helpful documentation and training:

* [Cloud-Init: The good parts](https://www.hashicorp.com/resources/cloudinit-the-good-parts)
* [Cloud-Init](https://cloud-init.io/)
* [Provision Infrastructure with Cloud-Init](https://learn.hashicorp.com/tutorials/terraform/cloud-init)
* [Cloud-Init Documentation](https://cloudinit.readthedocs.io/en/latest/)
* [Cloud-Init : Bluilding Clouds One Linux Box at a Time](https://cloudinit.readthedocs.io/en/latest/)
