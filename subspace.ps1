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
powershell -command "& { iwr https://github.com/subspace/subspace/releases/download/gemini-3h-2024-mar-04/subspace-farmer-windows-x86_64-skylake-gemini-3h-2024-mar-04.exe -OutFile subspace-farmer-windows-x86_64-skylake-gemini-3h-2024-mar-04.exe }"
powershell -command "& { iwr https://github.com/subspace/subspace/releases/download/gemini-3h-2024-mar-04/subspace-node-windows-x86_64-skylake-gemini-3h-2024-mar-04.exe -OutFile subspace-node-windows-x86_64-skylake-gemini-3h-2024-mar-04.exe }"
Start-Process PowerShell.exe -ArgumentList ".\subspace-node-windows-x86_64-skylake-gemini-3h-2024-mar-04.exe run --chain gemini-3h --base-path ${disk}:\Subspace\subspace-node --farmer --name $nodename"
Start-Sleep 300
Start-Process PowerShell.exe -ArgumentList ".\subspace-farmer-windows-x86_64-skylake-gemini-3h-2024-mar-04.exe farm --reward-address $walletaddress path=${disk}:\Subspace\subspace-farmer,size=$plotsize"
