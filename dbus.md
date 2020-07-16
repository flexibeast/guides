# D-Bus: The essentials

This guide is intended to provide a short overview of D-Bus, to save people from
having to distill the core concepts from more detailed documents elsewhere. It
generally follows the [conventions used in the Void
Handbook](https://docs.voidlinux.org/about-handbook/index.html).

This document is purely descriptive; nothing in it should be taken as implying
either support or criticism of D-Bus and/or its design. Technical corrections,
and additions to [the "Reference" section](#reference), are welcome.

## Introduction

D-Bus is a *protocol*, and should not be confused with specific
[implementations](#implementations) of the protocol. In particular, the [D-Bus
specification](https://dbus.freedesktop.org/doc/dbus-specification.html)
provides a bus for [Inter-Process
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

## Reference

*Well-known* bus names are defined in various specifications.

### Accessibility / AT-SPI

I have been unable to find a formal specification - http://a11y.org/d-bus is not
displaying any content at the time of writing - so this list has been pieced
together from the files
[here](https://github.com/GNOME/at-spi2-core/tree/mainline/bus).

Bus name:

- `org.a11y.Bus`

Interfaces:

- `org.a11y.atspi.Accessible`
- `org.a11y.atspi.Action`
- `org.a11y.atspi.Application`
- `org.a11y.atspi.Cache`
- `org.a11y.atspi.Collection`
- `org.a11y.atspi.Component`
- `org.a11y.atspi.DeviceEventController`
- `org.a11y.atspi.DeviceEventListener`
- `org.a11y.atspi.Document`
- `org.a11y.atspi.EditableText`
- `org.a11y.atspi.Event.Document`
- `org.a11y.atspi.Event.Focus`
- `org.a11y.atspi.Event.Keyboard`
- `org.a11y.atspi.Event.Mouse`
- `org.a11y.atspi.Event.Object`
- `org.a11y.atspi.Event.Terminal`
- `org.a11y.atspi.Event.Window`
- `org.a11y.atspi.Hyperlink`
- `org.a11y.atspi.Hypertext`
- `org.a11y.atspi.Image`
- `org.a11y.atspi.Registry`
- `org.a11y.atspi.Selection`
- `org.a11y.atspi.Socket`
- `org.a11y.atspi.Table`
- `org.a11y.atspi.TableCell`
- `org.a11y.atspi.Text`
- `org.a11y.atspi.Value`

### BlueZ

[specification](https://git.kernel.org/pub/scm/bluetooth/bluez.git/tree/doc)

Bus names:

- `org.bluez`
- `org.bluez.mesh`
- `org.bluez.obex`

Interfaces:

- `org.bluez.Adapter1`
- `org.bluez.AdvertisementMonitor1` (experimental)
- `org.bluez.AdvertisementMonitorManager1` (experimental)
- `org.bluez.LEAdvertisement1`
- `org.bluez.LEAdvertisingManager1`
- `org.bluez.Agent1`
- `org.bluez.AgentManager1`
- `org.bluez.Battery1`
- `org.bluez.Device1`
- `org.bluez.GattService1`
- `org.bluez.GattCharacteristic1`
- `org.bluez.GattDescriptor1`
- `org.bluez.GattProfile1`
- `org.bluez.HealthManager1`
- `org.bluez.HealthDevice1`
- `org.bluez.HealthChannel1`
- `org.bluez.Input1`
- `org.bluez.Media1`
- `org.bluez.MediaControl1`
- `org.bluez.MediaPlayer1`
- `org.bluez.MediaFolder1`
- `org.bluez.MediaItem1`
- `org.bluez.MediaEndpoint1`
- `org.bluez.MediaTransport1`
- `org.bluez.mesh.Network1`
- `org.bluez.mesh.Node1`
- `org.bluez.mesh.Management1`
- `org.bluez.mesh.Application1`
- `org.bluez.mesh.Element1`
- `org.bluez.mesh.Attention1`
- `org.bluez.mesh.Provisioner1`
- `org.bluez.mesh.ProvisionAgent1`
- `org.bluez.Network1`
- `org.bluez.NetworkServer1`
- `org.bluez.obex.AgentManager1`
- `org.bluez.obex.Agent1`
- `org.bluez.obex.Client1`
- `org.bluez.obex.Session1`
- `org.bluez.obex.Transfer1`
- `org.bluez.obex.ObjectPush1`
- `org.bluez.obex.FileTransfer`
- `org.bluez.obex.PhonebookAccess1`
- `org.bluez.obex.Synchronization1`
- `org.bluez.obex.MessageAccess1`
- `org.bluez.obex.Message1`
- `org.bluez.ProfileManager1`
- `org.bluez.Profile1`
- `org.bluez.SimAccess1`
- `org.bluez.ThermometerManager1`
- `org.bluez.Thermometer1`
- `org.bluez.ThermometerWatcher1`

### Desktop Notifications Specification

[specification](https://specifications.freedesktop.org/notification-spec/notification-spec-latest.html)

Bus name:

- `org.freedesktop.Notifications` on session bus.

Interfaces:

- `org.freedesktop.Notifications`

### File Manager Interface

[specification](https://www.freedesktop.org/wiki/Specifications/file-manager-interface/)

Bus name:

- `org.freedesktop.FileManager1`

Interfaces:

- `org.freedesktop.FileManager1`

### Media Player Remote Interfacing Specification (MPRIS)

[specification](https://specifications.freedesktop.org/mpris-spec/latest/)

Bus names:

- `org.mpris.MediaPlayer2.<media_player_name>`

Interfaces:

- `org.mpris.MediaPlayer2`
- `org.mpris.MediaPlayer2.Player`
- `org.mpris.MediaPlayer2.TrackList`
- `org.mpris.MediaPlayer2.Playlists`

### PulseAudio

[specification](https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/Developer/Clients/DBus/)

Bus names:

- `org.PulseAudio1`
- `org.pulseaudio.Server`

Interfaces:

- `org.PulseAudio.Core1`
- `org.PulseAudio.Core1.Memstats`
- `org.PulseAudio.Core1.Card`
- `org.PulseAudio.Core1.CardProfile`
- `org.PulseAudio.Core1.Device`
- `org.PulseAudio.Core1.Sink`
- `org.PulseAudio.Core1.Source`
- `org.PulseAudio.Core1.DevicePort`
- `org.PulseAudio.Core1.Stream`
- `org.PulseAudio.Core1.Sample`
- `org.PulseAudio.Core1.Module`
- `org.PulseAudio.Core1.Client`
- `org.PulseAudio.Ext.StreamRestore1`
- `org.PulseAudio.Ext.StreamRestore1.RestoreEntry`
- `org.PulseAudio.Ext.Ladspa1`
