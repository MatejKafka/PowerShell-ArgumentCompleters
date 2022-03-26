## NetSecurity module Custom Completers ##

#
# .SYNOPSIS
#
#    Complete the -Name argument to *-NetConnectionProfile cmdlets
#
function NetFirewallRuleNameParameterCompleter
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    NetSecurity\Get-NetFirewallRule -Name "$wordToComplete*" | Sort-Object Name | ForEach-Object {
        New-CompletionResult $_.Name "Name: $($_.Name)"
    }
}


#
# .SYNOPSIS
#
#    Complete the -DisplayName argument to *-NetFirewallRule cmdlets
#
function NetFirewallRuleDisplayNameParameterCompleter
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    NetSecurity\Get-NetFirewallRule -DisplayName "$wordToComplete*" | Sort-Object DisplayName | ForEach-Object {
        New-CompletionResult $_.DisplayName "DisplayName: $($_.DisplayName)"
    }
}


# Complete the -Name argument to *-NetFirewallRule cmdlets, for example: Get-NetFirewallRule -Name <TAB>
Register-ArgumentCompleter `
    -Command ('Copy-NetFirewallRule','Disable-NetFirewallRule','Enable-NetFirewallRule','Get-NetFirewallRule','Remove-NetFirewallRule','Rename-NetFirewallRule','Set-NetFirewallRule') `
    -Parameter 'Name' `
    -ScriptBlock $function:NetFirewallRuleNameParameterCompleter


# Complete the -DisplayName argument to *-NetFirewallRule cmdlets, for example: Get-NetFirewallRule -DisplayName <TAB>
Register-ArgumentCompleter `
    -Command ('Copy-NetFirewallRule','Disable-NetFirewallRule','Enable-NetFirewallRule','Get-NetFirewallRule','Remove-NetFirewallRule','Rename-NetFirewallRule','Set-NetFirewallRule') `
    -Parameter 'DisplayName' `
    -ScriptBlock $function:NetFirewallRuleDisplayNameParameterCompleter
