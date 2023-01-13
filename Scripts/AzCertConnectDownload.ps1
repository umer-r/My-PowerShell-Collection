# Certification-Based Connection Azure
$TenantID = ""
$AppID = ""
$ThumbPrint = ""

# Connection-Request
Connect-AzAccount -ApplicationId $AppID -Tenant $TenantID -CertificateThumbprint $ThumbPrint | Out-Null

# PreDefined Variables
$StorageAccountName = ""
$DestinationPath = ""
$DownloadFilePath = ""
$StorageAccountKey = ""

# Download-File
$ctx = New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey
$share = Get-AzStorageShare -Context $ctx
Get-AzStorageFileContent -Sharename $share.name -context $ctx -Path $DownloadFilePath -destination $DestinationPath 