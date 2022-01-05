#!/bin/bash
###########################################################################################################
# Dokumentaatio: https://shelly-api-docs.shelly.cloud/gen1/#shelly
# Komentaminen esim: ./shelly_rest.sh settings?sntp_server=10.0.60.1
# Usean komennon lähetys samaan aikaan: ./shelly_rest.sh settings?mqtt_max_qos=2\&mqtt_retain=true
# Vaihda skriptin for looppiin oikea aliverkko, jossa Shellyt sijaitsevat
# Voit myös käyttää skriptiä esim boottaamaan shellyt ajamalla: ./shelly_rest.sh reboot
###########################################################################################################

# Kysy tunnukset Shelly hallintaan
echo -n Shelly username:$'\n'
read -s username
echo -n Shelly password:$'\n'
read -s password

# Looppaa aliverkko läpi ja aja komennot curl avulla shellyihin
for ip in 10.0.60.{100..199}
do
        url="http://${ip}/$1"
	echo "$url"
        curl -m 1 --user $username:$password -s "$url" && echo
done
