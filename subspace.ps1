write-host "================================================================================"
write-host "Enter the letter of the drive where you want to install Subspace. For example D"
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
mkdir ${disk}:\Subspace
mkdir ${disk}:\Subspace\subspace-node
mkdir ${disk}:\Subspace\subspace-farmer
cd ${disk}:\Subspace
powershell -command "& { iwr https://github.com/subspace/subspace/releases/download/gemini-3f-2023-aug-17/subspace-farmer-windows-x86_64-skylake-gemini-3f-2023-aug-17.exe -OutFile subspace-farmer-windows-x86_64-skylake-gemini-3f-2023-aug-17.exe }"
powershell -command "& { iwr https://github.com/subspace/subspace/releases/download/gemini-3f-2023-aug-17/subspace-node-windows-x86_64-skylake-gemini-3f-2023-aug-17.exe -OutFile subspace-node-windows-x86_64-skylake-gemini-3f-2023-aug-17.exe }"
Start-Process PowerShell.exe -ArgumentList ".\subspace-node-windows-x86_64-skylake-gemini-3f-2023-aug-17.exe --chain gemini-3f --base-path ${disk}:\Subspace\subspace-node --execution wasm --blocks-pruning archive --state-pruning archive --dsn-disable-private-ips --no-private-ipv4 --validator --name $nodename"
Start-Sleep 20
Start-Process PowerShell.exe -ArgumentList ".\subspace-farmer-windows-x86_64-skylake-gemini-3f-2023-aug-17.exe --base-path ${disk}:\Subspace\subspace-farmer farm  --disable-private-ips --reward-address $walletaddress --plot-size $plotsize"
