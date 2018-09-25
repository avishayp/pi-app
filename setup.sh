#!/usr/bin/env bash

# app skeleton for raspberry pi
# usage:
# ./setup.sh ssid_name ssid_pass
#
# default values are all raspberry-app (security at user's risk)

# run from reporoot/
pushd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

first_time_setup() {
    sudo apt-get update

    sudo apt-get install -y \
        dnsmasq \
        hostapd \
        logrotate \
        nginx \
        python3 \
        python3-pip \
        rsyslog \
        supervisor

    sudo pip3 install -r server/requirements.txt
}

make_dirs() {
    sudo mkdir -p /var/run/wsgi
    sudo mkdir -p /var/log/app
    sudo chown root:adm /var/log/app
}

update() {
    echo "updating ap params"
    sed -i "s/ssid=.*/ssid=${SSID_NAME}/g; s/wpa_passphrase=.*/wpa_passphrase=${SSID_PASS}/g" fakeroot/etc/hostapd/hostapd.conf

    sudo cp -pRv fakeroot/* /
    sudo cp -pRv server /srv/
    
    echo "restarting..."
    which reboot && sudo reboot || echo "no reboot - likely docker container. move on"
}

SSID_NAME=${1-"raspberry-app"}
SSID_PASS=${2-"raspberry-app"}

first_time_setup && make_dirs && update
