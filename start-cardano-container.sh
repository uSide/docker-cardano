#!/bin/bash
echo "Docker container ::: Starting node cardano-sl, wallet mode. Network - $1"

# remove default nginx config
sudo rm -f /etc/nginx/sites-enabled/default

# change network in nginx config file
if [[ $1 = "testnet" ]] ; then
    sudo sed -i 's/mainnet/testnet/g' /etc/nginx/conf.d/default.conf
else
    sudo sed -i 's/testnet/mainnet/g' /etc/nginx/conf.d/default.conf
fi

# try to remove lock file from previous execution
sudo rm -f /home/cardano/cardano-sl/state-wallet-$1/wallet-db/open.lock

# restart nginx service in bg, give 10 sec that cardano node create ssl certif.
sleep 10 && sudo /usr/sbin/service nginx restart && echo "Docker container ::: Nginx service restarted" &

# start node
sudo /home/cardano/cardano-sl/connect-to-$1 --runtime-args --no-tls
