#{__requiredmodules__}
function {__name__} {
    <#
        .SYNOPSIS
            {__description__}
        .DESCRIPTION
            {__description__}. Details:
        .INPUTS
            None
        .OUTPUTS
            System.Management.Automation.PSCustomObject
            or
            none
        .EXAMPLE
            {__name__}

            This will run the function with the default options
        .NOTES
            <__EXCLUDE_IMPORT__>    # this will prevent the script from being automatically imported via the $PROFILE
            Author  : {__author__}
            Email   : {__email__}
            Created : {__date__}
    #>
    [CmdletBinding(DefaultParameterSetName = "{__defaultParameterSetName__}")]                                          # if no changes: Get-*
    # [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = "{__defaultParameterSetName__}")]                 # if making changes: Set-*
    # [OutputType([System.Management.Automation.PSCustomObject], ParameterSetName = "{__defaultParameterSetName__}")]   # use if returning an object
    param (

    )
    begin {

    }
    process {
        try {

        } catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
    end {

    }
}
<#PSScriptInfo
.VERSION {__version__}
.GUID {__guid__}
.AUTHOR {__author__}
.COMPANYNAME {__companyname__}
.DESCRIPTION {__description__}
.COPYRIGHT
.TAGS
.LICENSEURI
.PROJECTURI
.ICONURI
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES
.PRIVATEDATA
#>