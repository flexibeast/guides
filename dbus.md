# D-Bus: The essentials

This guide is intended to provide a short overview of D-Bus, to save people from
having to distill the core concepts from more detailed documents elsewhere. It
generally follows the [conventions used in the Void
Handbook](https://docs.voidlinux.org/about-handbook/index.html). For tips on
using D-Bus in the context of Void, refer to [this guide](./dbus-on-void.md).

This document is purely descriptive; nothing in it should be taken as implying
either support or criticism of D-Bus and/or its design. Technical corrections
are welcome.

## Introduction

D-Bus is a *protocol*, and should not be confused with specific
[implementations](#implementations) of the protocol. In particular, the [D-Bus
specification](https://dbus.freedesktop.org/doc/dbus-specification.html)
provides [buses](https://en.wikipedia.org/wiki/Software_bus) to facilitate
[Inter-Process
Communication](https://en.wikipedia.org/wiki/Inter-process_communication) (IPC)
and [Remote Procedure
Calls](https://en.wikipedia.org/wiki/Remote_procedure_call) (RPC).

The name "D-Bus" is short for "Desktop Bus". The intent of D-Bus was to try to
standardise communication for desktop services: before D-Bus, the
[GNOME](https://en.wikipedia.org/wiki/GNOME) project used
[CORBA](https://en.wikipedia.org/wiki/Common_Object_Request_Broker_Architecture)
for communication and
[KDE](https://en.wikipedia.org/wiki/KDE_Software_Compilation) used
[DCOP](https://en.wikipedia.org/wiki/DCOP), hindering interoperability. The
design of D-Bus was heavily influenced by DCOP. KDE moved to using D-Bus in
version 4, released in 2008.

There seems to be a common misconception that D-Bus is part of the systemd
project. This is incorrect; although systemd makes extensive use of D-Bus, the
two projects are distinct. In fact, the initial release of the D-Bus reference
implementation was in November 2006; the initial release of systemd was in March
2010.

## The core concepts

There are two primary D-Bus buses: a *system bus*, and a *session bus*. It's
important to note that *these are distinct buses, used for different purposes,
and are not simply the same bus being run in two different ways*.

A *system bus* relates to services provided by the OS and system daemons, and
communication between different user sessions. The system bus is used for
communication about system-wide events: storage being added, network
connectivity changes, printer status, and so on. There is usually only one
system bus.

A *session bus* relates to a particular user login session, and is used by
processes wishing to communicate with each other within that session.

Within each of these, there are various bus *names*. The D-Bus specification
glossary says that a bus name:

> is simply an identifier used to locate connections ... An application is said
> to own a name if the message bus has associated the application's connection
> with the name.

Each bus name has objects specified by an *object path*, e.g.
`/org/freedesktop/DBus`, and each of those objects supports one or more
*interfaces*, which are collections of messages that can be handled by an
object.

Every D-Bus connection has a *unique connection name*, e.g. `:1.1553`; there is
no special meaning to the identifier.

D-Bus can be used for [service
activation](https://dbus.freedesktop.org/doc/dbus-specification.html#message-bus-starting-services)
/ auto-starting. For example, instead of manually starting a PulseAudio server,
one can be automatically started when an application requires it.

Programs can register as being interested in messages to particular bus names
via service files in the `/usr/share/dbus-1/services/` and
`/usr/share/dbus-1/system-services/` directories. For example,
`org.knopwob.dunst.service` in `/usr/share/dbus-1/services/` contains:

```
[D-BUS Service]
Name=org.freedesktop.Notifications
Exec=/usr/bin/dunst
SystemdService=dunst.service
```

This file says that messages for `org.freedesktop.Notifications` can be handled
by `/usr/bin/dunst`.

Thus, desktop applications and components can send messages to particular bus
names, without having to explicitly specify which applications/components should
respond to those messages. For example, applications can send notifications via
`org.freedesktop.Notifications`, and users can choose which notification daemon
handles those notifications, and how.

## Implementations

The reference implementation is `dbus`, but other implementations include
[GDBus](https://developer.gnome.org/gio/stable/gdbus.html),
[QtDbus](https://doc.qt.io/qt-5/qtdbus-index.html) and the systemd
implementation, `sd-bus`.

## Well-known bus names and interfaces

For an overview of well-known bus names and interfaces, refer to [this
reference](./dbus-reference.md), which provides links to further details.

## Querying D-Bus

The following examples make use of
[dbus-send(1)](https://man.voidlinux.org/dbus-send.1), from the reference
implementation. The messages used in the following examples are described more
fully in [the "Message Bus Messages"
section](https://dbus.freedesktop.org/doc/dbus-specification.html#message-bus-messages)
of the specification.

To list available D-Bus services:

```
$ dbus-send \
    --print-reply \
    --dest=org.freedesktop.DBus \
    /org/freedesktop/DBus \
    org.freedesktop.DBus.ListNames
```

This command says to send the message `org.freedesktop.DBus.ListNames` to the
`/org/freedesktop/DBus` object on `org.freedesktop.DBus`.

By default, `dbus-send` uses the session bus. Use `--system` to use the system
bus.

List all names that can be activated:

```
$ dbus-send \
    --print-reply \
    --dest=org.freedesktop.DBus \
    /org/freedesktop/DBus \
    org.freedesktop.DBus.ListActivatableNames
```

Return a boolean indicating whether a name has an owner:

```
$ dbus-send \
    --print-reply \
    --dest=org.freedesktop.DBus \
    /org/freedesktop/DBus \
    org.freedesktop.DBus.NameHasOwner string:'org.freedesktop.Notifications'
```

The above command passes a message argument:
`string:'org.freedesktop.Notifications'`. The `dbus-send` interface requires
that message arguments be specified in the form `<type>:<data>`.

If a name has an owner, return the process ID of the owning process:

```
$ dbus-send \
    --print-reply \
    --dest=org.freedesktop.DBus \
    /org/freedesktop/DBus \
    org.freedesktop.DBus.GetConnectionUnixProcessID string:'org.freedesktop.Notifications'
```

A bus name can be monitored with [gdbus(1)](https://man.voidlinux.org/gdbus.1),
e.g.:

```
$ gdbus monitor \
    --session \
    --dest 'org.freedesktop.Notifications' \
    --object-path /org/freedesktop/Notifications
```
