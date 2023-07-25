$PowercfgOptions = @(
    @{Argument='/LIST'; Description='Lists all power schemes.'}
    @{Argument='/L'; Description='Lists all power schemes.'}
    @{Argument='/QUERY'; Description='Displays the contents of a power scheme.'}
    @{Argument='/Q'; Description='Displays the contents of a power scheme.'}
    @{Argument='/CHANGE'; Description='Modifies a setting value in the current power scheme.'}
    @{Argument='/X'; Description='Modifies a setting value in the current power scheme.'}
    @{Argument='/CHANGENAME'; Description='Modifies the name and description of a power scheme.'}
    @{Argument='/DUPLICATESCHEME'; Description='Duplicates a power scheme.'}
    @{Argument='/DELETE'; Description='Deletes a power scheme.'}
    @{Argument='/D'; Description='Deletes a power scheme.'}
    @{Argument='/DELETESETTING'; Description='Deletes a power setting.'}
    @{Argument='/SETACTIVE'; Description='Makes a power scheme active on the system.'}
    @{Argument='/S'; Description='Makes a power scheme active on the system.'}
    @{Argument='/GETACTIVESCHEME'; Description='Retrieves the currently active power scheme.'}
    @{Argument='/SETACVALUEINDEX'; Description='Sets the value associated with a power setting while the system is powered by AC power.'}
    @{Argument='/SETDCVALUEINDEX'; Description='Sets the value associated with a power setting while the system is powered by DC power.'}
    @{Argument='/IMPORT'; Description='Imports all power settings from a file.'}
    @{Argument='/EXPORT'; Description='Exports a power scheme to a file.'}
    @{Argument='/ALIASES'; Description='Displays all aliases and their corresponding GUIDs.'}
    @{Argument='/GETSECURITYDESCRIPTOR'; Description='Gets a security descriptor associated with a specified power setting, power scheme, or action.'}
    @{Argument='/SETSECURITYDESCRIPTOR'; Description='Sets a security descriptor associated with a power setting, power scheme, or action.'}
    @{Argument='/HIBERNATE'; Description='Enables and disables the hibernate feature.'}
    @{Argument='/H'; Description='Enables and disables the hibernate feature.'}
    @{Argument='/AVAILABLESLEEPSTATES'; Description='Reports the sleep states available on the system.'}
    @{Argument='/A'; Description='Reports the sleep states available on the system.'}
    @{Argument='/DEVICEQUERY'; Description='Returns a list of devices that meet specified criteria.'}
    @{Argument='/DEVICEENABLEWAKE'; Description='Enables a device to wake the system from a sleep state.'}
    @{Argument='/DEVICEDISABLEWAKE'; Description='Disables a device from waking the system from a sleep state.'}
    @{Argument='/LASTWAKE'; Description='Reports information about what woke the system from the last sleep transition.'}
    @{Argument='/WAKETIMERS'; Description='Enumerates active wake timers.'}
    @{Argument='/REQUESTS'; Description='Enumerates application and driver Power Requests.'}
    @{Argument='/REQUESTSOVERRIDE'; Description='Sets a Power Request override for a particular Process, Service, or Driver.'}
    @{Argument='/ENERGY'; Description='Analyzes the system for common energy-efficiency and battery life problems.'}
    @{Argument='/BATTERYREPORT'; Description='Generates a report of battery usage.'}
    @{Argument='/SLEEPSTUDY'; Description='Generates a diagnostic system power transition report.'}
    @{Argument='/SRUMUTIL'; Description='Dumps Energy Estimation data from System Resource Usage Monitor (SRUM).'}
    @{Argument='/SYSTEMSLEEPDIAGNOSTICS'; Description='Generates a diagnostic report of system sleep transitions.'}
    @{Argument='/SYSTEMPOWERREPORT'; Description='Generates a diagnostic system power transition report.'}
    @{Argument='/POWERTHROTTLING'; Description='Control power throttling for an application.'}
)

Register-ArgumentCompleter -Command 'powercfg' -Native -ScriptBlock {
    param($WordToComplete, $CommandAst)
    $PowercfgOptions | ? {$_.Argument -like "$WordToComplete*"} | sort Argument | % {
        New-CompletionResult $_.Argument $_.Description
    }
}
