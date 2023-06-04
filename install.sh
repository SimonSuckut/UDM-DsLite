#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# IP6 Tunnel module
if [ ! -f /lib/modules/4.19.152-ui-alpine/kernel/net/ipv6/ip6_tunnel.ko ]; then
    cp $SCRIPT_DIR/ip6_tunnel.ko /lib/modules/4.19.152-ui-alpine/kernel/net/ipv6/ip6_tunnel.ko
    depmod
fi

# PPP Hook
if [ ! -f /etc/ppp/ipv6-up.d/dslite-tunnel ]; then
    ln -s $SCRIPT_DIR/ppp/ipv6-up.d/dslite-tunnel /etc/ppp/ipv6-up.d/dslite-tunnel
fi
if [ ! -f /etc/ppp/ipv6-up.d/dslite-tunnel ]; then
    ln -s $SCRIPT_DIR/ppp/ipv6-down.d/dslite-tunnel-down /etc/ppp/ipv6-down.d/dslite-tunnel-down
fi

# odhcp6c Hook
if [ ! -f /usr/sbin/odhcp6c_hooked ]; then
    mv /usr/sbin/odhcp6c /usr/sbin/odhcp6c_hooked
fi
cp $SCRIPT_DIR/odhcp6c /usr/sbin/odhcp6c

# linkcheck Hook
sed -i 's/ExecStart=\/usr\/bin\/linkcheck/ExecStart=\/data\/ds-lite\/linkcheck_hook/g' /lib/systemd/system/linkcheck.service
systemctl daemon-reload

# dpinger Hook
if [ ! -f /usr/bin/dpinger_hooked ]; then
    mv /usr/bin/dpinger /usr/bin/dpinger_hooked
fi
cp $SCRIPT_DIR/dpinger /usr/bin/dpinger
