# shadowroot

## Shadow in a chroot

### Runs a shadow client in a (s)chroot.  Not using docker, no virtualization or containers.

### Features & Info:
* Works on Arch/Fedora/Debian (x86 only) based distros.
* Requires schroot and debootstrap packages
* Works on Chromebooks, developer mode must be enabled (https://www.androidcentral.com/how-enable-developer-mode-chrome-os), uses crouton (https://github.com/dnschneid/crouton)

## Non-Chromebook Installation:
* run ./setup_chroot.sh with super-user privileges to begin the installation.
  * This process will use your distributions package manager to download and install:
    * schroot
    * debootstrap
  * Then it will proceed to download Ubuntu Bionic, all associated packages as well as the Shadow clients, creating a chroot located in /var/shadowroot
  
## Running:
Once installation is complete, look in your "Games" menu in your favorite window manager, or in a terminal type:

* sudo shadow-prod
* sudo shadow-beta
* sudo shadow-alpha

### You need super-user privileges to run the shadow client using the chroot.

- bonus: add the --debug argument to pass all log output to the console.


## Uninstall:
* Run ./remove_chroot.sh with super-user privileges to remove the chroot and associates files.

# Chromebook Installation

## Requirements
* Crouton installed with Ubuntu 18.04 Bionic ONLY (other distributions or Ubuntu versions DO NOT WORK WITH SHADOW)

## Chromebook Installation
* If you have CROUTON currently installed:
  * Run: sudo ./chromeroot.sh
* If you do not have CROUTON installed:
  * Enable ChromeOS Developer Mode
  * Open a crosh shell (Hold Ctrl-Alt-T)
  * In the crosh shell, type: shell
  * Once in the shell, you should see a prompt: chronos@localhost / $ (or something similar), paste in the following command:
```
curl https://raw.githubusercontent.com/gtxaspec/shadowroot/master/crouton_shadowroot_setup -o ~/Downloads/crouton_shadowroot_setup ;sudo install -Dt /usr/local/bin -m 755 ~/Downloads/crouton_shadowroot_setup ; sudo crouton_shadowroot_setup
```
  * Installation will proceed, it may take a while to download and install everything. Afterwards, you will see the shadow clients in the "Games" menu.

# Why?
* Running docker, there is a slight cursor lag on my system running the client, so as an alternative, we jailed Shadow in a chroot!  Also using docker, Shadow would not output audio to my bluetooth speaker.  With Shadowroot, it works! (pulseaudio!)

## Thanks to @aar642 and the shadowcker (https://gitlab.com/aar642/shadowcker) project for the awesome work shadowroot was based off.

#### Notice
This project is not affliated with Shadow or Blade in any way shape or form!

