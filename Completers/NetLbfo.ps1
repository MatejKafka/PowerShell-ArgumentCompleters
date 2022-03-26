# ARGUMENT COMPLETER FUNCTIONS #################################################

# NETLBFO TEAM MEMBERS
function NetLBFO_TeamMembersArgumentCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $optionalCim = @{}
    $cim = $fakeBoundParameter["CimSession"]
    if($cim)
    {
        $optionalCim.CimSession = $cim
    }

    NetAdapter\Get-NetAdapter -Name "$wordToComplete*" @optionalCim | 
        Sort-Object -Property Name |
        ForEach-Object {
            $ToolTip = "Name: {0} - Status: {1} `nInterface: {2} - Speed: {3}" -f $_.Name,$_.Status,$_.InterfaceDescription,$_.LinkSpeed
            New-CompletionResult -CompletionText $_.Name -ToolTip $ToolTip
        }
}

# NETLBFO TEAM NAME
function NetLBFO_TeamNameArgumentCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $optionalCim = @{}
    $cim = $fakeBoundParameter["CimSession"]
    if($cim)
    {
        $optionalCim.CimSession = $cim
    }

    NetLbfo\Get-NetLbfoTeam -Name "$wordToComplete*" @optionalCim | 
        Sort-Object -Property Name |
        ForEach-Object {
            $ToolTip = "Name: {0} - Status: {1} `nMode: {2} - Algorithm: {3}" -f $_.Name,$_.Status,$_.TeamingMode,$_.LoadBalancingAlgorithm
            New-CompletionResult -CompletionText $_.Name -ToolTip $ToolTip
        }
}

# ARGUMENT COMPLETER REGISTRATION ##############################################

# NETLBFO TEAM MEMBERS
# Complete NetLBFO Team names, for example: New-NetLbfoTeam -Name <name> -TeamMembers <TAB>
Register-ArgumentCompleter `
    -Command ('New-NetLbfoTeam') `
    -Parameter 'TeamMembers' `
    -ScriptBlock $function:NetLBFO_TeamMembersArgumentCompletion

# NETLBFO TEAM NAME
# Complete NetLBFO Team names, for example: Get-NetLbfoTeam -Name <TAB>
Register-ArgumentCompleter `
    -Command ('Add-NetLbfoTeamMember','Add-NetLbfoTeamNic','Get-NetLbfoTeam','Get-NetLbfoTeamMember','Get-NetLbfoTeamNic','Remove-NetLbfoTeam','Remove-NetLbfoTeamMember','Rename-NetLbfoTeam','Set-NetLbfoTeam','Set-NetLbfoTeamMember','Set-NetLbfoTeamNic') `
    -Parameter 'Name' `
    -ScriptBlock $function:NetLBFO_TeamNameArgumentCompletion

# NETLBFO TEAM NAME
# Complete NetLBFO Team names, for example: Get-NetLbfoTeamNic -Team <TAB>
Register-ArgumentCompleter `
    -Command ('Add-NetLbfoTeamMember','Add-NetLbfoTeamNic','Get-NetLbfoTeamMember','Get-NetLbfoTeamNic','Remove-NetLbfoTeamMember','Remove-NetLbfoTeamNic','Set-NetLbfoTeamMember','Set-NetLbfoTeamNic') `
    -Parameter 'Team' `
    -ScriptBlock $function:NetLBFO_TeamNameArgumentCompletion
    
