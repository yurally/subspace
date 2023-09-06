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
"Сheck CPU version"
"Install and run Node v2"
"Install and run Node v3+"
"Update v2 06.09.23"
"Update v3+ 06.09.23"
"Restart Node & Farmer"
"Log Node & Farmer"
"Search in logs Node & Farmer"
"Wipe Node & Farmer"
"Delete Node & Farmer"
"Exit")
select opt in "${options[@]}"
do
case $opt in


"Install and run Node v2")

apt install jq

systemctl stop subspaced
rm $HOME/.config/subspace-cli/settings.toml
mkdir $HOME/subspace; \
cd $HOME/subspace && \
wget https://github.com/subspace/pulsar/releases/download/v0.6.6-alpha/pulsar-ubuntu-x86_64-v2-v0.6.6-alpha -O subspace-cli && \
sudo chmod +x subspace-cli && \
sudo mv subspace-cli /usr/local/bin/ && \
cd $HOME && \
/usr/local/bin/subspace-cli init
rm -Rvf $HOME/subspace


sudo tee <<EOF >/dev/null /etc/systemd/system/subspaced.service
[Unit]
Description=Subspace Node
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=/usr/local/bin/subspace-cli farm --verbose
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
echo -e "\n\033[32m ================================= \033[0m"
echo -e "\n\033[32m Installation completed \033[0m"
echo -e "\n\033[32m ================================= \033[0m"

break
;;

"Install and run Node v3+")

apt install jq

mkdir $HOME/subspace; \
cd $HOME/subspace && \
wget https://github.com/subspace/pulsar/releases/download/v0.6.6-alpha/pulsar-ubuntu-x86_64-skylake-v0.6.6-alpha -O subspace-cli && \
sudo chmod +x subspace-cli && \
sudo mv subspace-cli /usr/local/bin/ && \
cd $HOME && \
/usr/local/bin/subspace-cli init
rm -Rvf $HOME/subspace


sudo tee <<EOF >/dev/null /etc/systemd/system/subspaced.service
[Unit]
Description=Subspace Node
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=/usr/local/bin/subspace-cli farm --verbose
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
echo -e "\n\033[32m ================================= \033[0m"
echo -e "\n\033[32m Installation completed \033[0m"
echo -e "\n\033[32m ================================= \033[0m"

break
;;


"Delete Node & Farmer")

systemctl stop subspaced
systemctl disable subspaced
rm /etc/systemd/system/subspaced.service
rm -r /usr/local/bin/subspace*
rm -r $HOME/.local/share/pulsar*
rm -r $HOME/.config/pulsar*
echo -e "\n\033[32m ================================= \033[0m"
echo -e "\n\033[32m Node deletion completed \033[0m"
echo -e "\n\033[32m ================================= \033[0m"

break
;;

"Log Node & Farmer")
sudo journalctl -n 50 -f -u subspaced -o cat
break
;;

"Update v2 06.09.23")
systemctl stop subspaced
mkdir $HOME/subspace; \
cd $HOME/subspace && \
wget https://github.com/subspace/pulsar/releases/download/v0.6.6-alpha/pulsar-ubuntu-x86_64-v2-v0.6.6-alpha -O subspace-cli && \
sudo chmod +x subspace-cli && \
sudo mv subspace-cli /usr/local/bin/ && \
rm -Rvf $HOME/subspace && \
sudo systemctl restart subspaced
break
;;

"Update v3+ 06.09.23")
systemctl stop subspaced
mkdir $HOME/subspace; \
cd $HOME/subspace && \
wget https://github.com/subspace/pulsar/releases/download/v0.6.6-alpha/pulsar-ubuntu-x86_64-skylake-v0.6.6-alpha -O subspace-cli && \
sudo chmod +x subspace-cli && \
sudo mv subspace-cli /usr/local/bin/ && \
rm -Rvf $HOME/subspace && \
sudo systemctl restart subspaced
break
;;


"Wipe Node & Farmer")
systemctl stop subspaced
subspace-cli wipe
sudo systemctl restart subspaced
echo -e "\n\033[32m ================================= \033[0m"
echo -e "\n\033[32m Wipe completed \033[0m"
echo -e "\n\033[32m ================================= \033[0m"
break
;;

"Restart Node & Farmer")
sudo systemctl restart subspaced
echo -e "\n\033[32m ================================= \033[0m"
echo -e "\n\033[32m Restart completed \033[0m"
echo -e "\n\033[32m ================================= \033[0m"
break
;;

"Search in logs Node & Farmer")
echo "============================================================"
echo "Enter a keyword or phrase to search"
echo "============================================================"
read KEYWORD
echo -e "\n\033[32m =========================SEARCH RESULTS========================= \033[0m"
sudo journalctl -u subspaced -o cat | grep "$KEYWORD"
echo -e "\n\033[32m ================================================================ \033[0m"
break
;;

"Сheck CPU version")
echo 'BEGIN {
    while (!/flags/) if (getline < "/proc/cpuinfo" != 1) exit 1
    if (/lm/&&/cmov/&&/cx8/&&/fpu/&&/fxsr/&&/mmx/&&/syscall/&&/sse2/) level = 1
    if (level == 1 && /cx16/&&/lahf/&&/popcnt/&&/sse4_1/&&/sse4_2/&&/ssse3/) level = 2
    if (level == 2 && /avx/&&/avx2/&&/bmi1/&&/bmi2/&&/f16c/&&/fma/&&/abm/&&/movbe/&&/xsave/) level = 3
    if (level == 3 && /avx512f/&&/avx512bw/&&/avx512cd/&&/avx512dq/&&/avx512vl/) level = 4
    if (level > 0) { print "\n\033[32m ================================== \033[0m" "\n       CPU supports x86-64-v" level "\n\033[32m ================================== \033[0m";   exit level + 1;}
    exit 1
}' | awk -f -

break
;;

"Exit")
exit
;;
*) echo "invalid option $REPLY";;
esac
done
done
