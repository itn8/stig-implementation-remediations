 <#
.SYNOPSIS
    This PowerShell script ensures that camera access from the lock screen is disabled.

.NOTES
    Author          : Nate Carter
    LinkedIn        : linkedin.com/in/natecarter8/
    GitHub          : github.com/itn8
    Date Created    : 2025-04-22
    Last Modified   : 2025-04-22
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000005

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Please manually confirm camera presence before running.
    Example syntax:
    PS C:\> .\__remediation_template(STIG-ID-WN10-CC-000005).ps1 
#>

# CODE:

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as Administrator!" -ForegroundColor Red
    exit 1
}

# Registry path and key for disabling camera access from the lock screen
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
$registryKey = "NoLockScreenCamera"
$expectedValue = 1

# Ensure the registry path exists
if (-not (Test-Path $registryPath)) {
    try {
        New-Item -Path $registryPath -Force | Out-Null
        Write-Host "Created missing registry path: $registryPath" -ForegroundColor Green
    } catch {
        Write-Host "Failed to create registry path: $registryPath" -ForegroundColor Red
        exit 1
    }
}

# Set the registry value to disable camera access (1 = Disabled)
try {
    Set-ItemProperty -Path $registryPath -Name $registryKey -Value $expectedValue -Type DWord
    Write-Host "Set registry value '$registryKey' to $expectedValue" -ForegroundColor Green
} catch {
    Write-Host "Failed to set registry value '$registryKey'." -ForegroundColor Red
    exit 1
}

# Verify the setting
if ((Get-ItemProperty -Path $registryPath -Name $registryKey).$registryKey -eq $expectedValue) {
    Write-Host "Camera access from the lock screen has been successfully disabled." -ForegroundColor Green
    exit 0
} else {
    Write-Host "Failed to disable camera access from the lock screen." -ForegroundColor Red
    exit 1
}
 
