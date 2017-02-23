# Build a statsdaemon RPM

This is to build for EL7 only.

See: https://github.com/bitly/statsdaemon

statsdaemon is a statsd replacement written in go-lang. It's simpler to install since it's a single binary vs an install of nodejs + statsd.

## Using Docker

This will place an RPM file into the `rpms` directory

First, build the container image:

```
docker build -t centosdev:7 .
```

Then run the build script in the container to generate the RPM:

```
docker run -t -i -v $PWD:/shared centosdev:7 /shared/build.sh
```

## Versions

If you want to install a different version, e.g. v0.7, you can override the `STATSDAEMON_BINARY_URL` environment variable.
```
docker run -t -i -v $PWD:/shared -e STATSDAEMON_BINARY_URL='https://github.com/bitly/statsdaemon/releases/download/v0.7/statsdaemon-0.7.linux-amd64.go1.4.2.tar.gz' centosdev:7 /shared/build.sh 
```

## Cleanup

Once you've finished with the docker image, you can remove it via:

```
docker image rm -f centosdev:7
```

## Installation / config

Once you have the RPM, you can drop it into your local yum repo and install via yum, or install directly using rpm:

**Via yum:**

```
yum install statsdaemon
```

**Via rpm**

```
rpm -ivh statsdaemon-0.7.1-1.x86_64.rpm
```

### Config

The rpm installs a basic systemd unit file: `/etc/systemd/system/statsdaemon.service` (for example purposes only)

You'll need to update that for your own config (i.e. graphite server host etc). For example:

```
[Unit]
Description=statsd daemon (statsdaemon).
After=network.target

[Service]
ExecStart=/usr/bin/statsdaemon -address=127.0.0.1:8125 -flush-interval=10 -graphite=10.10.1.1:2003 -percent-threshold=75 -percent-threshold=90 -percent-threshold=99 -prefix=stats.production.webserver01.

[Install]
WantedBy=multi-user.target
```

Then to enable and start the service, run:

```
systemctl enable statsdaemon
systemctl start statsdaemon
journalctl -u statsdaemon   # to view log output
```

This is just the bare bones - most people will be using a config management system (e.g. ansible / puppet / chef) to perform the install, deploy the config (which is in the systemd unit file) and start the service.
