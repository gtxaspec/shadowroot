#!/bin/bash

function remove_schroot() {

#end chroot sessions before attempting to remove
echo "Ending Sessions"
schroot --end-session --chroot shadow-prod
schroot --end-session --chroot shadow-beta
schroot --end-session --chroot shadow-alpha

#Remove shadow from schroot config dir
echo "Remove shadowroot from schroot configurations"
rm -rf /etc/schroot/shadowroot

#remove chroot entry from schroot.conf
sed -i '/shadowroot/,+8 d' /etc/schroot/schroot.conf

#remove chroot working directory
echo "Remove shadowroot root"
rm -rf /var/shadowroot

}

function remove_ui() {

#Remove launcher shortcuts on host
echo "Remove launcher shortcuts"
rm -f /usr/local/bin/shadow-beta
rm -f /usr/local/bin/shadow-alpha
rm -f /usr/local/bin/shadow-prod
rm -f /usr/local/bin/stop-shadow

#Remove icons
echo "Remove UI icons"
rm -f /usr/share/icons/hicolor/48x48/apps/shadow.png
rm -f /usr/share/icons/hicolor/48x48/apps/shadow-preprod.png
rm -f /usr/share/icons/hicolor/48x48/apps/shadow-testing.png

#delete menu entries
echo "Delete UI menu entries"
rm -f /usr/share/applications/shadow*.desktop
update-desktop-database

}

if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
else
	remove_schroot
	remove_ui
fi
