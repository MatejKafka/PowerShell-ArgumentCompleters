## Wdac module Custom Completers ##

#
# .SYNOPSIS
#
#    Complete the -Name arguments to *-OdbcDriver cmdlets
#
function Wdac_OdbcDriverNameParameterCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    Wdac\Get-OdbcDriver -Name "$wordToComplete*" | Sort-Object Name | ForEach-Object {
        New-CompletionResult $_.Name "Name: $($_.Name)"
    }
}


#
# .SYNOPSIS
#
#    Complete the -Name arguments to *-OdbcDsn cmdlets
#
function Wdac_OdbcDsnNameParameterCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    Wdac\Get-OdbcDsn -Name "$wordToComplete*" | Sort-Object Name | ForEach-Object {
        New-CompletionResult $_.Name "Name: $($_.Name)"
    }
}


#
# .SYNOPSIS
#
#    Complete the -DriverName arguments to *-OdbcDsn cmdlets
#
function Wdac_DriverNameParameterCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    Wdac\Get-OdbcDsn -DriverName "$wordToComplete*" | Sort-Object DriverName | ForEach-Object {
        New-CompletionResult $_.DriverName "DriverName: $($_.DriverName)"
    }
}


# Complete the -Name arguments to *-OdbcDriver cmdlets. For example: Get-OdbcDriver -Name <TAB>
Register-ArgumentCompleter `
    -Command ('Get-OdbcDriver','Set-OdbcDriver') `
    -Parameter 'Name' `
    -ScriptBlock $function:Wdac_OdbcDriverNameParameterCompletion


# Complete the -Name arguments to *-OdbcDsn cmdlets. For example: Get-OdbcDsn -Name <TAB>
Register-ArgumentCompleter `
    -Command ('Add-OdbcDsn','Get-OdbcDsn','Remove-OdbcDsn','Set-OdbcDsn') `
    -Parameter 'Name' `
    -ScriptBlock $function:Wdac_OdbcDsnNameParameterCompletion


# Complete the -DriverName arguments to *-OdbcDsn cmdlets. For example: Get-OdbcDsn -DriverName <TAB>
Register-ArgumentCompleter `
    -Command ('Add-OdbcDsn','Get-OdbcDsn','Remove-OdbcDsn','Set-OdbcDsn') `
    -Parameter 'DriverName' `
    -ScriptBlock $function:Wdac_DriverNameParameterCompletion
