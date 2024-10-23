@{

    # Script module or binary module file associated with this manifest.
    RootModule = 'Strapper.psm1'

    # Version number of this module.
    ModuleVersion = '1.6.2'

    # ID used to uniquely identify this module
    GUID = '6fe5cf06-7b4f-4695-b022-1ca2feb0341f'

    # Author of this module
    Author = 'Stephen Nix'

    # Company or vendor of this module
    CompanyName = 'ProVal Tech'

    # Copyright statement for this module
    Copyright = '(c) ProVal Tech. All rights reserved.'

    # Description of the functionality provided by this module
    Description = 'A cross-platform helper module for PowerShell.'

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '5.0'

    RequiredAssemblies = @(
        './Libraries/SQLite/System.Data.SQLite.dll'
    )
    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @()

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport = @()

    # Variables to export from this module
    VariablesToExport = '*'

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        # Tags = @()

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/ProVal-Tech/Strapper/blob/main/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/ProVal-Tech/Strapper'

        # A URL to an icon representing this module.
        IconUri = 'https://raw.githubusercontent.com/ProVal-Tech/Strapper/main/res/img/strapper.png'

        # ReleaseNotes of this module
        ReleaseNotes = ''

        # Prerelease string of this module
        Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable

} # End of PrivateData hashtable

    # HelpInfo URI of this module
    HelpInfoURI = 'https://github.com/ProVal-Tech/Strapper/issues'
}