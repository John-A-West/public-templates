# find the module manifest by working down the directory tree
$Parent = Split-Path $PSScriptRoot
$ModuleName = Split-Path (Split-Path $Parent) -Leaf
$ModulePsd1Path = Join-Path $Parent ('{0}.psd1' -f $ModuleName)
if ( Test-Path $ModulePsd1Path ) {
    $ModuleData = Import-PowerShellDataFile -Path $ModulePsd1Path
    # Get a list of all the ExternalModuleDependencies from the module manifest
    $ExternalModules = $ModuleData.PrivateData.PSData.ExternalModuleDependencies
    foreach ( $Name in $ExternalModules ) {
        # Install the module if it's not already installed
        if ( $null -eq (Get-Module $Name -ListAvailable -ErrorAction SilentlyContinue) ) {
            $ModuleParams = @{
                Name = $Name
                Repository = 'PSGallery'
            }
            $OnlineModule = Find-Module @ModuleParams -ErrorAction SilentlyContinue
            if ( $OnlineModule ) {
                $IsAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
                $InstallScope = if ( $IsAdmin ) { 'AllUsers' } else { 'CurrentUser' }
                $InstallParams = @{
                    Scope = $InstallScope
                    SkipPublisherCheck = $true
                    AcceptLicense = $true
                    Force = $true
                }
                try {
                    Install-Module @ModuleParams @InstallParams -ErrorAction Stop
                } catch {
                    try {
                        if ( $PSItem.Exception.Message -match 'use -AllowClobber parameter' ) {
                            Install-Module @ModuleParams @InstallParams -AllowClobber -ErrorAction Stop
                        } else {
                            Write-Warning "Cannot install the dependent module '$Name' from the PSGallery. Please install it manually." -WarningAction Continue
                        }
                    } catch {
                        Write-Warning "Cannot install the dependent module '$Name' from the PSGallery. Please install it manually." -WarningAction Continue
                    }
                }
            } else {
                Write-Warning "The dependent module '$Name' is not available in the PSGallery. Please install it manually." -WarningAction Continue
            }
        }
    }
}
Remove-Module ExternalModules -Force -ErrorAction SilentlyContinue