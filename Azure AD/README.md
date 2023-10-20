Create M365_Licensed_Users.ps1
==============================
This PowerShell script connects to Microsoft 365, specifically Office 365 and Exchange Online, to export user information with a specific license to a CSV file. It prompts for the desired license, retrieves users who have that license, and collects user details such as User Principal Name (UPN), Primary SMTP Address, DirSync status, Credential Block status, License, and associated Service Plans. The exported user data is saved to a CSV file for further analysis or reporting.

This script is useful for organizations looking to manage and analyze user licenses and associated service plans within their Microsoft 365 environment.

| UPN              | PrimarySmtpAddress | IsDirSynced | BlockCredential | License                     | ServicePlans                                    |
|------------------|--------------------|-------------|-----------------|-----------------------------|-------------------------------------------------|
| user1@example.com| user1@example.com  | False       | True            | tenantname:ENTERPRISEPACK  | Exchange Online (Plan 1); Microsoft Teams; ...  |
| user2@example.com| user2@example.com  | True        | False           | tenantname:ENTERPRISEPACK  | Exchange Online (Plan 1); Microsoft Teams; ...  |


