## Dism module Custom Completers ##

#
# .SYNOPSIS
#
#    Complete the -FeatureName argument to DISM cmdlets
#
function Dism_WindowsOptionalFeatureNameCompleter
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    Dism\Get-WindowsOptionalFeature -Online | Where-Object FeatureName -like "$wordToComplete*" | Sort-Object FeatureName | ForEach-Object {
        New-CompletionResult $_.FeatureName "FeatureName '$($_.FeatureName)'"
    }
}


# Complete the -FeatureName argument to DISM cmdlets:  Get-WindowsOptionalFeature -FeatureName xps* -Online <TAB>
Register-ArgumentCompleter `
    -Command ('Disable-WindowsOptionalFeature','Enable-WindowsOptionalFeature','Get-WindowsOptionalFeature') `
    -Parameter 'FeatureName' `
    -ScriptBlock $function:Dism_WindowsOptionalFeatureNameCompleter
