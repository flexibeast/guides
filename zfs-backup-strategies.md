# Simple backup with `zfs-auto-snapshot`, `zfs-prune-snapshots` and `zrep`

*Contributed by @ahesford*

About 8 months ago, I abandoned my LVM thin pool configuration (which was
required to get sensible snapshot behavior for backups) in favor of ZFS. The
sophistication, ease of use and utility ecosystem makes ZFS a natural choice
for systems where fault tolerance is critical. In fact, because ZFS makes
resilient storage so trivial, "critical" tends to mean "wherever it takes more
than five minutes to recover".

There are many tools to create and replicate ZFS snapshots. Rather than an
all-in-one solution like [zrepl](https://zrepl.github.io/) or
[znapzend](https://www.znapzend.org/) (the latter of relies heavily on "Z"
puns), I rely on three simple shell scripts and some cron jobs:
[zfs-auto-snapshot](https://github.com/zfsonlinux/zfs-auto-snapshot),
[zfs-prune-snapshots](https://github.com/bahamas10/zfs-prune-snapshots) and
[zrep](http://www.bolthole.com/solaris/zrep/). The first two are already
packages for Void, while `zrep` is a simple `ksh` script.

## Rolling snapshots

On a Void system, install the `zfs-auto-snapshot` package. The package
installs the snapshot script and some convenient cronjobs that will institute
a sensible rolling snapshot strategy. I like to edit the cronjobs in
`/etc/cron.*/zfs-auto-snapshot`  to shorten the snapshot prefix (`--prefix`)
to something shorter than the default, like `znap`. You can also adjust the
retention policies for the cycles by changing the `--keep` parameters, along
with a few other options.

If you want to rely on the cronjobs, you need to run a `crond`. You can
install and enable `cronie` or `dcron` if you like. I prefer Leah Neukirchen's
excellent [snooze](https://github.com/leahneukirchen/snooze), which is useful
both as a simple `crond` replacement and as a mechanism for throttling user
services. After installing the `snooze` package, enable the `snooze-hourly`,
`snooze-daily`, `snooze-weekly` and `snooze-monthly` services to run any
`cron` scripts in `/etc/cron.{hourly,daily,weekly,monthly}` at the appropriate
times. The only thing missing from `snooze` is processing of `/etc/cron.d`,
which is used by `zfs-auto-snapshot` to run "frequent" snapshots every 15
minutes.

Should you desire frequent snapshots with `snooze`, a simple runit service
will do the job. Create, for example, the directory `/etc/sv/znap-frequent`
and the file `/etc/sv/znap-frequent/run` with the contents
```
#!/bin/sh

set -e

[ -f ./conf ] && . ./conf

: ${PREFIX:=znap}
: ${SNOOZE:=-M /15 -H /1 -s 5m}
: ${LABEL:=frequent}
: ${KEEP:=4}

exec snooze ${SNOOZE} zfs-auto-snapshot --skip-scrub \
		--prefix=${PREFIX} --label=${LABEL} --keep=${KEEP} //
```
Make sure the script is executable with
```
chmod 755 /etc/sv/znap-frequent/run
```
You can customize the variables by creating `/etc/sv/znap-frequent/conf` with
your desired definitions, or discard the `conf` support and just alter the
values in the script. (I wrote the script with the capability to reuse it for
snapshots at different time scales.) Enable the service and you're all set.

## Snapshot replication

The `zrep` script handles replication of snapshots to remote pools, be they
connected to your system or somewhere over the Internet. Download the script
from the page linked above and install it at `/usr/local/bin/zrep`. You'll
also need to install the Void `ksh` package. (Void cannot package `zrep`
because its license forbids redistribution. Fortunately, it's nothing more
than a single script.)

The first step in snapshot replication is initializing `zrep` for the
datasets you want to sync. I'm going to assume the following ZFS pool and
dataset hierarchy:
```
system
system/OS
system/OS/void
system/home
system/home/user1
system/home/user2
tank
tank/backups
```
We want to back up everything under `system/OS` and `system/home` to a similar
hierarchy under `tank/backups`. Fortunately, `zrep` allows recursive
replication, provided the environment variable `ZREP_R=-R` is set.
Initialization is done with a two-step process here:
```
ZREP_R=-R zrep -i system/OS localhost tank/backups/OS
ZREP_R=-R zrep -i system/home localhost tank/backups/home
```
This replicates the datasets to `tank/backups` and stores some metadata in ZFS
properties that will allow subsequent `zrep` runs to figure out what's going
on. If you're using `zfs-auto-snapshots` as above, you probably want to
disable automatic snapshots of `tank/backups` because you're just trying to
replicate datasets from the system pool:
```
zfs set com.sun:auto-snapshot=false tank/backups
```

The nice thing about recursive replication is that, if you later add a
`system/OS/void-musl` boot environment (and if you're serious about ZFS boot
environments, you *really* want
[zfsbootmenu](https://github.com/zdykstra/zfsbootmenu)) or create a new user
with a home dataset at `system/home/user3`, those new datasets will be
propagated. If you don't want this recursive behavior, drop the `ZREP_R=-R`
and specify explicitly each dataset you wish to replicate. If you want to take
recursion to the limit, you can do one pass with, *e.g.*,
```
ZREP_R=-R zrep -i system localhost tank/backups/system
```
I prefer to split mine into separate hierarchies while still relying on
recursion to pick up children because I want to be able to create datasets
like `system/lxc` that aren't automatically propagated (or are propagated
differently) and I don't want another level of hierarchy in the `tank/backups`
destination.

If you wish to push to a remote system over SSH, just change `localhost` to
the name of the remote host. You'll probably need to do this as root (unless
you've carefully set up ZFS delegations to allow another user to run and push
the backup), so you'll need to set up root login over SSH to another machine.
I've created a key that allows root on my work laptop to log into the root
account on my work desktop without a passphrase, but SSH is restricted to only
running the `zrep` command. This doesn't bother me for two reasons:

1. The contents of the work desktop are exactly the same as the work laptop,
so anybody who gets root on my laptop already has everything that might be
found on the desktop.
2. My work desktop is inaccessible except via VPN or corporate intranet, so
remote access fails unless I'm in the office or provide VPN credentials.

If the key setup bothers you, you can look at password management solutions to
lock the root SSH key or explore delegation. The `zrep` documentation
describes the required delegated privileges. (Note: `zrep` claims to need
`mount` privilege, which probably doesn't work as expected on Linux. I haven't
explored delegation for `zrep` but am hoping it could be made to work even if
mounting isn't functional.)

After the initial sync, all you need is a periodic service. Depending on the
frequency you wan to push, you could do this with a `cron` script in, *e.g.*,
`/etc/cron.hourly` or `/etc/cron.daily`. I find hourly a bit excessive because
I like my `tank` disks to spin down for awhile, but I want higher frequency
than daily. A period of three hours seems about right. To that end, I create a
new service at `/etc/sv/zrep/run`:
```
#!/bin/sh

set -e

exec 2>&1

[ -f ./conf ] && . ./conf

# Sensible defaults
: ${SNOOZE:=-H 2/3 -s 2h}
: ${DATASETS:=all}

# zrep must be in the path or target pruning fails
export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin"

# Propagate snapshots recursively
export ZREP_R="-R"
exec snooze ${SNOOZE} zrep -S ${DATASETS}
```
The `exec 2>&1` line forces all `stderr` output to be written to `stdout`,
which is useful if you log service output using, *e.g.*, `vlogger`. That's
beyond the scope of this article.

**NB**: If you enabled `ZREP_R=-R` for the initial replication, you *must*
enable it in the service. Likewise, if you did not enable it for initial
replication, *do not* enable it in the service. Inconsistent use of `ZREP_R`
is guaranteed to give you the wrong results.

## Cleaning the tank

`zrep` creates a series of `zrep_XXXXXX` snapshots and will clean these up as
it runs. By default, it keeps the five most recent sent snapshots. However,
`zrep` also propagates snapshots it did not create, and will not attempt to
reconcile changes in such snapshots on the remote host. That means your
`zfs-auto-snapshot` cycles will make their way to the backup `tank` and never
be purged. Running `zfs-prune-snapshots` on the system holding the backup
destination will take care of this, providing rolloff like that provided with
`zfs-auto-snapshot`.

On Void, install the `zfs-prune-snapshots` package, then create a service at
`/etc/sv/zprune/run`:
```
#!/bin/sh

set -e

[ -f ./conf ] && . ./conf

# Sensible defaults
: ${SNOOZE:=-H 1/3 -s 2h}
: ${ZPRUNE_BIN:=/usr/bin/zfs-prune-snapshots}

exec snooze ${SNOOZE} /bin/sh <<- EOF
        $ZPRUNE_BIN -p 'znap_frequent-' 1h $DATASETS
        $ZPRUNE_BIN -p 'znap_hourly-' 2d $DATASETS
        $ZPRUNE_BIN -p 'znap_daily-' 2M $DATASETS
        $ZPRUNE_BIN -p 'znap_weekly-' 16w $DATASETS
        $ZPRUNE_BIN -p 'znap_monthly-' 2y $DATASETS
EOF
```
Note that, for everything but "frequent" snapshots, I retain for twice as long
as the default `zfs-auto-snapshot` retention on the `system` pool. The whole
point of `tank` is to provide high-capacity, long-term storage, so I might as
well get some use out of it. Adjust the retention as you see fit.

By default, the `DATASETS` variable will be undefined, which means
`zfs-prune-snapshots` will try to prune snapshots from every dataset on the
system. Because `zfs-auto-snapshot` manages its own rolling snapshots, I
restrict `zfs-prune-snapshot` to `tank/backups` by writing
```
DATASETS="tank/backups"
```
to `/etc/sv/zprune/conf`. With everything configured as you desire, enable the
`zprune` service and your backups will not grow without bound.

## Conclusion

While software like `zrepl` or `znapzend` provides powerful ZFS replication, a
combination of a few shell scripts and some loosely coupled runit services
does a decent job of pushing snapshots to backup storage in a way that is easy
to understand and customize. One thing `zrep` will not do is manage remote
replication to more than one host. If you can tolerate this restriction, I
recommend you look at `zfs-auto-snapshot`, `zfs-prune-snapshots` and `zrep`
for fault tolerance in your ZFS setup.

