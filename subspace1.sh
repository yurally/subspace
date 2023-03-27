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
"Install and run Node(Update)"
"Restart Node & Farmer"
"Log Node & Farmer"
"Search in Node & Farmer"
"Wipe Node & Farmer"
"Delete Node & Farmer"
"Exit")
select opt in "${options[@]}"
do
case $opt in


"Install and run Node(Update)")

apt install jq

mkdir $HOME/subspace; \
cd $HOME/subspace && \
wget https://github.com/subspace/subspace-cli/releases/download/v0.1.9-alpha/subspace-cli-ubuntu-x86_64-v0.1.9-alpha -O subspace-cli-ubuntu-x86_64-v0.1.9-alpha && \
sudo chmod +x subspace-cli-ubuntu-x86_64-v0.1.9-alpha && \
sudo mv subspace-cli-ubuntu-x86_64-v0.1.9-alpha /usr/local/bin/ && \
cd $HOME && \
/usr/local/bin/subspace-cli-ubuntu-x86_64-v0.1.9-alpha init
rm -Rvf $HOME/subspace


sudo tee <<EOF >/dev/null /etc/systemd/system/subspaced.service
[Unit]
Description=Subspace Node
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=/usr/local/bin/subspace-cli-ubuntu-x86_64-v0.1.9-alpha farm --verbose
Restart=on-failure
RestartSec=10
LimitNOFILE=1024000
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable subspaced
sudo systemctl restart subspaced

break
;;

"Delete Node & Farmer")

systemctl stop subspaced
systemctl disable subspaced
rm /etc/systemd/system/subspaced.service
rm -r /usr/local/bin/subspace*
rm -r $HOME/.local/share/subspace*

break
;;

"Log Node & Farmer")
sudo journalctl -n 100 -f -u subspaced
break
;;


"Wipe Node & Farmer")
systemctl stop subspaced
subspace-cli-ubuntu-x86_64-v0.1.9-alpha wipe
sudo systemctl restart subspaced
break
;;

"Restart Node & Farmer")
sudo systemctl restart subspaced
break
;;

"Search in node logs")
echo "============================================================"
echo "Enter a keyword or phrase to search"
echo "============================================================"
read KEYWORD
echo -e "\n\033[32m =========================SEARCH RESULTS========================= \033[0m"
sudo journalctl -u subspaced -o cat | grep "$KEYWORD"
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
