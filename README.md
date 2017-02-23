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


```
docker run -t -i -v $PWD:/shared -e STATSDAEMON_BINARY_URL='https://github.com/bitly/statsdaemon/releases/download/v0.7/statsdaemon-0.7.linux-amd64.go1.4.2.tar.gz' centosdev:7 /shared/build.sh 
```

## Cleanup

Once you've finished with the docker image, you can remove it via:

```
docker image rm -f centosdev:7
```
