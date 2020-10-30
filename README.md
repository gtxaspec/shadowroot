# shadowroot

## Shadow in a chroot

### Runs a shadow client in a (s)chroot.  Not using docker, no virtualization or containers.

### Features & Info:
* Works on Arch/Fedora/Debian (x86_64 only) based distros.
* Requires schroot and debootstrap packages
* Works on Chromebooks, developer mode must be enabled (https://www.androidcentral.com/how-enable-developer-mode-chrome-os), uses crouton (https://github.com/dnschneid/crouton)

# PC Installation (non-chromebook):
### You need super-user privileges to install shadowroot!
* git clone http://www.github.com/gtxaspec/shadowroot; cd shadowroot
* run sudo ./setup_chroot.sh to begin the installation.
  * The installer will use your distributions package manager to download and install:
    * schroot
    * debootstrap
  * Then it will proceed to download Ubuntu Bionic, all associated packages as well as the Shadow clients, creating a chroot located in /var/shadowroot

## Running:
Once installation is complete, look in your "Games" menu in your favorite window manager, or in a terminal type:

* shadow-prod
* shadow-beta
* shadow-alpha

- bonus: add the --debug argument to pass all log output to the console.


## Uninstall:
* Run ./remove_chroot.sh with super-user privileges to remove the chroot and associated files.

## PC bugs
* If you have pointer or keyboard issues, you may disable libinput.  Comment out the "input" group in /var/shadowroot/etc/group and the Shadow Client will disable libinput support.

# Chromebook Installation

## Requirements
* Chromebook with an x86_64 cpu architecture
* If you are installing inside an existing crouton installation, you MUST be using **Ubuntu 18.04 Bionic** *ONLY* (other distributions or Ubuntu versions DO NOT WORK WITH SHADOW)

## Chromebook Installation
* If you have CROUTON currently installed:
  * git clone http://www.github.com/gtxaspec/shadowroot; cd shadowroot
  * Run: sudo ./chromeroot.sh
* If you do not have CROUTON installed:
  * Enable ChromeOS Developer Mode
  * Open a crosh shell (Hold Ctrl-Alt-T)
  * In the crosh shell, type: shell
  * Once in the shell, you should see a prompt: chronos@localhost / $ (or something similar), paste in the following command:
```
curl https://raw.githubusercontent.com/gtxaspec/shadowroot/master/crouton_shadowroot_setup -o ~/Downloads/crouton_shadowroot_setup ;sudo install -Dt /usr/local/bin -m 755 ~/Downloads/crouton_shadowroot_setup ; sudo crouton_shadowroot_setup
```
  * Installation will proceed, it may take a while to download and install everything.
  * After some time it will prompt you to set a username and password.  These will be used inside of crouton.
  * After some more time, and the installation completes, enter the crouton with sudo startxfce4, and you will see the shadow clients in the "Games" menu.

## Chromebook Bugs
* libinput doesn't work.  What does this mean? ex. cat /dev/input/event5 (the keyboard on my chromebook) outputs nothing in the crouton, while it works in the crosh shell. Running fuser -v /dev/input/event5 shows chrome Xorg and hexdump using the input. (possible crouton bug)
* the shadow launcher keyboard shortcut's dont work, fullscreen or otherwise, unless you change the default inside the crouton, applications>settings>keyboard. uncheck system defaults and change the chromebook to something else (logitech for example).  this will break brightness and volume keys
* On intel 8th gen or greater systems, run sudo driver_install_ihd to install the right drivers.

# Not Working on:
* You tell me! Open an issue.

# Why?
* Running docker, there is a slight cursor lag on my system running the client, so as an alternative, we jailed Shadow in a chroot!  Also using docker, Shadow would not output audio to my bluetooth speaker.  With Shadowroot, it works! (pulseaudio!)

## Thanks to @aar642 and the shadowcker (https://gitlab.com/aar642/shadowcker) project for the awesome work shadowroot was based off.

#### Notice
This project is not affliated with Shadow or Blade in any way shape or form!
