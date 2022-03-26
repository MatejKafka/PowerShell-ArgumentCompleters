## PowerShellWebAccess module Custom Completers ##

#
# .SYNOPSIS
#
#    Complete the -RuleName argument to *-PswaAuthorizationRule cmdlets
#
function PowerShellWebAccess_PswaAuthorizationRuleNameParameterCompleter
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    PowerShellWebAccess\Get-PswaAuthorizationRule | Where-Object RuleName -like "$wordToComplete*" | Sort-Object RuleName | ForEach-Object{
        New-CompletionResult $_.RuleName "RuleName: $($_.RuleName)"
    }
}


# Complete the -RuleName argument to *-PswaAuthorizationRule cmdlets. For example: Get-PswaAuthorizationRule -RuleName <TAB>
Register-ArgumentCompleter `
    -Command ('Get-PswaAuthorizationRule','Add-PswaAuthorizationRule') `
    -Parameter 'RuleName' `
    -ScriptBlock $function:PowerShellWebAccess_PswaAuthorizationRuleNameParameterCompleter
