#! /bin/sh

mkdir -p /tardis

# Initial Upgrade to zero-day
apt-get update
apt-get -y upgrade

# Fix locale error messages with apt
echo "LANG=\"en_US.UTF-8\"" > /etc/default/locale
echo "LANGUAGE=\"en_US.UTF-8\"" >> /etc/default/locale
echo "LC_ALL=\"en_US.UTF-8\"" >> /etc/default/locale
echo "LC_BYOBU=1" >> /etc/default/locale  # make byoby system-wide default, if its installed
locale-gen en_US en_US.UTF-8
dpkg-reconfigure locales
mkdir /root/.byobu
echo "source /tardis/config/byobu" > /root/.byobu/.tmux.conf

#Add Repo's
add-apt-repository -y ppa:keithw/mosh
add-apt-repository ppa:chris-lea/node.js
apt-get update

# Apt-get install
apt-get -y install mosh byobu git toilet fail2ban python-software-properties python g++ make
apt-get -y install nodejs npm

## NPM install
npm -g install sails
npm -g install shelljs
npm -g install prompt

# Set default group
addgroup tardis
usermod -g tardis root
echo "%tardis   ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/tardis
chmod 0440 /etc/sudoers.d/tardis

# Checkout Tardis
cd /tardis
git clone https://github.com/RamonGebben/tardis.git .
mkdir -p /tardis/sites
mkdir -p /tardis/flags

# Fix ownership
chown -R root:tardis /tardis 
chown -R root:tardis /tardis

# Fix default umask
sed -i 's/UMASK\s*022/UMASK 002/g' /etc/login.defs

# Reboot
reboot
