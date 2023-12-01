#!/bin/bash

while true
do

#Logo
echo "================================================================="
echo "███████╗██╗   ██╗██████╗ ███████╗██████╗  █████╗  ██████╗███████╗"
echo "██╔════╝██║   ██║██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔════╝██╔════╝"
echo "███████╗██║   ██║██████╔╝███████╗██████╔╝███████║██║     █████╗  "
echo "╚════██║██║   ██║██╔══██╗╚════██║██╔═══╝ ██╔══██║██║     ██╔══╝  "
echo "███████║╚██████╔╝██████╔╝███████║██║     ██║  ██║╚██████╗███████╗"
echo "╚══════╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝     ╚═╝  ╚═╝ ╚═════╝╚══════╝"
echo "================================================================="
echo -e "https://subspace.network/"
echo "================================================================="

# Menu

PS3='Select an action: '
options=(
"Install and run ValidatorNode&Farmer"
"Install and run Operator Node"
"Install and run Oper+ValNode&Farmer"
"Update 01.12.23"
"Restart Node"
"Restart Farmer"
"Log Node"
"Log Farmer"
"Search in node logs"
"Search in farmer logs"
"Wipe Farmer"
"Purge-chain"
"Delete Node"
"Exit")
select opt in "${options[@]}"
do
case $opt in


"Install and run ValidatorNode&Farmer")
echo "============================================================"
echo "Write the name of your node"
echo "============================================================"
read NODENAME
echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
echo "============================================================"
echo "Enter your wallet address"
echo "============================================================"
read WALLETADDRESS
echo 'export WALLETADDRESS='$WALLETADDRESS >> $HOME/.bash_profile
echo "============================================================"
echo "Write plot size for farmer(example 10G)"
echo "============================================================"
read PLOTSIZE
echo 'export PLOTSIZE='$PLOTSIZE >> $HOME/.bash_profile
source ~/.bash_profile

apt install jq

mkdir $HOME/subspace; \
cd $HOME/subspace && \
wget https://github.com/subspace/subspace/releases/download/gemini-3g-2023-dec-01/subspace-farmer-ubuntu-x86_64-skylake-gemini-3g-2023-dec-01 -O farmer && \
wget https://github.com/subspace/subspace/releases/download/gemini-3g-2023-dec-01/subspace-node-ubuntu-x86_64-skylake-gemini-3g-2023-dec-01 -O subspace && \
sudo chmod +x * && \
sudo mv * /usr/local/bin/ && \
cd $HOME && \
rm -Rvf $HOME/subspace && \
mkdir $HOME/.local/share/subspace-farmer

sudo tee <<EOF >/dev/null /etc/systemd/system/subspace.service
[Unit]
Description=Subspace Node
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which subspace) \\
--chain="gemini-3g" \\
--blocks-pruning="256" \\
--state-pruning="archive-canonical" \\
--no-private-ipv4 \\
--validator \\
--name="$NODENAME"
Restart=on-failure
RestartSec=10
LimitNOFILE=1024000
[Install]
WantedBy=multi-user.target
EOF

sudo tee <<EOF >/dev/null /etc/systemd/system/subspacefarm.service
[Unit]
Description=Subspace Farmer
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which farmer) farm --reward-address=$WALLETADDRESS path=$HOME/.local/share/subspace-farmer,size=$PLOTSIZE 
Restart=always
RestartSec=10
LimitNOFILE=1024000
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable subspace subspacefarm
sudo systemctl restart subspacefarm subspace

break
;;

"Install and run Oper+ValNode&Farmer")
echo "============================================================"
echo "Write the name of your node"
echo "============================================================"
read NODENAME
echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
echo "============================================================"
echo "Enter your wallet address"
echo "============================================================"
read WALLETADDRESS
echo 'export WALLETADDRESS='$WALLETADDRESS >> $HOME/.bash_profile
echo "============================================================"
echo "Write plot size for farmer(example 10G)"
echo "============================================================"
read PLOTSIZE
echo 'export PLOTSIZE='$PLOTSIZE >> $HOME/.bash_profile
source ~/.bash_profile

apt install jq

mkdir $HOME/subspace; \
cd $HOME/subspace && \
wget https://github.com/subspace/subspace/releases/download/gemini-3g-2023-dec-01/subspace-farmer-ubuntu-x86_64-skylake-gemini-3g-2023-dec-01 -O farmer && \
wget https://github.com/subspace/subspace/releases/download/gemini-3g-2023-dec-01/subspace-node-ubuntu-x86_64-skylake-gemini-3g-2023-dec-01 -O subspace && \
sudo chmod +x * && \
sudo mv * /usr/local/bin/ && \
cd $HOME && \
rm -Rvf $HOME/subspace && \
echo "============================================================" && \
echo "Create operator key:" && \
echo "============================================================" && \
subspace key generate --scheme sr25519 && \
echo "============================================================" && \
echo "Write your Secret phrase:" && \
echo "============================================================" && \
read Secret_phrase && \
subspace key insert --suri "$Secret_phrase" --key-type oper --scheme sr25519 --keystore-path /root/subspace_operator/keystore && \
echo "============================================================" && \
echo "Write your Public key:" && \
echo "============================================================" && \
read Public_key && \
mkdir $HOME/.local/share/subspace-farmer

sudo tee <<EOF >/dev/null /etc/systemd/system/subspace.service
[Unit]
Description=Subspace Node
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which subspace) \\
--chain="gemini-3g" \\
--node-key $Public_key \\
--blocks-pruning="256" \\
--state-pruning="archive" \\
--no-private-ipv4 \\
--validator \\
--name="$NODENAME" \\
-- \\
--domain-id 1 \\
#--operator-id you_id \\
--keystore-path /root/subspace_operator/keystore \\
--bootnodes /ip4/3.87.28.170/tcp/40333/p2p/12D3KooWGHtULvhdKMZtzigSK1438uWXPj9rBQHVzTaKMWv1WRXp
Restart=on-failure
RestartSec=10
LimitNOFILE=1024000
[Install]
WantedBy=multi-user.target
EOF

sudo tee <<EOF >/dev/null /etc/systemd/system/subspacefarm.service
[Unit]
Description=Subspace Farmer
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which farmer) farm --reward-address=$WALLETADDRESS path=$HOME/.local/share/subspace-farmer,size=$PLOTSIZE 
Restart=always
RestartSec=10
LimitNOFILE=1024000
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable subspace subspacefarm
sudo systemctl restart subspacefarm subspace

break
;;

"Install and run Operator Node")
echo "============================================================"
echo "Write the name of your node"
echo "============================================================"
read NODENAME
echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile

source ~/.bash_profile

apt install jq

mkdir $HOME/subspace; \
cd $HOME/subspace && \
wget https://github.com/subspace/subspace/releases/download/gemini-3g-2023-dec-01/subspace-node-ubuntu-x86_64-skylake-gemini-3g-2023-dec-01 -O subspace && \
sudo chmod +x * && \
sudo mv * /usr/local/bin/ && \
cd $HOME && \
rm -Rvf $HOME/subspace && \
echo "============================================================" && \
echo "Create operator key:" && \
echo "============================================================" && \
subspace key generate --scheme sr25519 && \
echo "============================================================" && \
echo "Write your Secret phrase:" && \
echo "============================================================" && \
read Secret_phrase && \
subspace key insert --suri "$Secret_phrase" --key-type oper --scheme sr25519 --keystore-path /root/subspace_operator/keystore && \
echo "============================================================" && \
echo "Write your Public key:" && \
echo "============================================================" && \
read Public_key && \


sudo tee <<EOF >/dev/null /etc/systemd/system/subspace.service
[Unit]
Description=Subspace Node
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which subspace) \\
--chain="gemini-3g" \\
--node-key $Public_key \\
--name="$NODENAME" \\
-- \\
--domain-id 1 \\
--chain gemini-3g \\
#--operator you_id \\
--bootnodes /ip4/3.87.28.170/tcp/40333/p2p/12D3KooWGHtULvhdKMZtzigSK1438uWXPj9rBQHVzTaKMWv1WRXp \\
--keystore-path /root/subspace_operator/keystore
Restart=on-failure
RestartSec=10
LimitNOFILE=1024000
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable subspace
sudo systemctl restart subspace

break
;;

"Delete Node")

systemctl stop subspace subspacefarm
systemctl disable subspace subspacefarm
rm /etc/systemd/system/subspace.service
rm /etc/systemd/system/subspacefarm.service
rm -r /usr/local/bin/subspace
rm -r /usr/local/bin/farmer
rm -r /root/.local/share/subspace-farmer
rm -r /root/.local/share/subspace-node

break
;;

"Log Node")
sudo journalctl -n 50 -f -u subspace -o cat
break
;;

"Log Farmer")
sudo journalctl -n 50 -f -u subspacefarm -o cat
break
;;

"Wipe Farmer")
systemctl stop subspacefarm
farmer wipe $HOME/.local/share/subspace-farmer
sudo systemctl restart subspacefarm
break
;;

"Purge-chain")
systemctl stop subspace
subspace purge-chain --chain gemini-3g -y
break
;;

"Restart Node")
sudo systemctl restart subspace
break
;;

"Restart Farmer")
sudo systemctl restart subspacefarm
break
;;

"Update 01.12.23")
systemctl stop subspacefarm subspace
mkdir $HOME/subspace; \
cd $HOME/subspace && \
wget https://github.com/subspace/subspace/releases/download/gemini-3g-2023-dec-01/subspace-farmer-ubuntu-x86_64-skylake-gemini-3g-2023-dec-01 -O farmer && \
wget https://github.com/subspace/subspace/releases/download/gemini-3g-2023-dec-01/subspace-node-ubuntu-x86_64-skylake-gemini-3g-2023-dec-01 -O subspace && \
sudo chmod +x * && \
sudo mv * /usr/local/bin/ && \
cd $HOME && \
rm -Rvf $HOME/subspace && \
sudo systemctl restart subspacefarm subspace
break
;;

"Search in node logs")
echo "============================================================"
echo "Enter a keyword or phrase to search"
echo "============================================================"
read KEYWORD
echo -e "\n\033[32m =========================SEARCH RESULTS========================= \033[0m"
sudo journalctl -u subspace -o cat | grep "$KEYWORD"
echo -e "\n\033[32m ================================================================ \033[0m"
break
;;

"Search in farmer logs")
echo "============================================================"
echo "Enter a keyword or phrase to search"
echo "============================================================"
read KEYWORD
echo -e "\n\033[32m =========================SEARCH RESULTS========================= \033[0m"
sudo journalctl -u subspacefarm -o cat | grep "$KEYWORD"
echo -e "\n\033[32m ================================================================ \033[0m"
break
;;

"Exit")
exit
;;
*) echo "invalid option $REPLY";;
esac
done
done
