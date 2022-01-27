Kernel upgrade
Updating the Linux kernel on Gentoo GNU/Linux.
linux, linux kernel, gentoo, update, upgrade, gentoo-sources, initramfs, grub

## Prerequisites

> Do not sync more than once a day. It puts a lot of stress on Gentoo servers. 

Make sure you've recently synced the Gentoo ebuild repository: `emerge --sync gentoo`

Ensure that `/boot` is mounted: `mount /boot`

## Steps

1. Backup current kernel configuration somewhere. For example: `cp /usr/src/linux/.config ~/$(uname -r).config`,
* Emerge new kernel: `emerge -uDN --with-bdeps=y sys-kernel/gentoo-sources`,
* List available kernel versions: `eselect kernel list`,
* Choose the latest kernel version (this will update the `/usr/src/linux` symlink): `eselect kernel set NUMBER`,
* `cd` into `/usr/src/linux`,
* Copy previously backed up kernel configuration to the `/usr/src/linux` directory and name it `.config`,
* Update config automatically using `make olddefconfig`, which sets missing values to their defaults,
* Finally compile and install the kernel (-jN specifies the number of parallel jobs, set N to the number of threads): `make -j4 && make modules_install && make install`
* Generate initramfs: `genkernel --kernel-config=.config initramfs`,
	* Add `--lvm` and `--luks` options if you use disk encryption and/or logical volumes,
	* Add `--compress-initramfs-type=TYPE` option if you use a nonstandard initramfs compression type,
* Update bootloader configuration. If you use GRUB run `grub-mkconfig -o /boot/grub/grub.cfg`.
