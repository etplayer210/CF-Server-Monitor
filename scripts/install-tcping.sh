#!/bin/sh

if command -v tcping >/dev/null 2>&1; then
    echo "tcping already installed: $(command -v tcping)"
    exit 0
fi

if [ "$(id -u)" != "0" ]; then
    echo "Please run as root"
    exit 1
fi

set -e

ARCH=$(uname -m)

case "$ARCH" in
    x86_64|amd64)
        URL="https://github.com/pouriyajamshidi/tcping/releases/latest/download/tcping-linux-amd64-static.tar.gz"
        ;;
    aarch64|arm64)
        URL="https://github.com/pouriyajamshidi/tcping/releases/latest/download/tcping-linux-arm64-static.tar.gz"
        ;;
    armv7l|armv6l|arm)
        URL="https://github.com/pouriyajamshidi/tcping/releases/latest/download/tcping-linux-arm-static.tar.gz"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

if command -v curl >/dev/null 2>&1; then
    curl -L "$URL" -o /tmp/tcping.tar.gz
elif command -v wget >/dev/null 2>&1; then
    wget -q "$URL" -O /tmp/tcping.tar.gz
else
    echo "curl or wget required"
    exit 1
fi

tar -xzf /tmp/tcping.tar.gz -C /tmp

install -m 755 /tmp/tcping /usr/bin/tcping

rm -f /tmp/tcping.tar.gz /tmp/tcping

echo "tcping installed:"
tcping -v