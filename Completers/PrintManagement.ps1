#
# .SYNOPSIS
#
#    Complete the -Name argument to Printer cmdlets
#
function PrinterNameArgumentCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $optionalCn = @{}
    $cn = $fakeBoundParameter["ComputerName"]
    if($cn)
    {
        $optionalCn.ComputerName = $cn
    }

    Get-Printer -Name "$wordToComplete*" @optionalCn |
        Sort-Object Name |
        ForEach-Object {
            $tooltip = $_.Description
            if ($tooltip -eq '') { $tooltip = $_.Location }
            if ($tooltip -eq '') { $tooltip = $_.Caption }
            New-CompletionResult $_.Name $tooltip
    }
}


#
# .SYNOPSIS
#
#    Complete the -Name argument to *-PrinterDriver cmdlets
#
function PrinterDriverNameArgumentCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $optionalCn = @{}
    $cn = $fakeBoundParameter["ComputerName"]
    if($cn)
    {
        $optionalCn.ComputerName = $cn
    }

    Get-PrinterDriver -Name "$wordToComplete*" @optionalCn |
        Sort-Object Name |
        ForEach-Object {
            $tooltip = $_.Description
            if (!$tooltip) { $tooltip = $_.Status }
            if (!$tooltip) { $tooltip = $_.Manufacturer }
            New-CompletionResult $_.Name $tooltip
        }
}


#
# .SYNOPSIS
#
#    Complete the -Name argument to *-PrinterPort cmdlets
#
function PrinterPortArgumentCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $optionalCn = @{}
    $cn = $fakeBoundParameter["ComputerName"]
    if($cn)
    {
        $optionalCn.ComputerName = $cn
    }

    Get-PrinterPort -Name "$wordToComplete*" @optionalCn |
        Sort-Object Name |
        ForEach-Object {
            New-CompletionResult $_.Name $_.Description
        }
}


# Complete printer names
Register-ArgumentCompleter `
    -Command ('Get-Printer', 'Remove-Printer', 'Set-Printer') `
    -Parameter 'Name' `
    -ScriptBlock $function:PrinterNameArgumentCompletion


# Complete printer names
Register-ArgumentCompleter `
    -Command ( 'Add-PrinterPort', 'Get-PrintConfiguration', 'Get-PrinterProperty', 'Get-PrintJob', 'Remove-PrintJob', 'Restart-PrintJob', 'Resume-PrintJob', 'Set-PrintConfiguration', 'Set-PrinterProperty', 'Suspend-PrintJob' ) `
    -Parameter 'PrinterName' `
    -ScriptBlock $function:PrinterNameArgumentCompletion


# Complete printer driver names.
Register-ArgumentCompleter `
    -Command ('Get-PrinterDriver', 'Remove-PrinterDriver') `
    -Parameter 'Name' `
    -ScriptBlock $function:PrinterDriverNameArgumentCompletion


# Complete printer port names.
Register-ArgumentCompleter `
    -Command ('Get-PrinterPort', 'Remove-PrinterPort') `
    -Parameter 'Name' `
    -ScriptBlock $function:PrinterPortArgumentCompletion
