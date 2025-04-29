#region functions
function Find-EMRequiredModule {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string[]]$Name,
        [string]$Repository = 'PSGallery',
        [bool]$UsePSResourceGet
    )
    try {
        $FindModParams = @{
            Name = $Name
            Repository = $Repository
        }
        if ( $UsePSResourceGet ) {
            Find-PSResource @FindModParams
        } else {
            Find-Module @FindModParams
        }
    } catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}
function Install-EMRequiredModule {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string[]]$Name,
        [string]$Repository = 'PSGallery',
        [ValidateSet('CurrentUser','AllUsers')]
        [string]$Scope = 'CurrentUser',
        [switch]$AllowClobber,
        [switch]$Force,
        [bool]$UsePSResourceGet
    )
    try {
        $InstallModParams = @{
            Name = $Name,
            Repository = $Repository
            Scope = $Scope
            AcceptLicense = $true
        }
        if ( $UsePSResourceGet ) {
            if ( $Force ) {
                $InstallModParams.Add('Reinstall', $true)
            }
            if ( -not $AllowClobber ) {
                $InstallModParams.Add('NoClobber', $true)
            }
            Install-PSResource @InstallModParams -Quiet -TrustRepository
        } else {
            if ( $Force ) {
                $InstallModParams.Add('Force', $true)
            }
            if ( $AllowClobber ) {
                $InstallModParams.Add('AllowClobber', $true)
            }
            Install-Module @InstallModParams -SkipPublisherCheck -Force
        }
    } catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}
#endregion functions
# find the module manifest by working down the directory tree
$Parent = Split-Path $PSScriptRoot
$ModuleName = Split-Path (Split-Path $Parent) -Leaf
$ModulePsd1Path = Join-Path $Parent ('{0}.psd1' -f $ModuleName)
if ( Test-Path $ModulePsd1Path ) {
    # Determine if we use PSResourceGet or PowerShellGet
    $UsePSRG = $null -ne (Get-Module 'Microsoft.PowerShell.PSResourceGet' -ListAvailable -ErrorAction SilentlyContinue)
    $ModuleData = Import-PowerShellDataFile -Path $ModulePsd1Path
    # Get a list of all the ExternalModuleDependencies from the module manifest
    foreach ( $Name in @($ModuleData.PrivateData.PSData.ExternalModuleDependencies) ) {
        # Install the module if it's not already installed
        if ( $null -eq (Get-Module $Name -ListAvailable -ErrorAction SilentlyContinue) ) {
            $ModuleParams = @{
                Name = $Name
                Repository = 'PSGallery'
                UsePSResourceGet = $UsePSRG
            }
            if ( Find-EMRequiredModule @ModuleParams -ErrorAction SilentlyContinue ) {
                $IsAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
                $InstallScope = if ( $IsAdmin ) { 'AllUsers' } else { 'CurrentUser' }
                $InstallParams = @{
                    Scope = $InstallScope
                }
                try {
                    Install-EMRequiredModule @ModuleParams @InstallParams -ErrorAction Stop
                } catch {
                    try {
                        if ( $PSItem.Exception.Message -match 'Clobber' ) {
                            Install-EMRequiredModule @ModuleParams @InstallParams -AllowClobber -ErrorAction Stop
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