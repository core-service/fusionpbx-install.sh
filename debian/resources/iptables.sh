#!/bin/sh

touch /etc/firewall.sh
echo '

#!/bin/bash
EXIF="eth0"

# Clear any existing firewall stuff before we start
/usr/sbin/iptables -F
#/usr/sbin/iptables --flush
#systemctl restart netfilter-persistent.service

# As the default policies, drop all incoming traffic but allow all
# outgoing traffic.  This will allow us to make outgoing connections
# from any port, but will only allow incoming connections on the ports
# specified below.
/usr/sbin/iptables --policy INPUT DROP
/usr/sbin/iptables --policy OUTPUT ACCEPT

# Allow all incoming traffic if it is coming from the local loopback device
/usr/sbin/iptables -A INPUT -i lo -j ACCEPT

# Accept all incoming traffic associated with an established connection, or a "related" connection
/usr/sbin/iptables -A INPUT -i $EXIF -m state --state ESTABLISHED,RELATED -j ACCEPT

# Check new packets are SYN packets for syn-flood protection
/usr/sbin/iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP

# Drop fragmented packets
/usr/sbin/iptables -A INPUT -f -j DROP

# Drop malformed XMAS packets
/usr/sbin/iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

# Drop null packets
/usr/sbin/iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

# Help to stop nasty scanners, hackers, burglars and wapists!
#/usr/sbin/iptables -I INPUT -p tcp -m tcp --dport 5060 -m string --string "User-Agent: snom" --algo bm --to 65535 -j DROP
#/usr/sbin/iptables -I INPUT -p udp -m udp --dport 5060 -m string --string "User-Agent: snom" --algo bm --to 65535 -j DROP
/usr/sbin/iptables -I INPUT -p udp -m udp --dport 5060 -m string --string "User-Agent: eyeBeam" --algo bm --to 65535 -j DROP
/usr/sbin/iptables -I INPUT -p udp -m udp --dport 5060 -m string --string "User-Agent: friendly-scanner" --algo bm --to 65535 -j DROP
/usr/sbin/iptables -I INPUT -p udp -m udp --dport 5060 -m string --string "User-Agent: VaxSIPUserAgent" --algo bm --to 65535 -j DROP
/usr/sbin/iptables -I INPUT -p udp -m udp --dport 5060 -m string --string "User-Agent: sundayddr" --algo bm --to 65535 -j DROP	
/usr/sbin/iptables -I INPUT -p udp -m udp --dport 5060 -m string --string "User-Agent: sipsak" --algo bm --to 65535 -j DROP
/usr/sbin/iptables -I INPUT -p udp -m udp --dport 5060 -m string --string "User-Agent: sipvicious" --algo bm --to 65535 -j DROP
/usr/sbin/iptables -I INPUT -p udp -m udp --dport 5060 -m string --string "User-Agent: iWar" --algo bm --to 65535 -j DROP
/usr/sbin/iptables -I INPUT -p udp -m udp --dport 5060 -m string --string "User-Agent: sip-scan" --algo bm --to 65535 -j DROP
/usr/sbin/iptables -I INPUT -p udp -m udp --dport 5060 -m string --string "User-Agent: sipcli" --algo bm --to 65535 -j DROP
/usr/sbin/iptables -I INPUT -p udp -m udp --dport 5060 -m string --string "User-Agent: CSipSimple" --algo bm --to 65535 -j DROP
/usr/sbin/iptables -I INPUT -p udp -m udp --dport 5060 -m string --string "User-Agent: SIVuS" --algo bm --to 65535 -j DROP
/usr/sbin/iptables -I INPUT -p udp -m udp --dport 5060 -m string --string "User-Agent: Gulp" --algo bm --to 65535 -j DROP
/usr/sbin/iptables -I INPUT -p udp -m udp --dport 5060 -m string --string "User-Agent: sipv" --algo bm --to 65535 -j DROP
/usr/sbin/iptables -I INPUT -p udp -m udp --dport 5060 -m string --string "User-Agent: smap" --algo bm --to 65535 -j DROP
/usr/sbin/iptables -I INPUT -p udp -m udp --dport 5060 -m string --string "User-Agent: friendly-request" --algo bm --to 65535 -j DROP
/usr/sbin/iptables -I INPUT -p udp -m udp --dport 5060 -m string --string "User-Agent: VaxIPUserAgent" --algo bm --to 65535 -j DROP
/usr/sbin/iptables -I INPUT -p udp -m udp --dport 5060 -m string --string "User-Agent: siparmyknife" --algo bm --to 65535 -j DROP
/usr/sbin/iptables -I INPUT -p udp -m udp --dport 5060 -m string --string "User-Agent: Test Agent" --algo bm --to 65535 -j DROP

# Allow connections from my machines
/usr/sbin/iptables -A INPUT -p tcp -i $EXIF -m state --state NEW -s 10.10.10.0/24 -j ACCEPT

# Allow http/https
#/usr/sbin/iptables -A INPUT -p tcp -i $EXIF --dport 80 -j ACCEPT
#/usr/sbin/iptables -A INPUT -p tcp -i $EXIF --dport 443 -j ACCEPT
#/usr/sbin/iptables -A INPUT -p tcp -i $EXIF --dport 8021 -j ACCEPT


# Allow SIP connections
/usr/sbin/iptables -A INPUT -p tcp -i $EXIF --dport 5060:5069 -j ACCEPT
/usr/sbin/iptables -A INPUT -p udp -i $EXIF --dport 5060:5069 -j ACCEPT
/usr/sbin/iptables -A INPUT -p udp -i $EXIF --dport 16384:32768 -j ACCEPT


# Allow icmp input so that people can ping us
/usr/sbin/iptables -A INPUT -p icmp --icmp-type 8 -m state --state NEW -j ACCEPT

# Log then reject any packets that are not allowed. You will probably want to turn off the logging
#/usr/sbin/iptables -A INPUT -j LOG
/usr/sbin/iptables -A INPUT -j REJECT

' >> /etc/firewall.sh

## Make firewall exectable
chmod +x /etc/firewall.sh