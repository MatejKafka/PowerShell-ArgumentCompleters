# PowerShell Argument Completers

This repository provides the argument completers from [TabExpansionPlusPlus](https://github.com/lzybkr/TabExpansionPlusPlus/), updated to work with the built-in `Register-ArgumentCompleter` cmdlet in PowerShell 5 and PowerShell Core.

## Installation

1. Clone this repository to a directory that's in your `$env:PSModulePath`.
2. Add the following to your PowerShell profile: `Import-Module ArgumentCompleters`

## Supported commands

Check the `./Completions` subdirectory for a list of completers – most of them add completions for a family of commands, not just one.

To speed up load time, you can remove completer files for commands that you don't use.
