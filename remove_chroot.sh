#!/bin/bash

if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
else


#Remove launcher shortcuts on host
rm -f /usr/local/bin/shadow-beta
rm -f /usr/local/bin/shadow-alpha
rm -f /usr/local/bin/shadow-prod
rm -f /usr/local/bin/stop-shadow

#remove icons

rm -f /usr/share/icons/hicolor/48x48/apps/shadow.png
rm -f /usr/share/icons/hicolor/48x48/apps/shadow-preprod.png
rm -f /usr/share/icons/hicolor/48x48/apps/shadow-testing.png

#remove shadow from schroot config dir

rm -rf /etc/schroot/shadowroot

#remove stuff from /etc/schroot/schroot.conf
sed -i '/shadowroot/,+8 d' /etc/schroot/schroot.conf

#remove schroot
rm -rf /var/shadowroot

#delete menu entries
rm -f /usr/share/applications/shadow*.desktop
update-desktop-database

fi
