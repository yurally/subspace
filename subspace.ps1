write-host "================================================================================"
write-host "Enter the letter of the drive where you want to install Subspace. For example D"
write-host "================================================================================"
$disk=read-host
write-host "==========================="
write-host "Write the name of your node"
write-host "==========================="
$nodename=read-host
write-host "==========================="
write-host "Write plot size for farmer. For example 100G"
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
powershell -command "& { iwr https://github.com/subspace/subspace/releases/download/gemini-3a-2022-dec-06/subspace-farmer-windows-x86_64-gemini-3a-2022-dec-06.exe -OutFile subspace-farmer-windows-x86_64-gemini-3a-2022-dec-06.exe }"
powershell -command "& { iwr https://github.com/subspace/subspace/releases/download/gemini-3a-2022-dec-06/subspace-node-windows-x86_64-gemini-3a-2022-dec-06.exe -OutFile subspace-node-windows-x86_64-gemini-3a-2022-dec-06.exe }"
Start-Process PowerShell.exe -ArgumentList ".\subspace-node-windows-x86_64-gemini-3a-2022-dec-06.exe --chain gemini-3a --base-path ${disk}:\Subspace\subspace-node --execution wasm --state-pruning archive --validator --name $nodename"
Start-Process PowerShell.exe -ArgumentList ".\subspace-farmer-windows-x86_64-gemini-3a-2022-dec-06.exe --base-path ${disk}:\Subspace\subspace-farmer farm  --reward-address $walletaddress --plot-size $plotsize"
