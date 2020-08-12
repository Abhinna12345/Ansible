$DataDir="c:\Scripts\Data"
$collectors = Get-ChildItem $DataDir\*.xml
foreach ($collector in $collectors) {
    #Start a data collector if it is stopped
    $query="logman query `""+$collector.BaseName+"`""
    $logmanQuery = Invoke-Expression $query
    #Stop existing collectors
    if ($logmanQuery -Match "Running") {
        Write-Output "Stoped " $collector.BaseName
        logman stop -n $collector.BaseName
    }
}