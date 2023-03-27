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
echo "Write plot size for farmer(100G and more)"
echo "============================================================"
read PLOTSIZE
echo 'export PLOTSIZE='$PLOTSIZE >> $HOME/.bash_profile
source ~/.bash_profile

apt install jq

mkdir $HOME/subspace; \
cd $HOME/subspace && \
wget https://github.com/nazar-pc/subspace/releases/download/snapshot-lamda-2513/subspace-farmer-ubuntu-x86_64-snapshot-lamda-2513 -O farmer && \
wget https://github.com/nazar-pc/subspace/releases/download/snapshot-lamda-2513/subspace-node-ubuntu-x86_64-snapshot-lamda-2513 -O subspace && \
sudo chmod +x * && \
sudo mv * /usr/local/bin/ && \
cd $HOME && \
rm -Rvf $HOME/subspace

sudo tee <<EOF >/dev/null /etc/systemd/system/subspace.service
[Unit]
Description=Subspace Node
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which subspace) \\
--chain="lamda-2513" \\
--execution="wasm" \\
--state-pruning="archive" \\
--validator \\
--name="$NODENAME"
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
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
ExecStart=$(which farmer) farm \\
--reward-address=$WALLETADDRESS \\
--plot-size=$PLOTSIZE
Restart=always
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable subspace subspacefarm
sudo systemctl restart subspacefarm subspace

break
;;