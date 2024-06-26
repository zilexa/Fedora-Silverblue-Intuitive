echo "___________________________________________________________________________________"
echo "                                                                                   "
echo "                           GET LANGUAGE INFO FROM USER                             "
echo "___________________________________________________________________________________"
# Get language & region info
echo "---------------------------------------"
echo "Besides English, what other language would you like to spellcheck?" answer
echo "Please type the 2-letter countrycode for the language you would like to install, for example "de" for German language (no caps):"
read -p 'countrycode for example "nl" and hit ENTER: ' LANG


echo "___________________________________________________________________________________"
echo "                                                                                   "
echo "               APPLICATIONS - Install required and recommended apps                "
echo "___________________________________________________________________________________"
# Add RPM Fusion to allow for other apps to install, like AMD, INTEL or NVIDIA drivers
#rpm-ostree install --apply-live https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
# Override the default codecs with the non-free codecs for full video playback support in all applications + ffmpeg support
#rpm-ostree override remove libavcodec-free libavfilter-free libavutil-free libavformat-free libswscale-free libswresample-free libpostproc-free --install ffmpeg --install libavcodec-freeworld

# Install essential applications via RPM-OSTREE, apps/tools/extensions 
rpm-ostree install --apply-live --assumeyes hunspell-$LANG dconf-editor gnome-screenshot gnome-connections gnome-shell-extension-dash-to-panel gnome-shell-extension-appindicator gnome-shell-extension-drive-menu gnome-shell-extension-blur-my-shell nemo nemo-extensions nemo-compare nemo-emblems nemo-fileroller nemo-image-converter nemo-search-helpers xed

# add Flathub repo and install remaining apps as flatpaks
##flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# Firefox and ffmpeg to ensure support for all videos
##flatpak install -y flathub org.mozilla.firefox
# Enable Firefox support for Wayland
##sudo flatpak override --socket=wayland --env=MOZ_ENABLE_WAYLAND=1 org.mozilla.firefox
# Remove Gnome Text Editor
flatpak uninstall -y org.gnome.TextEditor
# Ensure ffmpeg-full is available for all Flatpak applications
flatpak install -y flathub runtime/org.freedesktop.Platform.ffmpeg-full/x86_64/23.08
# MPV video player
flatpak install -y fedora app/io.mpv.Mpv/x86_64/stable
# Bleachbit cleanup tool
flatpak install -y flathub org.bleachbit.BleachBit
# Music editor tool
flatpak install -y flathub org.tenacityaudio.Tenacity
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
wget -O $HOME/Downloads/install-gnome-extensions.sh https://raw.githubusercontent.com/ToasterUwU/install-gnome-extensions/master/install-gnome-extensions.sh
# ArcMenu (arcmenu@arcmenu.com)
bash install-gnome-extensions.sh --enable 3628
# Desktop Icons (gtk4-ding@smedius.gitlab.com)
bash install-gnome-extensions.sh --enable 5263
# Allow Locked Remote Desktop (allowlockedremotedesktop@kamens.us)
bash install-gnome-extensions.sh --enable 4338
# Custom Hot Corners (custom-hot-corners-extended@G-dH.github.com)
bash install-gnome-extensions.sh --enable 4167
# Bing Wallpaper (BingWallpaper@ineffable-gmail.com)
bash install-gnome-extensions.sh --enable 1262
mkdir $HOME/Pictures/Wallpapers
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
sudo wget -P /etc/dconf/db/local.d https://raw.githubusercontent.com/zilexa/Fedora-Silverblue-Intuitive-Postinstall/main/00-gnome-intuitive
sudo dconf update


echo "___________________________________________________________________________________"
echo "                                                                                   "
echo "                             APPLICATIONS - configure apps                         "
echo "___________________________________________________________________________________"
echo "Configure NEMO file manager"
echo "__________________________________"
# Create the folder for user-space application shortcuts
sudo mkdir -p /usr/local/share/applications/
# Disable Gnome Nautilus Filemanager
sudo cp /usr/share/applications/org.gnome.Nautilus.desktop /usr/local/share/applications/
sudo sed -i "2a\\NotShowIn=GNOME;KDE" /usr/local/share/applications/org.gnome.Nautilus.desktop
# Fix Nemo shortcut from not showing up in Gnome
sudo cp /usr/share/applications/nemo.desktop /usr/local/share/applications/
sudo sed -i -e 's@OnlyShowIn=X-Cinnamon;Budgie;@#OnlyShowIn=X-Cinnamon;Budgie;@g' /usr/local/share/applications/nemo.desktop
# Update shortcuts database
sudo update-desktop-database /usr/local/share/applications/

# Associate Nemo as the default filemanager
# For current user
xdg-mime default nemo.desktop inode/directory
xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search
xdg-mime default nemo.desktop x-directory/normal
xdg-mime default nemo-autorun-software.desktop x-content/unix-software
sudo update-desktop-database /usr/local/share/applications/

# Set Nemo bookmarks, reflecting folder that will be renamed later (Videos>Media)
truncate -s 0 $HOME/.config/gtk-3.0/bookmarks
tee -a $HOME/.config/gtk-3.0/bookmarks &>/dev/null << EOF
file:///home/${USER}/Downloads Downloads
file:///home/${USER}/Documents Documents
file:///home/${USER}/Music Music
file:///home/${USER}/Pictures Pictures
file:///home/${USER}/Media Media
EOF


echo "Configure ONLYOFFICE DESKTOPEDITORS" 
echo "____________________"
# Enable dark mode, use separate windows instead of tabs
##mkdir -p $HOME/.config/onlyoffice
##tee -a $HOME/.config/onlyoffice/DesktopEditors.conf &>/dev/null << EOF
##UITheme=theme-dark
##editorWindowMode=true
##EOF


echo "Configure LIBREOFFICE"
echo "_____________________"
#LibreOffice profile enabling tabbed view, Office-like dark mode icons, Calibri default font and Office365 filetype by default and uto-save every 2min"
##cd /tmp
##wget -O /tmp/libreoffice-profile.tar.xz "https://github.com/zilexa/Fedora-Silverblue-Intuitive-Postinstall/raw/main/libreoffice-profile.tar.xz"
##tar -xvf /tmp/libreoffice-profile.tar.xz -C $HOME/.config
##rm /tmp/libreoffice-profile.tar.xz



echo "Configure FIREFOX"
echo "_____________________"
# For current and future system users and profiles
# Create default policies (install minimal set of extensions and theme, enable syncing of your toolbar layout, disable default Mozilla bookmarks)
# first delete existing profiles
rm -r $HOME/.mozilla/firefox/*.default-release
rm -r $HOME/.mozilla/firefox/*.default
rm $HOME/.mozilla/firefox/profiles.ini

# Create default firefox policies
# -Cleanup bookmarks toolbar by disabling default Mozilla bookmarks - install bare minimum extensions
sudo mkdir -p /etc/firefox/policies
sudo tee -a /etc/firefox/policies/policies.json &>/dev/null << EOF
{
  "policies": {
    "DisableProfileImport": true,
    "NoDefaultBookmarks": true,
    "Extensions": {
      "Install": ["https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi", "https://github.com/bpc-clone/bpc_updates/releases/download/latest/bypass_paywalls_clean-3.7.1.0.xpi", "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi", "https://addons.mozilla.org/firefox/downloads/latest/facebook-container/latest.xpi", "https://addons.mozilla.org/firefox/downloads/latest/google-container/latest.xpi", "https://addons.mozilla.org/firefox/downloads/latest/nord-polar-night-theme/latest.xpi"]
    }
  }
}
EOF

#  !!! BELOW DOES NOT WORK UNTIL MOZILLA SUPPORTS TO HAVE THESE FILES IN /ETC INSTEAD OF /USR/LIB64/ !!!

# Enable default Firefox config file
sudo tee -a /etc/firefox/pref/autoconfig.js &>/dev/null << EOF
pref("general.config.filename", "firefox.cfg");
pref("general.config.obscure_value", 0);
EOF
sudo mkdir -p /etc/firefox/defaults/pref
sudo cp /etc/firefox/pref/autoconfig.js /etc/firefox/defaults/pref/
# Create default Firefox config file
# -Use system default file manager - include toolbar layout in Sync - Enable bookmarks bar - set toolbar layout
sudo tee -a /etc/firefox/firefox.cfg &>/dev/null << EOF
// IMPORTANT: Start your code on the 2nd line
defaultPref("media.ffmpeg.vaapi.enabled",true);
defaultPref("media.navigator.mediadatadecoder_vpx_enabled",true);
defaultPref("services.sync.prefs.sync.browser.uiCustomization.state",true);
defaultPref("browser.toolbars.bookmarks.visibility", "always");
defaultPref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[\"screenshot-button\",\"print-button\",\"save-to-pocket-button\",\"bookmarks-menu-button\",\"library-button\",\"preferences-button\",\"panic-button\"],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"customizableui-special-spring1\",\"downloads-button\",\"ublock0_raymondhill_net-browser-action\",\"urlbar-container\",\"customizableui-special-spring2\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"fxa-toolbar-menu-button\",\"history-panelmenu\",\"personal-bookmarks\"]},\"seen\":[\"save-to-pocket-button\",\"_d133e097-46d9-4ecc-9903-fa6a722a6e0e_-browser-action\",\"_contain-facebook-browser-action\",\"sponsorblocker_ajay_app-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"developer-button\"],\"dirtyAreaCache\":[\"nav-bar\",\"widget-overflow-fixed-list\",\"PersonalToolbar\"],\"currentVersion\":17,\"newElementCount\":3}");
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
    sudo cp /usr/share/applications/org.mozilla.firefox.desktop /usr/local/share/applications/
    echo "Please enter the first Firefox profile (user) name:"
    read -p 'firefox profile 1 name (e.g. Lisa): ' PROFILE1
    echo "Please enter the second Firefox profile (user) name:"
    read -p 'firefox profile 2 name (e.g. John): ' PROFILE2
    echo adding profiles to right-click of Firefox shortcut... 
    sudo sed -i -e 's@Actions=new-window;new-private-window;profile-manager-window;@Actions=new-window;$PROFILE1;$PROFILE2;@g' /usr/local/share/applications/org.mozilla.firefox.desktop
    sudo tee -a /usr/local/share/applications/org.mozilla.firefox.desktop &>/dev/null << EOF 
[Desktop Action $PROFILE1]
Name=start $profile1's Firefox
Exec=firefox -P $PROFILE1 -no-remote

[Desktop Action $PROFILE2]
Name=start $profile2's Firefox
Exec=firefox -P $PROFILE2 -no-remote

EOF

    # The shortcut in ~/.local/share/application overrides the system shortcuts in /usr/share/applications. This also removes file associations. Fix those:
    ##xdg-settings set default-web-browser firefox.desktop
    ##xdg-mime default firefox.desktop x-scheme-handler/chrome
    ##xdg-mime default firefox.desktop application/x-extension-htm
    ##xdg-mime default firefox.desktop application/x-extension-html
    ##xdg-mime default firefox.desktop application/x-extension-shtml
    ##xdg-mime default firefox.desktop application/xhtml+xml
    ##xdg-mime default firefox.desktop application/x-extension-xhtml
    ##xdg-mime default firefox.desktop application/x-extension-xht
    ;;
    * )
        echo "Keeping the Firefox shortcut as is..."
    ;;
esac
