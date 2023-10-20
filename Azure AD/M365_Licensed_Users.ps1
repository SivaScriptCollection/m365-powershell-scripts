<#
.SYNOPSIS
Script to export users with a specific Microsoft 365 license to a CSV file.
.DESCRIPTION
This script connects to Office 365, retrieves users with a specified license, and exports their information to a CSV file. It collects user details, including User Principal Name (UPN), Primary SMTP Address, DirSync status, Credential Block status, License, and associated Service Plans. The output is saved to a CSV file specified by the $csvFilePath parameter. To avoid timeouts for a large number of users, the script pauses for 3 seconds after processing every 500 users.
.PARAMETER $csvFilePath
The path to the CSV file where user information will be exported.
.INPUTS
None
.OUTPUTS
CSV File containing user information with the specified license.
.NOTES
Version: 1.0
Author: Sivakumar Margabandhu
Creation Date: 20231020
Purpose/Change: Initial Script
.EXAMPLE
.\script.ps1
#>
# Connect to Office 365
Connect-MsolService

# Connect to Exchange Online
Connect-ExchangeOnline

# List all available licenses in the tenant
$AccountSkus = Get-MsolAccountSku
$AccountSkus | Format-Table -Property AccountSkuId, SkuPartNumber, ActiveUnits, ConsumedUnits

# Prompt for the desired license
$LicenseName = Read-Host -Prompt 'Enter the license name you want to export users for (e.g. tenantname:ENTERPRISEPACK)'

# Define the CSV file path
$csvFilePath = "ExportedUsers-Teams.csv"

# Initialize the output array
$Output = @()

# Retrieve users with the specified license
$Users = Get-MsolUser -All | Where-Object {($_.Licenses).AccountSkuId -contains $LicenseName}

# Initialize user counter
$UserCounter = 0

# Loop through users and gather required information
foreach ($User in $Users) {
    $UserCounter++
    Write-Host "Processing user $($User.UserPrincipalName) ($UserCounter of $($Users.Count))"
    
    $UPN = $User.UserPrincipalName
    $Mailbox = Get-Mailbox -Identity $UPN
    $PrimarySmtpAddress = $Mailbox.PrimarySmtpAddress
    $IsDirSynced = $User.LastDirSyncTime -ne $null
    $BlockCredential = $User.BlockCredential
    $License = $User.Licenses | Where-Object {$_.AccountSkuId -eq $LicenseName}
    $ServicePlans = ($License.ServiceStatus | Where-Object {$_.ProvisioningStatus -eq "Success"}).ServicePlan.ServiceName -join ";"


    $Output += [PSCustomObject]@{
        UPN                = $UPN
	  PrimarySmtpAddress = $PrimarySmtpAddress
        IsDirSynced        = $IsDirSynced
        BlockCredential    = $BlockCredential
	  License            = $LicenseName
        ServicePlans       = $ServicePlans
        
    }
    
    if ($UserCounter % 500 -eq 0) {
        Write-Host "Processed 500 users, pausing for 3 seconds..."
        Start-Sleep -Seconds 3
    }
}

# Export the output to a CSV file
$Output | Export-Csv -Path $csvFilePath -NoTypeInformation

Write-Host "User information has been exported to $csvFilePath"

# Disconnect from Exchange Online
Disconnect-ExchangeOnline -Confirm:$false
