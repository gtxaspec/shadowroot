# shadowroot

## Shadow in a chroot

### Runs a shadow client in a (s)chroot.  Not using docker, no virtualization or containers.

### Features & Info:
* Works on Arch/Fedora/Debian (x86_64 only) based distros.
* Requires schroot and debootstrap packages
* Does not work with WAYLAND, as the client doesn't support it yet.
* Does not work on chromebooks, use the native android client.
* Supports Intel Sandybridge / Ivybridge Hardware (Tested on Lenovo X220 / T520 / X230)

# PC Installation:
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

- args: add the --debug argument to pass all log output to the console.
- args: add the --custom arugment to run the script 'custom.sh' located in /var/shadowroot/home/shadow-user/custom.sh on launch.
- args: add the --help for help message.


## Uninstall:
* Run ./remove_chroot.sh with super-user privileges to remove the chroot and associated files.

## PC bugs
* If you have pointer or keyboard issues, you may disable libinput.  Comment out the "input" group in /var/shadowroot/etc/group and the Shadow Client will disable libinput support.

# Not Working on:
* You tell me! Open an issue.

# Why?
* Running docker, there is a slight cursor lag on my system running the client, so as an alternative, we jailed Shadow in a chroot!  Also using docker, Shadow would not output audio to my bluetooth speaker.  With Shadowroot, it works! (pulseaudio!)

## Thanks to @aar642 and the shadowcker (https://gitlab.com/aar642/shadowcker) project for the awesome work shadowroot was based off.

#### Notice
This project is not affliated with Shadow or Blade in any way shape or form!
