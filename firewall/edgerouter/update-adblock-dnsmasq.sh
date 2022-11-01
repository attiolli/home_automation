#!/bin/bash
# The script will download a set of adservers which are then masked as "0.0.0.0" when someone runs a dns query on them.
# Tested with Edgerouter X when using DNSMASQ
# On Edgerouter as root, set the script to run on crontab for example like this:
# 20 4 * * *  /root/update-adblock-dnsmasq.sh
# (Every morning at 04:20)

# Blocklists pre-formatted as e.g. "0.0.0.0 ads.google.com"
# NB: the script implies blocklists use 0.0.0.0 as the blackhole IP. If you change blocklists you need to change the code.
blocklist_urls=("https://pgl.yoyo.org/adservers/serverlist.php?hostformat=dnsmasq")

# Blackhole/IP to respond to DNS query if domain is on blocklist
# IP "0.0.0.0" is a black hole. Per RFC 1122, section 3.2.1.3 "This host on this network. MUST NOT be sent, except as a source address as part of an initializ
ation procedure by which the host learns its own IP address."
blackhole_ip="0.0.0.0"

# Block configuration to be used by dnsmasq
blocklist="/etc/dnsmasq.d/dnsmasq-blocklist.conf"
# Temp blocklists
tmp_blocklist="/tmp/dnsmasq-raw_blocklist.conf.tmp"

# Make sure we're starting with empty blocklists
rm -f $tmp_blocklist

# Blocklists pre-formatted as e.g. "0.0.0.0 ads.google.com"
# NB: the script implies blocklists use 0.0.0.0 as the blackhole IP. If you change blocklists you need to change the code.
# You could use regex matches to make this prettier and more flexible.
for i in "${blocklist_urls[@]}"
do
    curl -k -s "$i" | sed "s/0\.0\.0\.0 //" >> $tmp_blocklist
    done

    # Remove any comment lines/lines containing '#'
    sed -i "/#.*$/d;/^$/d" $tmp_blocklist

    # Format raw blocklist
    # Add to start of all lines: '/address='
    sed -i "s/^/address=\//g" $tmp_blocklist
    # Add to end of all lines: '/$blackhole_ip'
    sed -i "s/$/\/$blackhole_ip/" $tmp_blocklist

    # Domains that need to be allowed (whitelisting patterns here)
    sed -i "/googleadservices/d" $tmp_blocklist
    sed -i "/t.co/d" $tmp_blocklist

    # Keep only unique entries
    sort $tmp_blocklist | uniq > $blocklist

    # Clean up temp blocklists
    rm -f $tmp_blocklist

    # Restart dnsmasq to load new config
    /etc/init.d/dnsmasq force-reload
