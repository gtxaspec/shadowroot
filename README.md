# shadowroot

## Shadow in a chroot

### Runs a shadow client in a (s)chroot.  Not using docker, no virtualization or containers.

* Works on Arch/Fedora/Debian (x86 only) based distros.
* Requires schroot and debootstrap packages
* Not tested on chromebooks, don't try to run a chroot inside a chroot... yet.

# Installation:
* run ./setup_chroot.sh with super-user privileges to begin the installation.
  * This process will use your distributions package manager to download and install:
    * schroot
    * debootstrap
  * Then it will proceed to download Ubuntu Bionic, all associated packages as well as the Shadow clients, creating a chroot located in /var/shadowroot
  
# Running:
Once installation is complete, look in your "Games" menu in your favorite window manager, or in a terminal type:

* sudo shadow-prod
* sudo shadow-beta
* sudo shadow-alpha

### You need super-user privileges to run the shadow client using the chroot.

- bonus: add the --debug argument to pass all log output to the console.


# Uninstall:
* Run ./remove_chroot.sh with super-user privileges to remove the chroot and associates files.

#Why?
* Running docker there is a slight cursor lag on my system, so as an alternative, I thought of a chroot!  Also using docker, Shadow would not output audio to my bluetooth speaker.  With Shadowroot, it works! (pulseaudio!!!)

## Thanks to @aar642 and the shadowcker (https://gitlab.com/aar642/shadowcker) project for the awesome work shadowroot was based off.

#### Notice
This project is not affliated with Shadow or Blade in any way shape or form!

