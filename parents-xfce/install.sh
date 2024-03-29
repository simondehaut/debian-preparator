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

#add x86 arch
dpkg --add-architecture i386

#update & upgrade
apt update
apt upgrade -y

#extend path env var
echo "export PATH=/usr/local/sbin:/usr/sbin:/sbin:$PATH" >> ~/.bashrc

#set grub timeout to 0
sed -i -r 's/.*GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/g' /etc/default/grub
/usr/sbin/update-grub

#install: DE
apt install xfce4 -y

#install: utils
#apt install iw -y
apt install wireless-tools -y
apt install wget -y
apt install xfce4-terminal -y
apt install htop -y
apt install hplip hplip-gui -y
apt install mousepad -y
apt install atril -y
apt install xarchiver -y
apt install ristretto -y
apt install flatpak -y
apt install scrot -y
apt install pdfsam -y

#install and config firewall
apt install ufw -y
systemctl enable ufw
ufw default deny incoming
ufw default allow outgoing

#enable ssd trim timer
systemctl enable fstrim.timer

#install: multimedia
apt install firefox-esr firefox-esr-l10n-fr -y
apt install gimp -y
apt install kolourpaint -y
apt install vlc vlc-l10n -y

#install: wine
apt install wine wine32 wine64 libwine libwine:i386 fonts-wine -y
apt install wine32-preloader wine64-preloader wine32-tools wine64-tools libwine-dev wine-binfmt -y
apt install winetricks -y
apt install zenity -y

#install: google earth pro
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
sh -c 'echo "deb [arch=amd64] https://dl.google.com/linux/earth/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
apt update 
apt install google-earth-pro-stable -y

#install: teamviewer
wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
apt install ./teamviewer_amd64.deb
rm ./teamviewer_amd64.deb

#libre office
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.libreoffice.LibreOffice -y

#autostart mod : hplip
#if [ ! -f /etc/xdg/autostart/hplip-systray.desktop ]; then
#	mkdir /etc/xdg/autostart/old
#	mv /etc/xdg/autostart/hplip-systray.desktop /etc/xdg/autostart/old/hplip-systray.desktop
#fi
#if [ ! -f /home/dehaut/autostart/hplip-systray.desktop ]; then
#	mkdir /home/dehaut/autostart/old
#	mv /home/dehaut/autostart/hplip-systray.desktop /home/dehaut/autostart/old/hplip-systray.desktop
#fi

#folder struct
mkdir /home/dehaut/doc
mkdir /home/dehaut/doc/scan
mkdir /home/dehaut/doc/images
mkdir /home/dehaut/doc/téléchargements
mkdir /home/dehaut/doc/captures_ecran

#copy files from git to dehaut home folder and init
cp -R /home/dehaut/debian-preparator/parents-xfce/home/{.,}* /home/dehaut/
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
chmod +x /home/dehaut/.simon/screenshot.sh
chmod +x /home/dehaut/.simon/open_audio_cd_vlc.sh
chmod +x /home/dehaut/Bureau/lecteur_cd.desktop
chmod +x /home/dehaut/Bureau/teamviewer.desktop

#pci wifi card driver
#apt install firmware-iwlwifi -y
apt install firmware-realtek -y
modprobe r8192_pci

#wpasupplicant install
apt install wpasupplicant -y

cp /etc/network/interfaces /etc/network/interfaces.bak
chmod 0600 /etc/network/interfaces

#make conf (tmp)
echo -e "${CYANCOLOR}wifi pwd for freebox_YSFVBB_dehaut :${NOCOLOR}"
wpa_passphrase freebox_YSFCBB_dehaut > /home/dehaut/tmp.wpa

#get the computed psk
sed -i -r 's/.*#psk.*/\t#psk/g' /home/dehaut/tmp.wpa
thePsk=$(cat /home/dehaut/tmp.wpa | xargs | grep -o -P '(?<= psk=).*(?=})' | xargs)

#write config in /etc/network/interfaces
echo '' >> /etc/network/interfaces
echo 'auto wlp2s0' >> /etc/network/interfaces
echo 'iface wlp2s0 inet dhcp' >> /etc/network/interfaces
echo -e '\twpa-ssid freebox_YSFCBB_dehaut' >> /etc/network/interfaces
echo -e '\twpa-psk _vercingetorix_' >> /etc/network/interfaces
#remplace substring by psk 
sed -i -e "s/_vercingetorix_/$thePsk/g" /etc/network/interfaces

#touch wpa supplicant config
#touch /etc/wpa_supplicant/wpa_supplicant.conf

#make conf
#echo -e "${CYANCOLOR}wifi pwd for freebox_YSFVBB_dehaut :${NOCOLOR}"
#wpa_passphrase freebox_YSFCBB_dehaut >> /etc/wpa_supplicant/wpa_supplicant.conf

#delete clear pswd
#sed -i -r 's/.*#psk.*/\t#psk/g' /etc/wpa_supplicant/wpa_supplicant.conf

#get the computed psk
#thePsk=$(cat /etc/wpa_supplicant/wpa_supplicant.conf | xargs | grep -o -P '(?<= psk=).*(?=})' | xargs) 

#write config in /etc/network/interfaces
#echo '' >> /etc/network/interfaces
#echo 'allow-hotplug wlp2s0' >> /etc/network/interfaces
#echo 'iface wlp2s0 inet dhcp' >> /etc/network/interfaces
#echo -e '\twpa-ssid freebox_YSFCBB_dehaut' >> /etc/network/interfaces
#echo -e '\twpa-psk _vercingetorix_' >> /etc/network/interfaces
#remplace substring by psk 
#sed -i -e "s/_vercingetorix_/$thePsk/g" /etc/network/interfaces
#chmod 0600 /etc/network/interfaces

#miscs
chown -R dehaut /home/dehaut/{,.}*

#clear var and files
thePsk=NULL
rm /home/dehaut/tmp.wpa
