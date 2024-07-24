# Build-CdfModule will automatically use this if it exists alongside the {__ModuleName__}.psd1 module manifest
# Use this file to override the default parameter values used by the Build-Module
# command when building the module (see Get-Help Build-Module -Full for details).
@{
    # PowerShell Module manifest
    Path = "{__ModuleName__}.psd1"

    # Output the ModuleInfo of the "built" module
    # Passthru = $true

    # Folders which should be copied intact to the module output
    #   Can be relative to the  module folder
    CopyPaths = @('ScriptsToProcess')

    # Folders which contain source .ps1 scripts to be concatenated into the module
    #   If you're adding folders, you must include the existing folders, or they won't be included during the build
    #   Defaults to Enum, Classes, Private, Public
    # SourceDirectories = @( 'Private', 'Public' )

    # A Filter (relative to the module folder) for public functions
    #   If non-empty, FunctionsToExport will be set with the file BaseNames of matching files
    #   Defaults to Public\*.ps1
    # PublicFilter = @('Public\*.ps1')

    # A switch that allows you to disable the update of the AliasesToExport
    #   By default, (if PublicFilter is not empty, and this is not set)
    #   Build-Module updates the module manifest FunctionsToExport and AliasesToExport
    #    with the combination of all the values in [Alias()] attributes on public functions in the module
    # IgnoreAliasAttribute = $true

    # The prefix is either the path to a file (relative to the module folder) or text to put at the top of the file.
    #   If the value of prefix resolves to a file, that file will be read in, otherwise, the value will be used.
    # EXAMPLE: This will add 'using namespace System.Management.Automation' to the top of the .psm1 file
    # Prefix = "using namespace System.Management.Automation"

    # The Suffix is either the path to a file (relative to the module folder) or text to put at the bottom of the file.
    #   If the value of Suffix resolves to a file, that file will be read in, otherwise, the value will be used.
    # EXAMPLE: This will add 'Export-ModuleMember -Function *-* -Variable PreferenceVariable' to the bottom of the .psm1 file
    # Suffix = "Export-ModuleMember -Function *-* -Variable PreferenceVariable"

    # Controls whether we delete the output folder and whether we build the output
    #   There are three options:
    #    - Clean deletes the build output folder
    #    - Build builds the module output
    #    - CleanBuild first deletes the build output folder and then builds the module back into it
    #   Note that the folder to be deleted is the actual calculated output folder, with the version number
    #    So for the default OutputDirectory with version 1.2.3, the path to clean is: ..\Output\ModuleName\1.2.3
    # Target = "CleanBuild"

    # Overrides the VersionedOutputDirectory, producing an OutputDirectory without a version number as the last folder
    # UnversionedOutputDirectory = $true

    # The module version (must be a valid System.Version such as PowerShell supports for modules)
    # Version = "1.0.0"

    # Semantic version, like 1.0.3-beta01+sha.22c35ffff166f34addc49a3b80e622b543199cc5
    #   If the SemVer has metadata (after a +), then the full Semver will be added to the ReleaseNotes
    # SemVer = "1.0.3-beta01+sha.22c35ffff166f34addc49a3b80e622b543199cc5"
}