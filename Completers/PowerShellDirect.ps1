# Argument completer by Kurt Roggen [BE] - kurtroggen.be
# PowerShell Direct (Windows 10/Windows Server 2016 HOST running Windows 10/Windows Server 2016 VM)
# Supports cmdlets
# - PSSession cmdlets ('Enter-PSSession','Get-PSSession','New-PSSession','Remove-PSSession','Invoke-Command') for -VMName and -VMId parameters
# - Copy-Item cmdlet (-ToSession, -FromSession)

# ARGUMENT COMPLETER FUNCTIONS #################################################

# PSSESSION using VMName
function PowerShellDirect_VMNameArgumentCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $optionalCn = @{}
    $cn = $fakeBoundParameter["ComputerName"]
    if($cn)  { $optionalCn.ComputerName = $cn }

    Hyper-V\Get-VM -Name "$wordToComplete*" @optionalCn |
    Sort-Object |
    ForEach-Object {
        $ToolTip = "Name: {0} - State: {1} - Status: {2} `nID: {3} `nVersion: {4} - Generation: {5} `nvCPU: {6} - vRAM: {7:N0}GB-{8:N0}GB" -f $_.Name,$_.State,$_.Status,$_.Id,$_.Version,$_.Generation,$_.ProcessorCount,($_.MemoryMinimum/1GB),($_.MemoryMaximum/1GB)
        New-CompletionResult -CompletionText $_.Name -ToolTip $ToolTip
    }
}
# PSSESSION using VMId
function PowerShellDirect_VMIdArgumentCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $optionalCn = @{}
    $cn = $fakeBoundParameter["ComputerName"]
    if($cn) { $optionalCn.ComputerName = $cn }

    Hyper-V\Get-VM -Name "$wordToComplete*" @optionalCn |
    Sort-Object |
    ForEach-Object {
        $ToolTip = "Name: {0} - State: {1} - Status: {2} `nID: {3} `nVersion: {4} - Generation: {5} `nvCPU: {6} - vRAM: {7:N0}GB-{8:N0}GB" -f $_.Name,$_.State,$_.Status,$_.Id,$_.Version,$_.Generation,$_.ProcessorCount,($_.MemoryMinimum/1GB),($_.MemoryMaximum/1GB)
        New-CompletionResult -CompletionText $_.Id -ToolTip $ToolTip -ListItemText $_.Name
    }
}
# PSSESSION using ConfigurationName
function PowerShellDirect_ConfigurationArgumentCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    if (-not $fakeBoundParameter['ComputerName'])
    {
        Get-PSSessionConfiguration -Name "$wordToComplete*" |
        Sort-Object -Property Name |
        ForEach-Object {
            New-CompletionResult -CompletionText $_.Name -ToolTip $_.Name
        }
    }
}

# COPY-ITEM using PSSESSION
function PowerShellDirect_SessionArgumentCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    Get-PSSession -Name "$wordToComplete*" |
    Sort-Object -Property Name |
    ForEach-Object {
        $ToolTip = "Name: {0} - State: {1} - ID: {2}" -f $_.Name,$_.State,$_.Id
        New-CompletionResult -CompletionText $_.Name -ToolTip $ToolTip
    }
}

# ARGUMENT COMPLETER REGISTRATION ##############################################

# PSSESSION VMNAME
# Complete VM names, for example: Enter-PSSession -VMName <TAB>
Register-ArgumentCompleter `
    -Command ('Enter-PSSession','Get-PSSession','New-PSSession','Remove-PSSession','Invoke-Command') `
    -Parameter 'VMName' `
    -ScriptBlock $function:PowerShellDirect_VMNameArgumentCompletion

# PSSESSION VMID
# Complete VM names, for example: Enter-PSSession -VMId <TAB>
Register-ArgumentCompleter `
    -Command ('Enter-PSSession','Get-PSSession','New-PSSession','Remove-PSSession','Invoke-Command') `
    -Parameter 'VMId' `
    -ScriptBlock $function:PowerShellDirect_VMIdArgumentCompletion

# PSSESSION CONFIGURATIONAME
# Complete PS Session Configuration names, for example: Enter-PSSession -VMName <VM> -ConfiguratioName <TAB>
Register-ArgumentCompleter `
    -Command ('Enter-PSSession','Get-PSSession','New-PSSession','Remove-PSSession','Invoke-Command') `
    -Parameter 'ConfigurationName' `
    -ScriptBlock $function:PowerShellDirect_ConfigurationArgumentCompletion

# COPY-ITEM using PSSESSION TOSESSION
# Complete PSSession names, for example: Copy-Item -ToSession <TAB>
Register-ArgumentCompleter `
    -Command ('Copy-Item') `
    -Parameter 'ToSession' `
    -ScriptBlock $function:PowerShellDirect_SessionArgumentCompletion

# COPY-ITEM using PSSESSION FROMSESSION
# Complete PSSession names, for example: Copy-Item -FromSession <TAB>
Register-ArgumentCompleter `
    -Command ('Copy-Item') `
    -Parameter 'FromSession' `
    -ScriptBlock $function:PowerShellDirect_SessionArgumentCompletion
