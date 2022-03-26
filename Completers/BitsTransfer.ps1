# ARGUMENT COMPLETER FUNCTIONS #################################################

# BITS JOB NAME
function BitsTransfer_JobNameArgumentCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    BitsTransfer\Get-BitsTransfer -Name "$wordToComplete*" |
        Sort-Object -Property DisplayName |
        ForEach-Object {
            $Tooltip = "JobId: {0} `nTransferType: {1} - State: {2}" -f $_.JobId,$_.TransferType,$_.JobState
            New-CompletionResult -CompletionText $_.DisplayName -ToolTip $Tooltip
        }
}
# BITS JOB ID
function BitsTransfer_JobIdArgumentCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    BitsTransfer\Get-BitsTransfer -Name "$wordToComplete*" |
        Sort-Object -Property DisplayName |
        ForEach-Object {
            $Tooltip = "Job Name: {0} `nJobId: {1} `nTransferType: {2} - State: {3}" -f $_.DisplayName,$_.JobId,$_.TransferType,$_.JobState
            New-CompletionResult -CompletionText $_.JobId -ToolTip $Tooltip -ListItemText $_.DisplayName
        }
}

# BITS JOB
function BitsTransfer_BitsJobArgumentCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    BitsTransfer\Get-BitsTransfer -Name "$wordToComplete*" |
        ForEach-Object {
            $Tooltip = "Job Name: {0} `nJobId: {1} `nTransferType: {2} - State: {3}" -f $_.DisplayName,$_.JobId,$_.TransferType,$_.JobState
            $CompletionText = "(Get-BitsTransfer -Name {0})" -f $_.DisplayName
            New-CompletionResult -CompletionText $CompletionText -ToolTip $Tooltip -ListItemText $_.DisplayName -CompletionResultType Command
        }
}

# ARGUMENT COMPLETER REGISTRATION ##############################################

# BITS JOB NAME
# Complete BITS job names, for example: Get-BitsTransfer -Name <TAB>
Register-ArgumentCompleter `
    -Command ('Get-BitsTransfer') `
    -Parameter 'Name' `
    -ScriptBlock $function:BitsTransfer_JobNameArgumentCompletion

# BITS JOB ID
# Complete BITS job Ids, for example: Get-BitsTransfer -JobId <TAB>
Register-ArgumentCompleter `
    -Command ('Get-BitsTransfer') `
    -Parameter 'JobId' `
    -ScriptBlock $function:BitsTransfer_JobIdArgumentCompletion

# BITS JOB
# Complete BITS jobs, for example: Set-BitsTransfer -BitsJob <TAB>
Register-ArgumentCompleter `
    -Command ('Add-BitsFile','Complete-BitsTransfer','Remove-BitsTransfer','Resume-BitsTransfer','Set-BitsTransfer','Suspend-BitsTransfer') `
    -Parameter 'BitsJob' `
    -ScriptBlock $function:BitsTransfer_BitsJobArgumentCompletion
