1. Install Fedora Silverblue:
    - Download the Fedora Media Writer and use it to prep your USB boot stick (use a fast min. 32GB one).
    - Shutdown your system, reboot, hit the bootmenu key (F9, F10 usually) and select the USB stick. Install Fedora Silverblue.
    - Reboot, finish wizard. 
2. Rebase to vanilla uBlue OS (, Silverblue Main)
    - Open Terminal (CTRL+T) and rebase with this command:  \
       For Intel/AMD: `rpm-ostree rebase ostree-unverified-registry:ghcr.io/ublue-os/silverblue-main` \
       For nVidia: `rpm-ostree rebase ostree-unverified-registry:ghcr.io/ublue-os/silverblue-nvidia` 
    - Reboot.
3. Run the Fedora Silverblue Intuitive script to configure the OS, install & configure common apps
    - `bash postinstall.sh`
    - At some point you will be asked to enter your user password to allow configuration to continue.
    - Reboot.
  
