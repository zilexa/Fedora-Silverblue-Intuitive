# Remove unused apps
sudo zypper remove nautilus
sudo zypper remove evolution

# Install apps
# Nemo filemanager and useful plugins
sudo zypper install nemo nemo-extension-audio-tab nemo-extension-compare nemo-extension-emblems nemo-extension-folder-color nemo-extension-image-converter nemo-extension-preview nemo-extension-repairer nemo-extension-seahorse nemo-extension-share nemo-font-manager

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
