write-host "================================================================================"
write-host "Enter the letter of the drive where you want to install Autonomys. For example D"
write-host "================================================================================"
$disk=read-host
write-host "==========================="
write-host "Write the name of your node"
write-host "==========================="
$nodename=read-host
write-host "==========================="
write-host "Write plot size for farmer. For test 10G"
write-host "==========================="
$plotsize=read-host
write-host "==========================="
write-host "Enter your wallet address"
write-host "==========================="
$walletaddress=read-host
mkdir ${disk}:\Autonomys
mkdir ${disk}:\Autonomys\subspace-node
mkdir ${disk}:\Autonomys\subspace-farmer
cd ${disk}:\Autonomys
powershell -command "& { iwr https://github.com/autonomys/subspace/releases/download/mainnet-2024-dec-09/subspace-farmer-windows-x86_64-skylake-mainnet-2024-dec-09.exe -OutFile subspace-farmer.exe }"
powershell -command "& { iwr https://github.com/autonomys/subspace/releases/download/mainnet-2024-dec-09/subspace-node-windows-x86_64-skylake-mainnet-2024-dec-09.exe -OutFile subspace-node.exe }"
Start-Process PowerShell.exe -ArgumentList ".\subspace-node.exe run --chain mainnet --base-path ${disk}:\Autonomys\subspace-node --farmer --name $nodename"
Start-Sleep 300
Start-Process PowerShell.exe -ArgumentList ".\subspace-farmer.exe farm --reward-address $walletaddress path=${disk}:\Autonomys\subspace-farmer,size=$plotsize"
