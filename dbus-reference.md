# D-Bus reference

For a brief overview of D-Bus, refer to [this guide](./dbus.md).

Bus names and interfaces are defined in various specifications, reference documents and repositories. When a repository is linked, the methods for a given interface can be found in the XML file for that interface.

## Contents

- [Accessibility / AT-SPI](#accessibility--ati-spi)
- [AccountsService](#accountsservice)
- [Avahi](#avahi)
- [BlueZ](#bluez)
- [colord](#colord)
- [D-Bus](#d-bus)
- [dconf](#dconf)
- [Desktop Notifications Specification](#desktop-notifications-specification)
- [File Manager Interface](#file-manager-interface)
- [Flatpak](#flatpak)
- [GNOME Session](#gnome-session)
- [hostname1](#hostname1)
- [logind](#logind)
- [Media Player Remote Interfacing Specification (MPRIS)](#media-player-remote-interfacing-specification-mpris)
- [PolicyKit](#policykit)
- [PulseAudio](#pulseaudio)
- [resolve1](#resolve1)
- [UDisks2](#udisks2)
- [UPower](#upower)
- [wpa_supplicant](#wpa-supplicant)

## Accessibility / AT-SPI

[repository](https://github.com/GNOME/at-spi2-core/tree/mainline/bus).

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

## AccountsService

[repository](https://gitlab.freedesktop.org/accountsservice/accountsservice/)

Interfaces:

- `org.freedesktop.Accounts`
- `org.freedesktop.Accounts.User`

## Avahi

[repository](https://github.com/lathiat/avahi/tree/master/avahi-daemon)

Interfaces:

- `org.freedesktop.Avahi.AddressResolver`
- `org.freedesktop.Avahi.DomainBrowser`
- `org.freedesktop.Avahi.EntryGroup`
- `org.freedesktop.Avahi.HostNameResolver`
- `org.freedesktop.Avahi.RecordBrowser`
- `org.freedesktop.Avahi.Server`
- `org.freedesktop.Avahi.ServiceBrowser`
- `org.freedesktop.Avahi.ServiceResolver`
- `org.freedesktop.Avahi.ServiceTypeBrowser`

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

## colord

[specification](https://www.freedesktop.org/software/colord/gtk-doc/ref-dbus.html)

Bus name:

- `org.freedesktop.ColorManager`?

Interfaces:

- `org.freedesktop.ColorManager`
- `org.freedesktop.ColorManager.Device`
- `org.freedesktop.ColorManager.Profile`
- `org.freedesktop.ColorManager.Sensor`

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

## dconf

[repository](https://gitlab.gnome.org/GNOME/dconf/-/tree/master/service)

Bus name:

- `ca.desrt.dconf`

Interfaces:

- `ca.desrt.dconf.Writer`
- `ca.desrt.dconf.ServiceInfo`

## Desktop Notifications Specification

[specification](https://specifications.freedesktop.org/notification-spec/notification-spec-latest.html)

Bus name:

- `org.freedesktop.Notifications` on session bus.

Interfaces:

- `org.freedesktop.Notifications`

## File Manager Interface

[specification](https://www.freedesktop.org/wiki/Specifications/file-manager-interface/)

Bus name:

- `org.freedesktop.FileManager1`

Interfaces:

- `org.freedesktop.FileManager1`

## Flatpak

### libflatpak

[API reference](https://docs.flatpak.org/en/latest/libflatpak-api-reference.html)

Bus name:

- `org.freedesktop.Flatpak`

Interfaces:

- `org.freedesktop.Flatpak.Authenticator`
- `org.freedesktop.Flatpak.Development`
- `org.freedesktop.Flatpak.SessionHelper`
- `org.freedesktop.Flatpak.SystemHelper`

### portal

[API reference](https://docs.flatpak.org/en/latest/portal-api-reference.html)

Bus name:

- `org.freedesktop.portal.Flatpak`

Interfaces:

- `org.freedesktop.portal.Account`
- `org.freedesktop.portal.Background`
- `org.freedesktop.portal.Camera`
- `org.freedesktop.portal.Device`
- `org.freedesktop.portal.Documents`
- `org.freedesktop.portal.DynamicLauncher`
- `org.freedesktop.portal.Email`
- `org.freedesktop.portal.FileChooser`
- `org.freedesktop.portal.FileTransfer`
- `org.freedesktop.portal.Flatpak.UpdateMonitor`
- `org.freedesktop.portal.Flatpak`
- `org.freedesktop.portal.GameMode`
- `org.freedesktop.portal.Inhibit`
- `org.freedesktop.portal.Location`
- `org.freedesktop.portal.MemoryMonitor`
- `org.freedesktop.portal.NetworkMonitor`
- `org.freedesktop.portal.Notification`
- `org.freedesktop.portal.OpenURI`
- `org.freedesktop.portal.PowerProfileMonitor`
- `org.freedesktop.portal.Print`
- `org.freedesktop.portal.ProxyResolver`
- `org.freedesktop.portal.Realtime`
- `org.freedesktop.portal.RemoteDesktop`
- `org.freedesktop.portal.Request`
- `org.freedesktop.portal.ScreenCast`
- `org.freedesktop.portal.Screenshot`
- `org.freedesktop.portal.Secret`
- `org.freedesktop.portal.Session`
- `org.freedesktop.portal.Settings`
- `org.freedesktop.portal.Trash`
- `org.freedesktop.portal.Wallpaper`

## GNOME Session

[specification](https://people.gnome.org/~mccann/gnome-session/docs/gnome-session.html)

Bus name:

- `org.gnome.SessionManager`?

Interfaces:

- `org.gnome.SessionManager`
- `org.gnome.SessionManager.Client`
- `org.gnome.SessionManager.ClientPrivate`
- `org.gnome.SessionManager.Inhibitor`
- `org.gnome.SessionManager.Presence`

## hostname1

[API reference / man page](https://manpages.debian.org/bullseye/systemd/org.freedesktop.hostname1.5.en.html)

Interface:

- `org.freedesktop.hostname1`

## logind

[specification](https://freedesktop.org/wiki/Software/systemd/logind/)

Bus name:

- `org.freedesktop.login1`

Interfaces:

- `org.freedesktop.login1.Manager`
- `org.freedesktop.login1.Seat`
- `org.freedesktop.login1.Session`
- `org.freedesktop.login1.User`

## Media Player Remote Interfacing Specification (MPRIS)

[specification](https://specifications.freedesktop.org/mpris-spec/latest/)

Bus names:

- `org.mpris.MediaPlayer2.<media_player_name>`

Interfaces:

- `org.mpris.MediaPlayer2`
- `org.mpris.MediaPlayer2.Player`
- `org.mpris.MediaPlayer2.TrackList`
- `org.mpris.MediaPlayer2.Playlists`

## PolicyKit

[specifications](https://www.freedesktop.org/software/polkit/docs/latest/ref-dbus-api.html)

Bus names:

- `org.freedesktop.PolicyKit1` on system bus

Interfaces:

- `org.freedesktop.PolicyKit1.Authority`
- `org.freedesktop.PolicyKit1.AuthenticationAgent`

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

## resolve1

[API reference](https://www.freedesktop.org/software/systemd/man/org.freedesktop.resolve1.html)

Interfaces:

- `org.freedesktop.resolve1.Manager`
- `org.freedesktop.resolve1.Link`

## UDisks2

[API reference](http://storaged.org/doc/udisks2-api/latest/ref-dbus.html)

Bus names:

- `org.freedesktop.UDisks2` on system bus

Interfaces:

- `org.freedesktop.UDisks2.Manager`
- `org.freedesktop.UDisks2.Drive`
- `org.freedesktop.UDisks2.Drive.Ata`
- `org.freedesktop.UDisks2.MDRaid`
- `org.freedesktop.UDisks2.Block`
- `org.freedesktop.UDisks2.Partition`
- `org.freedesktop.UDisks2.PartitionTable`
- `org.freedesktop.UDisks2.Filesystem`
- `org.freedesktop.UDisks2.Swapspace`
- `org.freedesktop.UDisks2.Encrypted`
- `org.freedesktop.UDisks2.Loop`
- `org.freedesktop.UDisks2.Job`
- `org.freedesktop.UDisks2.Drive.LSM`
- `org.freedesktop.UDisks2.Drive.LsmLocal`
- `org.freedesktop.UDisks2.Block.LVM2`
- `org.freedesktop.UDisks2.LogicalVolume`
- `org.freedesktop.UDisks2.VDOVolume`
- `org.freedesktop.UDisks2.Manager.LVM2`
- `org.freedesktop.UDisks2.PhysicalVolume`
- `org.freedesktop.UDisks2.VolumeGroup`
- `org.freedesktop.UDisks2.ISCSI.Session`
- `org.freedesktop.UDisks2.Manager.ISCSI.Initiator`
- `org.freedesktop.UDisks2.Manager.BTRFS`
- `org.freedesktop.UDisks2.Filesystem.BTRFS`
- `org.freedesktop.UDisks2.Manager.ZRAM`
- `org.freedesktop.UDisks2.Block.ZRAM`
- `org.freedesktop.UDisks2.Manager.Bcache`
- `org.freedesktop.UDisks2.Block.Bcache`
- `org.freedesktop.UDisks2.Manager.VDO`
- `org.freedesktop.UDisks2.Block.VDO`

## UPower

[API reference](https://upower.freedesktop.org/docs/ref-dbus.html)

Bus names:

- `org.freedesktop.UPower` on system bus

Interfaces:

- `org.freedesktop.UPower`
- `org.freedesktop.UPower.Device`
- `org.freedesktop.UPower.KbdBacklight`

# wpa_supplicant

[API reference](https://w1.fi/wpa_supplicant/devel/dbus.html)

Bus names:

- `fi.w1.wpa_supplicant1` on system bus

Interfaces:

- `fi.w1.wpa_supplicant1`
- `fi.w1.wpa_supplicant1.Interface`
- `fi.w1.wpa_supplicant1.Interface.WPS`
- `fi.w1.wpa_supplicant1.Interface.P2PDevice`
- `fi.w1.wpa_supplicant1.BSS`
- `fi.w1.wpa_supplicant1.Network`
- `fi.w1.wpa_supplicant1.Peer`
- `fi.w1.wpa_supplicant1.Group`
- `fi.w1.wpa_supplicant1.PersistentGroup`
