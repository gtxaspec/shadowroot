#!/bin/bash

u=`getent passwd "1000" | cut -d: -f1`

#Make sure we are root to setup the chroot
if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo or root privileges."
    echo "sudo $0 $*"
    exit 1
else

#Set variables so apt doesn't require any user interaction during installation
export DEBIAN_FRONTEND=noninteractive
apt-get update && \
apt-get install -y --no-install-recommends nano

#Download software and updates
apt-get install -y --no-install-recommends \
    dbus \
    fuse \
    gconf-service \
    gconf2 \
    i965-va-driver \
    libappindicator1 \
    libcairo2 \
    libcanberra-gtk-module \
    libcanberra-gtk3-module \
    libcurl3-gnutls \
    libfreetype6 \
    libgdk-pixbuf2.0-0 \
    libgl1 \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    libgles2-mesa \
    libglib2.0-0 \
    libgtk2.0-0 \
    libjson-c3 \
    libnotify4 \
    libnss3 \
    libopus0 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libsecret-1-0 \
    libsm6 \
    libsndio6.1 \
    libssl1.1 \
    libubsan0 \
    libuv1 \
    libva-drm2 \
    libva-glx2 \
    libva-x11-2 \
    libva2 \
    libxtst6 \
    libxxf86vm1 \
    mesa-va-drivers \
    mesa-vdpau-drivers \
    pulseaudio-utils \
    seahorse \
    unzip \
    vainfo \
    vdpau-va-driver \
    wget \
    xserver-xorg-video-intel \
    libinput10 \
    libsdl2-2.0 \
    alsa-utils \
    xfce4-volumed \

#Create the AppImage directory in the home folder where all the clients are stored
mkdir -p /home/$u/AppImage/

#Download clients
wget --no-check-certificate https://update.shadow.tech/launcher/prod/linux/ubuntu_18.04/Shadow.AppImage -O /home/$u/AppImage/Shadow.AppImage && \
wget --no-check-certificate https://update.shadow.tech/launcher/preprod/linux/ubuntu_18.04/ShadowBeta.AppImage -O /home/$u/AppImage/ShadowBeta.AppImage && \
wget --no-check-certificate https://update.shadow.tech/launcher/testing/linux/ubuntu_18.04/ShadowAlpha.AppImage -O /home/$u/AppImage/ShadowAlpha.AppImage  && \

#Give clients user and execute privileges
chmod +x /home/$u/AppImage/*.AppImage
chmod $u:$u -R /home/$u/AppImage

#Create directory for icons
mkdir /usr/share/icons/hicolor/0x0/
mkdir /usr/share/icons/hicolor/0x0/apps

#Install Icons for Window Manager
/home/$u/AppImage/Shadow.AppImage --appimage-extract
mv squashfs-root/usr/share/icons/hicolor/0x0/apps/shadow.png /usr/share/icons/hicolor/48x48/apps/
rm -rf squashfs-root/

/home/$u/AppImage/ShadowBeta.AppImage --appimage-extract
mv squashfs-root/usr/share/icons/hicolor/0x0/apps/shadow-preprod.png /usr/share/icons/hicolor/48x48/apps/
rm -rf squashfs-root/

/home/$u/AppImage/ShadowAlpha.AppImage --appimage-extract
mv squashfs-root/usr/share/icons/hicolor/0x0/apps/shadow-testing.png /usr/share/icons/hicolor/48x48/apps/
rm -rf squashfs-root/

cp *.desktop /usr/share/applications/
update-desktop-database

#Copy launcher shortcuts to local host
cp shadow-beta /usr/local/bin/shadow-beta
cp shadow-alpha /usr/local/bin/shadow-alpha
cp shadow-prod /usr/local/bin/shadow-prod
cp stop-shadow /usr/local/bin/stop-shadow
#ln -s $PWD/driver_install_ihd /usr/local/bin/driver_install_ihd

#Add execute privileges to shortcuts
chmod +x /usr/local/bin/shadow-beta
chmod +x /usr/local/bin/shadow-alpha
chmod +x /usr/local/bin/shadow-prod
chmod +x /usr/local/bin/stop-shadow

#add env

echo DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus >> /etc/environment

echo -e "\e[30;48;5;226mShadowRoot\e[0m installation is now complete! Please restart now."
echo -e "\e[30;48;5;226mShadowRoot\e[0m: After rebooting, you may now run the client with the following terminal command: sudo shadow-prod"

fi
