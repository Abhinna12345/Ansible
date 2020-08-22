<#
The default display of a process is a table that includes the following columns:
-- Handles: The number of handles that the process has opened.
-- NPM(K): The amount of non-paged memory that the process is using, in kilobytes.
-- PM(K): The amount of pageable memory that the process is using, in kilobytes.
-- WS(K): The size of the working set of the process, in kilobytes. The working set consists of the pages of memory that were recently referenced by the process.
-- VM(M): The amount of virtual memory that the process is using, in megabytes. Virtual memory includes storage in the paging files on disk.
-- CPU(s): The amount of processor time that the process has used on all processors, in seconds.
-- ID: The process ID (PID) of the process.
-- ProcessName: The name of the process.
#>

$body1=(Get-Process | Sort-Object CPU -desc | Select-Object -first 5 | Format-Table `
    ProcessName, @{Label = "NPM(K)"; Expression = {[int]($_.NPM / 1024)}},
    @{Label = "PM(K)"; Expression = {[int]($_.PM / 1024)}},
    @{Label = "WS(K)"; Expression = {[int]($_.WS / 1024)}},
    @{Label = "VM(M)"; Expression = {[int]($_.VM / 1MB)}},
    @{Label = "CPU(s)"; Expression = {if ($_.CPU) {$_.CPU.ToString("N")}}}, Id)
  
<# Top Memory Consumption #>

$ProcArray = @()
$Processes = get-process | Group-Object -Property ProcessName
foreach($Process in $Processes)
{
    $prop = @(
            @{n='Threads';e={$Process.Count}}
            @{n='Name';e={$Process.Name}}
            @{n='Memory';e={($Process.Group|Measure WorkingSet -Sum).Sum}}
            )
    $ProcArray += "" | select $prop  
}
$body2=$ProcArray | sort -Descending Memory | select Count1,Name,@{n='Memory usage(Total)';e={"$(($_.Memory).ToString('N0'))Kb"}}  | Select-Object -First 5

$EmailBody="<pre><H1>Top 5 CPU Usage</h1>"+($body1|Out-String)+"<br><H1>Top 5 Memory Usage</h1>"+($body2|Out-String)+"</pre>"
$EmailBody