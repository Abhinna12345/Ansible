$properties=@(
    @{Name="Name"; Expression = {$_.name}},
    @{Name="PID"; Expression = {$_.IDProcess}},
    @{Name="CPU (%)"; Expression = {$_.PercentProcessorTime}},
    @{Name="Memory (MB)"; Expression = {[Math]::Round(($_.workingSetPrivate / 1mb),2)}}
    @{Name="Disk (KB)"; Expression = {[Math]::Round(($_.IODataOperationsPersec / 1kb),2)}}
    @{Name="Read (KB/sec)"; Expression = {[Math]::Round(($_.IOReadBytesPerSec / 1kb),2)}}
    @{Name="Write (KB/sec)"; Expression = {[Math]::Round(($_.IOWriteBytesPerSec / 1kb),2)}}
    
)
$ProcessCPU = Get-WmiObject -class Win32_PerfFormattedData_PerfProc_Process |
    Select-Object $properties |
    Sort-Object "CPU (%)" -desc |
    Select-Object -First 7
$ProcessCPU | select *,@{Name="Path";Expression = {(Get-Process -Id $_.PID).Path}} | where {$_.Name -ne "idle"} | where {$_.Name -ne "_total"} |Format-Table 

#Get-Content -Path .\process.txt