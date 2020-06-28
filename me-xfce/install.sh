#!/bin/bash

CYANCOLOR='\033[0;36m'
NOCOLOR='\033[0m'

#/etc/apt/sources.list
echo "deb http://deb.debian.org/debian/ buster main non-free" > /etc/apt/sources.list
echo "deb-src http://deb.debian.org/debian/ buster main non-free" >> /etc/apt/sources.list
echo "" >> /etc/apt/sources.list
echo "deb http://security.debian.org/debian-security/ buster/updates main non-free" >> /etc/apt/sources.list
echo "deb-src http://security.debian.org/debian-security/ buster/updates main non-free" >> /etc/apt/sources.list
echo "" >> /etc/apt/sources.list
echo "deb http://deb.debian.org/debian/ buster-updates main non-free" >> /etc/apt/sources.list
echo "deb-src http://deb.debian.org/debian/ buster-updates main non-free" >> /etc/apt/sources.list

#update & upgrade
apt update
apt upgrade -y

#extend path env var
echo "export PATH=/usr/local/sbin:/usr/sbin:/sbin:$PATH" >> ~/.bashrc

#install: DE
apt install xfce4 -y

#install : xcfce : miscs
#pkg list for xfce4-goodies : https://packages.debian.org/buster/xfce4-goodies
apt install xfce4-goodies -y

#utils
apt install linux-headers-$(uname -r) -y
apt install software-properties-common -y

#miscs
#apt install -y iw -y
apt install -y laptop-mode-tools
apt install -y flatpak
apt install -y audacity
apt install -y ffmpeg
apt install -y php
apt install -y epiphany-browser
apt install -y filezilla
apt install -y wireless-tools
apt install -y firmware-realtek
apt install -y hplip hplip-gui
apt install -y build-essential
apt install -y curl wget
apt install -y htop
apt install -y kolourpaint
apt install -y xsane
apt install -y xbacklight
apt install -y vlc vlc-l10n
apt install -y redshift
apt install -y acpi acpi-support acpica-tools acpid acpidump acpitail acpitool
apt install -y gimp
apt install -y scribus inkscape

#vscode
apt install apt-transport-https -y
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
apt install -y code

#libre office
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.libreoffice.LibreOffice -y

#brave
apt install apt-transport-https -y
curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-release.list
apt update
apt install brave-browser -y

#node js & peerflix
curl -sL https://deb.nodesource.com/setup_14.x | bash -
apt install -y nodejs
npm install -g peerflix

#grub config
touch /boot/grub/custom.cfg
echo "set color_normal=white/black" >> /boot/grub/custom.cfg
echo "set color_highlight=red/black" >> /boot/grub/custom.cfg
echo "set menu_color_normal=white/black" >> /boot/grub/custom.cfg
echo "set menu_color_highlight=red/black" >> /boot/grub/custom.cfg
echo GRUB_BACKGROUND=\"\" >> /etc/default/grub
update-grub

#shell
apt install -y fish
#usermod -s /usr/bin/fish nomis

#nemo et mousepad preferences
#dconf write /org/nemo/desktop/show-desktop-icons false
#dconf write /org/nemo/preferences/show-full-path-titles true
gsettings set org.xfce.mousepad.preferences.view color-scheme 'oblivion'

#copy files from git to dehaut home folder and init
cp -R /home/nomis/debian-preparator/me-xfce/home/{.,}* /home/nomis/

#render to Caesar the things that are Caesar's
chown -R nomis /home/nomis/{,.}*
