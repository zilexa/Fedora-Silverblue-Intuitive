#!/bin/bash
echo "___________________________________________________________________________________"
echo "                                                                                   "
echo "                         APPLICATIONS - Remove unused apps                         "
echo "___________________________________________________________________________________"
sudo zypper remove nautilus evolution gnome-text-editor


echo "___________________________________________________________________________________"
echo "                                                                                   "
echo "               APPLICATIONS - Install required and recommended apps                "
echo "___________________________________________________________________________________"
# Install apps
# Hardware support: rotation sensor
sudo zypper install -y iio-sensor-proxy
# Wireguard VPN support
sudo zypper install -y wireguard-tools
# Gnome screenshot without having to go through UI
sudo zypper install -y gnome-screenshot
# Gnome Connections, to connect to other PCs/Laptops via RDP or VNC
sudo zypper install -y gnome-connections
# Nemo filemanager and useful plugins (replacing gnome files, Nautilus)
sudo zypper install -y nemo nemo-extension-audio-tab nemo-extension-compare nemo-extension-emblems nemo-extension-folder-color nemo-extension-image-converter nemo-extension-preview nemo-extension-repairer nemo-extension-seahorse nemo-extension-share nemo-font-manager
# Text Editor (replacing default gnome-text-editor)
sudo zypper install -y pluma
# Nextcloud Desktop Client
sudo zypper install -y nextcloud-desktop
# Bleachbit cleanup tool
sudo zypper install -y bleachbit
# Music editor tool
sudo zypper install -y audacity
# Image editor tool
sudo zypper install -y pinta
# Photo management tool
sudo zypper install -y digikam
# Video converter
flatpak install -y app/fr.handbrake.ghb/x86_64/stable
# Video trimmer
flatpak install -y app/no.mifi.losslesscut/x86_64/stable
# Video editor
flatpak install -y app/org.shotcut.Shotcut/x86_64/stable’


echo "___________________________________________________________________________________"
echo "                                                                                   "
echo "           GNOME EXTENSIONS - Required for usable and intuitive system             "
echo "___________________________________________________________________________________"
# Install Gnome Extensions to support a more friendly and intuitive GUI
# Install script to easily install extensions system wide
wget -O gnome-shell-extension-installer.sh "https://github.com/brunelli/gnome-shell-extension-installer/raw/master/gnome-shell-extension-installer"
# ArcMenu for all users
sudo bash /home/asterix/gnome-shell-extension-installer.sh 3628
# Gesture Improvements for all users
sudo bash /home/asterix/gnome-shell-extension-installer.sh 4245
# Dash to Panel for all users
sudo bash /home/asterix/gnome-shell-extension-installer.sh 1160
# Bing Wallpaper for all users
sudo bash /home/asterix/gnome-shell-extension-installer.sh 1262
# Improved On Screen Keyboard
sudo bash /home/asterix/gnome-shell-extension-installer.sh 4413
# Allow Locked Remote Desktop
sudo bash /home/asterix/gnome-shell-extension-installer.sh 4338
# Gnome UI Tune
sudo bash /home/asterix/gnome-shell-extension-installer.sh 4158
# Desktop Icons
sudo bash /home/asterix/gnome-shell-extension-installer.sh 2087
# AppIndicator
sudo bash /home/asterix/gnome-shell-extension-installer.sh 615
# Custom Hot Corners
sudo bash /home/asterix/gnome-shell-extension-installer.sh 4167
# Removable Drive Menu
sudo bash /home/asterix/gnome-shell-extension-installer.sh 7
# Fix permissions of folder containing system-wide extensions otherwise regular users have no access, extensions won't be visible.
sudo chmod -R 755 /usr/share/gnome-shell/extensions


echo "___________________________________________________________________________________"
echo "                                                                                   " 
echo "            GNOME - Intuitive configuration for Gnome, Extensions, Apps            "
echo "___________________________________________________________________________________"
# To override distribution defaults and create your own for all (future and current users)
# See here: https://help.gnome.org/admin/system-admin-guide/stable/dconf-custom-defaults.html.en
# First create a dconf profile
sudo mkdir -p /etc/dconf/profile
sudo tee /etc/dconf/profile/user &>/dev/null << EOF
user-db:user
system-db:local
EOF
# Download the Gnome Intuitive configuration and apply
sudo wget --no-check-certificate -P /etc/dconf/db/local.d https://raw.githubusercontent.com/zilexa/OpenSUSE-post-install/master/00-gnome-intuitive
sudo dconf update


echo "___________________________________________________________________________________"
echo "                                                                                   "
echo "                             APPLICATIONS - configure apps                         "
echo "___________________________________________________________________________________"
echo "Configure NEMO file manager"
echo "__________________________________"
# Associate Nemo as the default filemanager
# For root
sudo xdg-mime default nemo.desktop inode/directory
sudo update-desktop-database /root/.local/share/applications/
# For current user
xdg-mime default nemo.desktop inode/directory
xdg-mime default nemo.desktop x-directory/normal
xdg-mime default nemo-autorun-software.desktop x-content/unix-software
update-desktop-database

# Set Nemo bookmarks, reflecting folder that will be renamed later (Videos>Media)
truncate -s 0 $HOME/.config/gtk-3.0/bookmarks
tee -a $HOME/.config/gtk-3.0/bookmarks &>/dev/null << EOF
file:///home/${USER}/Downloads Downloads
file:///home/${USER}/Documents Documents
file:///home/${USER}/Music Music
file:///home/${USER}/Pictures Pictures
file:///home/${USER}/Media Media
EOF


echo "Configure PLUMA text editor" 
echo "___________________________"
# Associate Pluma as the default text editor
sudo sed -i -e 's@libreoffice-writer.desktop;pluma.desktop;@pluma.desktop;libreoffice-writer.desktop;@g' /usr/share/applications/mimeinfo.cache
# For current user
xdg-mime default pluma.desktop text/plain
update-desktop-database ~/.local/share/applications/
# For root
sudo xdg-mime default pluma.desktop text/plain
sudo update-desktop-database /root/.local/share/applications/


echo "Configure ONLYOFFICE DESKTOPEDITORS" 
echo "____________________"
# Enable dark mode, use separate windows instead of tabs
mkdir -p $HOME/.config/onlyoffice
tee -a $HOME/.config/onlyoffice/DesktopEditors.conf &>/dev/null << EOF
UITheme=theme-dark
editorWindowMode=true
EOF


echo "Configure LIBREOFFICE"
echo "_____________________"
#LibreOffice profile enabling tabbed view, Office-like dark mode icons, Calibri default font and Office365 filetype by default and uto-save every 2min"
cd /tmp
wget -O /tmp/libreoffice-profile.tar.xz "https://github.com/zilexa/manjaro-gnome-post-install/raw/main/files/libreoffice-profile.tar.xz"
tar -xvf /tmp/libreoffice-profile.tar.xz -C $HOME/.config
rm /tmp/libreoffice-profile.tar.xz

# Install LibreOffice languagepack
echo "---------------------------------------"
echo "Install languagepack for LibreOffice?" answer

case ${answer:0:1} in
    y|Y )
    echo "Please type the 2-letter countrycode for the language you would like to install, for example "de" for German language (no caps):"
    read -p 'countrycode for example "nl" and hit ENTER: ' lang
    sudo pamac install --no-confirm libreoffice-fresh-$lang hunspell-$lang hyphen-$lang
    ;;
    * )
        echo "Not installing a languagepack for LibreOffice..." 
    ;;
esac


echo "Configure FIREFOX"
echo "_____________________"
# Enable Firefox support for Wayland
sudo sh -c "echo MOZ_ENABLE_WAYLAND=1 >> /etc/environment"
# For current and future system users and profiles
# Create default policies (install minimal set of extensions and theme, enable syncing of your toolbar layout, disable default Mozilla bookmarks)
# first delete existing profiles
rm -r $HOME/.mozilla/firefox/*.default-release
rm -r $HOME/.mozilla/firefox/*.default
rm $HOME/.mozilla/firefox/profiles.ini

# Enable default Firefox config file
sudo tee -a /usr/lib64/firefox/defaults/pref/autoconfig.js &>/dev/null << EOF
pref("general.config.filename", "firefox.cfg");
pref("general.config.obscure_value", 0);
EOF
# Create default Firefox config file
# -Use system default file manager - include toolbar layout in Sync - Enable bookmarks bar - set toolbar layout
sudo tee -a /usr/lib64/firefox/firefox.cfg &>/dev/null << EOF
// IMPORTANT: Start your code on the 2nd line
defaultPref("dom.w3c_touch_events.enabled",1);
defaultPref("widget.use-xdg-desktop-portal.file-picker",1);
defaultPref("widget.use-xdg-desktop-portal.mime-handler",1);
defaultPref("services.sync.prefs.sync.browser.uiCustomization.state",true);
defaultPref("browser.toolbars.bookmarks.visibility", "always");
defaultPref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[\"screenshot-button\",\"print-button\",\"save-to-pocket-button\",\"bookmarks-menu-button\",\"library-button\",\"preferences-button\",\"panic-button\"],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"customizableui-special-spring1\",\"downloads-button\",\"ublock0_raymondhill_net-browser-action\",\"urlbar-container\",\"customizableui-special-spring2\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"fxa-toolbar-menu-button\",\"history-panelmenu\",\"personal-bookmarks\"]},\"seen\":[\"save-to-pocket-button\",\"_d133e097-46d9-4ecc-9903-fa6a722a6e0e_-browser-action\",\"_contain-facebook-browser-action\",\"sponsorblocker_ajay_app-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"developer-button\"],\"dirtyAreaCache\":[\"nav-bar\",\"widget-overflow-fixed-list\",\"PersonalToolbar\"],\"currentVersion\":17,\"newElementCount\":3}");
EOF
# Create default firefox policies
# -Cleanup bookmarks toolbar by disabling default Mozilla bookmarks - install bare minimum extensions
sudo tee -a /usr/lib64/firefox/distribution/policies.json &>/dev/null << EOF
{
  "policies": {
    "DisableProfileImport": true,
    "NoDefaultBookmarks": true,
    "Extensions": {
      "Install": ["https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi", "https://addons.mozilla.org/firefox/downloads/latest/bypass-paywalls-clean/latest.xpi", "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi", "https://addons.mozilla.org/firefox/downloads/latest/facebook-container/latest.xpi", "https://addons.mozilla.org/firefox/downloads/latest/google-container/latest.xpi", "https://addons.mozilla.org/firefox/downloads/latest/nord-polar-night-theme/latest.xpi"]
    }
  }
}
EOF

# Use your custom Firefox Sync Server by default
echo "---------------------------------------"
read -p "Would you like to use your own Firefox Sync Server? (y/n)" answer
case ${answer:0:1} in
    y|Y )
    echo "Please type your Firefox Sync domain address, for example: firefox.mydomain.com"
    read -p 'Firefox Sync domain address: ' ffsyncdomain
    sudo tee -a /usr/lib/firefox/firefox.cfg &>/dev/null << EOF
defaultPref("identity.sync.tokenserver.uri","https://$ffsyncdomain/token/1.0/sync/1.5");
EOF
    echo "Done. New firefox profile will use your Firefox sync server by default."
    ;;
    * )
        echo "default Mozilla public sync server is used."
    ;;
esac

# Get a Firefox shortcut for 2 profiles
echo "---------------------------------------"
echo "Firefox: would you like to be able to launch different profiles (2), by simply right-clicking the Firefox shortcut?"
read -p "Only useful if multiple users use this machine and each user has its own Firefox profile. (y/n)?" answer
case ${answer:0:1} in
    y|Y )
    cp /usr/share/applications/firefox.desktop /home/asterix/.local/share/applications/
    echo "Please enter the first Firefox profile (user) name:"
    read -p 'firefox profile 1 name (e.g. Lisa): ' profile1
    echo "Please enter the second Firefox profile (user) name:"
    read -p 'firefox profile 2 name (e.g. John): ' profile2
    echo adding profiles to right-click of Firefox shortcut... 
    sudo sed -i -e 's@Actions=new-window;new-incognito-window;@Actions=new-window;$profile1;$profile2;@g' /home/asterix/.local/share/applications/firefox.desktop
    cat >> /home/asterix/.local/share/applications/firefox.desktop << EOL 
    [Desktop Action $profile1]
    Name=start $profile1's Firefox
    Exec=firefox -P $profile1 -no-remote
    [Desktop Action $profile2]
    Name=start $profile2's Firefox
    Exec=firefox -P $profile2 -no-remote
    EOL

    # The shortcut in ~/.local/share/application overrides the system shortcuts in /usr/share/applications. This also removes file associations. Fix those:
    xdg-settings set default-web-browser firefox.desktop
    xdg-mime default firefox.desktop x-scheme-handler/chrome
    xdg-mime default firefox.desktop application/x-extension-htm
    xdg-mime default firefox.desktop application/x-extension-html
    xdg-mime default firefox.desktop application/x-extension-shtml
    xdg-mime default firefox.desktop application/xhtml+xml
    xdg-mime default firefox.desktop application/x-extension-xhtml
    xdg-mime default firefox.desktop application/x-extension-xht
    ;;
    * )
        echo "Keeping the Firefox shortcut as is..."
    ;;
esac
