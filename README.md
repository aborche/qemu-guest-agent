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

