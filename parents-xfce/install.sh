#!/bin/bash

su

#/etc/apt/sources.list
echo "deb http://deb.debian.org/debian/ buster main non-free" > /etc/apt/sources.list
echo "deb-src http://deb.debian.org/debian/ buster main non-free" >> /etc/apt/sources.list
echo "deb http://security.debian.org/debian-security/ buster/updates main non-free" >> /etc/apt/sources.list
echo "deb-src http://security.debian.org/debian-security/ buster/updates main non-free" >> /etc/apt/sources.list
echo "deb http://deb.debian.org/debian/ buster-updates main non-free" >> /etc/apt/sources.list
echo "deb-src http://deb.debian.org/debian/ buster-updates main non-free" >> /etc/apt/sources.list

#update & upgrade
apt update
apt upgrade -y

#pci wifi card driver
apt install firmware-iwlwifi -y

#copy files from git to dehaut home folder and init
cp -R /home/dehaut/debian-preparator/parents-xfce/home/* /home/dehaut/
chmod +x /home/dehaut/.simon/scan_gray.sh
chmod +x /home/dehaut/.simon/scan_color.sh
chmod +x /home/dehaut/Bureau/Writer
chmod +x "/home/dehaut/Bureau/scan couleur.desktop"
chmod +x "/home/dehaut/Bureau/scan bw.desktop"
chmod +x /home/dehaut/Bureau/org.kde.kolourpaint.desktop
chmod +x /home/dehaut/Bureau/mail.desktop
chmod +x "/home/dehaut/Bureau/Google Earth"
chmod +x /home/dehaut/Bureau/gimp.desktop
chmod +x /home/dehaut/Bureau/Firefox
chmod +x /home/dehaut/Bureau/dehaut.desktop
chmod +x /home/dehaut/.config/autostart/simon_startup_script.sh

#touch wpa supplicant config
touch /etc/wpa_supplicant/wpa_supplicant.conf

#make conf
wpa_passphrase freebox_YSFVBB_dehaut >> /etc/wpa_supplicant/wpa_supplicant.conf

#delete clear pswd
sed -i -r 's/.*#psk.*/\t#psk/g' /etc/wpa_supplicant/wpa_supplicant.conf

#get the computed psk
thePsk=$(cat /etc/wpa_supplicant/wpa_supplicant.conf | xargs | grep -o -P '(?<= psk=).*(?=})' | xargs) 

#write config in /etc/network/interfaces
echo '' >> /etc/network/interfaces
echo 'allow-hotplug wlp2s0' >> /etc/network/interfaces
echo 'iface wlp2s0 inet dhcp' >> /etc/network/interfaces
echo -e '\twpa-ssid freebox_YSFCBB_dehaut' >> /etc/network/interfaces
echo -e '\twpa-psk _vercingetorix_' >> /etc/network/interfaces
#remplace substring by psk 
sed -i -e "s/_vercingetorix_/$thePsk/g" /etc/network/interfaces
chmod 0600 /etc/network/interfaces

#clear var
thePsk = NULL

#extend path env var
echo "export PATH=/usr/local/sbin:/usr/sbin:/sbin:$PATH" >> ~/.bashrc

#set grub timeout to 0
sed -i -r 's/.*GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/g' /etc/default/grub
/usr/sbin/update-grub

#install: DE
apt install xfce4 -y

#install: utils
apt install wget -y
apt install xfce4-terminal -y
apt install htop -y
apt install hplip hplip-gui -y
apt install mousepad -y
apt install atril -y
apt install xarchiver -y
apt install ristretto -y
apt install flatpak

#install: multimedia
apt install firefox-esr firefox-esr-l10n-fr -y
apt install gimp -y
apt install kolourpaint -yclear
apt install vlc vlc-l10n -y

#install: google earth pro
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/earth/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
apt update 
apt install google-earth-pro-stable -y

#libre office
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.libreoffice.LibreOffice -y

#autostart mod : hplip
if [ ! -f /etc/xdg/autostart/hplip-systray.desktop ]; then
	mkdir /etc/xdg/autostart/old
	mv /etc/xdg/autostart/hplip-systray.desktop /etc/xdg/autostart/old/hplip-systray.desktop
fi
if [ ! -f /home/dehaut/autostart/hplip-systray.desktop ]; then
	mkdir /home/dehaut/autostart/old
	mv /home/dehaut/autostart/hplip-systray.desktop /home/dehaut/autostart/old/hplip-systray.desktop
fi

#folder struct
mkdir /home/dehaut/doc
mkdir /home/dehaut/doc/scan
mkdir /home/dehaut/doc/images
mkdir /home/dehaut/doc/téléchargements
