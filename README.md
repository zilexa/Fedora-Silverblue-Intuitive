1. Install Fedora Silverblue
    - Download the Fedora Media Writer and use it to prep your USB boot stick (use a fast min. 32GB one).
    - Shutdown, turn on, hit bootmenu key (usually F9 or F10), select the USB stick. Install Fedora Silverblue.
    - Reboot, finish wizard
2. Rebase to the base uBlue OS image
    - Open Terminal (CTRL+T) and rebase with this command:
       - For Intel/AMD: `rpm-ostree rebase ostree-unverified-registry:ghcr.io/ublue-os/silverblue-main`
       - For nVidia: `rpm-ostree rebase ostree-unverified-registry:ghcr.io/ublue-os/silverblue-nvidia`
    - Reboot
3. Run the Fedora Silverblue Intuitive script to configure the OS, install & configure common apps
    - Download and run it:
        - `cd Downloads` 
        - `wget https://raw.githubusercontent.com/zilexa/Fedora-Silverblue-Intuitive/main/postinstall.sh`
        - `bash postinstall.sh`
    - Follow the instructions at the beginning and end. Have some patience. 
    - Reboot when done. 
  
