$pcName = $env:computername
$logFileLocation = "\\srvsccm\sources$\Applications\Software Script\Report\Software Data Logs\"

function Tidy-Logs {
  Write-output ("Loading files...") ##### CMD OUTPUT
  $files = @(Get-ChildItem -Path $logFileLocation -filter "ST*.csv" -File | Select-Object -ExpandProperty FullName)

  while ($files.count -ne 0) { ### change -ne to -gt
    $logFile = Get-ChildItem -Path $logFileLocation -filter "ST*.csv" -File | Select-Object -First 1                     ### first ST file log
    $logDate = $logFile.LastWriteTime.ToString("dd MM yyyy")                                                             ### ST file log date
    $outputlogFileLocation = "\\srvsccm\sources$\Applications\Software Script\Report\Software Data Logs\${logDate}.csv" ### joined log file name/location
    $logFile = $logFile.Basename                                                                                        ### ST file log name
    $inputlogFileLocation = "\\srvsccm\sources$\Applications\Software Script\Report\Software Data Logs\${logFile}.csv" ### input logfile

    Check-Log-File-Exists

    Get-ChildItem -Path $inputlogFileLocation -File | Select-Object -ExpandProperty FullName | Import-Csv | Export-Csv $outputlogFileLocation -NoTypeInformation -Append ##### COMBINES CSV
    Remove-Item (Get-ChildItem -Path $inputlogFileLocation  -File)
    $files = @(Get-ChildItem -Path $logFileLocation -filter "ST*.csv" -File | Select-Object -ExpandProperty FullName)
  }
}


function Check-Log-File-Exists {
    if (-not(Test-Path -Path $logFileName)) { ### Doesn't Exist
    Set-Content $logFileName -Value "Name,Version,PSComputerName" } 
    Else { ### Exists
    Write-Output "Log file ${logDate} already exists" }
    }

Tidy-Logs