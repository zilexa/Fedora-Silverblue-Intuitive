echo "___________________________________________________________________________________"
echo "                                                                                   "
echo "                           GET LANGUAGE INFO FROM USER                             "
echo "___________________________________________________________________________________"
# Get language & region info
echo "___________________________________________________________________"
read -p "Besides English, would you like spellchecker support for another language? (y/n)" answer
case ${answer:0:1} in
    y|Y )
    echo "Please type the 2-letter countrycode for the language, for example "de" for German language (no caps):"
    echo "___________________________________________________________________"
    read -p 'countrycode for example "de" and hit ENTER: ' LANG
    flatpak config --system --set languages "en;$LANG"
    flatpak update -y ;;
    n|N ) ;;
    * ) ;;
esac


echo "___________________________________________________________________________________"
echo "                                                                                   "
echo "               APPLICATIONS - Install required and recommended apps                "
echo "___________________________________________________________________________________"
# Install applications/tools via the proper method (Flatpak)
# Remove Gnome Text Editor, install a less 'naked' simple texteditor instead
flatpak uninstall -y org.gnome.TextEditor
flatpak -y install flathub mousepad
# Music editor tool
flatpak install -y flathub org.audacityteam.Audacity
# Image editor tool
flatpak install -y flathub com.github.PintaProject.Pinta
# GIMP advanced image editor
flatpak install -y fedora org.gimp.GIMP  
# Video converter
flatpak install -y flathub app/fr.handbrake.ghb/x86_64/stable
# Video trimmer, converter, merger
flatpak install -y flathub losslesscut
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
# Dash-to-Panel (dash-to-panel@jderose9.github.com)
bash install-gnome-extensions.sh --enable 1160
# Removable Drive menu (drive-menu@gnome-shell-extensions.gcampax.github.com)
bash install-gnome-extensions.sh --enable 7
# ArcMenu (arcmenu@arcmenu.com)
bash install-gnome-extensions.sh --enable 3628
# Desktop Icons (gtk4-ding@smedius.gitlab.com)
bash install-gnome-extensions.sh --enable 5263
# Allow Locked Remote Desktop (allowlockedremotedesktop@kamens.us)
bash install-gnome-extensions.sh --enable 4338
# Custom Hot Corners (custom-hot-corners-extended@G-dH.github.com)
bash install-gnome-extensions.sh --enable 4167
# Bing Wallpaper (BingWallpaper@ineffable-gmail.com)
mkdir $HOME/Pictures/Wallpapers
bash install-gnome-extensions.sh --enable 1262
#remove the script used to install extensions. 
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
echo "Configure FIREFOX"
echo "___________________________________"
# For current and future system users and profiles
# Create default policies (install minimal set of extensions and theme, enable syncing of your toolbar layout, disable default Mozilla bookmarks)
# first delete existing profiles
rm -r $HOME/.mozilla/firefox/*.default-release
rm -r $HOME/.mozilla/firefox/*.default
rm $HOME/.mozilla/firefox/profiles.ini

# Create default firefox policies
sudo mkdir -p /etc/firefox/policies
sudo tee -a /etc/firefox/policies/policies.json &>/dev/null << EOF
{
  "policies": {
    "DisableProfileImport": true,
    "NoDefaultBookmarks": true,
    "DisplayBookmarksToolbar": "always",
    "Preferences": {
      "browser.uiCustomization.state": {
        "Value": "{\"placements\":{\"widget-overflow-fixed-list\":[\"screenshot-button\",\"save-to-pocket-button\",\"logins-button\",\"panic-button\",\"preferences-button\",\"bookmarks-menu-button\"],\"unified-extensions-area\":[\"sponsorblocker_ajay_app-browser-action\",\"_contain-facebook-browser-action\",\"magnolia_12_34-browser-action\"],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"customizableui-special-spring1\",\"downloads-button\",\"ublock0_raymondhill_net-browser-action\",\"urlbar-container\",\"customizableui-special-spring2\",\"_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action\",\"unified-extensions-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"firefox-view-button\",\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\",\"fullscreen-button\"],\"vertical-tabs\":[],\"PersonalToolbar\":[\"fxa-toolbar-menu-button\",\"history-panelmenu\",\"personal-bookmarks\"]},\"seen\":[\"save-to-pocket-button\",\"developer-button\",\"sponsorblocker_ajay_app-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"_contain-facebook-browser-action\",\"magnolia_12_34-browser-action\",\"_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action\"],\"dirtyAreaCache\":[\"nav-bar\",\"unified-extensions-area\",\"toolbar-menubar\",\"TabsToolbar\",\"PersonalToolbar\",\"widget-overflow-fixed-list\",\"vertical-tabs\"],\"currentVersion\":20,\"newElementCount\":8}",
        "Status": "default"
      }
    },
    "Extensions": { 
      "Install": ["https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi", "https://github.com/bpc-clone/bpc_updates/releases/download/latest/bypass_paywalls_clean-3.7.1.0.xpi", "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi", "https://addons.mozilla.org/firefox/downloads/latest/facebook-container/latest.xpi", "https://addons.mozilla.org/firefox/downloads/latest/google-container/latest.xpi", "https://addons.mozilla.org/firefox/downloads/latest/nord-polar-night-theme/latest.xpi"]}
  }    
}
EOF


echo "Configure ONLYOFFICE DESKTOPEDITORS" 
echo "___________________________________"
# Enable dark mode, use separate windows instead of tabs
mkdir -p $HOME/.var/app/onlyoffice
tee -a $HOME/.var/app/onlyoffice/DesktopEditors.conf &>/dev/null << EOF
UITheme=theme-dark
editorWindowMode=true
EOF


echo "       Configure LIBREOFFICE       "
echo "___________________________________"
# Adjust the LibreOffice settings to make it look like MS Office: icons: Colibre, ribbon view. Also enable LanguageTools modern spell and grammar checker, save every 5min etc. 
cd $HOME/Downloads
wget -O $HOME/Downloads/libreoffice-configure-to-look-like-Office365.tar.xz "https://github.com/zilexa/Fedora-Silverblue-Intuitive-Postinstall/raw/main/libreoffice-configure-to-look-like-Office365.tar.xz"
mkdir -p $HOME/.var/app/org.libreoffice.LibreOffice/config/libreoffice/4/user
tar -xvf $HOME/Downloads/libreoffice-configure-to-look-like-Office365.tar.xz -C $HOME/.var/app/org.libreoffice.LibreOffice/config/libreoffice/4/user
rm $HOME/Downloads/libreoffice-configure-to-look-like-Office365.tar.xz


echo "Get & install all MS Office365 fonts"
echo "___________________________________"
# Get a script that uses MEGA api to donwload a file
wget -P $HOME/Downloads/ https://raw.githubusercontent.com/tonikelope/megadown/refs/heads/master/megadown
# Get the fonts via MEGA
source $HOME/Downloads/megadown 'https://mega.nz/#!u4p02JCC!HnJOVyK8TYDqEyVXLkwghDLKlKfIq0kOlX6SPxH53u0'
# remove the helper script
rm $HOME/Downloads/megadown
# Extract to systems font folder
mkdir -P $HOME/.local/share/fonts
tar -xvf $HOME/Downloads/fonts-office365.tar.xz -C $HOME/.local/share/fonts
# Refresh the font cache (= register the fonts)
fc-cache -f -v
# Remove the downloaded font file
rm $HOME/Downloads/fonts-office365.tar.xz


echo "___________________________________________________________________________________"
echo "                                                                                   "
echo "                             OPTIONAL SETTINGS - choose y/n                        "
echo "___________________________________________________________________________________"
# Get a Firefox shortcut for 2 profiles
echo "---------------------------------------"
echo "Firefox: would you like to be able to launch different profiles (2), by simply right-clicking the Firefox shortcut?"
read -p "Only useful if multiple users use this machine and each user has its own Firefox profile. (y/n)?" answer
case ${answer:0:1} in
    y|Y )
    mkdir -P $HOME/.local/share/flatpak/exports/share/applications
    cp /var/lib/flatpak/exports/share/applications/org.mozilla.firefox.desktop $HOME/.local/share/flatpak/exports/share/applications/
    echo "Please enter the first Firefox profile (user) name:"
    read -p 'firefox profile 1 name (e.g. Lisa): ' PROFILE1
    echo "Please enter the second Firefox profile (user) name:"
    read -p 'firefox profile 2 name (e.g. John): ' PROFILE2
    echo adding profiles to right-click of Firefox shortcut... 
    sed -i -e 's@Actions=new-window;new-private-window;profile-manager-window;@Actions=new-window;$PROFILE1;$PROFILE2;@g' $HOME/.local/share/flatpak/exports/share/applications/org.mozilla.firefox.desktop
    tee -a $HOME/.local/share/flatpak/exports/share/applications/ &>/dev/null << EOF 
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
