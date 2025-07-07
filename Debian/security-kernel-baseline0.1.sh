#!/bin/bash
#Updated at 2016.08.23

#6 Kernel Baseline -- forked from LinuxMint hardening at Hardenedlinux.org.
echo "6 Setting Kernel Baseline..."

echo "Are you on a Desktop/laptop or on a server? (d for a desktop or s for server, or n to skip)"
read d
if [ "$d" == "d" ];then

echo "
##############################################################3
# Functions previously found in netbase
#

# Uncomment the next two lines to enable Spoof protection (reverse-path filter)
# Turn on Source Address Verification in all interfaces to
# prevent some spoofing attacks
net.ipv4.conf.default.rp_filter=1
net.ipv4.conf.all.rp_filter=1

# Uncomment the next line to enable TCP/IP SYN cookies
# See http://lwn.net/Articles/277146/
# Note: This may impact IPv6 TCP sessions too
net.ipv4.tcp_syncookies=1

# Desktop doesn't need IP forward
net.ipv4.ip_forward=0

#  Enabling this option disables Stateless Address Autoconfiguration
#  based on Router Advertisements for this host
net.ipv6.conf.all.forwarding=0


###################################################################
# Additional settings - these settings can improve the network
# security of the host and prevent against some network attacks
# including spoofing attacks and man in the middle attacks through
# redirection. Some network environments, however, require that these
# settings are disabled so review and enable them as needed.
#
# Do not accept ICMP redirects (prevent MITM attacks)
net.ipv4.conf.all.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0

# _or_
# Accept ICMP redirects only for gateways listed in our default
# gateway list (enabled by default)
net.ipv4.conf.all.secure_redirects = 1
#
# Do not send ICMP redirects (we are not a router)
net.ipv4.conf.all.send_redirects = 0
#
# Do not accept IP source route packets (we are not a router)
net.ipv4.conf.all.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0
#
# Log Martian Packets
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.log_martians = 0

#ignore broadcast imcp echo packet
net.ipv4.icmp_echo_ignore_broadcasts = 1

# Ignore all incoming ICMP echo requests
net.ipv4.icmp_echo_ignore_all = 0

# Don't log invalid responses to broadcast
net.ipv4.icmp_ignore_bogus_error_responses = 1

# Disable multicast routing
net.ipv4.conf.default.mc_forwarding=0
net.ipv4.conf.all.mc_forwarding = 0

# Disable proxy_arp
net.ipv4.conf.default.proxy_arp = 0
net.ipv4.conf.all.proxy_arp = 0

# Disable bootp_relay
net.ipv4.conf.default.bootp_relay = 0
net.ipv4.conf.all.bootp_relay = 0

##mitigation
kernel.randomize_va_space=2
kernel.kptr_restrict=2
vm.mmap_min_addr=65536

# Grsecurity
#kernel.grsecurity.chroot_restrict_nice = 0
#kernel.grsecurity.harden_ipc = 0
" > /etc/sysctl.d/99-security.conf

elif [ "$d" == "s" ];then

echo "net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_fin_timeout = 15
net.ipv4.tcp_max_syn_backlog = 8192
net.core.netdev_max_backlog = 16384
net.core.somaxconn = 4096
net.ipv4.tcp_keepalive_time = 300
net.ipv4.tcp_keepalive_probes = 3
net.ipv4.tcp_syn_retries = 3
net.ipv4.tcp_synack_retries = 3 
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.all.rp_filter = 1
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.conf.all.log_martians = 1
net.ipv4.tcp_max_orphans = 65536
net.ipv4.tcp_mem = 131072 196608 262144
net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
kernel.randomize_va_space=2
kernel.kptr_restrict=1
" > /etc/sysctl.d/99-security.conf
fi

/sbin/sysctl --system


#7 Hardening with Apparmor/Grsecurity
echo "Adjust your Apparmor/Grsecurity setting if you want."

echo "Done."
echo
exit 0
