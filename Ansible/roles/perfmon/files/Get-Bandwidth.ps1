#Bytes total/sec must not exceed 75%

# Context switch limit (core / second)
<#
ctx_switches_careful=10000
ctx_switches_warning=12000
ctx_switches_critical=14000
((Get-counter –Counter “\Network Interface(*)\Bytes Received/sec” –SampleInterval 1 –MaxSamples 1).countersamples | select-object –Property @{ expression={$_.Path}; label=“Host Performance Query”},@{ expression={ $_.CookedValue}; label=“Network Bytes Received”}) | Where–Object {$_.“Network Bytes Received” -ne 0} 
#>

# Measure the Network interface IO over a period of half minute (0.5)
$startTime = get-date
$endTime = $startTime.addMinutes(0.5)
$timeSpan = new-timespan $startTime $endTime

$count = 0
$total = 0

# For each Interface, get the CurrentBandwidth
#query to check if BytesTotalPersec*8)/$_.CurrentBandwidth)*100 > 75% 

while ($timeSpan -gt 0)
{
   # Get an object for the network interfaces, excluding any that are currently disabled.
   $colInterfaces = Get-WmiObject -class Win32_PerfFormattedData_Tcpip_NetworkInterface |select Name, BytesTotalPersec, CurrentBandwidth,PacketsPersec, OutputQueueLength,@{name='bitsPerSec';expr={[float]($_.BytesTotalPersec*8)}},@{name='totalBandwidth';expr={[float](($_.BytesTotalPersec*8)/$_.CurrentBandwidth)*100}}|where {$_.PacketsPersec -gt 0}
   foreach ($interface in $colInterfaces) {
        #Write-Host "Current Bandwidth: $interface.totalBandwidth"
        $total += $interface.totalBandwidth
        #Write-Host "Bandwidth utilized:`t $total %"
         $count++
   }
   Start-Sleep -Seconds 1

   # recalculate the remaining time
   $timeSpan = new-timespan $(Get-Date) $endTime
}

"Measurements:`t`t $count"

$averageBandwidth = $total / $count
$value = "{0:N10}" -f $averageBandwidth
Write-Host "Count: $count"
Write-Host "Average Bandwidth utilized:`t $averageBandwidth"
Write-Host "Average Bandwidth utilized:$value %"

if ($value -ge 75) {
    Write-Output "Send Email"
} else {
    Write-Output "No Email is sent"
}

#$query = "Select * from Win32_PerfFormattedData_Tcpip_NetworkInterface"
#Get-WmiObject -Query $query

