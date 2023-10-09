#!/bin/bash
echo "___________________________________________________________________________________"
echo "                                                                                   "
echo "                         APPLICATIONS - Remove unused apps                         "
echo "___________________________________________________________________________________"
# Get language info
echo "---------------------------------------"
echo "Besides English, what other language would you like to spellcheck?" answer
echo "Please type the 2-letter countrycode for the language you would like to install, for example "de" for German language (no caps):"
read -p 'countrycode for example "nl" and hit ENTER: ' lang


echo "___________________________________________________________________________________"
echo "                                                                                   "
echo "               APPLICATIONS - Install required and recommended apps                "
echo "___________________________________________________________________________________"
# Add tools and applications by overlaying the base image
rpm-ostree install hunspell-$lang wireguard-tools gnome-tweaks gnome-screenshot gnome-connections nemo pluma nextcloud-client gnome-shell-extension-dash-to-panel.noarch gnome-shell-extension-appindicator.noarch gnome-shell-extension-drive-menu.noarch
# disable Firefox in the base image - it does not allow video playback due to lack of proprietary codecs
rpm-ostree override remove firefox 
# add Flathub repo and install remaining apps as flatpaks
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# Firefox and ffmpeg to ensure support for all videos
flatpak install -y flathub org.mozilla.firefox flathub org.freedesktop.Platform.ffmpeg-full
# Gnome videos
flatpak install flathub org.gnome.Totem
# Bleachbit cleanup tool
flatpak install -y flathub org.bleachbit.BleachBit
# Music editor tool
flatpak install -y flathub org.audacityteam.Audacity
# Image editor tool
flatpak install -y flathub com.github.PintaProject.Pinta
# GIMP advanced image editor
flatpak install -y fedora org.gimp.GIMP  
# Photo management tool
flatpak install -y flathub org.kde.digikam
# Video converter
flatpak install -y flathub app/fr.handbrake.ghb/x86_64/stable
# Video trimmer
flatpak install -y flathub app/no.mifi.losslesscut/x86_64/stable
# Video editor
flatpak install -y flathub app/org.shotcut.Shotcut/x86_64/stable
# Gnome Extension Manager
flatpak install -y flathub com.mattjakeman.ExtensionManager
# OnlyOffice
flatpak install -y flathub org.onlyoffice.desktopeditors
# LibreOffice
flatpak install -y fedora org.libreoffice.LibreOffice


echo "___________________________________________________________________________________"
echo "                                                                                   "
echo "           GNOME EXTENSIONS - Required for usable and intuitive system             "
echo "___________________________________________________________________________________"
#Install extensions that cannot be installed+autoupdated system-wide on Fedora SilverBlue  
wget -O install-gnome-extensions.sh https://raw.githubusercontent.com/ToasterUwU/install-gnome-extensions/master/install-gnome-extensions.sh
# ArcMenu (arcmenu@arcmenu.com)
install-gnome-extensions.sh --enable 3628
# Desktop Icons (gtk4-ding@smedius.gitlab.com)
install-gnome-extensions.sh --enable 5263
# Improved On Screen Keyboard (improvedosk@nick-shmyrev.dev)
install-gnome-extensions.sh --enable 4413
# Allow Locked Remote Desktop (allowlockedremotedesktop@kamens.us)
install-gnome-extensions.sh --enable 4338
# Custom Hot Corners (custom-hot-corners-extended@G-dH.github.com)
install-gnome-extensions.sh --enable 4167
# Bing Wallpaper (BingWallpaper@ineffable-gmail.com)
install-gnome-extensions.sh --enable 1262
rm install-gnome-extensions.sh 


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


echo "Configure FIREFOX"
echo "_____________________"
# Enable Firefox support for Wayland
sudo flatpak override --socket=wayland --env=MOZ_ENABLE_WAYLAND=1 org.mozilla.firefox
# For current and future system users and profiles
# Create default policies (install minimal set of extensions and theme, enable syncing of your toolbar layout, disable default Mozilla bookmarks)
# first delete existing profiles
rm -r $HOME/.mozilla/firefox/*.default-release
rm -r $HOME/.mozilla/firefox/*.default
rm $HOME/.mozilla/firefox/profiles.ini

# Create a persistent, writeable /usr layer to make changes to the /usr/lib64/firefox folder, applying a policy and defaultPrefs
sudo rpm-ostree usroverlay --hotfix

# Enable default Firefox config file
sudo tee -a /usr/lib64/firefox/defaults/pref/autoconfig.js &>/dev/null << EOF
pref("general.config.filename", "firefox.cfg");
pref("general.config.obscure_value", 0);
EOF
# Create default Firefox config file
# -Use system default file manager - include toolbar layout in Sync - Enable bookmarks bar - set toolbar layout
sudo tee -a /usr/lib64/firefox/firefox.cfg &>/dev/null << EOF
// IMPORTANT: Start your code on the 2nd line
defaultPref("services.sync.prefs.sync.browser.uiCustomization.state",true);
defaultPref("media.ffmpeg.vaapi.enabled",true);
defaultPref("media.ffvpx.enabled",false);
defaultPref("media.navigator.mediadatadecoder_vpx_enabled",true);
defaultPref("media.rdd-vpx.enabled",false);
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
    cat >> /home/asterix/.local/share/applications/firefox.desktop << EOF
    [Desktop Action $profile1]
    Name=start $profile1's Firefox
    Exec=firefox -P $profile1 -no-remote
    [Desktop Action $profile2]
    Name=start $profile2's Firefox
    Exec=firefox -P $profile2 -no-remote
EOF

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
