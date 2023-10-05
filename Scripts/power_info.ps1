if ($env:os -eq "Windows_NT") 
{
    echo "+----------------------------------+"
    echo "|  @umer_74 | github.com/umer-r    |"
    echo "+----------------------------------+"
    echo ""
    echo "Gathering data for computer [$env:computername]. Please wait..."
    echo ""

    #_____VARIABLES_____
    $file = "IT-Assessment-Results-PS.csv"
    $loc = Get-Location | findstr '\'
    $date = Get-Date -UFormat "%d/%m/%Y %T"
    $system = wmic OS Get csname /value | Select-String -pattern '(?<=\=)[^"]+' | ForEach-Object { $_.Matches.Value }
    $manufacturer = wmic ComputerSystem Get Manufacturer /value | Select-String -pattern '(?<=\=)[^"]+' | ForEach-Object { $_.Matches.Value }
    $model = wmic ComputerSystem Get Model /value  | Select-String -pattern '(?<=\=)[^"]+' | ForEach-Object { $_.Matches.Value }
    $serialnumber = wmic Bios Get SerialNumber /value | Select-String -pattern '(?<=\=)[^"]+' | ForEach-Object { $_.Matches.Value }
    $ageofbios = systeminfo | findstr BIOS | Select-String -pattern '(?<=\,)[^"]+' | ForEach-Object { $_.Matches.Value }
    $ageofbios = $ageofbios -replace ' '
    $osname = wmic os Get Name /value | Select-String -pattern '(?<=\=)[^"]+' | ForEach-Object { $_.Matches.Value }
    $sp = wmic os get ServicePackMajorVersion /value | Select-String -pattern '(?<=\=)[^"]+' | ForEach-Object { $_.Matches.Value }
    $cpu = wmic cpu get name /value | Select-String -pattern '(?<=\=)[^"]+' | ForEach-Object { $_.Matches.Value }
    $totalMem = systeminfo | findstr /L "Total Phyiscal" | Select-String -pattern '(?<=\:)[^"]+' | ForEach-Object { $_.Matches.Value }
    $totalmem = $totalmem -replace ',' -replace ' '
    $memspeed = wmic memorychip get speed | findstr [1-10] | select-object -first 1
    $diskdrivetype = wmic diskdrive get caption /value | Select-String -pattern '(?<=\=)[^"]+' | ForEach-Object { $_.Matches.Value } | select-object -first 1
    $diskspacetotal = wmic logicaldisk get size /value | Select-String -pattern '(?<=\=)[^"]+' | ForEach-Object { $_.Matches.Value } | select-object -first 1
    $diskspaceavail = wmic logicaldisk get freespace /value | Select-String -pattern '(?<=\=)[^"]+' | ForEach-Object { $_.Matches.Value } | select-object -first 1
    $interfaceName = wmic nic where "NetConnectionStatus=2 and AdapterTypeId=0" get  NetConnectionID /format:list | Select-String -pattern '(?<=\=)[^"]+' | ForEach-Object { $_.Matches.Value }
    $publicfirewallst =  Get-NetFirewallProfile | Format-Table Name, Enabled | findstr Public | %{"$($_.Split('c')[1])"}
    $antivirus = wmic /namespace:\\root\SecurityCenter2 path AntiVirusProduct get displayName /value | Select-String -pattern '(?<=\=)[^"]+' | ForEach-Object { $_.Matches.Value }
    $bitlocker = manage-bde -status c: | findstr Conversion | Select-String -pattern '(?<=\:)[^"]+' | ForEach-Object { $_.Matches.Value }
    echo ""
    echo "Audit for computer [$env:computername] completed successfuly."
    echo ""
    Read-Host -Prompt "Press any key to view Results"
    cls

    $out = echo "`n+-----------------------+`n| Credits @Umer_74      |`n+-----------------------+--------------------------`n| Date/Time script ran  | $date`n| Computer Name         | $system`n| Logged Username       | $env:username`n| Last BIOS install     | $ageofbios`n| Manufacturer Brand    | $manufacturer`n| Computer Model        | $model`n| BIOS SerialNumber     | $serialnumber`n| Operating System      | $osname`n| Total RAM Installed   | $totalMem`n| RAM Speed (MHz)       | $memspeed`n| Processor Model       | $cpu`n| Primary Disk Drive    | $diskdrivetype`n| Disk Total Space      | $diskspacetotal`n| Disk Available Space  | $diskspaceavail`n| Network Interface     | $interfaceName`n| Antivirus System      | $antiVirus`n| Firewall Status (pub) | $publicfirewallst`n| Bitlocker Status      | $bitlocker`n+-----------------------+--------------------------`n"
    echo "$out"														  
    $x = Read-Host -Prompt "Save the output to file (y/n)"
    if($x -eq 'y') {echo "$out" >> "(c)_IT_AUDIT.txt"}
    Read-Host -Prompt "`nPress any key to Exit"
    Exit

    #"$system,$env:username,$env:logonserver,$ageofbios,$manufacturer,$model,$serialnumber,$osname,$totalMem,$cpu,$diskdrivetype,$diskspacetotal,$diskspaceavail,$interfaceName,$antivirus" | Add-Content -Path $file
    #echo "Check File $loc\$file"
}
else {
    echo Error...Invalid Operating System...
    echo Error...No actions were made...
    Exit
}