# D-Bus and X sessions

For a short introduction to D-Bus, read [this guide](./dbus.md). It's important
to note the distinction between a D-Bus *system bus* and a D-Bus *session bus*:

> There are two primary D-Bus buses: a *system bus*, and a *session bus*. It's
> important to note that *these are distinct buses, used for different purposes,
> and are not simply the same bus being run in two different ways*.
>
> A *system bus* relates to services provided by the OS and system daemons, and
> communication between different user sessions. The system bus is used for
> communication about system-wide events: storage being added, network
> connectivity changes, printer status, and so on. There is usually only one
> system bus.
>
> A *session bus* relates to a particular user login session, and is used by
> processes wishing to communicate with each other within that session.

Some software expects to be able to use a D-Bus *system* bus to communicate with
other parts of the system; other software expects to be able to use a D-Bus
*session* bus to communicate with certain parts of a user login session. Some
software doesn't require either. Thus, whether or not you need to enable a
system bus and/or a session bus is dependent on the software you use.

The system bus (e.g. as started by Void Linux's `dbus` service) does
not provide a *session* bus. Session buses are started by your Desktop
Environment (DE), or can be started with `dbus-run-session`, which is
[preferred](https://github.com/void-linux/void-docs/pull/263/files#r426368717)
to `dbus-start`. Both `dbus-run-session` and `dbus-start` set the
`DBUS_SESSION_BUS_ADDRESS` environment variable. However, only
`dbus-start` writes that the value of that variable (together with the
values of `DBUS_SESSION_BUS_PID` and `DBUS_SESSION_BUS_WINDOWID`) to a
file in `~/.dbus/session-bus/`.

The usual way to use `dbus-run-session` is to use it in `~/.xinitrc` to call a
Window Manager (WM), so that a session bus is available to software you run from
within your WM. For example, `.xinitrc` might contain, as its only or final
line:

```
exec dbus-run-session i3
```

Note that the value of `DBUS_SESSION_BUS_ADDRESS` will only be available to the
WM and processes spawned by it - anything in `~/.xinitrc` *after* the call to
`dbus-run-session` will not have access to that value. Thus, if one instead had:

```
dbus-run-session i3
some-program
```

then, from the point of view of `some-program`, `DBUS_SESSION_BUS_ADDRESS` would
not be set. If such a program needs access to the value of
`DBUS_SESSION_BUS_ADDRESS`, it should be instead called via the WM's setup
process: for example, in `~/.config/i3/config` or `~/.config/bspwm/bspwmrc`.

## PulseAudio

In general, [as described in the Void
Handbook](https://docs.voidlinux.org/config/media/pulseaudio.html), PulseAudio
should be started on demand via D-Bus, rather than by using the `pulseaudio`
service. PulseAudio can be started via the system bus or a session bus. However,
some hardware setups can require that PulseAudio be started with `pulseaudio
--start` instead.
