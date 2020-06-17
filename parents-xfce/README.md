# debian preparator for parents : xfce
install:
- debian net install
- `su`
- `echo 'deb http://deb.debian.org/debian/ buster main' > /etc/apt/sources.list`
- `echo 'deb-src http://deb.debian.org/debian/ buster main' > /etc/apt/sources.list`
- `apt update`
- `apt install git -y`
- `exit`
- `git clone https://github.com/simondehaut/debian-preparator.git`
- `chmod +x ~/debian-preparator/parents-xfce/install.sh`
- `bash ~/debian-preparator/parents-xfce/install.sh`
- delete cloned git
