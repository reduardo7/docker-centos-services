#!/usr/bin/env bash

set -e

chmod 600 /ansible/ssh/deployer/id_rsa

touch /home/user/.data/history
ln -fs /home/user/.data/history /home/user/.bash_history
chmod a+rw /home/user/.data/history
chmod a+rw /home/user/.bash_history

while true; do
  sleep 30
done
