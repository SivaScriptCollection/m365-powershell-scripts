**UG-OM.ps1** (UnifiedGroup-OwnerMember)

The M365 Groups with Members and Owners Export Script is a PowerShell script that exports Microsoft 365 Unified Groups members and owners to a CSV file. The script reads a list of groups from a CSV file and exports the group email, group name, owners, and members to another CSV file. The input CSV file should have following info

| Email  | Name |
| ------------- | ------------- |
| Emailaddress1  | Displayname1  |
| Emailaddress2  | Displayname2  |

------------------------------
**UG-OM-Export.ps1** (UnifiedGroup-OwnerMember-Export)

This PowerShell script exports Microsoft 365 Unified Group's members and owners to a CSV file by retrieving all the groups in the Microsoft 365 tenant. It retrieves group information, including the group email, identity, display name, owners, and members, and exports it to a CSV file specified by the $CSVFilename parameter. It will store the output CSV in the same path you are executing the script. To avoid the time out for larger environment, it will go to sleep mode for 3 seconds for every 1000 processed groups.

-------------------------------
