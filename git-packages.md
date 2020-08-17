# Managing -git packages on Void

*Contributed by @ericonr*

Void maintainers seek to strike a balance between current software and a stable
system. For this reason, official packages use tagged releases and avoid
patching upstream behavior as much as possible. This makes usage of `-git`
packages, in the style of the [AUR](https://aur.archlinux.org/), very much an
anti-pattern. However, sometimes it is impossible to avoid this type of package,
whether because the development branch of a piece of software you use has
essential bug fixes or features, or because you want to test drive the brand new
developments. This guide explains how to create such packages from an existing
template, presents an alternative way of adding essential fixes through patches
(which may even be accepted in the
[void-packages](https://github.com/void-linux/void-packages) repository), and
explains potential issues that you may face.

If you have any doubts when using `xbps-src` or editing templates, be sure to
take a look at the
[README](https://github.com/void-linux/void-packages/blob/master/README.md) and
the [Manual](https://github.com/void-linux/void-packages/blob/master/Manual.md)
in void-packages.

This guide uses the [conventions of the Void
Handbook](https://docs.voidlinux.org/about/about-this-handbook.html).

## Prepare the environment

In order to prepare the environment, follow the steps detailed
[here](./suckless.md#prepare-the-environment).

## Converting a template into a -git template

To start off, locate the template for the package you wish to convert in
`srcpkgs/<package>/template`. Verify that the dependencies and build options
listed in the template are enough to build the package, since features might
have been added, removed or altered.

### Fetching distfiles

There are two ways of fetching the necessary distfiles: using a source control
utility or a source tarball. The first way has the advantage of applying the
latest updates every time you build the package, but this can also be a
disadvantage, since you won't be tracking the versions and reverting to a
non-broken version will be harder.

For the source control utility method:

- Add the utility, such as `git`, to `hostmakedepends`.
- Erase the relevant `distfiles` lines. Changing `checksum` might also be
   necessary.
- Add a `do_fetch` function to the template, which downloads the source code
   into the `wrksrc` directory. Using an option equivalent to Git's `--depth 1`
   can speed up the download process. It is also possible to `cd` into the
   downloaded directory and check out a specific branch. An example is shown
   below.

The following example uses [git-clone(1)](https://man.voidlinux.org/git-clone.1)
and [git-checkout(1)](https://man.voidlinux.org/git-checkout.1).

```
do_fetch() {
    git clone <project_url> ${wkrsrc} --depth 1
    cd ${wrksrc}
    git checkout <feature_branch>
}
```

For the distfile method:

- Replace the `distfiles` URL with one that downloads a tarball from a specific
   commit. To do this for a GitHub project, for example, the URL should look
   like `https://github.com/<user>/<project>/archive/<commit_hash>.tar.gz`.
- Update the distfile checksums using
   [xgensum(1)](https://man.voidlinux.org/xtools.1).

### Additional pre_configure steps

For projects using build styles such as `gnu-configure`, it might be necessary
to add a `pre_configure` step to the template, since the `./configure` script,
which is usually generated when creating a distribution tarball, is likely not
available. In this case, this requires adding the `automake` package - and
possibly the `libtool` and `which` packages as well - to `hostmakedepends` and
running a `./bootstrap` script (if available) or `autoreconf -fi` in
`pre_configure`.

### Versioning the package

It is possible to bump the package `revision` for each rebuild, but it is
generally easier to rebuild the package with the `-f` flag for `xbps-src`, and
install it with `xi -f <package>`. However, this overwrites a previous package
version.

### Potential issues

XBPS is able to track the versions of dynamic libraries, making it capable of
performing safe partial upgrades. However, this is not the case when using
development packages. Generally speaking,
[soname](https://en.wikipedia.org/wiki/Soname) versioning is done by the
upstream project, which probably doesn't care about tracking ABI breaks during
development, only once a release is made. This means that updating a library to
a development version can, potentially, break utilities that depend on it, even
though XBPS happily installed it without incident.

## Patching software

If the prospect of running bleeding edge software sounds too worrying, or a
package in the official repositories is broken because it lacks a specific patch
(note that in this case it is recommended to ask upstream for a new release),
including specific patches is also possible.

Once the package has been built and tested with the patches, the
[CONTRIBUTING](https://github.com/void-linux/void-packages/blob/master/CONTRIBUTING.md)
file in void-packages can help you get your changes into the official
void-packages repository. It should be noted that non-release versions of
packages aren't usually accepted into void-packages, so adding a patch is
potentially the only way of getting fixes merged into the official repository.

### Downloading a patch

For projects hosted on GitHub, a patch file for a specific commit can be found
in `https://github.com/<user>/<project>/commit/<commit_hash>.patch`, while a
patch for a Pull Request can be found in
`https://github.com/<user>/<project>/pull/<pull_number>.patch`. Once these
patches are downloaded, they should be moved to `srcpkgs/<package>/patches/`.
All patches in that directory should have the same format, which means each
section in the patches should start with either:

```
--- tools/static-nodes.c.orig
+++ tools/static-nodes.c
```

or

```
--- a/tools/static-nodes.c.orig
+++ b/tools/static-nodes.c
```

For the first option, no change is necessary, but for the second option it is
necessary to add `patch_args="-Np1"` to the template or remove `a/` and `b/`
from the patch.

### Backporting patches

It is possible that a patch can't be applied automatically to the source tree
and needs to be fixed. In this case, it can be necessary to create a patch
yourself. This can be done using Git, for example.

Start by cloning the repository and locating the commit(s) containing the fix
you need. Once you have that information, check out the released version that is
currently packaged with
[git-checkout(1)](https://man.voidlinux.org/git-checkout.1):

```
$ git checkout <version>
```

Then, use [git-cherry-pick(1)](https://man.voidlinux.org/git-cherry-pick.1) to
apply the changes from the commit:

```
$ git cherry-pick <commit_hash>
```

You might need to solve some conflicts in the affected files, which are
annotated as shown below:

```
<<<<<<< HEAD
distfiles="${homepage}/archive/v${version}.tar.gz"
checksum=e54fb985468c12d75be61a39e54ec1da4595447d681511998474066288cddb22
=======
#distfiles="${homepage}/archive/v${version}.tar.gz"
checksum=b0ee1d3517de6380dd71345ec3020ee7f8c43ffc07baee6226f7f568939b3b06

do_fetch() {
    git clone https://github.com/ericonr/nwg-launchers.git ${wrksrc}
    cd ${wrksrc}
    git checkout includes
}
>>>>>>> ca48e5d3a4... nwg-launcher: git version, enable cross.
```

These conflicts are separated by blocks of seven `<`, `=` and `>` characters.
The content contained in the first block, between `<<<<<<< HEAD` and `=======`,
is the current version, while the content between `=======` and `>>>>>>>` is the
version with the edits that are being applied. To resolve the conflict, you
should decide which parts of each section should stay, edit the file
appropriately, and finally remove the separators. This same part of the file
would have the following content, after conflicts are resolved:

```
#distfiles="${homepage}/archive/v${version}.tar.gz"
checksum=e54fb985468c12d75be61a39e54ec1da4595447d681511998474066288cddb22

do_fetch() {
    git clone https://github.com/ericonr/nwg-launchers.git ${wrksrc}
    cd ${wrksrc}
    git checkout includes
}
```

Once these conflicts are resolved, you can finish the cherry-pick:

```
$ git cherry-pick --continue
```

To generate a patch from your commits, you can use
[git-format-patch(1)](https://man.voidlinux.org/git-format-patch.1).
