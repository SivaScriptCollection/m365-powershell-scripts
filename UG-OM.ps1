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