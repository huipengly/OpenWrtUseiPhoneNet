#!/bin/sh

#script to make the OpenWrt Router use net from iPhone

#install packages
opkg update
opkg install kmod-usb-net-ipheth kmod-usb-net kmod-usb-ohci libimobiledevice-utils libplist-utils libusbmuxd-utils usbmuxd

#usbmuxd auto-start
cp usbmuxd /etc/init.d/usbmuxd
chmod +x /etc/init.d/usbmuxd

/etc/init.d/usbmuxd enable
/etc/init.d/usbmuxd start

#set network
uci delete network.wan

uci set network.iPhone=interface
uci set network.iPhone.proto=dhcp
uci set network.iPhone.ifname=eth1
uci commit network

uci set firewall.@zone[1].network='wan6 iPhone'
uci commit firewall
/etc/init.d/firewall restart
/etc/init.d/network reload
/etc/init.d/network restart
