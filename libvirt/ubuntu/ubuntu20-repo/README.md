
# Create an Ubuntu 20 repo on a VM using Terraform and libvirt


Edit meta-data and user-data to match your requirements. The included password is "password" for the lab user.
Enter an ssh key into the  user_data for convenience.

Generate the commoninit.iso image using the following command:

genisoimage -output ubuntu20-commoninit.iso -V cidata -r -J user-data meta-data


kwikbit@marshall-Inspiron-N5050:~$ find .local/share/terraform/
.local/share/terraform/
.local/share/terraform/plugins
.local/share/terraform/plugins/registry.terraform.io
.local/share/terraform/plugins/registry.terraform.io/dmacvicar
.local/share/terraform/plugins/registry.terraform.io/dmacvicar/libvirt
.local/share/terraform/plugins/registry.terraform.io/dmacvicar/libvirt/0.6.3
.local/share/terraform/plugins/registry.terraform.io/dmacvicar/libvirt/0.6.3/linux_amd64
.local/share/terraform/plugins/registry.terraform.io/dmacvicar/libvirt/0.6.3/linux_amd64/terraform-provider-libvirt




Helpful documentation and training:

* [Libvirt package tricks](https://github.com/dmacvicar/terraform-provider-libvirt/issues/747)
