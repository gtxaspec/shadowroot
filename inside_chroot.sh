#!/bin/bash

#Set variables so apt doesn't require any user interaction during installation
export DEBIAN_FRONTEND=noninteractive

#Delete the symlink to resolved (if present)
rm -f /etc/resolv.conf
#Add public nameservers to reach the internet
touch /etc/resolv.conf
echo nameserver 8.8.8.8 > /etc/resolv.conf
echo nameserver 8.8.4.4 > /etc/resolv.conf

#Install wget and nano and locales
apt-get install -y --no-install-recommends wget nano locales
##language-pack-en-base

#Download software and updates
apt-get update && \
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

#Fix locale errors that client may display when rnu
locale-gen en_US.UTF-8
##TO-DO: match the host's locale

#Create user
useradd -ms /bin/bash shadow-user
groupadd fuse

#match group IDs to real system so keyboard input doesn't break in the VM
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

#create local directories
mkdir -p /home/shadow-user/.config/
mkdir -p /home/shadow-user/.config/pulse
mkdir -p /home/shadow-user/.cache/blade/
mkdir -p /home/shadow-user/.local/share/keyrings/
chown shadow-user:shadow-user -R /home/shadow-user

#DONE!
