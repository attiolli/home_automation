#!/bin/bash

# Check if all required arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 my_email my_domain my_isp_smtp_address" >&2
    exit 1
fi

# Assign command line arguments to variables
myemail="$1"
domain="$2"
myispsmtp="$3"

# Asenna paketit
apt-get update && apt-get install -y postfix mailutils

# Laita konffit (korjaa fqdn & katso että ko. Fqdn resolvautuu DNS kautta joksikin osoitteeksi)
cat << EOF > /etc/aliases
root: ${myemail}
EOF

cat << EOF > /etc/mailutils.conf
address {
  email-domain $(hostname).${domain};
};
EOF

cat << EOF > /etc/postfix/main.cf
myhostname=$(hostname).${domain}
smtpd_banner = \$myhostname ESMTP \$mail_name (Debian/GNU)
biff = no
# appending .domain is the MUA's job.
append_dot_mydomain = no
# Uncomment the next line to generate "delayed mail" warnings
#delay_warning_time = 4h
alias_maps = hash:/etc/aliases
alias_database = hash:/etc/aliases
mydestination = \$myhostname, localhost.\$mydomain, localhost
#relayhost =
mynetworks = 127.0.0.0/8
inet_interfaces = loopback-only
recipient_delimiter = +
compatibility_level = 2
# google mail configuration
relayhost = ${myispsmtp}:587
smtp_use_tls = yes
smtp_sasl_auth_enable = no
EOF

echo "Postfix related files created successfully."

# restarttaa postfix
systemctl restart postfix

echo "Postfix restarted."

# aja newaliases 
newaliases

# Testaa lähettämällä meili
echo "This is a test email from root" | mail -s "Test Email" root

echo "Sent a test email to root, check your inbox."
