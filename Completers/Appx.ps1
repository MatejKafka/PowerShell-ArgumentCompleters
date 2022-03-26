# ARGUMENT COMPLETER FUNCTIONS #################################################

# APPX Package
function Appx_PackageNameArgumentCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    Appx\Get-AppxPackage -Name "$wordToComplete*" |
        Sort-Object -Property Name |
        ForEach-Object {
            $ToolTip = "Name: {0} - Version: {1}" -f $_.Name,$_.Version
            New-CompletionResult -CompletionText $_.Name -ToolTip $ToolTip
        }
}

function Appx_PackagePublisherArgumentCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    Appx\Get-AppxPackage -Publisher "$wordToComplete*" |
        Select-Object -Property Publisher -Unique |
        Sort-Object -Property Publisher |
        ForEach-Object {
            $ToolTip = "Publisher: {0}" -f $_.Publisher
            New-CompletionResult -CompletionText $_.Publisher -ToolTip $ToolTip
        }
}

function Appx_PathArgumentCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    Get-CompletionWithExtension $lastWord ('.appx')
}

# APPX Package Manifest
function Appx_PackageManifestNameArgumentCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    Appx\Get-AppxPackage |
        Where-Object {$_.PackageFullName -like "$wordToComplete*"} |
        Sort-Object -Property PackageFullName |
        ForEach-Object {
            $ToolTip = "Name: {0} - Version: {1} - Full Name: {2}" -f $_.Name,$_.Version,$_.PackageFullName
            New-CompletionResult -CompletionText $_.PackageFullName -ToolTip $ToolTip
        }
}

################################################################################

# APPX Package

# Complete Appx names, for example: Get-AppxPackage -Name <TAB>
Register-ArgumentCompleter `
    -Command ('Get-AppxPackage') `
    -Parameter 'Name' `
    -ScriptBlock $function:Appx_PackageNameArgumentCompletion

# Complete Appx publisher, for example: Get-AppxPackage -Publisher <TAB>
Register-ArgumentCompleter `
    -Command ('Get-AppxPackage') `
    -Parameter 'Publisher' `
    -ScriptBlock $function:Appx_PackagePublisherArgumentCompletion

# Complete Appx path names, for example: Add-AppxPackage -Path <TAB>
Register-ArgumentCompleter `
    -Command ('Add-AppxPackage') `
    -Parameter 'Path' `
    -ScriptBlock $function:Appx_PathArgumentCompletion

# APPX Package Manifest

# Complete Appx Package names, for example: Get-AppxPackageManifest -Package <TAB>
Register-ArgumentCompleter `
    -Command ('Get-AppxPackageManifest','Remove-AppxPackage') `
    -Parameter 'Package' `
    -ScriptBlock $function:Appx_PackageManifestNameArgumentCompletion

