<#
.LINK
    https://github.com/umer-r/
.NOTES
    Author: Umer R.
    X: @umer_74
    Dated:   Sep 25, 2022
    Version:    1.0

    This is a custom powershell profile for terminal customization also creates and alias to some scripts and custom functions.
#>

function prompt {
    $dateTime = get-date -Format "dd-MM-yyyy (HH:mm:ss)"
    $currentDirectory = $(Get-Location)
    $UncRoot = $currentDirectory.Drive.DisplayRoot

    write-host "`n$dateTime" -NoNewline -ForegroundColor Green
    write-host " $UncRoot" -ForegroundColor Gray
    # Convert-Path needed for pure UNC-locations
    write-host "PS [" -NoNewline -ForegroundColor Gray
    write-host "$(Convert-Path $currentDirectory)" -NoNewline -ForegroundColor White -BackgroundColor Blue
    write-host "]" -NoNewline -ForegroundColor Gray
    write-host "`n===|>" -NoNewline -ForegroundColor White
    return " "
}

Set-PSReadLineOption -PredictionSource History
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

function batteryreports { $datenow = Get-date -Format "dddd_dd-MM-yyyy_HH-mm"; powercfg /batteryreport /output "C:\batteryreports\${datenow}.html" }
New-Alias battery-report batteryreports

function hist { 
  $find = $args; 
  Write-Host "Finding in full history using {`$_ -like `"*$find*`"}"; 
  Get-Content (Get-PSReadlineOption).HistorySavePath | ? {$_ -like "*$find*"} | Get-Unique | more 
}

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.

$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
