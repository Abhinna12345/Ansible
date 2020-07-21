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
        [Parameter(Mandatory=$false)] [string] $collector
    )
    process {
     $Time = New-ScheduledTaskTrigger -AtStartup
     try {
            #Set the Scheduler at Startup
            $taskPath="\Microsoft\Windows\PLA\"
            
            $cmd=(Set-ScheduledTask -TaskName "$collector" -TaskPath $taskPath  -Trigger $Time -ErrorAction SilentlyContinue -ErrorVariable lastexitmsg)
            if ($lastexitmsg) {
                $cmd="Update Scheduler"
                throw $lastexitmsg
            }

            #Start the Event Immediate
            $cmd="logman start `""+$collector + "`""
            $lastexitmsg = Invoke-Expression $cmd -ErrorAction Stop
            if ($lastexitcode) {throw $lastexitmsg.ToString()}

            Write-Output "    [OK]"
      } 
      catch 
      {
        Write-Output "    [$cmd][$lastexitmsg]"
      }
   }

