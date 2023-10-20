Export_OneDrive_URLs.ps1
========================
This is a PowerShell script that streamlines the process of fetching OneDrive URLs for a list of user emails in a Microsoft 365 (Office 365) environment. By utilizing ShareGate's module, the script connects to your SharePoint admin site, processes a CSV file containing user emails, and exports the corresponding OneDrive URLs to a CSV file. This automation simplifies the management of user OneDrive accounts, making it a valuable tool for administrators in Microsoft 365 environments.

Input file user.csv must have user's email address
| Email               |
|---------------------|
| user1@m365simplified.com   |
| user2@m365simplified.com  |


Output file will have the following details
| Email                | OneDriveUrl                                   |
|----------------------|---------------------------------------------|
| user1@example.com    | https://tenant-my.sharepoint.com/personal/user1_m365simplified_com |
| user2@example.com    | https://tenant-my.sharepoint.com/personal/user2_m365simplified_com |

