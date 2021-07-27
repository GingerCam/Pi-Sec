#!/bin/bash

is_command() {
    # Checks to see if the given command (passed as a string argument) exists on the system.
    # The function returns 0 (success) if the command exists, and 1 if it doesn't.
    local check_command="$1"

    command -v "${check_command}" >/dev/null 2>&1
}

config_files="dhcpcd.conf dnsmasq.conf hostapd.conf" 

setup() {
    echo "Pi Security written by GingerCam"
    echo "Applying config"
    for file in config_files; do 
    wget https://raw.githubusercontent.com/GingerCam/Pi-0w-security/master/config/$file -o /etc/$file
    
    if grep -q "DAEMON_CONF="/etc/hostapd.conf"" "/etc/default/hostapd"; then
        echo 1
    else
        echo ""DAEMON_CONF="/etc/hostapd.conf" >>"/etc/default/hostapd"
    fi
    sleep 2

    echo "Setting up wireless location to GB"
    wpa_cli -i $wireless_interface set country GB
    wpa_cli -i $wireless_interface save_config >/dev/null 2>&1
    rfkill unblock wifi
    for filename in /var/lib/systemd/rfkill*:wlan; do
        echo 0 >$filename
    done
    sleep 1
    echo "Set"
    echo "Setting up ssh server"
    ssh-keygen -A
    update-rc.d ssh enable
    invoke-rc.d ssh start
    echo ""
    echo "ssh server is configured"
    echo ""
}