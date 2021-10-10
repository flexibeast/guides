# 66 on Void

66 is a collection of system tools built around
[s6](http://skarnet.org/software/s6/) and
[s6-rc](https://skarnet.org/software/s6-rc/), intended to make the
implementation and manipulation of service files easier. The Obarun wiki has [an
introduction](https://wiki.obarun.org/doku.php?id=66intro).

66 manages services within *trees*, which are bundles of services, daemons or
programs. These bundles can run once, all the time, or on-demand, as required.

The tree `boot`, created during installation, initializes the system (setting
hostname and timezone, opening LUKS devices, etc.), and starts
[agetty(8)](https://man.voidlinux.org/agetty.8) on TTYs 1-4.

## Installation

The `boot-66serv` package is not yet available in the Void repos, although there
is a [WIP PR for it](https://github.com/void-linux/void-packages/pull/25743).
Consequently, the package needs to be built with the `xbps-src` utility, using
the contents of that PR. The following uses the
[xi(1)](https://man.voidlinux.org/xtools.1) package installation utility from
the `xtools` package.

```
$ git clone --depth 1 https://github.com/void-linux/void-packages/
$ cd void-packages
$ ./xbps-src binary-bootstrap
$ git remote add mobinmob https://github.com/mobinmob/void-packages/
$ git fetch mobinmob boot-66serv
$ git checkout -b boot-66serv mobinmob/boot-66serv
$ ./xbps-src pkg boot-66serv
# xi boot-66serv
```

## Setup

Create the mandatory tree `boot` using
[66-tree(1)](https://man.voidlinux.org/66-tree.1):

```
# 66-tree -n boot
```

Then use [66-enable(1)](https://man.voidlinux.org/66-enable.1) to enable a
`boot@system` service in the `boot` tree:

```
# 66-enable -C -F -t boot boot@system
```

## Configuration

Configure the boot process with [66-env(1)](https://man.voidlinux.org/66-env.1):

```
# 66-env -t boot boot@system
```

`66-env` opens your configuration in the editor specified by `$EDITOR`. Review
all settings to ensure they are appropriate for your system.

After saving your configuration, apply the changes with `66-enable`:

```
# 66-enable -F -t boot boot@system
```

Add `init=/usr/bin/66` to the [kernel command line](../../kernel.md#cmdline) to
boot with 66 instead of runit.

It is now possible to boot with 66. However, although *CTRL+ALT+DEL* will work,
because the new init will capture it, the `halt`, `reboot`, `shutdown` and
`poweroff` commands will *not* work. This is because these commands are from the
`void-runit` package, and cannot work with 66.

The 66 commands can be used directly by running `/etc/66/halt`,
`/etc/66/reboot`, etc. as `root`. Alternatively, you can symlink them, replacing
the runit commands:

```
# mv /usr/bin/halt /usr/bin/halt.runit
# mv /usr/bin/shutdown /usr/bin/shutdown.runit
# mv /usr/bin/poweroff /usr/bin/poweroff.runit
# mv /usr/bin/reboot /usr/bin/reboot.runit
# ln -s /etc/66/halt /usr/bin/halt
# ln -s /etc/66/shutdown /usr/bin/shutdown
# ln -s /etc/66/poweroff /usr/bin/poweroff
# ln -s /etc/66/reboot /usr/bin/reboot
```

However, note that the above will create similar problems when booting with
runit. If you wish to return to booting with runit, do the following:

```
# rm /usr/bin/{halt,shutdown,poweroff,reboot}
# mv /usr/bin/halt.runit /usr/bin/halt
# mv /usr/bin/shutdown.runit /usr/bin/shutdown
# mv /usr/bin/poweroff.runit /usr/bin/poweroff
# mv /usr/bin/reboot.runit /usr/bin/reboot
```

## Updating the 66 internal file format

If an update to the `66` package changes the 66 internal file format,
[66-intree(1)](https://man.voidlinux.org/66-intree.1) will report an error:

```
66-intree: fatal: unable to build the graph
```

and booting with [66-init(1)](https://man.voidlinux.org/66-init.1) will fail:

```
66-init: fatal: unable to resolve dependencies of tty@tty12: Protocol error
```

To convert to the new file format, use
[66-update(1)](https://man.voidlinux.org/66-update.1).

## Working with runit services

66 can work with the existing runit services, replacing only the first stage of
the regular init process. On Void, this is necessary, since there are no
currently no individual service files for 66.

To configure runit to run only services that are not included in the
`boot-66serv` package, remove the runit symlinks for the services provided by
`boot-66serv`:

```
# rm /var/service/agetty-*
```

To use the remaining runit services, create a `runit` tree and enable it, then
enable and start the `runit` service:

```
# 66-tree -nE runit
# 66-enable -t runit -S runit
```

To return to booting with runit, boot into single user mode, then run:

```
# for i in {agetty-tty1,agetty-tty2,agetty-tty2,agetty-tty3,agetty-tty4,agetty-tty5,agetty-tty6}; do ln -sr /etc/sv/$i /var/service/$i; done
```

and reboot the system.
