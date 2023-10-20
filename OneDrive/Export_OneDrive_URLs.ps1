<#
.SYNOPSIS
Script to automate the retrieval of OneDrive URLs for a list of users in a Microsoft 365 (Office 365) environment.
.DESCRIPTION
This script connects to your Microsoft 365 tenant, processes a CSV file containing user email addresses, and fetches the corresponding OneDrive URLs. It leverages SharePoint and OneDrive APIs to simplify the management of user OneDrive accounts. This script is using the ShareGate module.
.PARAMETER $csvFile
The path to the CSV file contains a list of user email addresses.
.PARAMETER $outputFile
The path for the output CSV file to store user emails and OneDrive URLs.
.INPUTS
None
.OUTPUTS
CSV file containing user email addresses and their respective OneDrive URLs.
.NOTES
- Version: 1.0
- Author: Sivakumar Margabandhu
- Creation Date: 2023-10-20
- Purpose/Change: Initial Script
.EXAMPLE
.\script.ps1 -csvFile "user.csv" -outputFile "OneDriveUrls.csv"
#>

Import-Module ShareGate
#Replace the URL with your SharePoint Admin URL
$tenant = Connect-Site -Url "https://YOURTENANTNAME-admin.sharepoint.com" -Browser
$csvFile = "user.csv"
$outputFile = "OneDriveUrls.csv"
$table = Import-Csv $csvFile -Delimiter ","

# Initialize an array to store the output
$output = @()

foreach ($row in $table) {
    $oneDriveUrl = Get-OneDriveUrl -Tenant $tenant -Email $row.Email

    # Create a custom object to store the email and OneDrive URL
    $obj = [PSCustomObject]@{
        Email      = $row.Email
        OneDriveUrl = $oneDriveUrl
    }

    # Add the custom object to the output array
    $output += $obj
}

# Export the output to a CSV file
$output | Export-Csv $outputFile -NoTypeInformation

Write-Host "OneDrive URLs have been exported to $outputFile"

