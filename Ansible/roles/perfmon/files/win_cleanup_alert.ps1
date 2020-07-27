#####################################################################
# This script will delete existing alert definition
# 
# Assumptions: All data collector definitions are located under 
#              the default folder C:\Scripts\Data
# Script Name: win_cleanup_alert.ps1
#
# Change History
#   Name: Anil Das Date: 07/10/2020  Initial Creation
#####################################################################
[CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)] [string] $collector,
        [Parameter(Mandatory=$false)] [string] $DataDir = "C:\Scripts\Data"
    )
    process {
     try {
        $query="logman query `""+$collector + "`""
        $logmanQuery = Invoke-Expression $query -ErrorAction Stop
        #Stop existing collectors
        if (($logmanQuery -Match "Running")) {
            $query = "logman stop -n `""+$collector + "`""
            $out = Invoke-Expression $query -ErrorAction Stop
        }
        #Delete the existing collector
        if (($logmanQuery -Match $collector)) {
            #logman stop -n $file.BaseName
            $query = "logman delete -n `""+$collector + "`""
            $out = Invoke-Expression $query -ErrorAction Stop
            if ($lastexitcode) {throw $out}
        }
        Write-Output "    [OK]"
      } 
      catch 
      {
        Write-Output "[$query][$out]"
      }
   }

