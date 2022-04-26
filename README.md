# Summary

A collection of ICT guides for FOSS \*n\*x-ish systems that people might find helpful.

- Authoring documentation
   - [Writing man pages with mdoc(7): a quickstart guide](./mdoc-quickstart.md)
- D-Bus
   - [D-Bus: The essentials](./dbus.md)
   - [D-Bus interfaces reference](./dbus-reference.md)
- Gentoo
   - [A minimal Gentoo kernel for your hardware](./minimal-gentoo-kernel.md)
   - [Making man pages usable after switching from man-db to mandoc on Gentoo](./gentoo-man-pages.md)
- Void
   - [66 on Void](https://github.com/mobinmob/void-66-services/blob/master/conf/void-66-conf.md)
   - [D-Bus on Void](./dbus-on-void.md)
   - [Managing suckless software on Void](./suckless.md)
   - [Managing -git packages on Void](./git-packages.md)
- ZFS
   - [Simple backup with `zfs-auto-snapshot`, `zfs-prune-snapshots` and
      `zrep`](./zfs-backup-strategies.md)
   - [Using ZFS snapshots and `zfsbootmenu` to bisect a `libvirt`
      "regression"](./libvirt-zbm-notes.md)

# Contributions

Potential contributions to this collection are welcome! Contributions will be accepted at the discretion of the owner of this repository, but must meet at least the following criteria:

* Be related to at least one FOSS \*n\*x-ish OS. Guides for proprietary OSes like Windows, macOS, Android and iOS will not be accepted.

* Provide information not currently available elsewhere, and that would not be more appropriately included elsewhere. For example, the Void Handbook does not currently have a "System Maintenance" section, but [one is sought](https://github.com/void-linux/void-docs/issues/616). On the other hand, a Void-specific tutorial that is outside [the scope of the Handbook](https://docs.voidlinux.org/about/about-this-handbook.html) would certainly be considered. 

* Be non-trivial. A 'guide' of the form "Install X, then install Y, then run this command" is considered trivial in this context.

* Follow [the Void Handbook style guide](https://github.com/void-linux/void-docs/blob/master/CONTRIBUTING.md#style-guide), with the following exceptions:

  * Use of the `vmdfmt` tool is not required.
  * Use of the `mdbook-linkcheck` tool is not applicable, though links should be checked in some way.
  * The "Redirects" section is not applicable.

More critera may be added in the future, as needed.
