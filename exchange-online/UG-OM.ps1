<#
.SYNOPSIS
Example script to export Microsoft 365 Unified Groups with Members and Owners to CSV from the given CSV file
.DESCRIPTION
This script exports Microsoft 365 Unified Groups members and owners to a CSV file. The script reads a list of groups from a CSV file and exports the group email, group name, owners, and members to another CSV file.
.PARAMETER $InputFile
The path to the CSV file containing a list of groups. The CSV file should contain Email and Name coloumn with the Groups email and Displayname
.PARAMETER $OutputFile
The path to the CSV file to export the group data to.
.INPUTS
None
.OUTPUTS
CSV File
.NOTES
Version: 1.0
Author: Sivakumar Margabandhu
Creation Date: 20230410
Purpose/Change: Initial version

.EXAMPLE
.\ug-om.ps1
#>

# Define variables for input and output file paths
$InputFile = "C:\M365groups\groups-source.csv"
$OutputFile = "C:\M365groups\ownerreport.csv"

# Import group list from input file
$Groups = Import-Csv -Path $InputFile

# Loop through each group in the list and get the owners
$Results = foreach ($Group in $Groups) {
	Write-Host "Processing group $($group.Name) with email $($group.Email)"
    $GroupEmail = $Group.Email
    $GroupName = $Group.Name
    $owners = (Get-UnifiedGroupLinks -Identity $group.Email -LinkType Owners -ResultSize Unlimited | Select -ExpandProperty PrimarySmtpAddress) -join ";"
    $members = (Get-UnifiedGroupLinks -Identity $group.Email -LinkType Members -ResultSize Unlimited | Select -ExpandProperty PrimarySmtpAddress) -join ";"
    [PSCustomObject]@{
        "Group Email" = $group.Email
        "Group Name" = $group.Name
        "Owners" = $owners
        "Members" = $members
    }
}

# Export results to output file
$Results | Export-Csv -Path $OutputFile -NoTypeInformation
