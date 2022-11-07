$pcName = $env:computername                      #### gets pc name 
$logDateName = (Get-Date -Format "ddMMyyyy")     #### log date name formatting
$logDate = (Get-Date)                            #### Error log date
$logName = $pcName                               #### builds log name
$logFileLocation = "\\srvsccm\sources$\Applications\Software Script\Report\Software Data Logs\${logName}.csv"      ########## log location
$errorLogFileLocation =  "\\srvsccm\sources$\Applications\Software Script\Report\Software Data Logs\Error log.txt" ########## error log location
$completeLog = $True ##### log completed message flag

function Validate-Log {

    if (-not(Test-Path -Path "$logFileLocation")) {
        write-host "Creating log file, Please wait..."
        Create-SWList
    }
    Else {write-output "Log Already exists... Aborting..."
    }
 }


function Create-SWList { Write-Output "Updating log file... Please wait..."
        try { Get-WmiObject Win32_Product -ComputerName $pcName -ErrorAction "Stop" | Where-Object  {$_.Name.Length -gt 0 }  | Select-Object -skip 1 | Select-Object Name,Version,PSComputerName | Export-Csv $logFileLocation -NoTypeInformation }
        catch {$PCname,$logDate,$Error | Out-File -Append $errorLogFileLocation
        write-output "Error, please check logs"
        $completeLog = $false}
        finally { if ($completeLog -eq $True) { Write-output "Log file created..."}
    }
}

Validate-log 