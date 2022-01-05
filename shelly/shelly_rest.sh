#!/bin/bash
#
# Script to provision Gen1 Shelly devices (Manufactured by Allterco Robotics) though their API interface.
# Author: Olli Attila (attley@iki.fi).
# Version: 1.0.
#
# Shelly API documentation: https://shelly-api-docs.shelly.cloud/gen1/#shelly
# Note! If your shelly is not on default factory settings see "settings.conf" file and fill in your shelly subnet.
# Example how to send a single setting to shellies:  ./shelly_rest.sh settings?sntp_server=ntp1.funet.fi
# Example how to send multiple settings to shellies: ./shelly_rest.sh settings?mqtt_max_qos=2\&mqtt_retain=true
# You can also use the script to reboot all of your shellies by executing: ./shelly_rest.sh reboot


# Is the user doing an initial Shelly configuration?
echo Are you configuring a Shelly device with factory default settings? [y/n]
read initialconfig

if [ $initialconfig != "y" ]
then
	# Check settings.conf file
	if [ -f settings.conf ]
	then
		. settings.conf
		if [ -z "$SHELLYSUBNET" ]; then
        		echo "No SHELLYSUBNET defined in settings.conf file"
			printf \n
			exit 1
		fi
	else 
        	echo "Failed to load settings.conf file"
		printf \n
		exit 1
	fi
	# Ask the user for Shelly credentials
	echo Shelly username:$'\n'
	read username
	echo -n Shelly password:$'\n'
	read -s password
fi
if [ $initialconfig == "y" ]; then
	SHELLYSUBNET="192.168.33.1"
fi

# Loop though the given subnet and push settings to the Shelly devices
for ip in $( eval echo $SHELLYSUBNET )
do
        url="http://${ip}/$1"
	echo "$url"
	if [ -z "$username" ] || [ -z "$password" ]
	then
		# Username and/or password is missing, lets try without credentials
        	curl -m 1 -s "$url" && echo
	else
		# Ok so you have given some credential pair, lets try with that
        	curl -m 1 --user $username:$password -s "$url" && echo
	fi
done
