#!/bin/bash

echo -e "\033[0;35m"
echo "MMCPRO";
echo -e "\e[0m"

sleep 2

if [ "$(id -u)" != "0" ]; then
    echo "Please run as root"
    exit 1
fi


function yukle() {

service_name="tanssid"

if systemctl is-active --quiet "$service_name.service" ; then
    echo "Tansi node is already installed."
    return 1
fi

# set variables
if [ ! $Node_names ]; then
	read -p "Enter Name: " Node_names
	echo 'export Node_names='$Node_names >> $HOME/.bash_profile
else
    echo "Node name is already defined: ${Node_names}"
fi

source $HOME/.bash_profile

echo '================================================='
echo "node name: $Node_names"
echo '================================================='
sleep 2

# install evmosd
wget https://github.com/moondance-labs/tanssi/releases/download/v0.6.0/tanssi-node && \
chmod +x ./tanssi-node
sudo mkdir /root/tanssi-data/
cd /root/tanssi-data/
mv /root/tanssi-node /root/tanssi-data
sleep 2

# create service
sudo tee /etc/systemd/system/tanssid.service > /dev/null <<EOF
[Unit]
Description="Tanssi systemd service"
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
Restart=on-failure
RestartSec=10
User=root
SyslogIdentifier=tanssi
SyslogFacility=local7
KillSignal=SIGHUP
ExecStart=/root/tanssi-data/tanssi-node \
--chain=dancebox \
--name=$Node_name \
--sync=warp \
--base-path=/root/tanssi-data/para \
--state-pruning=2000 \
--blocks-pruning=2000 \
--collator \
--database paritydb \
--telemetry-url='wss://telemetry.polkadot.io/submit/ 0' \
--name=$Node_name \
--base-path=/root/tanssi-data/container \
--telemetry-url='wss://telemetry.polkadot.io/submit/ 0' \
--chain=westend_moonbase_relay_testnet \
--name=$Node_name \
--sync=fast \
--base-path=/root/tanssi-data/relay \
--state-pruning=2000 \
--blocks-pruning=2000 
--database paritydb \
--telemetry-url='wss://telemetry.polkadot.io/submit/ 0' 

[Install]
WantedBy=multi-user.target
EOF

# start service
sudo systemctl daemon-reload
sudo systemctl enable tanssid.service
sudo systemctl restart tanssid.service

echo '=============== INSTALLATION NODE IS FINISHED ==================='
echo 'To check logs: journalctl -u tanssid -fo cat'
sleep 2
}


function product() {
    echo "To exit, please press ctrl+c on the keyboard"
    sleep 1
    ./tanssi-node key generate -w 24
}

function key_gor() {
    curl http://127.0.0.1:9944 -H \
  "Content-Type:application/json;charset=utf-8" -d \
  '{
    "jsonrpc":"2.0",
    "id":1,
    "method":"author_rotateKeys",
    "params": []
  }'
}

function log_gor() {
    echo "To exit, please press ctrl+c on the keyboard"
    sleep 1
    journalctl -u tanssid -fo cat
}


function main_menu() {
    while true; do
        clear
        echo "                            MMMCPRO                             "
        echo "================================================================"
        echo "Telegram : https://t.me/HerculesNode"
        echo "1. Install Tansi node"
        echo "2. Install producer address"
        echo "3. Install Key"
        echo "4. See logs"
        echo "5. Exit"
        read -p "Please enter options （1-8): " OPTION

        case $OPTION in
        1) yukle ;;
        2) product ;;
        3) key_gor ;;
        4) log_gor ;;
        5) break;;
        *) echo "Invalid option, re-enter" ;;
        esac
        read -p "Press enter to return to the menu..."
done
}
main_menu
