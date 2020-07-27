# D-Bus reference

*Well-known* bus names are defined in various specifications.

## Accessibility / AT-SPI

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

## BlueZ

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

## D-Bus

[specification](https://dbus.freedesktop.org/doc/dbus-specification.html)

Bus name:

- `org.freedesktop.DBus`

Interfaces:

- `org.freedesktop.DBus`
- `org.freedesktop.DBus.Peer`
- `org.freedesktop.DBus.Introspectable`
- `org.freedesktop.DBus.Properties`
- `org.freedesktop.DBus.ObjectManager`

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

## logind

[specification](https://freedesktop.org/wiki/Software/systemd/logind/)

Bus name:

- `org.freedesktop.login1`

Interfaces:

- `org.freedesktop.login1.Manager`
- `org.freedesktop.login1.Seat`
- `org.freedesktop.login1.Session`
- `org.freedesktop.login1.User`

### Media Player Remote Interfacing Specification (MPRIS)

[specification](https://specifications.freedesktop.org/mpris-spec/latest/)

Bus names:

- `org.mpris.MediaPlayer2.<media_player_name>`

Interfaces:

- `org.mpris.MediaPlayer2`
- `org.mpris.MediaPlayer2.Player`
- `org.mpris.MediaPlayer2.TrackList`
- `org.mpris.MediaPlayer2.Playlists`

## PulseAudio

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
