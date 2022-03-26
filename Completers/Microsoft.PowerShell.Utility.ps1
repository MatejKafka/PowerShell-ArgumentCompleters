
#
# Reading the registry for progids takes > 500ms, so we do it just once
#
function InitClassIdTable
{
    $progIds = [Microsoft.Win32.Registry]::ClassesRoot.GetSubKeyNames()
    $versionedProgIds = new-object System.Collections.Generic.List[string]

    function AddProgId($progId)
    {
        $subKey = [Microsoft.Win32.Registry]::ClassesRoot.OpenSubKey($progId)
        foreach ($clsidSubkey in $subKey.GetSubKeyNames())
        {
            if ($clsidSubkey -eq 'CLSID')
            {
                $description = $subKey.GetValue('')
                $result[$progId] = $description
                break
            }
        }
    }

    $result = [ordered]@{}
    foreach ($progId in $progIds)
    {
        # Skip versioned progIds (ends in digits) for now - we'll make a second pass
        # and add those if there is no version indepent progId.
        if ($progId -match '^(\w+\.\w+)\.[\d]+(\.\d+)?$')
        {
            $versionedProgIds.Add($progId)
            continue
        }

        # Check if it really is a progId - does it have a CLSID underneath
        AddProgId $progId
    }

    foreach ($progId in $versionedProgIds)
    {
        $null = $progId -match '^(\w+\.\w+)\.[\d]+(\.\d+)?$'
        if (!$result[$matches[1]])
        {
            AddProgId $progId
        }
    }

    return $result
}

#
# .SYNOPSIS
#
#     Complete -ComObject arguments
#
function NewComObjectCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $allProgIds = Get-CompletionPrivateData -Key New-Object_ComObject
    if (!$allProgIds)
    {
        $allProgIds = InitClassIdTable
        Set-CompletionPrivateData -Key New-Object_ComObject -Value $allProgIds
    }

    # TODO - is sorting from intialization good enough?  This completion is pretty slow
    # as is if $wordToComplete is empty.
    $allProgIds.GetEnumerator() |
        Where-Object Key -like "$wordToComplete*" |
        ForEach-Object {
            $progId = $_.Key
            $tooltip = $_.Value
            New-CompletionResult $progId $tooltip }
}


#
# .SYNOPSIS
#
#     Complete event name arguments
#
function EventNameCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $inputObject = $fakeBoundParameter["InputObject"]
    if ($null -ne $inputObject)
    {
        $inputObject.GetType().GetEvents("Public,Instance").Name |
            Where-Object { $_ -like "$wordToComplete*" } |
            Sort-Object |
            ForEach-Object {
                New-CompletionResult $_ "Event $_"
            }
    }
}


#
# .SYNOPSIS
#
#    Complete the -Name argument to Out-Printer
#
function OutPrinterNameArgumentCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    Get-WmiObject -Class Win32_Printer |
        Where-Object Name -like "$wordToComplete*" |
        Sort-Object Name |
        ForEach-Object {
            New-CompletionResult $_.Name $_.Location
        }
}


#
# .SYNOPSIS
#
#     Complete arguments that take ps1xml files for the Update-[Type|Format]Data commands.
#
function AddTypePathArgumentCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    Get-CompletionWithExtension $lastWord ('.dll', '.cs', '.vb', '.js')
}


#
# .SYNOPSIS
#
#     Complete arguments that take ps1xml files for the Update-[Type|Format]Data commands.
#
function Ps1xmlPathArgumentCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    Get-CompletionWithExtension $lastWord '.ps1xml'
}


#
# .SYNOPSIS
#
#    Complete the -SerializationMethod argument to Update-TypeData
#
function UpdateTypeDataSerializationMethodCompleter
{
   param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

   $sm = [PSObject].Assembly.GetType('System.Management.Automation.SerializationMethod')
   [System.Enum]::GetNames($sm) | Where-Object {$_ -like "*$wordToComplete*"} | Sort-Object | Foreach-Object {
    New-CompletionResult $_ $_
   }
}


#
# .SYNOPSIS
#
#     Complete the SourceIdentifier argument to Register-EngineEvent
#
function EventNameCompletion
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    [System.Management.Automation.PsEngineEvent].GetFields() | ForEach-Object { $_.GetValue($null) } | Sort-Object | Where-Object {$_ -like "*$wordToComplete*"} | ForEach-Object {
        New-CompletionResult  $_ $_
    }
}


#
# .SYNOPSIS
#
#     Complete the TypeName argument to Update-TypeData
#
function UpdateTypeTypeNameCompleter
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    [System.Management.Automation.CompletionCompleters]::CompleteType($wordToComplete)
}


#
# .SYNOPSIS
#
#     Complete the Id argument for Disable-PSBreakPoint
#
function DisablePSBreakpointIdCompleter
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    Microsoft.PowerShell.Utility\Get-PSBreakpoint | 
        Where-Object { $_.Enabled -and $_.Id -like "*$wordToComplete*" } |
        ForEach-Object {
            $toolTip = "Script: {0} Type: {1}" -f $_.Script, $_.GetType().Name
            New-CompletionResult $_.Id $toolTip
        }
}


#
# .SYNOPSIS
#
#     Complete the Id argument for Disable-PSBreakPoint
#
function RemovePSBreakpointIdCompleter
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    Microsoft.PowerShell.Utility\Get-PSBreakpoint | 
        Where-Object { $_.Id -like "*$wordToComplete*" } |
        ForEach-Object {
            $toolTip = "Script: {0} Type: {1}" -f $_.Script, $_.GetType().Name
            New-CompletionResult $_.Id $toolTip
        }
}


# Complete com object class ids for New-Object -ComObject <TAB>
Register-ArgumentCompleter `
    -Command 'New-Object' `
    -Parameter 'ComObject' `
    -ScriptBlock $function:NewComObjectCompletion


# Complete the -EventName argument for Register-ObjectEvent, for example:
#     $timer = new-object System.Timers.Timer
#     Register-ObjectEvent -InputObject $timer -EventName <TAB>
Register-ArgumentCompleter `
    -Command 'Register-ObjectEvent' `
    -Parameter 'EventName' `
    -ScriptBlock $function:EventNameCompletion


# Complete printer names for Out-Printer
Register-ArgumentCompleter `
    -Command 'Out-Printer' `
    -Parameter 'Name' `
    -ScriptBlock $function:OutPrinterNameArgumentCompletion


# Complete source code and dlls for Add-Type -Path
Register-ArgumentCompleter `
    -Command 'Add-Type' `
    -Parameter 'Path' `
    -ScriptBlock $function:AddTypePathArgumentCompletion


# Complete source code and dlls for Add-Type -LiteralPath
Register-ArgumentCompleter `
    -Command 'Add-Type' `
    -Parameter 'LiteralPath' `
    -ScriptBlock $function:AddTypePathArgumentCompletion


# Complete ps1xml files for -AppendPath
Register-ArgumentCompleter `
    -Command ('Update-TypeData', 'Update-FormatData') `
    -Parameter 'AppendPath' `
    -ScriptBlock $function:Ps1xmlPathArgumentCompletion


# Complete ps1xml files for -PrependPath
Register-ArgumentCompleter `
    -Command ('Update-TypeData', 'Update-FormatData') `
    -Parameter 'PrependPath' `
    -ScriptBlock $function:Ps1xmlPathArgumentCompletion


# Complete the -SerializationMethod argument to Update-TypeData. For example: Update-TypeData -SerializationMethod <TAB>
Register-ArgumentCompleter `
    -Command 'Update-TypeData' `
    -Parameter 'SerializationMethod' `
    -ScriptBlock $function:UpdateTypeDataSerializationMethodCompleter


# Complete the -SourceIdentifier argument for Register-ObjectEvent, for example: Register-EngineEvent -SourceIdentifier <TAB>
Register-ArgumentCompleter `
    -Command 'Register-EngineEvent' `
    -Parameter 'SourceIdentifier' `
    -ScriptBlock $function:EventNameCompletion


# Complete names of types:  Update-TypeData -TypeName <TAB>
Register-ArgumentCompleter `
    -Command ('Get-TypeData','Remove-TypeData','Update-TypeData') `
    -Parameter 'TypeName' `
    -ScriptBlock $function:UpdateTypeTypeNameCompleter


# Complete Id parameter:  Disable-PSBreakpoint -Id <TAB>
Register-ArgumentCompleter `
    -Command ('Disable-PSBreakpoint') `
    -Parameter 'Id' `
    -ScriptBlock $function:DisablePSBreakpointIdCompleter


# Complete Id parameter:  Remove-PSBreakpoint -Id <TAB>
Register-ArgumentCompleter `
    -Command ('Remove-PSBreakpoint') `
    -Parameter 'Id' `
    -ScriptBlock $function:RemovePSBreakpointIdCompleter
