#!/bin/sh

if [ -z "$1" ]; then
  echo -e "Please specify an IP address for hostname for me to bootstrap!\n"
  echo -e "Usage: \n\n net-bootstrap.sh HOST USERNAME"
  echo -e "\nPlease provice a SUDO-able user."
  exit
fi

if [ -z "$2" ]; then
  echo "No username specified"
fi

HOST="$1"
USER="$2"

echo "You will new be asked for the root-password for the machine. This is not ME asking, bit ssh-copy-id. Makes provisioning easier."
ssh-copy-id ${USER}@${HOST}

scp bootstrap.sh ${USER}@${HOST}:~/bootstrap.sh
scp initial-profile ${USER}@${HOST}:~/initial-profile
ssh ${USER}@${HOST} "sudo sh ~/bootstrap.sh"

