#!/usr/bin/env bash

# app skeleton for raspberry pi
# usage:
# wget https://raw.githubusercontent.com/avishayp/pi-app/master/setup.sh
# chmod +x setup.sh
# ./setup.sh ssid_name ssid_pass
#
# default values are all raspberry-app (security at user's risk)

# run from reporoot/
pushd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

get_source() {
    which git || sudo apt-get install -y git
    SOURCEDIR="$(mktemp -d)"
    git clone https://github.com/avishayp/pi-app ${SOURCEDIR}
    cp -R ${SOURCEDIR}/fakeroot ./
    cp -R ${SOURCEDIR}/server ./
    rm -fR ${SOURCEDIR}
}

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

    if [ ! -d server ] ; then
        echo "get files first"
        get_source
    fi

    sudo pip3 install -r server/requirements.txt
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

first_time_setup && update
