# Using ZFS snapshots and `zfsbootmenu` to bisect a `libvirt` "regression"

*Contributed by @ahesford*

My home desktop is built around an AMD Ryzen 5 3600 CPU and runs Void Linux.
On an SSD, a ZFS pool houses a few Void boot environments: a primary glibc
installation, a duplicate of the glibc environment, and a musl installation
I've been testing. To choose between these boot environments, I use the
excellent [zfsbootmenu](https://github.com/zdykstra/zfsbootmenu), a boot
loader that uses a custom Dracut module and a stock Linux kernel to identify,
manipulate and boot the various environments it finds on ZFS pools. (In the
spirit of full disclosure, I am also an active contributor to the zfsbootmenu
project.) The SSD pool also houses datasets for home directories and other
uses. The home directories are common to all of the ZFS boot environments.

The [zfs-auto-snapshot](https://github.com/zfsonlinux/zfs-auto-snapshot)
utility facilitates a rolling snapshot scheme on the SSD that provides a level
of revision control:

1. "Frequent" snapshots, taken every fifteen minutes, are retained for one
hour.

2. Hourly snapshots are retained for one day.

3. Daily snapshots are retained for one month.

4. Weekly snapshots are retained for eight weeks.

5. Monthly snapshots are retained for a year.

In addition to my SSD pool, a RAID-Z1 of spinning disks provides larger
capacity. The [zrep](http://www.bolthole.com/solaris/zrep/) script provides a
simple means to transmit duplicates of my SSD snapshots to the RAID-Z1 pool.
(On other systems, I also use zrep to propagate snapshots to remote systems
over SSH.) Running every three hours, zrep ensures that my backups are never
too far out of date. Because zrep only prunes snapshots that it creates,
[zfs-prune-snapshots](https://github.com/bahamas10/zfs-prune-snapshots)
provides roll-off behavior for snapshots duplicated on the RAID-Z1 pool.
However, because I have extra capacity in this pool, the retention times for
each of the above categories is double the corresponding value on the SSD.

## A libvirt problem

My system has a rarely used Windows 10 virtual machine running in QEMU/KVM and
managed by libvirt. Yesterday, I started the virtual machine but was presented
with a `KERNEL SECURITY CHECK FAILURE` error that forced the VM into a reboot
loop. The same failure appeared when I tried to boot from the Windows 10
installation ISO; the VM was unusable and, apparently, unrepairable. I created
a new VM to test, and was again unable to boot the Windows 10 installation
image.

## Diagnosis

While experimenting with the musl C library last week, I had successfully
booted the VM to test its functionality in the other boot environment.
Rebooting into the musl boot environment, a task made trivial with
zfsbootmenu, I found the VM worked as expected. The musl boot environment was
slightly out of date, so I updated its packages, including a move from
libvirt-6.4.0 to libvirt-6.5.0. After the upgrade, the VM stopped functioning.

Rebooted into a second glibc boot environment that hadn't been touched in two
weeks, I found the VM (installed in a QEMU user session) fully functional.
This suggested that the problem lay with the system software or configuration
and nothing specific to the VM.

From within zfsbootmenu, I duplicated a week-old snapshot of my primary glibc
boot environment. ZFS does not allow writes to snapshots; thus, snapshots must
be promoted to full datasets if they are to be used as boot environments. If I
intended to retain this duplicate indefinitely, I would have relied on the
default behavior of zfsbootmenu to create a full duplicate, which would make
it fully independent of the original boot environment. If I intended this
snapshot to replace the original environment, I could have used zfsbootmenu to
efficiently clone the snapshot to a writable dataset and "promoted" it.
Because I am only using the clone for tracking down a bug, I instructed
zfsbootmenu to clone the snapshot without promoting it.

In the week-old clone of the glibc boot environment, my Windows VM booted
without issue. The task was now to bisect the daily snapshots between last
week and today to identify exactly when my VM became unusable. Four reboots
and clones later, and I discovered that the problem appeared between July 3
and July 4. From within the up-to-date boot environment, a `zfs diff` command
revealed several package updates. The libvirt update from 6.4.0 to 6.5.0
indeed happened that day. 

## Zeroing in

A closer look at `zfs diff` between the last working snapshot and first broken
snapshot showed a number of libvirt-related configuration changes. Files in
`/etc` changed by the update contained only trivial changes in the comments;
nothing there would influence libvirt operation. However, some of the
configuration XML in `/usr/share/libvirt` had also changed and warranted
closer inspection.

On a hunch, I changed the CPU type in my VM from `host-model` (which tended to
report an AMD EPYC-IBPB CPU to the guest) to `EPYC`. The resulting VM booted
as expected. Changing the CPU to an explicit `EPYC-IBPB` produced a working
VM. Restoring the CPU to `host-model` broke the virtual machine. Comparing the
qemu command lines between broken and working configurations revealed a large
number of CPU flags enabled on the `host-model` CPU that were not enabled with
either `EPYC` or `EPYC-IBPB` explicit configurations.

To better isolate any offending CPU features, I did a recursive `diff` into
`/usr/share/libvirt` from the last working snapshot to the fist broken
snapshot and found that the map `x86_features.xml` included about a dozen new
CPU flags. After cross-referencing these changes with the features enabled by
libvirt when launching qemu, I discovered that five or six of the new features
are now enabled by default. Disabling and re-enabling the features one-by-one
allowed me to isolate the problem to enabling of `amd-stibp` and `npt`. After
restoring my `host-model` configuration but disabling the offending features,
the VM functioned as expected.

## Conclusion

The right tools make arduous tasks tractable. Without multiple boot
environments, identifying a libvirt upgrade from last week would have taken
considerably more time. Without ZFS snapshots, identifying the offending
change as a collection of newly enabled CPU feature flags would have been
difficult.

Diagnosis and resolution of this issue could have been accomplished with
lesser tools, but the complexity of managing the alternatives probably would
have prevented me from accumulating the necessary historical information.
Just as ZFS greatly simplifies manipulation of volumes and datasets,
zfsbootmenu greatly simplifies manipulation of boot environments. For Linux,
there are no finer alternatives.

