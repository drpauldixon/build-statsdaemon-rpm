#!/bin/bash
RVM_SCRIPT=/etc/profile.d/rvm.sh

# Build a statsdaemon RPM

set -x
STATSDAEMON_BINARY_URL="${STATSDAEMON_BINARY_URL:-https://github.com/bitly/statsdaemon/releases/download/v0.7.1/statsdaemon-0.7.1.linux-amd64.go1.4.2.tar.gz}"
STATSDAEMON_TGZ=$(basename $STATSDAEMON_BINARY_URL)
STATSDAEMON_VERSION=$(echo $STATSDAEMON_TGZ | sed -e "s/statsdaemon-//" -e "s/.linux.*//")
BUILD_ROOT=/root/build
set +x

mkdir -p $BUILD_ROOT/usr/bin $BUILD_ROOT/etc/systemd/system
[ ! -d /shared/rpms ] && mkdir /shared/rpms
wget -nc $STATSDAEMON_BINARY_URL
tar xzf $STATSDAEMON_TGZ
STATSDAEMON_BINARY=$(find . -name statsdaemon)
mv $STATSDAEMON_BINARY $BUILD_ROOT/usr/bin

cat > $BUILD_ROOT/etc/systemd/system/statsdaemon.service << EOF
[Unit]
Description=statsd daemon (statsdaemon).
After=network.target

[Service]
ExecStart=/usr/bin/statsdaemon -address=127.0.0.1:8125 -flush-interval=10 -graphite=127.0.0.1:2003 -percent-threshold=75 -percent-threshold=90 -percent-threshold=99 -prefix=stats.

[Install]
WantedBy=multi-user.target
EOF

builtin cd $WORKSPACE
rm -f *.rpm
fpm -s dir -t rpm -n statsdaemon -v $STATSDAEMON_VERSION --config-files /etc/systemd/system/statsdaemon.service -C $BUILD_ROOT usr etc
cp -f statsdaemon-$STATSDAEMON_VERSION-1.x86_64.rpm /shared/rpms
echo "copied statsdaemon-$STATSDAEMON_VERSION-1.x86_64.rpm to rpms"
