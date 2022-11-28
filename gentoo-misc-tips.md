# Miscellaneous Gentoo tips

A small collection of tips that don't obviously seem to belong to any particular page of [the Gentoo wiki](https://wiki.gentoo.org/). If you're an experienced editor / administrator of the wiki and feel that a particular tip should be included on a particular wiki page, please raise an issue to let me know!

## Resolving slot conflicts

### Try specifying latest version

```
# emerge --ignore-world dev-libs/icu:0/71.1
```

### Try updating to latest version and rebuilding rdeps

In shells with POSIX-style sh(1p) word splitting (or with such splitting enabled):

```
# emerge -au dev-libs/boost:0/1.79.0 \
    $( qdepends -CQqqF'%{CAT}/%{PN}:%{SLOT}' '^dev-libs/boost:0/1.79.0' )
```

In bash:

```
# IFS=' ' emerge -au dev-libs/boost:0/1.79.0 \
    $( qdepends -CQqqF'%{CAT}/%{PN}:%{SLOT}' '^dev-libs/boost:0/1.79.0' | tr '\n' ' ' )
```
