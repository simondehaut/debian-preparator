# debian preparator for me : xfce

install:
- debian baremetal net install (dont select "debian desktop environnement")
- `su`
- `echo 'deb http://deb.debian.org/debian/ buster main' > /etc/apt/sources.list`
- `echo 'deb-src http://deb.debian.org/debian/ buster main' > /etc/apt/sources.list`
- `apt update`
- `apt install git -y`
- `exit`
- `git clone https://github.com/simondehaut/debian-preparator.git`
- `chmod +x ~/debian-preparator/me-xfce/install.sh`
- `su`
- `bash ~/debian-preparator/me-xfce/install.sh`
- delete cloned git
