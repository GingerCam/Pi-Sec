#!/bin/bash

is_command() {
    # Checks to see if the given command (passed as a string argument) exists on the system.
    # The function returns 0 (success) if the command exists, and 1 if it doesn't.
    local check_command="$1"

    command -v "${check_command}" >/dev/null 2>&1
}

config_files="dhcpcd.conf dnsmasq.conf hostapd.conf" 


echo "Pi Security written by GingerCam"
sudo bash scripts/rpi-wiggle.sh
apt install hostapd dnsmasq dhcpcd5 git python3 python3-pip
wireless_interface=$(iw dev | awk '$1=="Interface"{print $2}')
echo "Applying config"
cp config/dhcpcd.conf /etc/
cp config/hostpad.conf /etc/
cp config/dnsmasq.conf /etc/ 
cp scripts/rpi-wiggle.sh /usr/bin/
chmod +x /usr/bin/rpi-wiggle.sh

if ! grep -q "DAEMON_CONF="/etc/hostapd.conf"" "/etc/default/hostapd"; then
    echo ""DAEMON_CONF="/etc/hostapd.conf" >>"/etc/default/hostapd"
fi
sleep 2

if grep -q "^net.ipv4.ip_forward=1" /etc/sysctl.conf; then
    echo 1
else
    sed -i "s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/" /etc/sysctl.conf
fi

sudo systemctl enable --now dnsmasq
sudo systemctl enable --now dhcpcd

echo ""
echo "Setting up ssh server"
ssh-keygen -A
update-rc.d ssh enable
invoke-rc.d ssh start
echo ""
echo "ssh server is configured"
echo ""
apt update
apt install kali-linux-headless airgeddon git cmatrix hollywood
sudo loadkeys uk

evillimiter () {
    git clone https://github.com/bitbrute/evillimiter.git
    cd evillimiter
    sudo python3 setup.py install
    cd ~
}

wifipumpkin3 () {
    sudo apt install libssl-dev libffi-dev build-essential python3-pyqt5
    git clone https://github.com/P0cL4bs/wifipumpkin3.git
    sudo python3 setup.py install
    cd ~
}

pishrink (){
    wget https://raw.githubusercontent.com/Drewsif/PiShrink/master/pishrink.sh
    chmod +x pishrink.sh
    sudo mv pishrink.sh /usr/local/bin
    cd ~
}

lscript () {
    git clone https://github.com/arismelachroinos/lscript.git
    cd lscript
    chmod +x install.sh
    sudo ./install.sh
    cd ~
}

anonsurf () {
    sudo apt install libssl-dev libffi-dev build-essential make
    git clone https://github.com/ParrotSec/anonsurf.git
    cd anonsurf
    sudo make all
    cd ~
}

Nightmare() {
    git clone https://github.com/GingerCam/Nightmare.git
    cd Nightmare
    chmod +x setup.sh
    sudo ./setup.sh install global
    cd ~
}

All () {
    wifipumpkin3
    evillimiter 
    lscript
    pishrink
    anonsurf
    Nightmare
}

All

echo "export PS1="\[\e[32m\]\u\[\e[m\]\[\e[32m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\]\[\e[32m\]:\[\e[m\]\[\e[32m\]~\[\e[m\]\[\e[32m\]\\$\[\e[m\] "" >> ~/.bashrc