# ARGUMENT COMPLETER FUNCTIONS #################################################
# Version 0.97

#CLUSTER
function FailoverClusters_ClusterArgumentCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $OptionalDomain = @{}
    $Domain = $fakeBoundParameter["Domain"]
    if($Domain)
    {
        $OptionalDomain.Domain = $Domain
    } else
    {
        $OptionalDomain.Domain = $env:USERDOMAIN
    }

    FailoverClusters\Get-Cluster -Name "$wordToComplete*" @OptionalDomain |
        ForEach-Object {
            $Tooltip = "Cluster Name: {0}" -f $_.Name
            New-CompletionResult -CompletionText $_.Name -ToolTip $Tooltip
        }
}
function FailoverClusters_ClusterNameArgumentCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    FailoverClusters\Get-Cluster -Name "$wordToComplete*" |
        ForEach-Object {
            $Tooltip = "Cluster Name: {0}" -f $_.Name
            New-CompletionResult -CompletionText $_.Name -ToolTip $Tooltip
        }
}
#CLUSTER NAME
function FailoverClusters_ClusterNodeArgumentCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $OptionalCluster = @{}
    $Cluster = $fakeBoundParameter["Cluster"]
    if($Cluster)
    {
        $OptionalCluster.Cluster = $Cluster
    }

    FailoverClusters\Get-ClusterNode -Name "$wordToComplete*" @OptionalCluster |
        ForEach-Object {
            $Tooltip = "Name: {0}" -f $_.Name
            New-CompletionResult -CompletionText $_.Name -ToolTip $Tooltip
        }    
}
#CLUSTER GROUP
function FailoverClusters_ClusterGroupNameArgumentCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $OptionalCluster = @{}
    $Cluster = $fakeBoundParameter["Cluster"]
    if($Cluster)
    {
        $OptionalCluster.Cluster = $Cluster
    }
    # These completions are slow 
    FailoverClusters\Get-ClusterGroup -Name "$wordToComplete*" @OptionalCluster |
        ForEach-Object {
            $Tooltip = "Name: {0} - State: {1} - Owner Node: {2}" -f $_.Name,$_.State,$_.OwnerNode
            New-CompletionResult -CompletionText $_.Name -ToolTip $Tooltip
        }
}
function FailoverClusters_ClusterGroupVMIdArgumentCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $OptionalCluster = @{}
    $Cluster = $fakeBoundParameter["Cluster"]
    if($Cluster)
    {
        $OptionalCluster.Cluster = $Cluster
    }
    # These completions are slow 
    FailoverClusters\Get-ClusterGroup -Name "*$wordToComplete*" @OptionalCluster |
        Where-Object {$_.GroupType -eq "VirtualMachine"} |
        Hyper-V\Get-VM | 
        ForEach-Object {
            $Tooltip = "Name: {0} - VM Id: {1} `nState: {2} - Owner Node: {3}" -f $_.Name,$_.VMId,$_.State,$_.ComputerName
            New-CompletionResult -CompletionText $_.VMId -ToolTip $Tooltip -ListItemText $_.Name
        }
}
#CLUSTER VIRTUALMACHINE
function FailoverClusters_ClusterVirtualMachineRoleNameArgumentCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $OptionalCluster = @{}
    $Cluster = $fakeBoundParameter["Cluster"]
    if($Cluster)
    {
        $OptionalCluster.Cluster = $Cluster
    }
    # These completions are slow 
    FailoverClusters\Get-ClusterGroup -Name "$wordToComplete*" @OptionalCluster | 
        Where-Object { $_.GroupType -eq 'VirtualMachine'} |
        ForEach-Object {
            $Tooltip = "Name: {0} - State: {1} - Owner Node: {2}" -f $_.Name,$_.State,$_.OwnerNode
            New-CompletionResult -CompletionText $_.Name -ToolTip $Tooltip
        }
}
function FailoverClusters_ClusterVirtualMachineRoleVMIdArgumentCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $OptionalCluster = @{}
    $Cluster = $fakeBoundParameter["Cluster"]
    if($Cluster)
    {
        $OptionalCluster.Cluster = $Cluster
    }
    # These completions are slow 
    FailoverClusters\Get-ClusterGroup -Name "*$wordToComplete*" @OptionalCluster | 
        Where-Object { $_.GroupType -eq 'VirtualMachine'} |
        Hyper-V\Get-VM |
        ForEach-Object {
            $Tooltip = "Name: {0} - VM Id: {1} `nState: {2} - Owner Node: {3}" -f $_.Name,$_.VMId,$_.State,$_.ComputerName
            New-CompletionResult -CompletionText $_.VMId -ToolTip $Tooltip -ListItemText $_.Name
        }
}
#CLUSTER RESOURCE
function FailoverClusters_ClusterResourceNameArgumentCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $OptionalCluster = @{}
    $Cluster = $fakeBoundParameter["Cluster"]
    if($Cluster)
    {
        $OptionalCluster.Cluster = $Cluster
    }
    # These completions are slow 
    FailoverClusters\Get-ClusterResource -Name "$wordToComplete*" @OptionalCluster |
        Sort-Object |
        ForEach-Object {
            $Tooltip = "State: {0} - Resource Type: {1}" -f $_.State,$_.ResourceType
            New-CompletionResult -CompletionText $_.Name -ToolTip $Tooltip
        }
}
function FailoverClusters_ClusterResourceVMIdArgumentCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $OptionalCluster = @{}
    $Cluster = $fakeBoundParameter["Cluster"]
    if($Cluster)
    {
        $OptionalCluster.Cluster = $Cluster
    }
    # These completions are slow 
    FailoverClusters\Get-ClusterResource -Name "*$wordToComplete*" @OptionalCluster | 
        Where-Object { $_.ResourceType -eq 'Virtual Machine'} |
        Hyper-V\Get-VM |
        Sort-Object |
        ForEach-Object {
            $Tooltip = "Name: {0} - VM Id: {1} `nState: {2} - Owner Node: {3}" -f $_.Name,$_.VMId,$_.State,$_.ComputerName
            New-CompletionResult -CompletionText $_.VMId -ToolTip $Tooltip -ListItemText $_.Name
        }
}
function FailoverClusters_ClusterResourceDiskArgumentCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $OptionalCluster = @{}
    $Cluster = $fakeBoundParameter["Cluster"]
    if($Cluster)
    {
        $OptionalCluster.Cluster = $Cluster
    }
    # These completions are slow 
    FailoverClusters\Get-ClusterResource -Name "$wordToComplete*" @OptionalCluster |
        Where-Object {$_.ResourceType -eq "Physical Disk" }
        Sort-Object |
        ForEach-Object {
            $Tooltip = "State: {0} - Resource Type: {1} - Owner Node: {2}" -f $_.State,$_.ResourceType,$_.OwnerNode
            New-CompletionResult -CompletionText $_.Name -ToolTip $Tooltip
        }
}
function FailoverClusters_ClusterResourceTypeNameArgumentCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $OptionalCluster = @{}
    $Cluster = $fakeBoundParameter["Cluster"]
    if($Cluster)
    {
        $OptionalCluster.Cluster = $Cluster
    }

    FailoverClusters\Get-ClusterResourceType -Name "$wordToComplete*" @OptionalCluster |
        Sort-Object |
        ForEach-Object {
            $Tooltip = "Name: {0} - Resource DLL: {1}" -f $_.DisplayName,$_.DllName
            New-CompletionResult -CompletionText $_.Name -ToolTip $Tooltip
        }
}
#CLUSTER SHAREDVOLUME
function FailoverClusters_ClusterSharedVolumeNameArgumentCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $OptionalCluster = @{}
    $Cluster = $fakeBoundParameter["Cluster"]
    if($Cluster)
    {
        $OptionalCluster.Cluster = $Cluster
    }
    # These completions are slow 
    FailoverClusters\Get-ClusterSharedVolume -Name "$wordToComplete*" @OptionalCluster |
        Sort-Object |
        ForEach-Object {
            $Tooltip = "State: {0} - OwnerNode: {1}" -f $_.State,$_.OwnerNode
            New-CompletionResult -CompletionText $_.Name -ToolTip $Tooltip
        }
}
#STORAGE
function FailoverClusters_StorageArgumentCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $OptionalCluster = @{}
    $Cluster = $fakeBoundParameter["Cluster"]
    if($Cluster)
    {
        $OptionalCluster.Cluster = $Cluster
    }

    FailoverClusters\Get-ClusterAvailableDisk @OptionalCluster |
        Where-Object {$_.Name -like "$wordToComplete*"}
        Sort-Object |
        ForEach-Object {
            $Tooltip = "State: {0} - OwnerNode: {1}" -f $_.State,$_.OwnerNode
            New-CompletionResult -CompletionText $_.Name -ToolTip $Tooltip
        }
}
#CLUSTER NETWORK
function FailoverClusters_ClusterNetworkNameArgumentCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $OptionalCluster = @{}
    $Cluster = $fakeBoundParameter["Cluster"]
    if($Cluster)
    {
        $OptionalCluster.Cluster = $Cluster
    }

    FailoverClusters\Get-ClusterNetwork -Name "$wordToComplete*" @OptionalCluster |
        Sort-Object |
        ForEach-Object {
            $Tooltip = "State: {0} - Subnet/Mask: {1}/{2}" -f $_.State,$_.Address,$_.AddressMask
            New-CompletionResult -CompletionText $_.Name -ToolTip $Tooltip
        }
}
#CLUSTER NETWORK INTERFACE
function FailoverClusters_ClusterNetworkInterfaceNameArgumentCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $OptionalCluster = @{}
    $Cluster = $fakeBoundParameter["Cluster"]
    if($Cluster)
    {
        $OptionalCluster.Cluster = $Cluster
    }

    FailoverClusters\Get-ClusterNetworkInterface -Name "$wordToComplete*" @OptionalCluster |
        Sort-Object |
        ForEach-Object {
            $Tooltip = "Adapter: {0} `nState: {1} - IP: {2} - Network: {3}" -f $_.Adapter,$_.State,$_.Address,$_.Network
            New-CompletionResult -CompletionText $_.Name -ToolTip $Tooltip
        }
}

# ARGUMENT COMPLETER REGISTRATION ##############################################

#CLUSTER
# Complete cluster names, for example: Get-Cluster -Name <TAB>
Register-ArgumentCompleter `
    -Command ('Get-Cluster') `
    -Parameter 'Name' `
    -ScriptBlock $function:FailoverClusters_ClusterArgumentCompletion

# Complete cluster names, for example: Get-ClusterResource -Cluster <TAB>
Register-ArgumentCompleter `
    -Command ('Add-VMToCluster','Remove-VMFromCluster','Add-ClusterCheckpoint','Add-ClusterDisk','Add-ClusterFileServerRole','Add-ClusterGenericApplicationRole','Add-ClusterGenericScriptRole','Add-ClusterGenericServiceRole','Add-ClusterGroup','Add-ClusteriSCSITargetServerRole','Add-ClusterNode','Add-ClusterPrintServerRole','Add-ClusterResource','Add-ClusterResourceDependency','Add-ClusterResourceType','Add-ClusterScaleOutFileServerRole','Add-ClusterServerRole','Add-ClusterSharedVolume','Add-ClusterVirtualMachineRole','Add-ClusterVMMonitoredItem','Block-ClusterAccess','Clear-ClusterNode','Get-ClusterAccess','Get-ClusterAvailableDisk','Get-ClusterCheckpoint','Get-ClusterGroup','Get-ClusterLog','Get-ClusterNetwork','Get-ClusterResource','Get-ClusterNetworkInterface','Get-ClusterNode','Get-ClusterOwnerNode','Get-ClusterParameter','Get-ClusterQuorum','Get-ClusterResource','Get-ClusterResourceDependency','Get-ClusterResourceDependencyReport','Get-ClusterResourceType','Get-ClusterSharedVolume','Get-ClusterSharedVolumeState','Get-ClusterVMMonitoredItem','Grant-ClusterAccess','Move-ClusterGroup','Move-ClusterResource','Move-ClusterSharedVolume','Move-ClusterVirtualMachineRole','Remove-Cluster','Remove-ClusterAccess','Remove-ClusterCheckpoint','Remove-ClusterGroup','Remove-ClusterNode','Remove-ClusterResource','Remove-ClusterResourceDependency','Remove-ClusterResourceType','Remove-ClusterSharedVolume','Remove-ClusterVMMonitoredItem','Resume-ClusterNode','Resume-ClusterResource','Set-ClusterLog','Set-ClusterOwnerNode','Set-ClusterParameter','Set-ClusterQuorum','Set-ClusterResourceDependency','Start-Cluster','Start-ClusterGroup','Start-ClusterNode','Start-ClusterResource','Stop-Cluster','Stop-ClusterGroup','Stop-ClusterNode','Stop-ClusterResource','Suspend-ClusterNode','Suspend-ClusterResource','Test-Cluster','Test-ClusterResourceFailure','Update-ClusterIPResource','Update-ClusterNetworkNameResource','Update-ClusterVirtualMachineConfiguration') `
    -Parameter 'Cluster' `
    -ScriptBlock $function:FailoverClusters_ClusterNameArgumentCompletion

#CLUSTER NODE
# Complete cluster node names, for example: Test-Cluster -Cluster <cluster> -Node <TAB>
Register-ArgumentCompleter `
    -Command ('Clear-ClusterDiskReservation','Get-ClusterLog','Get-ClusterNetworkInterface','Get-ClusterSharedVolumeState','Move-ClusterGroup','Move-ClusterSharedVolume','Move-ClusterVirtualMachineRole','New-Cluster','Test-Cluster') `
    -Parameter 'Node' `
    -ScriptBlock $function:FailoverClusters_ClusterNodeArgumentCompletion

# Complete cluster node names, for example: Get-ClusterNode -Cluster <cluster> -Name <TAB>
Register-ArgumentCompleter `
    -Command ('Clear-ClusterNode','Get-ClusterNode','Remove-ClusterNode','Resume-ClusterNode','Start-ClusterNode','Stop-ClusterNode','Suspend-ClusterNode') `
    -Parameter 'Name' `
    -ScriptBlock $function:FailoverClusters_ClusterNodeArgumentCompletion

#CLUSTER GROUP
# Complete cluster group names, for example: Get-ClusterGroup -Cluster <cluster> -Name <TAB>
Register-ArgumentCompleter `
    -Command ('Add-ClusterGroup','Get-ClusterGroup','Move-ClusterGroup','Move-ClusterVirtualMachineRole','Remove-ClusterGroup','Start-ClusterGroup','Stop-ClusterGroup') `
    -Parameter 'Name' `
    -ScriptBlock $function:FailoverClusters_ClusterGroupNameArgumentCompletion

# Complete cluster group names, for example: Get-ClusterGroup -Cluster <cluster> -VMId <TAB>
Register-ArgumentCompleter `
    -Command ('Get-ClusterGroup','Remove-ClusterGroup') `
    -Parameter 'VMId' `
    -ScriptBlock $function:FailoverClusters_ClusterGroupVMIdArgumentCompletion

# Complete cluster group names, for example: Get-ClusterOwnerNode -Cluster <cluster> -Group <TAB>
Register-ArgumentCompleter `
    -Command ('Get-ClusterOwnerNode','Set-ClusterOwnerNode') `
    -Parameter 'Group' `
    -ScriptBlock $function:FailoverClusters_ClusterGroupNameArgumentCompletion

#CLUSTER VM
# Complete cluster virtual machine group names, for example: Move-ClusterVirtualMachineRole -Cluster <cluster> -Name <TAB>
Register-ArgumentCompleter `
    -Command ('Move-ClusterVirtualMachineRole') `
    -Parameter 'Name' `
    -ScriptBlock $function:FailoverClusters_ClusterVirtualMachineRoleNameArgumentCompletion

# Complete cluster virtual machine VMId names, for example: Move-ClusterVirtualMachineRole -Cluster <cluster> -VMId <TAB>
Register-ArgumentCompleter `
    -Command ('Move-ClusterVirtualMachineRole') `
    -Parameter 'VMId' `
    -ScriptBlock $function:FailoverClusters_ClusterVirtualMachineRoleVMIdArgumentCompletion

#CLUSTER RESOURCE
# Complete cluster resource names, for example: Get-ClusterResource -Cluster <cluster> -Name <TAB>
Register-ArgumentCompleter `
    -Command ('Get-ClusterResource','Move-ClusterResource','Remove-ClusterResource','Start-ClusterResource','Stop-ClusterResource') `
    -Parameter 'Name' `
    -ScriptBlock $function:FailoverClusters_ClusterResourceNameArgumentCompletion

# Complete cluster resource names, for example: Get-ClusterResource -Cluster <cluster> -VMId <TAB>
Register-ArgumentCompleter `
    -Command ('Get-ClusterResource') `
    -Parameter 'VMId' `
    -ScriptBlock $function:FailoverClusters_ClusterResourceVMIdArgumentCompletion

# Complete cluster resource names, for example: Move-ClusterResource -Cluster <cluster> -Name <name> -Group <TAB>
Register-ArgumentCompleter `
    -Command ('Move-ClusterResource') `
    -Parameter 'Group' `
    -ScriptBlock $function:FailoverClusters_ClusterGroupNameArgumentCompletion

# Complete cluster resource names, for example: Move-ClusterResource -Cluster <cluster> -Name <name> -Group <TAB>
Register-ArgumentCompleter `
    -Command ('Get-ClusterOwnerNode','Set-ClusterOwnerNode') `
    -Parameter 'Resource' `
    -ScriptBlock $function:FailoverClusters_ClusterResourceNameArgumentCompletion

# Complete cluster disk resource names, for example: Get-ClusterResource -Cluster <cluster> -Name <TAB>
Register-ArgumentCompleter `
    -Command ('Resume-ClusterResource','Supsend-ClusterResource') `
    -Parameter 'Name' `
    -ScriptBlock $function:FailoverClusters_ClusterResourceDiskArgumentCompletion

# Complete cluster shared volume names, for example: Resume-ClusterResource -Cluster <cluster> -VolumeName <TAB>
Register-ArgumentCompleter `
    -Command ('Resume-ClusterResource','Supsend-ClusterResource') `
    -Parameter 'Name' `
    -ScriptBlock $function:FailoverClusters_ClusterSharedVolumeNameArgumentCompletion

#CLUSTER RESOURCE TYPE
# Complete cluster resource type names, for example: Get-ClusterResourceType -Cluster <cluster> -Name <TAB>
Register-ArgumentCompleter `
    -Command ('Get-ClusterResourceType','Remove-ClusterResourceType') `
    -Parameter 'Name' `
    -ScriptBlock $function:FailoverClusters_ClusterResourceTypeNameArgumentCompletion
# Complete cluster resource type names, for example: Get-ClusterOwnerNode -Cluster <cluster> -ResourceType <TAB>
Register-ArgumentCompleter `
    -Command ('Get-ClusterOwnerNode','Get-ClusterParameter') `
    -Parameter 'ResourceType' `
    -ScriptBlock $function:FailoverClusters_ClusterResourceTypeNameArgumentCompletion

#CLUSTER SHAREDVOLUME
# Complete cluster shared volume names, for example: Get-ClusterSharedVolume -Cluster <cluster> -Name <TAB>
Register-ArgumentCompleter `
    -Command ('Get-ClusterSharedVolume','Get-ClusterSharedVolumeState','Move-ClusterSharedVolume','Remove-ClusterSharedVolume') `
    -Parameter 'Name' `
    -ScriptBlock $function:FailoverClusters_ClusterSharedVolumeNameArgumentCompletion

#STORAGE
# Complete cluster storage names, for example: Add-ClusterFileServerRole -Cluster <cluster> -Storage <TAB>
Register-ArgumentCompleter `
    -Command ('Add-ClusterFileServerRole','Add-ClusterGenericApplicationRole','Add-ClusterGenericScriptRole','Add-ClusterGenericServiceRole','Add-ClusteriSCSITargetServerRole','Add-ClusterPrintServerRole','Add-ClusterServerRole') `
    -Parameter 'Storage' `
    -ScriptBlock $function:FailoverClusters_StorageArgumentCompletion

#CLUSTER NETWORK
# Complete cluster network names, for example: Get-ClusterNetwork -Cluster <cluster> -Name <TAB>
Register-ArgumentCompleter `
    -Command ('Get-ClusterNetwork') `
    -Parameter 'Name' `
    -ScriptBlock $function:FailoverClusters_ClusterNetworkNameArgumentCompletion
#CLUSTER NETWORK INTERFACE
# Complete cluster network interface network names, for example: Get-ClusterNetworkInterface -Cluster <cluster> -Network <TAB>
Register-ArgumentCompleter `
    -Command ('Get-ClusterNetworkInterface') `
    -Parameter 'Network' `
    -ScriptBlock $function:FailoverClusters_ClusterNetworkNameArgumentCompletion
# Complete cluster network interface network names, for example: Get-ClusterNetworkInterface -Cluster <cluster> -Network <TAB>
Register-ArgumentCompleter `
    -Command ('Get-ClusterNetworkInterface') `
    -Parameter 'Name' `
    -ScriptBlock $function:FailoverClusters_ClusterNetworkInterfaceNameArgumentCompletion
