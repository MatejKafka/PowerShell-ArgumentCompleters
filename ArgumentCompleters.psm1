Set-StrictMode -Version Latest

# do not export internal completion functions
Export-ModuleMember

# Helper function to create new completion results
function New-CompletionResult
{
    param([Parameter(Position=0, ValueFromPipelineByPropertyName, Mandatory, ValueFromPipeline)]
          [ValidateNotNullOrEmpty()]
          [string]
          $CompletionText,

          [Parameter(Position=1, ValueFromPipelineByPropertyName)]
          [string]
          $ToolTip,

          [Parameter(Position=2, ValueFromPipelineByPropertyName)]
          [string]
          $ListItemText,

          [System.Management.Automation.CompletionResultType]
          $CompletionResultType = [System.Management.Automation.CompletionResultType]::ParameterValue,
 
          [Parameter(Mandatory = $false)]
          [switch] $NoQuotes = $false
          )

    process
    {
        $toolTipToUse = if ($ToolTip -eq '') { $CompletionText } else { $ToolTip }
        $listItemToUse = if ($ListItemText -eq '') { $CompletionText } else { $ListItemText }

        # If the caller explicitly requests that quotes
        # not be included, via the -NoQuotes parameter,
        # then skip adding quotes.

        if ($CompletionResultType -eq [System.Management.Automation.CompletionResultType]::ParameterValue -and -not $NoQuotes)
        {
            # Add single quotes for the caller in case they are needed.
            # We use the parser to robustly determine how it will treat
            # the argument.  If we end up with too many tokens, or if
            # the parser found something expandable in the results, we
            # know quotes are needed.

            $tokens = $null
            $null = [System.Management.Automation.Language.Parser]::ParseInput("echo $CompletionText", [ref]$tokens, [ref]$null)
            if ($tokens.Length -ne 3 -or
                ($tokens[1] -is [System.Management.Automation.Language.StringExpandableToken] -and
                 $tokens[1].Kind -eq [System.Management.Automation.Language.TokenKind]::Generic))
            {
                $CompletionText = "'$CompletionText'"
            }
        }
        return New-Object System.Management.Automation.CompletionResult `
            ($CompletionText,$listItemToUse,$CompletionResultType,$toolTipToUse.Trim())
    }

}


Get-ChildItem $PSScriptRoot\Completers -File | % {
	Write-Verbose "Registering argument completers from '$($_.Name)'"
	. $_.FullName
}
