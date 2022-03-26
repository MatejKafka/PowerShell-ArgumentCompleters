
#
# .SYNOPSIS
#
#    Complete the -Counter argument to Get-Counter cmdlet
#
function CounterParameterCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $optionalCn = @{}
    $cn = $fakeBoundParameter["ComputerName"]
    if($cn)
    {
        $optionalCn.ComputerName = $cn
    }

    (Get-Counter -ListSet * @optionalCn).Counter |
        Where-Object { $_ -like "$wordToComplete*" } |
        Sort-Object |
        ForEach-Object {
            # TODO: need a tooltip
            New-CompletionResult $_
        }
}


#
# .SYNOPSIS
#
#    Complete the -ListSet argument to Get-Counter cmdlet
#
function ListSetParameterCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $optionalCn = @{}
    $cn = $fakeBoundParameter["ComputerName"]
    if($cn)
    {
        $optionalCn.ComputerName = $cn
    }

    Get-Counter -ListSet "$wordToComplete*" @optionalCn |
        Sort-Object CounterSetName |
        ForEach-Object {
            $tooltip = $_.Description
            New-CompletionResult $_.CounterSetName $tooltip
        }
}


#
# .SYNOPSIS
#
#     Completes names of the logs for Get-WinEvent cmdlet.
#
function GetWinEvent_LogNameCompleter
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $optionalCn = @{}
    $cn = $fakeBoundParameter['ComputerName']
    if ($cn)
    {
        $optionalCn.ComputerName = $cn
    }

    Get-WinEvent -ListLog "$wordToComplete*" -Force @optionalCn |
        where { $_.IsEnabled } |
        Sort-Object -Property LogName |
        ForEach-Object {
            $toolTip = "Log $($_.LogName): $($_.RecordCount) entries"
            New-CompletionResult $_.LogName $toolTip
        }
}


#
# .SYNOPSIS
#
#     Completes names of the logs for Get-WinEvent cmdlet.
#
function GetWinEvent_ListLogCompleter
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    [System.Diagnostics.Eventing.Reader.EventLogSession]::GlobalSession.GetLogNames() | Where-Object {$_ -like "*$wordToComplete*"} | Sort-Object | ForEach-Object {
        New-CompletionResult $_ $_
    }
}


#
# .SYNOPSIS
#
#     Completes providers names for Get-WinEvent cmdlet.
#
function GetWinEvent_ListProviderCompleter
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    [System.Diagnostics.Eventing.Reader.EventLogSession]::GlobalSession.GetProviderNames() | Where-Object {$_ -like "*$wordToComplete*"} | Sort-Object | ForEach-Object {
        New-CompletionResult $_ $_
    }
}


# Complete counter for the Get-Counter cmdlet, optionally on a remote machine. For example:
#     Get-Counter -Counter <TAB>
#     Get-Counter -cn 127.0.0.1 -Counter <TAB>
Register-ArgumentCompleter `
    -Command 'Get-Counter' `
    -Parameter 'Counter' `
    -ScriptBlock $function:CounterParameterCompletion


# Complete counter sets for the Get-Counter cmdlet, optionally on a remote machine. For example:
#     Get-Counter -ListSet <TAB>
#     Get-Counter -cn 127.0.0.1 -ListSet <TAB>
Register-ArgumentCompleter `
    -Command 'Get-Counter' `
    -Parameter 'ListSet' `
    -ScriptBlock $function:ListSetParameterCompletion


# Completes names for the logs, for example:  Get-WinEvent -LogName <TAB>
Register-ArgumentCompleter `
    -Command 'Get-WinEvent' `
    -Parameter 'LogName' `
    -ScriptBlock $function:GetWinEvent_LogNameCompleter


# Completes names for the logs, for example:  Get-WinEvent -ListLog <TAB>
Register-ArgumentCompleter `
    -Command 'Get-WinEvent' `
    -Parameter 'ListLog' `
    -ScriptBlock $function:GetWinEvent_ListLogCompleter


# Completes names of the providers, for example:  Get-WinEvent -ListProvider <TAB>
Register-ArgumentCompleter `
    -Command 'Get-WinEvent' `
    -Parameter 'ListProvider' `
    -ScriptBlock $function:GetWinEvent_ListProviderCompleter
