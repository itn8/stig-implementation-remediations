<#
.SYNOPSIS
    This PowerShell script ensures that the built-in administrator account is disabled.

.NOTES
    Author          : Nate Carter
    LinkedIn        : linkedin.com/in/natecarter8/
    GitHub          : github.com/itn8
    Date Created    : 2025-04-23
    Last Modified   : 2025-04-24
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-SO-000005

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Run as a local admin
    **When using a non-default admin account (non RID 500 account), first disable UAC Token Elevation Filtering:**
    The following command disables the UAC Token Elevation policy restriction for local admin accounts (for testing/stig scanning):

New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "LocalAccountTokenFilterPolicy" -Value 1 -PropertyType DWord -Force
   
#>

# CODE:


# Ensure running as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script must be run as Administrator." -ForegroundColor Red
    exit 1
}

# Get the built-in Administrator account (SID ends in -500)
$adminAccount = Get-LocalUser | Where-Object { $_.SID.Value -like '*-500' }

if ($null -eq $adminAccount) {
    Write-Host "Could not find the built-in Administrator account." -ForegroundColor Red
    exit 1
}

# Disable the account if it is enabled
if ($adminAccount.Enabled) {
    try {
        Disable-LocalUser -Name $adminAccount.Name
        Start-Sleep -Seconds 2
    } catch {
        Write-Host "Failed to disable the Administrator account: $_" -ForegroundColor Red
        exit 1
    }
}

# Verify
$adminAccount = Get-LocalUser -Name $adminAccount.Name
if (-not $adminAccount.Enabled) {
    Write-Host "Successfully disabled the built-in Administrator account." -ForegroundColor Green
    exit 0
} else {
    Write-Host "Failed to disable the Administrator account." -ForegroundColor Red
    exit 1
}
