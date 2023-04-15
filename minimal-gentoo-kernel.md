# A minimal Gentoo kernel for your hardware

[ **NB** The use of `#` as the prompt in examples indicates that the commands should be run as the superuser. ]

The ["Configuring the Linux kernel" chapter](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Kernel) of the Gentoo Handbook describes a number of ways of configuring and installing a kernel:

* manually working through all the kernel configuration options, changing settings as necessary;
* using `genkernel` to compile and install a kernel with broad hardware support;
* compiling and installing the latest Gentoo-patched kernel ('distribution kernel'); or
* directly installing the latest precompiled Gentoo-patched kernel ('distribution kernel').

But what if you just want the minimal kernel and kernel config for a functioning system?

Here are the steps.

```
# emerge gentoo-kernel-bin
```

This will install the latest precompiled Gentoo kernel. Restart the system and boot from that kernel. If all the system's hardware is detected and successfully functioning, proceed to the next step. Otherwise, determine the cause of any issues and resolve them before continuing.

Note that any pluggable devices intended to be used on the system should be plugged in, so that the relevant kernel modules get loaded. The `sys-kernel/modprobed-db` package in the GURU repository can be used to create a list of modules that were needed over time:

> Modprobed-db simply logs every module ever probed on the target system to a text-based database ($XDG_CONFIG_HOME/modprobed-db) which can be read directly by "make localmodconfig"

-- https://github.com/graysky2/modprobed-db

Next:

```
# emerge gentoo-sources
```

This will install the Gentoo-patched sources for the precompiled kernel. It should also change the `/usr/src/linux/` symlink to point to the appropriate sources for that kernel version, e.g. `linux-5.16.20-gentoo-dist`. Confirm this via the output of `eselect`:

```
# eselect kernel list
```

If necessary, use `eselect` to ensure `/usr/src/linux/` points to the correct version of the kernel sources.

Next:

```
# cd /usr/src/linux/
# make localmodconfig
```

The second line will automatically create a modules-based config, compiling only the modules the running system has actually loaded (and/or their dependencies). An alternative `make` target is `localyesconfig`, which will compile the necessary hardware support directly into the kernel, rather than into modules.

If the `/etc/portage/savedconfig/sys-kernel` directory does not already exist, create it, then copy the new config into that directory, with the name `gentoo-kernel`:

```
# mkdir -p /etc/portage/savedconfig/sys-kernel/
# cp .config /etc/portage/savedconfig/sys-kernel/gentoo-kernel
```

Be sure to include the leading `.` in front of `config`!

The `/etc/portage/savedconfig/sys-kernel/gentoo-kernel` file will be used when compiling and installing the kernel.

Now add the `savedconfig` USE flag for `sys-kernel/gentoo-kernel` in the appropriate place in `/etc/portage/`. If no USE flags have yet been specified:

```
# mkdir /etc/portage/package.use/
# echo 'sys-kernel/gentoo-kernel savedconfig' > /etc/portage/package.use/kernel
```

Remove the `-bin` kernel package:

```
# emerge -c gentoo-kernel-bin
```

Compile and install the kernel:

```
# emerge gentoo-kernel
```

Building a `localmodconfig` kernel can substantially reduce compile times.

In addition to compiling and installing the kernel, the `emerge` process will also create an initramfs for the kernel, using `dracut`.

Finally, assuming GRUB is the system bootloader, and that kernels are stored in `/boot/grub/`, refresh the GRUB menu to include the new kernel and initramfs:

```
# grub-mkconfig -o /boot/grub/grub.cfg
```

You should now be able to boot with the new kernel.
