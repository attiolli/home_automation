#!/bin/bash
#
# Script to provision Gen1 Shelly devices (Manufactured by Allterco Robotics) though their API interface.
# Author: Olli Attila (attley@iki.fi).
# Version: 1.0.
# Shelly API documentation: https://shelly-api-docs.shelly.cloud/gen1/#shelly
# Please see settings.conf file for further instructions on how to use the sciprt.

# Some initial checks
if [ -f settings.conf ]; then
	. settings.conf
else 
       	echo "Failed to load settings.conf file"
	exit 1
fi
if [ ! -z "$CONFPARAMS" ]; then
	PARAMS=$CONFPARAMS
fi
if [ ! -z "$1" ]; then
	PARAMS=$1
      	echo "Reading parameters from command line"
fi
if [ -z "$PARAMS" ]; then
       	echo "No parameters given, exiting..."
	exit 1
fi

# Is the user doing an initial Shelly configuration?
echo Are you configuring a Shelly device with factory default settings? [y/n]
read initialconfig
if [ $initialconfig != "y" ]
then
	if [ -z "$SHELLYSUBNET" ]
	then
        	echo "No SHELLYSUBNET defined in settings.conf file"
		exit 1
	fi
	echo Shelly username:
	read username
	echo -n Shelly password:$'\n'
	read -s password
else
	SHELLYSUBNET="192.168.33.1"
      	echo "Setting target address as 192.168.33.1"
fi

REPLIES=0

# Loop though the given subnet and push settings to the Shelly devices
for ip in $( eval echo $SHELLYSUBNET )
do
        url="http://${ip}/$PARAMS"
	echo "$url"
	if [ -z "$username" ] || [ -z "$password" ]
	then
		# Username and/or password is missing, lets try without credentials.
        	curl -m 1 -s "$url" && echo
	else
		# Credential pair given, lets try with that
        	curl -m 1 --user $username:$password -s "$url" && echo
	fi
	if [ $? -eq 0 ]
    	then
        	REPLIES=$(($REPLIES+1))
    	fi
done
echo "All done! Total Shellies affected: ${REPLIES}"
