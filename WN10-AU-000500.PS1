 <#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Windows Application event log is at least 32768 KB (32 MB).

.NOTES
    Author          : Nate Carter
    LinkedIn        : linkedin.com/in/natecarter8/
    GitHub          : github.com/itn8
    Date Created    : 2025-04-22
    Last Modified   : 2025-04-22
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AU-000500

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Please automate or manually execute the .ps1 file for remediation.
    Example syntax:
    PS C:\> .\__remediation_template(STIG-ID-WN10-AU-000500).ps1 
#>

# PS Code:

# Define the registry path and value
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application"
$propertyName = "MaxSize"
$propertyValue = 0x00008000  # This is the hexadecimal value for the DWORD 0x8000

# Check if the registry path exists, and create it if necessary
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force
}

# Set the MaxSize value in the registry
Set-ItemProperty -Path $registryPath -Name $propertyName -Value $propertyValue

# Output success message
Write-Host "Registry key set: $registryPath\$propertyName = $propertyValue"
 
