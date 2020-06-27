#!/bin/bash

CYANCOLOR='\033[0;36m'
NOCOLOR='\033[0m'

#disable wake-on-lan and bluetooth at startup
touch /etc/init.d/mystartup.sh
echo "#!/bin/bash" > /etc/init.d/mystartup.sh
echo "hciconfig hci0 down ; rmmod hci_usb ; echo disable > /proc/acpi/ibm/bluetooth" >> /etc/init.d/mystartup.sh
echo "ethtool -s eth0 wol d" >> /etc/init.d/mystartup.sh
echo "ethtool -s enx9cebe8126fe7 wol d" >> /etc/init.d/mystartup.sh
chmod +x /etc/init.d/mystartup.sh
/sbin/update-rc.d mystartup.sh defaults 100

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

#apt config
#cat > /etc/apt/apt.conf.d/00pas-de-recommends <<EOF
#APT::Install-Recommends "false";
#APT::Install-Suggests "false";
#APT::AutoRemove::RecommendsImportant "false";
#APT::AutoRemove::SuggestsImportant "false";
#EOF

#wm
apt install openbox -y
apt install obconf -y
apt install obmenu -y
apt install obsession -y

#x server
apt install xinit

#utils
apt install linux-headers-$(uname -r) -y
apt install software-properties-common -y

#desktop environnements utils
apt install menu -y
apt install nitrogen -y
apt install dmenu -y
apt install tint2 -y
apt install arc-theme -y
apt install materia-gtk-theme -y

#miscs
#apt install -y iw -y
apt install -y laptop-mode-tools
apt install -y flatpak
apt install -y xfce4-terminal
apt install -y wireless-tools
apt install -y firmware-realtek
apt install -y hplip hplip-gui
apt install -y build-essential
apt install -y curl wget
apt install -y htop
apt install -y kolourpaint
apt install -y wpasupplicant guessnet
apt install -y pavucontrol
apt install -y pulseaudio-module-bluetooth
apt install -y libacpi0 laptop-detect gstreamer1.0-alsa libpulse-mainloop-glib0 libpulsedsp
apt install -y gsimplecal
apt install -y libnotify-bin dunst
apt install -y volumeicon-alsa
apt install -y lxappearance dconf-editor xfce4-power-manager
apt install -y mousepad
apt install -y xsane
apt install -y xbacklight xinput xbindkeys
apt install -y thunar
apt install -y ristretto
apt install -y xarchiver
apt install -y vlc vlc-l10n
apt install -y redshift
apt install -y acpi acpi-support acpica-tools acpid acpidump acpitail acpitool
apt install -y gimp
apt install -y scribus inkscape

#libre office
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.libreoffice.LibreOffice -y

#brave
apt install apt-transport-https
curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-release.list
apt update
apt install brave-browser

#node js & peerflix
curl -sL https://deb.nodesource.com/setup_14.x | bash -
apt install -y nodejs
npm install -g peerflix

#set openbox autostart
echo "nitrogen --restore &" >> /home/nomis/.config/openbox/autostart
echo "tint2 &" >> /home/nomis/.config/openbox/autostart
echo "xfce4-power-manager &" >> /home/nomis/.config/openbox/autostart
echo "redshift &" >> /home/nomis/.config/openbox/autostart
echo "volumeicon &" >> /home/nomis/.config/openbox/autostart

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
usermod -s /usr/bin/fish nomis

#nemo et mousepad preferences
dconf write /org/nemo/desktop/show-desktop-icons false
dconf write /org/nemo/preferences/show-full-path-titles true
gsettings set org.xfce.mousepad.preferences.view color-scheme 'oblivion'

#interfaces
cp /etc/network/interfaces /etc/network/interfaces.bak
rm /etc/network/interfaces
cp /home/nomis/debian-preparator/me-openbox/interfaces /etc/network/interfaces
#interfaces : make conf (tmp)
echo -e "${CYANCOLOR}wifi pwd for freebox_YSFVBB_dehaut :${NOCOLOR}"
wpa_passphrase freebox_YSFCBB_dehaut > /home/nomis/tmp.wpa
#interfaces : get the computed psk
sed -i -r 's/.*#psk.*/\t#psk/g' /home/nomis/tmp.wpa
thePsk=$(cat /home/nomis/tmp.wpa | xargs | grep -o -P '(?<= psk=).*(?=})' | xargs)
#interfaces : remplace substring by psk 
sed -i -e "s/_vercingetorix_/$thePsk/g" /etc/network/interfaces
#interfaces : file access mod
chmod 0600 /etc/network/interfaces
#interfaces : clear var and files
thePsk=NULL
rm /home/nomis/tmp.wpa

#copy files from git to dehaut home folder and init
cp -R /home/nomis/debian-preparator/me-openbox/home/{.,}* /home/nomis/

#render to Caesar the things that are Caesar's
chown -R nomis /home/nomis/{,.}*