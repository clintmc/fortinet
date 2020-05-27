<#
.SYNOPSIS
    This script will take a file input and create an output file with updated formatting to make it work as a TCL script in FortiManager.
  
.DESCRIPTION
    This will prepends and appends to all lines, except those that start with #, since this is a comment line
    Prepend value: do_cmd "
    Append value: "
    This change requires a Procedure to be added to the script file to create the do_cmd procedure. Add the procedure AFTER running this script against your source.
.INPUTS
    Source File - provide the original file to be modified
.OUTPUTS
    Destination File - provide the new filename for the update version
.NOTES
  Version:        0.1
  Author:         Clint McGuire
  Creation Date:  2020-05-15
  Purpose/Change: Initial script development
  
.EXAMPLE
  ConvertToTcl.ps1 -source .\FortiGate-CLI.txt -dest .\FortiGate.tcl

#>

# Variables

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [ValidateNotNull()]
    [string]
    $SourceFile,
    [Parameter(Mandatory=$true)]
    [ValidateNotNull()]
    [string]
    $DestFile
)

$Prepend = 'do_cmd "'
$Append = '"'
$Comment = "#"
$DestContent = @() #might be wrong braces for this variable...

$SourceContent = Get-Content $SourceFile
foreach ($line in $SourceContent)
{
    if ($line -ne ""){ #Check for emtpy line - substring doesn't like it if there isn't any text on the line.
        $Character = $line.Substring(0,1) #evaluate the first character of the string
        if ($Character -ne $Comment){
            $DestContent += $Prepend + $line + $Append #wrap the line in the prepend & append, sometimes also wraps empty lines...
        }
    
        else{
            $DestContent += $line #Don't modify comments
        }
    }
    else {
        $DestContent += $line #Don't modify empty lines (this doesn't always work, some empty lines still get modified...)
    }
}

Set-Content -Path $DestFile -Value $DestContent
