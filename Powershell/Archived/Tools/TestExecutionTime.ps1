$stopwatch =  [system.diagnostics.stopwatch]::StartNew()
$result = Get-Hotfix
$time = $stopwatch.ElapsedMilliseconds

'{0} results in {1:n1} milliseconds' -f $result.Count, $time