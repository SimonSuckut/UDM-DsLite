# UDM-DsLite
This repository is a workaround for adding Dual Stack Light (defined in RFC 6333 and RFC 6334) support to the Unifi Dream Machine. DS-Lite is a technique used for ipv4 connectivity over ipv6 only internet connections. This technique is used by many ISPs in e.g. Germany. The technique was testet on the Dream Macine Pro, but shoudld work on the regualar UDM as well.
This repository currently supports firmware version 3.0.20 and is not tested on other versions.

## Installation
SSH into your Dream Machine and copy the content of this repository to /data/ds-lite on the device. Then run the install script.
```
./install.sh
```
Afterward, setup the PPPoE connection on the Web console. Make sure that you enable ipv6 and that you get an ipv6 address (some DS-Lite providers don't assign one over DHCP. In those cases, just assign a static one. The IP does not matter, it will never be used for any outgoing packages).

## How it works
The Dual Stack Light specification requires to request DHCPv6 option 64 which returns the domain name of the so called AFTR-Gateway. The UDM creates an ipip6 tunnel to this gateway to get ipv4 connectivity. The UDM uses the [odhcp6c](https://github.com/openwrt/odhcp6c) client on the WAN interface which luckyly already supports option 64. Thus it is sufficient to create a simple shell script that wraps this application to request option 64. The pppd application, which is used to create the PPPoE connection provides the possibliity to add hooks. A simple hook script, which is called after the ipv6 connection on the ppp interface is established, is used to create the ipip6 tunnel and apply some firewall rules to propery apply WAN rules to the packets of the tunnel interface. The main problem is that the UDM firmware comes with does not include the ip6_tunnel module. Thus I had to build one (which is rather tricky without the mathing kernel sources/headers). You can build it your self using the [udm-ip6-tunnel](https://github.com/SimonSuckut/udm-ip6-tunnel) repository.
The last step is to hook 2 applications, namely linkcheck and dpinger which are used by the Unifi Network application to perform speedtests and determine whether the ISP connection is online and working.

## Contributing
Feel free to create pull-request. I am neither a networking nor a linux kernel export. You are welcome to make suggestions or improvements.

## License
The code is released under the GPLv2 license. See COPYING.txt.
