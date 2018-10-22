# QEMU Guest Agent

QEMU Guest Agent version adopted for FreeBSD

## Getting Started

Before using and compiling QEMU Guest Agent, be sure module "virtio_console"
is loaded

### Prerequisites

Run following command in console

```
# kldload virtio_console
```

For permanent loading virtio_console driver add next line to /boot/loader.conf

```
virtio_console_load="YES"
```

And check filesystem contents

```
# ls -al /dev/vtcon/
total 1
dr-xr-xr-x   2 root  wheel  512 Oct 22 16:05 .
dr-xr-xr-x  11 root  wheel  512 Oct 22 16:05 ..
lrwxr-xr-x   1 root  wheel   10 Oct 22 16:05 com.redhat.spice.0 -> ../ttyV0.1
lrwxr-xr-x   1 root  wheel   10 Oct 22 16:05 org.qemu.guest_agent.0 -> ../ttyV0.2
```

### Installing

Clone this repo and run `make` and then `make install`

```
Give the example
```

Add next lines to `/etc/rc.conf` file

```
qemu_guest_agent_enable="YES"
qemu_guest_agent_flags="-d -v -l /var/log/qemu-ga.log"
```

## Run Agent

After installing qemu-guest-agent, run it with command:

```
# service start qemu-guest-agent
```

## Authors

* **Kaltashkin Eugene** - [aborche](https://github.com/aborche)

## License

This project is licensed under the BSD License - see the [LICENSE.md](LICENSE.md) file for details

