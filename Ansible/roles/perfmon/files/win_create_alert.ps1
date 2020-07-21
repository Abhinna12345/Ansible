#####################################################################
# This script will setup the Event Collector Tasks to generate
# real-tile alerts on a local computer
# 
# Assumptions: All data collector definitions are located under 
#              the default folder C:\Scripts\Data
# Script Name: CreateDataCollectors.ps1
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
        $fileName=$collector+'.xml'
        $fullFileName=Join-Path -Path $DataDir -ChildPath $fileName
        if(Test-Path $fullFileName) {
            #Recreate the existing collector
            $cmd = "logman import `""+$collector+"`" -xml `""+$fullFileName+"`""
            $logmanQuery = Invoke-Expression -Command $cmd -ErrorAction Stop
            if ($lastexitcode) {throw $logmanQuery}
            Write-Output "    [OK]"
        } else {
            $logmanQuery = "File not present"
            throw $logmanQuery
        }
      } 
      catch 
      {
         Write-Output "[$logmanQuery]"
      }
   }

