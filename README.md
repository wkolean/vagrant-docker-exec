# vagrant-docker-exec

This plugin allows you to run `docker exec` on a running container.

## Known Issues

Docker exec requires Docker 1.3.0 or higher. boot2docker provided by Vagrant is version 1.2 and does not support exec, so a proxy VM is required to use
this plugin until boot2docker is updated.

This plugin has been tested on Mac OS X.

## Getting Started

To install the plugin, run the following command:
```bash
vagrant plugin install vagrant-docker-exec
```

## Usage

```bash
vagrant docker-exec [options] [container] -- [command] [args]
```
--[no-]detach Run in the background

-t, --[no-]tty Open an interactive shell

To create a new file in a container named `nginx`

```bash
vagrant docker-exec nginx -- touch /var/www/html/test.html
```

To open an interactive shell in a conatiner named `nginx`

```bash
vagrant docker-exec -t nginx -- bash
```

To simplify opening a shell, you can use the shortcut `vagrant docker-shell [container]`

## Author
William Kolean william.kolean@gmail.com