﻿#
# .SYNOPSIS
#
#    Auto-complete the -StorageAccountName parameter value for Azure PowerShell cmdlets.
#
# .NOTES
#    
#    Created by Trevor Sullivan <pcgeek86@gmail.com>
#    http://trevorsullivan.net
#
function StorageAccount_StorageAccountNameCompleter
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    #Write-Verbose -Message ('Called Azure StorageAccountName completer at {0}' -f (Get-Date))

    $CacheKey = 'StorageAccount_StorageAccountNameCache'
    $StorageAccountNameCache = Get-CompletionPrivateData -Key $CacheKey

    ### Return the cached value if it has not expired
    if ($StorageAccountNameCache) {
        return $StorageAccountNameCache
    }

    $StorageAccountList = Get-AzureStorageAccount -WarningAction SilentlyContinue | Where-Object {$PSItem.StorageAccountName -match ${wordToComplete} } | ForEach-Object {
        $CompletionResult = @{
            CompletionText = $PSItem.StorageAccountName
            ToolTip = 'Storage Account "{0}" in "{1}" region.' -f $PSItem.StorageAccountName, $PSItem.Location
            ListItemText = '{0} ({1})' -f $PSItem.StorageAccountName, $PSItem.Location
            CompletionResultType = [System.Management.Automation.CompletionResultType]::ParameterValue
            }
        New-CompletionResult @CompletionResult
    }

    Set-CompletionPrivateData -Key $CacheKey -Value $StorageAccountList
    return $StorageAccountList
}

#
# .SYNOPSIS
#
#    Auto-complete the -Name parameter value for Azure PowerShell storage container cmdlets.
#
# .NOTES
#    
#    Created by Trevor Sullivan <pcgeek86@gmail.com>
#    http://trevorsullivan.net
#
function AzureStorage_StorageContainerNameCompleter
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $CacheKey = 'AzureStorage_ContainerNameCache'
    $ContainerNameCache = Get-CompletionPrivateData -Key $CacheKey

    ### Return the cached value if it has not expired
    if ($ContainerNameCache) {
        return $ContainerNameCache
    }

    $ContainerList = Get-AzureStorageContainer -Context $fakeBoundParameter['Context'] | Where-Object -FilterScript { $PSItem.Name -match ${wordToComplete} } | ForEach-Object {
        $CompletionResult = @{
            CompletionText = $PSItem.Name
            ToolTip = 'Storage Container "{0}" in "{1}" Storage Account.' -f $PSItem.Name, $fakeBoundParameter['Context'].StorageAccountName
            ListItemText = '{0} ({1})' -f $PSItem.Name, $fakeBoundParameter['Context'].StorageAccountName
            CompletionResultType = [System.Management.Automation.CompletionResultType]::ParameterValue
            }
        New-CompletionResult @CompletionResult
    }

    Set-CompletionPrivateData -Key $CacheKey -Value $ContainerList
    return $ContainerList
}

#
# .SYNOPSIS
#
#    Auto-complete the -ServiceName parameter value for Azure PowerShell cmdlets.
#
# .NOTES
#    
#    Created by Trevor Sullivan <pcgeek86@gmail.com>
#    http://trevorsullivan.net
#
function CloudService_ServiceNameCompleter
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    #Write-Verbose -Message ('Called Azure ServiceName completer at {0}' -f (Get-Date))
    $CacheKey = 'CloudService_ServiceNameCache'
    $ServiceNameCache = Get-CompletionPrivateData -Key $CacheKey
    if ($ServiceNameCache) {
        return $ServiceNameCache
    }

    $ItemList = Get-AzureService | Where-Object { $PSItem.ServiceName -match ${wordToComplete} } | ForEach-Object {
        $CompletionResult = @{
            CompletionText = $PSItem.ServiceName
            ToolTip = 'Cloud Service in "{0}" region.' -f $PSItem.ExtendedProperties.ResourceLocation
            ListItemText = '{0} ({1})' -f $PSItem.ServiceName, $PSItem.ExtendedProperties.ResourceLocation
            CompletionResultType = [System.Management.Automation.CompletionResultType]::ParameterValue
            }
        New-CompletionResult @CompletionResult
    }
    Set-CompletionPrivateData -Key $CacheKey -Value $ItemList

    return $ItemList
}

#
# .SYNOPSIS
#
#    Auto-complete the -SubscriptionName parameter value for Azure PowerShell cmdlets.
#
# .NOTES
#    
#    Created by Trevor Sullivan <pcgeek86@gmail.com>
#    http://trevorsullivan.net
#
function Subscription_SubscriptionNameCompleter
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    #Write-Verbose -Message ('Called Azure SubscriptionName completer at {0}' -f (Get-Date))

    ### Attempt to read Azure subscription details from the cache
    $CacheKey = 'AzureSubscription_SubscriptionNameCache'
    $SubscriptionNameCache = Get-CompletionPrivateData -Key $CacheKey

    ### If there is a valid cache for the Azure subscription names, then go ahead and return them immediately
    if ($SubscriptionNameCache) {
        return $SubscriptionNameCache
    }

    ### Create fresh completion results for Azure subscriptions
    $ItemList = Get-AzureSubscription | Where-Object { $PSItem.SubscriptionName -match ${wordToComplete} } | ForEach-Object {
        $CompletionResult = @{
            CompletionText = $PSItem.SubscriptionName
            ToolTip = 'Azure subscription "{0}" with ID {1}.' -f $PSItem.SubscriptionName, $PSItem.SubscriptionId
            ListItemText = '{0} ({1})' -f $PSItem.SubscriptionName, $PSItem.SubscriptionId
            CompletionResultType = [System.Management.Automation.CompletionResultType]::ParameterValue
            }
        New-CompletionResult @CompletionResult
    }
    
    ### Update the cache for Azure subscription names
    Set-CompletionPrivateData -Key $CacheKey -Value $ItemList

    ### Return the fresh completion results
    return $ItemList
}

#
# .SYNOPSIS
#
#    Auto-complete the -Name parameter value for Azure PowerShell virtual machine cmdlets.
#
# .NOTES
#    
#    Created by Trevor Sullivan <pcgeek86@gmail.com>
#    http://trevorsullivan.net
#    http://twitter.com/pcgeek86
#
function AzureVirtualMachine_NameCompleter
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    #Write-Verbose -Message ('Called Azure Virtual Machine Name completer at {0}' -f (Get-Date))

    ### Attempt to read Azure virtual machine details from the cache
    $CacheKey = 'AzureVirtualMachine_NameCache'
    $VirtualMachineNameCache = Get-CompletionPrivateData -Key $CacheKey

    ### If there is a valid cache for the Azure virtual machine names, then go ahead and return them immediately
    if ($VirtualMachineNameCache -and (Get-Date) -gt $VirtualMachineNameCache.ExpirationTime) {
        return $VirtualMachineNameCache
    }

    ### Create fresh completion results for Azure virtual machines
    $ItemList = Get-AzureVM | Where-Object { $PSItem.Name -match ${wordToComplete} } | ForEach-Object {
        $CompletionResult = @{
            CompletionText = '{0} -ServiceName {1}' -f $PSItem.Name, $PSItem.ServiceName
            ToolTip = 'Azure VM {0}/{1} in state {2}.' -f $PSItem.ServiceName, $PSItem.Name, $PSItem.Status
            ListItemText = '{0}/{1}' -f $PSItem.ServiceName, $PSItem.Name
            CompletionResultType = [System.Management.Automation.CompletionResultType]::ParameterValue
            }
        New-CompletionResult @CompletionResult
    }
    
    ### Update the cache for Azure virtual machines
    Set-CompletionPrivateData -Key $CacheKey -Value $ItemList

    ### Return the fresh completion results
    return $ItemList
}


# Complete the -StorageAccountName parameter value for Azure cmdlets:  Get-AzureStorageAccount -StorageAccountName <TAB>
Register-ArgumentCompleter `
    -Command ( 'Enable-WAPackWebsiteApplicationDiagnositc', 'Add-AzureHDInsightStorage', 'Enable-AzureWebsiteApplicationDiagnostic', 'Get-AzureStorageAccount', 'Get-AzureStorageKey', 'New-AzureMediaServicesAccount', 'New-AzureStorageAccount', 'New-AzureStorageContext', 'New-AzureStorageKey', 'Publish-AzureServiceProject', 'Remove-AzureStorageAccount', 'Set-AzureHDInsightDefaultStorage', 'Set-AzureStorageAccount', 'Set-AzureVMCustomScriptExtension' ) `
    -Parameter 'StorageAccountName' `
    -ScriptBlock $function:StorageAccount_StorageAccountNameCompleter


# Complete the -Name parameter value for Azure cmdlets:  Get-AzureStorageContainer -Context $Context -Name <TAB>
Register-ArgumentCompleter `
    -Command ( 'Get-AzureStorageContainerAcl', 'Get-AzureSiteRecoveryProtectionContainer', 'Get-AzureStorageContainer', 'New-AzureStorageContainer', 'New-AzureStorageContainerSASToken', 'Remove-AzureStorageContainer', 'Set-AzureStorageContainerAcl' ) `
    -Parameter 'Name' `
    -ScriptBlock $function:AzureStorage_StorageContainerNameCompleter


# Complete the -ServiceName parameter value for Azure cmdlets:  Get-AzureService -ServiceName <TAB>
Register-ArgumentCompleter `
    -Command ( 'Add-AzureCertificate', 'Add-AzureDns', 'Add-AzureInternalLoadBalancer', 'Export-AzureVM', 'Get-AzureCertificate', 'Get-AzureDeployment', 'Get-AzureDeploymentEvent', 'Get-AzureInternalLoadBalancer', 'Get-AzureRemoteDesktopFile', 'Get-AzureRole', 'Get-AzureService', 'Get-AzureServiceADDomainExtension', 'Get-AzureServiceAntimalwareConfig', 'Get-AzureServiceDiagnosticsExtension', 'Get-AzureServiceExtension', 'Get-AzureServiceRemoteDesktopExtension', 'Get-AzureVM', 'Get-AzureWinRMUri', 'Move-AzureDeployment', 'New-AzureDeployment', 'New-AzureQuickVM', 'New-AzureService', 'New-AzureServiceProject', 'New-AzureVM', 'Publish-AzureServiceProject', 'Remove-AzureCertificate', 'Remove-AzureDeployment', 'Remove-AzureDns', 'Remove-AzureInternalLoadBalancer', 'Remove-AzureService', 'Remove-AzureServiceADDomainExtension', 'Remove-AzureServiceAntimalwareExtension', 'Remove-AzureServiceDiagnosticsExtension', 'Remove-AzureServiceExtension', 'Remove-AzureServiceRemoteDesktopExtension', 'Remove-AzureVM', 'Reset-AzureRoleInstance', 'Restart-AzureVM', 'Save-AzureVMImage', 'Set-AzureDeployment', 'Set-AzureDns', 'Set-AzureInternalLoadBalancer', 'Set-AzureLoadBalancedEndpoint', 'Set-AzureRole', 'Set-AzureService', 'Set-AzureServiceADDomainExtension', 'Set-AzureServiceAntimalwareExtension', 'Set-AzureServiceDiagnosticsExtension', 'Set-AzureServiceExtension', 'Set-AzureServiceRemoteDesktopExtension', 'Set-AzureWalkUpgradeDomain', 'Start-AzureService', 'Start-AzureVM', 'Stop-AzureService', 'Stop-AzureVM', 'Update-AzureVM' ) `
    -Parameter 'ServiceName' `
    -ScriptBlock $function:CloudService_ServiceNameCompleter


# Complete the -SubscriptionName parameter value for Azure cmdlets:  Select-AzureSubscription -SubscriptionName <TAB>
Register-ArgumentCompleter `
    -Command ( 'Get-WAPackSubscription', 'Remove-WAPackSubscription', 'Select-WAPackSubscription', 'Set-WAPackSubscription', 'Get-AzureSubscription', 'New-AzureSqlDatabaseServerContext', 'Remove-AzureSubscription', 'Select-AzureSubscription', 'Set-AzureSubscription' ) `
    -Parameter 'SubscriptionName' `
    -ScriptBlock $function:Subscription_SubscriptionNameCompleter


# Complete the -Name parameter value for Azure virtual machine cmdlets:  Stop-AzureVM -Name <TAB>
Register-ArgumentCompleter `
    -Command ( 'Export-AzureVM', 'Get-AzureVM', 'Remove-AzureVM', 'Restart-AzureVM', 'Start-AzureVM', 'Stop-AzureVM', 'Update-AzureVM' ) `
    -Parameter 'Name' `
    -ScriptBlock $function:AzureVirtualMachine_NameCompleter
