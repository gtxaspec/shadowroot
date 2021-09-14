#!/bin/bash

##
##This script executes inside the chroot, and sets up the environment for the Shadow Client
##

#Set variables so apt doesn't require any user interaction during installation
export DEBIAN_FRONTEND=noninteractive

#Install wget and nano and locales, first.
apt-get update && \
apt-get install -y --no-install-recommends wget nano locales
##language-pack-en-base

#Download required software packages for Shadow client to function properly.
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
    sudo \
    wget \
    xserver-xorg-video-intel \
    libinput10 \
    libsdl2-2.0 \
    alsa-utils \
    appmenu-gtk2-module \
    appmenu-gtk3-module \
    firefox \
    xdg-utils \
    libpci-dev \
    libxcb-render-util0 \
    libxcb-image0 \
    libcurl4

#Fix locale errors that client may display when run
locale-gen en_US.UTF-8
##TO-DO: match the host's locale

#Create user
useradd -ms /bin/bash shadow-user
groupadd fuse

#Match group IDs to real system so keyboard input doesn't break in the VM
groupmod -og `stat -c '%g' /dev/fb0` video
groupmod -og `stat -c '%g' /dev/input/event0` input

usermod -aG video shadow-user
usermod -aG fuse shadow-user
usermod -aG input shadow-user
mkdir -p /home/shadow-user/AppImage/
chmod 770 -R /home/shadow-user

#install pulseaudio, install after the group id for input is
#aquired, or it could take over the input ID from the real system

apt-get install -y --no-install-recommends \
	pulseaudio \
&& rm -rf /var/lib/apt/lists/*

#Download clients
wget --no-check-certificate https://update.shadow.tech/launcher/prod/linux/ubuntu_18.04/Shadow.AppImage -O /home/shadow-user/AppImage/Shadow.AppImage && \
wget --no-check-certificate https://update.shadow.tech/launcher/preprod/linux/ubuntu_18.04/ShadowBeta.AppImage -O /home/shadow-user/AppImage/ShadowBeta.AppImage && \
wget --no-check-certificate https://update.shadow.tech/launcher/testing/linux/ubuntu_18.04/ShadowAlpha.AppImage -O /home/shadow-user/AppImage/ShadowAlpha.AppImage  && \

#make clients executable
chmod +x /home/shadow-user/AppImage/*.AppImage

#Install Menu entry icons for Window Manager, create directory for icons
mkdir /usr/share/icons/hicolor/0x0/
mkdir /usr/share/icons/hicolor/0x0/apps

#Extract menu entry icons from clients
/home/shadow-user/AppImage/Shadow.AppImage --appimage-extract
mv squashfs-root/usr/share/icons/hicolor/0x0/apps/shadow.png /usr/share/icons/hicolor/0x0/apps/
rm -rf /root/squashfs-root/

/home/shadow-user/AppImage/ShadowBeta.AppImage --appimage-extract
mv squashfs-root/usr/share/icons/hicolor/0x0/apps/shadow-preprod.png /usr/share/icons/hicolor/0x0/apps/
rm -rf /root/squashfs-root/

/home/shadow-user/AppImage/ShadowAlpha.AppImage --appimage-extract
mv squashfs-root/usr/share/icons/hicolor/0x0/apps/shadow-testing.png /usr/share/icons/hicolor/0x0/apps/
rm -rf /root/squashfs-root/

#Create local directories
mkdir -p /home/shadow-user/.config/
mkdir -p /home/shadow-user/.config/pulse
mkdir -p /home/shadow-user/.cache/blade/
mkdir -p /home/shadow-user/.local/share/keyrings/
chown shadow-user:shadow-user -R /home/shadow-user
touch /home/shadow-user/uuid

#setup custom script to run at lanuch
touch /home/shadow-user/custom.sh
chmod +x /home/shadow-user/custom.sh

##set env variables for dbus
echo DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus >> /etc/environment
echo HOME=/home/shadow-user >> /etc/environment
#breaks shadow, stream will not start:
#echo XDG_RUNTIME_DIR=/run/usr/1000 >> /etc/environment

##allow shadow-user to launch from schroot without asking for a password due to su being in the chroot's command line
echo "shadow-user     ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
sed -i '1i auth  sufficient                 pam_succeed_if.so use_uid user = shadow-user' /etc/pam.d/su
sed -i '1i auth  [success=ignore default=1] pam_succeed_if.so user = shadow-user' /etc/pam.d/su

#set browser for new shadow online authentication, must be run as the shadow-user
runuser -l shadow-user -c 'xdg-settings set default-web-browser firefox.desktop'

exit 0
