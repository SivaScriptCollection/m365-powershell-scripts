<#
.SYNOPSIS
Example script to export Microsoft 365 Unified Groups with Members and Owners to CSV file.
.DESCRIPTION
This script exports all Microsoft 365 Unified Group's members and owners to a CSV file. The script retrieves all the groups in the Microsoft 365 tenant and exports the group's email, group identity, display name, owners, and members to the CSV file specified by the $CSVFilename parameter. To avoid timeout for larger environment it will go sleep for 3 seconds for every 1000 processed group.
.PARAMETER $CSVFilename
The path to the CSV file to export the group data to.
.INPUTS
None
.OUTPUTS
CSV File containing group information
.NOTES
Version: 1.0
Author: Sivakumar Margabandhu
Creation Date: 20230410
Purpose/Change: Initial script
.EXAMPLE
.\script.ps1 -CSVFilename "C:\GroupData.csv"
#>

param([parameter(Mandatory=$True, HelpMessage='Enter a filename for the CSV file to export')]$CSVFilename)

Write-Host -ForegroundColor Green "Loading all Microsoft365 Groups"
$Groups = Get-UnifiedGroup -ResultSize Unlimited

# Process Groups
$GroupsCSV = @()
Write-Host -ForegroundColor Green "Processing Microsoft365 Groups"
$i = 0
foreach ($Group in $Groups)
{
    # Get group information
    Write-Host -ForegroundColor Yellow -NoNewline "."
    $GroupInfo = Get-UnifiedGroup -Identity $Group.Identity
    
    # Get owners
    $Owners = Get-UnifiedGroupLinks -Identity $Group.Identity -LinkType Owners -ResultSize Unlimited
    $OwnersSMTP = $Owners.PrimarySmtpAddress -join ","
    
    # Get members
    $Members = Get-UnifiedGroupLinks -Identity $Group.Identity -LinkType Members -ResultSize Unlimited
    $MembersSMTP = $Members.PrimarySmtpAddress -join ","
    
    # Create CSV file line
    $GroupsRow = [pscustomobject]@{
        GroupSMTPAddress = $GroupInfo.PrimarySmtpAddress
        GroupIdentity = $GroupInfo.Identity
        GroupDisplayName = $GroupInfo.DisplayName
        MembersSMTP = $MembersSMTP
        OwnersSMTP = $OwnersSMTP
    }

    # Add to export array
    $GroupsCSV += $GroupsRow
    
    # Check if 1000 groups have been processed
    $i++
    if ($i % 1000 -eq 0) {
        Write-Host -ForegroundColor Green "`nProcessed $i groups, sleeping for 3 seconds..."
        Start-Sleep -Seconds 3
    }
}

# Export to CSV
Write-Host -ForegroundColor Green "`nCreating and exporting CSV file"
$GroupsCSV | Export-Csv -NoTypeInformation -Path $CSVFilename
