#!/bin/bash
#
# Remove unused apps
sudo zypper remove nautilus evolution gnome-text-editor

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
echo "                             APPLICATIONS - configure apps                         "
echo "___________________________________________________________________________________"
echo "Configure new default file manager"
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

# Configure Nemo to make it a bit more intuitive
gsettings set org.nemo.preferences quick-renames-with-pause-in-between true
gsettings set org.nemo.preferences date-format 'iso'
gsettings set org.nemo.preferences show-reload-icon-toolbar true
gsettings set org.nemo.preferences default-folder-viewer 'list-view'
gsettings set org.nemo.preferences inherit-folder-viewer true
## also when opening folders as with elevated privileges (root user)
sudo -u root dbus-launch gsettings set org.nemo.preferences quick-renames-with-pause-in-between true
sudo -u root dbus-launch gsettings set org.nemo.preferences date-format 'iso'
sudo -u root dbus-launch gsettings set org.nemo.preferences show-reload-icon-toolbar true
sudo -u root dbus-launch gsettings set org.nemo.preferences default-folder-viewer 'list-view'
sudo -u root dbus-launch gsettings set org.nemo.preferences inherit-folder-viewer true
# Set Nemo bookmarks, reflecting folder that will be renamed later (Videos>Media)
truncate -s 0 $HOME/.config/gtk-3.0/bookmarks
tee -a $HOME/.config/gtk-3.0/bookmarks &>/dev/null << EOF
file:///home/${USER}/Downloads Downloads
file:///home/${USER}/Documents Documents
file:///home/${USER}/Music Music
file:///home/${USER}/Pictures Pictures
file:///home/${USER}/Media Media
EOF

echo "Configure Pluma text editor" 
echo "___________________________"
# Associate Pluma as the default text editor
sudo sed -i -e 's@libreoffice-writer.desktop;pluma.desktop;@pluma.desktop;libreoffice-writer.desktop;@g' /usr/share/applications/mimeinfo.cache
# For current user
xdg-mime default pluma.desktop text/plain
update-desktop-database ~/.local/share/applications/
# For root
sudo xdg-mime default pluma.desktop text/plain
sudo update-desktop-database /root/.local/share/applications/

#Configuration of Pluma for user
gsettings set org.mate.pluma highlight-current-line true
gsettings set org.mate.pluma bracket-matching true
gsettings set org.mate.pluma display-line-numbers true
gsettings set org.mate.pluma display-overview-map true
gsettings set org.mate.pluma auto-indent true
gsettings set org.mate.pluma active-plugins "['time', 'sort', 'snippets', 'modelines', 'filebrowser', 'docinfo']"
gsettings set org.mate.pluma color-scheme 'cobalt'

#Configuration of Pluma for root/elevated privileges
sudo -u root dbus-launch gsettings set org.mate.pluma highlight-current-line true
sudo -u root dbus-launch gsettings set org.mate.pluma bracket-matching true
sudo -u root dbus-launch gsettings set org.mate.pluma display-line-numbers true
sudo -u root dbus-launch gsettings set org.mate.pluma display-overview-map true
sudo -u root dbus-launch gsettings set org.mate.pluma auto-indent true
sudo -u root dbus-launch gsettings set org.mate.pluma active-plugins "['time', 'sort', 'snippets', 'modelines', 'filebrowser', 'docinfo']"
sudo -u root dbus-launch gsettings set org.mate.pluma color-scheme 'cobalt'

echo "Configure OnlyOffice" 
echo "____________________"
# Enable dark mode, use separate windows instead of tabs
mkdir -p $HOME/.config/onlyoffice
tee -a $HOME/.config/onlyoffice/DesktopEditors.conf &>/dev/null << EOF
UITheme=theme-dark
editorWindowMode=true
EOF

echo "Configure LibreOffice"
echo "_____________________"
#LibreOffice profile enabling tabbed view, Office-like dark mode icons, Calibri default font and Office365 filetype by default and uto-save every 2min"
cd /tmp
wget -O /tmp/libreoffice-profile.tar.xz "https://github.com/zilexa/manjaro-gnome-post-install/raw/main/files/libreoffice-profile.tar.xz"
tar -xvf /tmp/libreoffice-profile.tar.xz -C $HOME/.config
rm /tmp/libreoffice-profile.tar.xz


echo "Configure Firefox"
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
sudo tee -a /usr/lib/firefox/defaults/pref/autoconfig.js &>/dev/null << EOF
pref("general.config.filename", "firefox.cfg");
pref("general.config.obscure_value", 0);
EOF
# Create default Firefox config file
# -Use system default file manager - include toolbar layout in Sync - Enable bookmarks bar - set toolbar layout
sudo tee -a /usr/lib/firefox/firefox.cfg &>/dev/null << EOF
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
sudo tee -a /usr/lib/firefox/distribution/policies.json &>/dev/null << EOF
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


echo "___________________________________________________________________________________"
echo "                                                                                   " 
echo "  Configure panel (taskbar), App menu (Arcmenu) and common dessktop, GUI settings  "
echo "___________________________________________________________________________________"
# add minimise and maximise to window title bar
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
# Pin common apps to Arc Menu
gsettings set org.gnome.shell.extensions.arcmenu pinned-app-list "['ONLYOFFICE Desktop Editors', '', 'org.onlyoffice.desktopeditors.desktop', 'LibreOffice Writer', '', 'libreoffice-writer.desktop', 'LibreOffice Calc', '', 'libreoffice-calc.desktop', 'LibreOffice Impress', '', 'libreoffice-impress.desktop', 'Document Scanner', '', 'simple-scan.desktop', 'Pinta Image Editor', '', 'pinta.desktop', 'digiKam', '', 'org.kde.digikam.desktop', 'GNU Image Manipulation Program', '', 'gimp.desktop', '', 'Audacity', '', 'audacity.desktop', 'LosslessCut', '', 'losslesscut-bin.desktop', 'Shotcut', '', 'org.shotcut.Shotcut.desktop', 'HandBrake', '', 'fr.handbrake.ghb.desktop', 'BleachBit', '', 'org.bleachbit.BleachBit.desktop', 'Tweaks', '', 'org.gnome.tweaks.desktop', 'Terminal', '', 'org.gnome.Terminal.desktop', 'Extension Manager', '', 'com.mattjakeman.ExtensionManager.desktop', 'Add/Remove Software', '', 'org.manjaro.pamac.manager.desktop']"
# Add most used apps to Panel (favourites)
gsettings set org.gnome.shell favorite-apps "['nemo.desktop', 'firefox.desktop', 'org.gnome.gThumb.desktop', 'pluma.desktop', 'org.gnome.Calculator.desktop']"
# Arc Menu & Dash to Panel
gsettings set org.gnome.shell.extensions.arcmenu arc-menu-placement 'DTP'
gsettings set org.gnome.shell.extensions.arcmenu menu-layout 'Eleven'
gsettings set org.gnome.shell enabled-extensions "['gnome-ui-tune@itstime.tech', 'ding@rastersoft.com', 'appindicatorsupport@rgcjonas.gmail.com', 'dash-to-panel@jderose9.github.com', 'arcmenu@arcmenu.com', 'drive-menu@gnome-shell-extensions.gcampax.github.com', 'custom-hot-corners-extended@G-dH.github.com', 'gestureImprovements@gestures', 'BingWallpaper@ineffable-gmail.com', 'allowlockedremotedesktop@kamens.us', 'improvedosk@nick-shmyrev.dev']"
gsettings set org.gnome.shell.extensions.arcmenu available-placement "[false, true, false]"
gsettings set org.gnome.shell.extensions.dash-to-panel panel-positions '{"0":"LEFT"}'
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.shell.extensions.arcmenu reload-theme true
gsettings set org.gnome.shell.extensions.arcmenu power-options "[(0, true), (1, true), (2, true), (3, true), (4, true), (5, false), (6, true)]"
# Arc Menu Hot corner (top left) 
gsettings set org.gnome.shell.extensions.arcmenu override-hot-corners false
gsettings set org.gnome.shell.extensions.arcmenu hot-corners 'Default'
# Dash to Panel
gsettings set org.gnome.shell.extensions.dash-to-panel animate-appicon-hover true
gsettings set org.gnome.shell.extensions.dash-to-panel animate-appicon-hover-animation-extent "{'RIPPLE': 4, 'PLANK': 4, 'SIMPLE': 1}"
gsettings set org.gnome.shell.extensions.dash-to-panel animate-appicon-hover-animation-zoom "{'SIMPLE': 1.2, 'RIPPLE': 1.25, 'PLANK': 2.0}"
gsettings set org.gnome.shell.extensions.dash-to-panel appicon-margin 8
gsettings set org.gnome.shell.extensions.dash-to-panel appicon-padding 4
gsettings set org.gnome.shell.extensions.dash-to-panel available-monitors "[0]"
gsettings set org.gnome.shell.extensions.dash-to-panel dot-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-panel dot-style-focused 'METRO'
gsettings set org.gnome.shell.extensions.dash-to-panel dot-style-unfocused 'DOTS'
gsettings set org.gnome.shell.extensions.dash-to-panel hide-overview-on-startup true
gsettings set org.gnome.shell.extensions.dash-to-panel hotkeys-overlay-combo 'TEMPORARILY'
gsettings set org.gnome.shell.extensions.dash-to-panel intellihide false
gsettings set org.gnome.shell.extensions.dash-to-panel intellihide-animation-time 250
gsettings set org.gnome.shell.extensions.dash-to-panel intellihide-close-delay 800
gsettings set org.gnome.shell.extensions.dash-to-panel intellihide-hide-from-windows true
gsettings set org.gnome.shell.extensions.dash-to-panel intellihide-use-pressure true
gsettings set org.gnome.shell.extensions.dash-to-panel isolate-workspaces true
gsettings set org.gnome.shell.extensions.dash-to-panel leftbox-padding -1
gsettings set org.gnome.shell.extensions.dash-to-panel overview-click-to-exit true
gsettings set org.gnome.shell.extensions.dash-to-panel panel-anchors '{"0":"MIDDLE"}'
gsettings set org.gnome.shell.extensions.dash-to-panel panel-element-positions '{"0":[{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"showAppsButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"centered"},{"element":"centerBox","visible":true,"position":"stackedBR"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":true,"position":"stackedBR"},{"element":"desktopButton","visible":false,"position":"stackedBR"}]}'
gsettings set org.gnome.shell.extensions.dash-to-panel panel-lengths '{"0":100}'
gsettings set org.gnome.shell.extensions.dash-to-panel panel-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-panel panel-positions '{"0":"LEFT"}'
gsettings set org.gnome.shell.extensions.dash-to-panel panel-size 51
gsettings set org.gnome.shell.extensions.dash-to-panel panel-sizes '{"0":51}'
gsettings set org.gnome.shell.extensions.dash-to-panel secondarymenu-contains-showdetails false
gsettings set org.gnome.shell.extensions.dash-to-panel show-running-apps true
gsettings set org.gnome.shell.extensions.dash-to-panel status-icon-padding -1
gsettings set org.gnome.shell.extensions.dash-to-panel trans-bg-color '#241f31'
gsettings set org.gnome.shell.extensions.dash-to-panel trans-dynamic-anim-target 0.95000000000000007
gsettings set org.gnome.shell.extensions.dash-to-panel trans-dynamic-anim-time 300
gsettings set org.gnome.shell.extensions.dash-to-panel trans-gradient-bottom-color '#5e5c64'
gsettings set org.gnome.shell.extensions.dash-to-panel trans-gradient-bottom-opacity 0.050000000000000003
gsettings set org.gnome.shell.extensions.dash-to-panel trans-gradient-top-color '#000000'
gsettings set org.gnome.shell.extensions.dash-to-panel trans-gradient-top-opacity 0.80000000000000004
gsettings set org.gnome.shell.extensions.dash-to-panel trans-panel-opacity 0.75
gsettings set org.gnome.shell.extensions.dash-to-panel trans-use-custom-bg true
gsettings set org.gnome.shell.extensions.dash-to-panel trans-use-custom-gradient true
gsettings set org.gnome.shell.extensions.dash-to-panel trans-use-custom-opacity true
gsettings set org.gnome.shell.extensions.dash-to-panel trans-use-dynamic-opacity true
gsettings set org.gnome.shell.extensions.dash-to-panel tray-padding -1
gsettings set org.gnome.shell.extensions.dash-to-panel window-preview-title-position 'TOP'
#gsettings set org.gnome.shell.extensions.dash-to-panel panel-element-positions 
# Workspaces
gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.desktop.wm.preferences num-workspaces 2
# Desktop
gsettings set org.gnome.shell.extensions.ding show-home false
gsettings set org.gnome.shell.extensions.ding start-corner 'bottom-left'
gsettings set org.gnome.shell.extensions.ding sort-special-folders true
gsettings set org.gnome.shell.extensions.ding keep-arranged true
# Theme
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark-Maia'
# Display
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic false
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-from 22.0
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-to 8.75
gsettings set org.gnome.desktop.screensaver picture-uri 'file:///usr/share/backgrounds/wallpapers-2018/palm-beach.jpg'
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.session idle-delay 'uint32 480'
# cleanup
gsettings set org.gnome.desktop.privacy remove-old-temp-files true
gsettings set org.gnome.desktop.privacy remove-old-trash-files true
# Touchpad
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false
# Locale
gsettings set org.gnome.system.location enabled true
gsettings set org.gnome.desktop.datetime automatic-timezone true
gsettings set org.gnome.desktop.calendar show-weekdate true
# Keyboard shortcut: Ctrl+Alt+T opens Terminal
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"                  
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Terminal'         
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'gnome-terminal'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Ctrl><Alt>T' 
# Remove Gnome <41 (gnome-screenshots tool) default screenshot shortcuts, they are not logical and do not store screenshots in Pictures/Screenshots
gsettings set org.gnome.settings-daemon.plugins.media-keys area-screenshot "@as []"
gsettings set org.gnome.settings-daemon.plugins.media-keys window-screenshot "@as []"
gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot "@as []"
gsettings set org.gnome.settings-daemon.plugins.media-keys area-screenshot-clip "@as []"
gsettings set org.gnome.settings-daemon.plugins.media-keys window-screenshot-clip "@as []"
gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot-clip "@as []"
# Remove Gnome 42> (Screenshots tool) default screenshot shortcuts, they use the new tool that requires too much user interaction
gsettings set org.gnome.shell.keybindings screenshot "@as []"
gsettings set org.gnome.shell.keybindings show-screenshot-ui "@as []"
gsettings set org.gnome.shell.keybindings screenshot-window "@as []"
# Create Screenshots folder
mkdir $HOME/Pictures/Screenshots
gsettings set org.gnome.gnome-screenshot auto-save-directory "file:///home/${USER}/Pictures/Screenshots/"
# Create custom screenshot shortcuts using foold old gnome-screenshots, only custom shortcuts ARE stored to the auto-save-directory
# Note gnome-screenshot package needs to be installed (already done by this script)
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/']"     
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'Area screenshot to custom folder'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command 'gnome-screenshot -a'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding 'Print'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ name 'Area screenshot to clipboard'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ command 'gnome-screenshot -a -c'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding '<Shift>Print'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ name 'Window screenshot to custom folder'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ command 'gnome-screenshot -w -p'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ binding '<Alt>Print'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/ name 'window screenshot to clipboard'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/ command 'gnome-screenshot -w -c'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/ binding '<Primary>Print'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/ name 'Interactive screenshot to cust folder'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/ command 'gnome-screenshot -i -p'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/ binding '<Primary><Shift>Print'


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


# Get a Firefox shortcut for 2 profiles
echo "---------------------------------------"
echo "Firefox: would you like to be able to launch different profiles (2), by simply right-clicking the Firefox shortcut?"
read -p "Only useful if multiple users use this machine and each user has its own Firefox profile. (y/n)?" answer
case ${answer:0:1} in
    y|Y )
    echo adding profiles to right-click of Firefox shortcut... 
    wget --no-check-certificate -P $HOME/.local/share/applications https://raw.githubusercontent.com/zilexa/Ubuntu-Budgie-Post-Install-Script/master/firefox/firefox.desktop
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
