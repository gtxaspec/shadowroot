#!/bin/bash

u="$SUDO_USER"

#Make sure we are root to setup the chroot
if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo or root privileges."
    echo "sudo $0 $*"
    exit 1
else

#If the user is running Wayland, prevent installation
if [[ `ps aux | grep /usr/bin/Xwayland | grep -v grep` == *"Xwayland"* ]]; then
echo "Not running X11.  Shadow does not work with Wayland.  Restart installation when Xorg is enabled and running."
exit 1
else
echo "Running Xorg, installation will continue"
fi

#If user is using Arch, run this
if [ -f "/etc/arch-release" ]; then
pacman -S --noconfirm schroot debootstrap
elif [ -f "/etc/fedora-release" ]; then
#If user is using a redhat based distro, run this
yum -y install schroot debootstrap
else
#If user is using a debian based distro, run this
apt-get update
apt-get install -y --no-install-recommends schroot debootstrap
fi



#Create the working directory for the chroot
mkdir /var/shadowroot

#Add chroot to schroot config
echo [shadowroot] >> /etc/schroot/schroot.conf
echo description=Ubuntu Bionic for Shadow >> /etc/schroot/schroot.conf
echo directory=/var/shadowroot >> /etc/schroot/schroot.conf
echo users=$u >> /etc/schroot/schroot.conf
echo root-groups=root >> /etc/schroot/schroot.conf
echo personality=linux >> /etc/schroot/schroot.conf
echo preserve-environment=true >> /etc/schroot/schroot.conf
echo type=directory >> /etc/schroot/schroot.conf
echo profile=shadowroot >> /etc/schroot/schroot.conf

#Create the chroot's configuration directory in schroot config dir
mkdir /etc/schroot/shadowroot

#Copy our fstab to the chroot config dir
cp fstab /etc/schroot/shadowroot/fstab

#Create these empty files we do not use so schroot does not complain.
touch /etc/schroot/shadowroot/copyfiles
touch /etc/schroot/shadowroot/nssdatabases

#TODO: Add logic to find debootstrap if its not in the user's PATH
#Install Ubuntu Bionic 18.04 in chroot
debootstrap --variant=buildd --arch amd64 bionic /var/shadowroot/ http://us.archive.ubuntu.com/ubuntu

#Copy the Ubuntu 18.10 "bionic" sources.list to chroot to we can install software inside it
cp bionic_soures.list /var/shadowroot/etc/apt/sources.list

#Copy inside script to chroot, this script will run inside the chroot to install all required programs and libraries
cp inside_chroot.sh /var/shadowroot/root/inside_chroot.sh

#Create an empty machine-id file (for pulseaudio)
touch /var/shadowroot/etc/machine-id

#Execute inside script in the chroot
schroot -c shadowroot --directory /root -- /root/inside_chroot.sh

#Copy launcher shortcuts to local host
cp shadow-beta /usr/local/bin/shadow-beta
cp shadow-alpha /usr/local/bin/shadow-alpha
cp shadow-prod /usr/local/bin/shadow-prod
cp stop-shadow /usr/local/bin/stop-shadow

#Add execute privileges to shortcuts
chmod +x /usr/local/bin/shadow-beta
chmod +x /usr/local/bin/shadow-alpha
chmod +x /usr/local/bin/shadow-prod
chmod +x /usr/local/bin/stop-shadow

#Install icons for Window Managers
cp /var/shadowroot/usr/share/icons/hicolor/0x0/apps/shadow.png /usr/share/icons/hicolor/48x48/apps/
cp /var/shadowroot/usr/share/icons/hicolor/0x0/apps/shadow-preprod.png /usr/share/icons/hicolor/48x48/apps/
cp /var/shadowroot/usr/share/icons/hicolor/0x0/apps/shadow-testing.png /usr/share/icons/hicolor/48x48/apps/

#Copy menu entries for easy lauching
cp *.desktop /usr/share/applications/
update-desktop-database

##Add lines to fstab for pulseaudio sound fix- remove this if no longer needed.
##echo "/home/$u/.config/pulse      /home/shadow-user/.config/pulse        none    rw,bind         0       0" >> /etc/schroot/shadowroot/fstab

echo -e "\e[30;48;5;226mShadowRoot\e[0m installation is now complete! You may now run the client with the following terminal command: sudo shadow-prod"

fi
