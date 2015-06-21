# vagrant-docker-exec
This plugin allows you to run `docker exec` commands from your host. When running docker in a proxy, this will save you the effort of sshing into the proxy to run `docker exec`. If you have multiple running containers, you can exec a command that runs on each container sequentially. Visit [Docker's command reference](https://docs.docker.com/reference/commandline/cli/#exec) for details on the exec command.

## Known Issues
When running vagrant on Linux, interactive shells fail to return output with Vagrant 1.7.2 running on Ubuntu 14 Trusty Tahr. It appears to be a problem inherent to Vagrant 1.7.2 because built in commands like `vagrant docker run` also fail to return output from a shell. There is no known workaround at this time.

A container must be running before running `docker exec`, it will not be started automatically.

`docker-exec` requires Docker 1.3.0 or higher. On non-Linux system, the docker in boot2docker provided by Vagrant is version 1.2 and does not support the exec command, so a custom docker host is required.

You can find more information on setting up a custom docker host on the [Vagrant blog](http://www.vagrantup.com/blog/feature-preview-vagrant-1-6-docker-dev-environments.html) but basically, create Vagrantfile.proxy and forward all your ports:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "phusion/ubuntu-14.04-amd64"
  config.vm.provision "docker"
  config.vm.network :forwarded_port, host: 8080, guest: 8080
  config.vm.provider :virtualbox do |vb|
    vb.name = "docker-proxy"
  end
end
```

And then use the vagrant_vagrantfile setting to reference your custom host in your Vagrantfile:

```ruby
Vagrant.configure("2") do |config|
  config.vm.provider "docker" do |d|
    d.image   = "dockerfile/nginx"
    d.ports   = ["8080:80"]
    d.vagrant_vagrantfile = "./Vagrantfile.proxy"
  end
end
```

This plugin has been tested on Mac OS X and VirtualBox.

## Getting Started
To install the plugin, run the following command:
```bash
vagrant plugin install vagrant-docker-exec
```

Periodically check for updates:
```bash
vagrant plugin update
```

## Usage
A common use case for the exec command is to open a new shell in a running conatiner. To make it easy, run the `docker-shell` shortcut:
```bash
vagrant docker-shell [container]
```

In a single machine environment you can omit the container name and just run `vagrant docker-shell`.

`docker-shell` is a shortcut for `docker-exec` running Bash in an interactive shell:
```bash
vagrant docker-exec -t nginx -- bash
```

The syntax for `docker-exec` is:
```bash
vagrant docker-exec [options] [container] -- <command> [args]
```

Options are:
-t, \-\-[no-]tty Open an interactive shell
\-\-[no-]prefix Prefix output with machine names
\-\-[no-]detach Run in the background

When opening a shell in a multimachine environment, `docker-exec -t` (and `docker-shell`) must be followed by at least 1 container name defined by `config.vm.define`. For example, for this Vagrantfile
```ruby
Vagrant.configure("2") do |config|
  config.vm.define "web" do |v|
    v.vm.provider "docker" do |d|
      d.image   = "dockerfile/nginx"
      d.ports   = ["8082:80"]
      d.name    = "nginx"
      d.vagrant_vagrantfile = "./Vagrantfile.proxy"
    end
  end
end
```

The vagrant identifier is `web` so the command to open a shell will be `vagrant docker-exec -t web -- bash` even though the command `docker ps` will list the container name as "nginx". To avoid confusion it's best to use the same name for `config.vm.define` and `d.name`.

## Examples
Arguments after the double hyphen are sent to docker's exec command. For example, to create a new file in a container named nginx:
```bash
vagrant docker-exec web -- touch /var/www/html/test.html
```

If the command produces output, the output will be prefixed with the name of the container.
```bash
vagrant docker-exec nginx nginx2 -- ifconfig | grep inet
==> nginx:           inet addr:172.17.0.5  Bcast:0.0.0.0  Mask:255.255.0.0
==> nginx:           inet6 addr: fe80::42:acff:fe11:5/64 Scope:Link
==> nginx:           inet addr:127.0.0.1  Mask:255.0.0.0
==> nginx:           inet6 addr: ::1/128 Scope:Host
==> nginx2:           inet addr:172.17.0.4  Bcast:0.0.0.0  Mask:255.255.0.0
==> nginx2:           inet6 addr: fe80::42:acff:fe11:4/64 Scope:Link
==> nginx2:           inet addr:127.0.0.1  Mask:255.0.0.0
==> nginx2:           inet6 addr: ::1/128 Scope:Host
```

To omit the container name prefix, pass the option \-\-no-prefix:
```bash
bundle exec vagrant docker-exec --no-prefix -- head -n 1 /etc/hosts
```

The name of the container is only required for interactive shells. To run a command on multiple running containers, omit the container name:
```bash
vagrant docker-exec -- hostname
==> nginx: 231e57e57825
==> nginx2: 6ebced94866b
```

You can also specify containers as you would any other vagrant command:
```bash
vagrant docker-exec /nginx\d?/ -- ps aux | grep www-data
```

Note that all exec commands run by docker are run as the root user.

## Author
William Kolean william.kolean@gmail.com