Function Send-Email { 
[CmdletBinding()] 
[outputType([Object])] 
    param(
        [Parameter(Mandatory=$false)] [string] $SMTPserver = "smtp.nist.gov",
        [Parameter(Mandatory=$false)] [string] $MsgFrom = "anil.das@nist.gov",
        [Parameter(Mandatory=$false)] [string] $MsgTo = "anil.das@nist.gov",
        [Parameter(Mandatory=$true)] [string] $msgBody,
        [Parameter(Mandatory=$true)] [string] $msgSubject
     )
    Process { 
            #Send defrag report using email
            $messageParameters = @{                         
                            Subject = $msgSubject
                            Body = $msgBody 
                            From = $MsgFrom                         
                            To = $MsgTo
                            SmtpServer = $SMTPserver                        
                        }    
            
            Try
            {
                Send-MailMessage @messageParameters -BodyAsHtml -ErrorAction Stop   
            } catch [System.Exception] {
                #Write to Event Log - For Splunk 
                #New-EventLog –LogName Application –Source “CheckFreeSpace.ps1”
                #TBD LogName EventId
                #Write-EventLog -LogName "Application" -Source "CheckFreeSpace.ps1" -EventID 9001 -EntryType Error -Message "Unable send email." -Category 1
            } 
   }
}

Function Get-DefragStatus { 
[CmdletBinding()] 
[outputType([Object])] 
param(
        [Parameter(Mandatory=$false)] [string] $drive
     )
Process { 
    #$curDate=(Get-Date)
    #$msgBody= ([Array]$curDate)
    $msgBody="<br><br>Start defrag analysis "
    if ($drive -ne "") {   
        $msgBody+="for "+$drive    
        $a=Get-WmiObject -Class win32_volume | Where-Object { $_.drivetype -eq 3 -and $_.driveletter -eq $drive } 
    }
    else {
        $msgBody+="for all local disk drives<br><br>"
        #Get all local disks on the specified computer via WMI class Win32_Volume 
        $a=Get-WmiObject -Class win32_volume | Where-Object { $_.drivetype -eq 3 -and $_.driveletter -ne $null } 
    }     
    #Perform a defrag analysis on each disk returned  
    ($a)|ForEach-Object -begin {} -process { 
             
        #Initialise properties hashtable 
        $properties = @{} 
               
        #perform the defrag analysis 
        $results = $_.DefragAnalysis()

        $msgBody+="</pre><br>"
        $msgSubject="Defrag Analysis Report for "+$env:COMPUTERNAME
        #if the return code is 0 the operation was successful so output the results using the properties hashtable 
        if ($results.ReturnValue -eq 0) {                    
            $properties.Add('ComputerName',$_.__Server) 
            $properties.Add('DriveLetter', $_.DriveLetter ) 
            if ($_.DefragAnalysis().DefragRecommended -eq $true) { $properties.Add( 'DefragRequired',$true ) } else {$properties.Add( 'DefragRequired',$false)} 
            if (($_.FreeSpace / 1GB) -gt (($_.Capacity / 1GB) * 0.15)) { $properties.Add( 'SufficientFreeSpace',$true ) } else {$properties.Add( 'SufficientFreeSpace',$false)} 
            $msgBody+="Analysis complete<br><pre>" 
            Write-Output $properties
            New-Object PSObject -Property $properties
        } 
        #If the return code is 1 then access to perform the defag analysis was denied 
        ElseIf ($results.ReturnValue -eq 1) { 
            $msgBody+=("<br>Defrag analysis for disk " + $_.DriveLetter + " on computer " + $_.__Server + " failed: Access Denied")
            Send-Email -msgBody $msgBody -msgSubject $msgSubject
        } 
        #If the return code is 2 defragmentation is not supported for the device specified 
        ElseIf ($results.ReturnValue -eq 2) { 
            $msgBody+=("<br>Defrag analysis for disk " + $_.DriveLetter + " on computer " + $_.__Server + " failed: Defrag is not supported for this volume") 
            Send-Email -msgBody $msgBody -msgSubject $msgSubject
        }             
        #If the return code is 3 defrag analysis cannot be performed as the dirty bit is set for the device 
        ElseIf ($results.ReturnValue -eq 3) { 
            $msgBody+=("<br>Defrag analysis for disk " + $_.DriveLetter + " on computer " + $_.__Server + " failed: The dirty bit is set for this volume") 
            Send-Email -msgBody $msgBody -msgSubject $msgSubject
        }                         
        #If the return code is 4 there is not enough free space to perform defragmentation 
        ElseIf ($results.ReturnValue -eq 4) { 
            $msgBody+=("<br>Defrag analysis for disk " + $_.DriveLetter + " on computer " + $_.__Server + " failed: The is not enough free space to perform this action") 
            Send-Email -msgBody $msgBody -msgSubject $msgSubject
        }    
        #If the return code is 5 defragmentation cannot be performed as a corrupt Master file table was detected 
        ElseIf ($results.ReturnValue -eq 5) { 
            $msgBody+=("<br>Defrag analysis for disk " + $_.DriveLetter + " on computer " + $_.__Server + " failed: Possible Master File Table corruption") 
            Send-Email -msgBody $msgBody -msgSubject $msgSubject
        }      
        #If the return code is 6 or 7 the operation was cancelled 
        ElseIf ($results.ReturnValue -eq 6 -or $results.ReturnValue -eq 7) { 
            $msgBody+=("<br>Defrag analysis for disk " + $_.DriveLetter + " on computer " + $_.__Server + " failed: The operation was cancelled") 
            Send-Email -msgBody $msgBody -msgSubject $msgSubject
        }   
        #If the return code is 8 the defrag engine is already running 
        ElseIf ($results.ReturnValue -eq 8) { 
            $msgBody+=("<br>Defrag analysis for disk " + $_.DriveLetter + " on computer " + $_.__Server + " failed: The defragmentation engine is already running") 
            Send-Email -msgBody $msgBody -msgSubject $msgSubject
        }                                                             
        #If the return code is 9 the script could not connect to the defrag engine on the machine specified 
        ElseIf ($results.ReturnValue -eq 9) { 
            $msgBody+=("<br>Defrag analysis for disk " + $_.DriveLetter + " on computer " + $_.__Server + " failed: Could not connect to the defrag engine") 
            Send-Email -msgBody $msgBody -msgSubject $msgSubject
        }    
        #If the return code is 10 a degrag engine error occured 
        ElseIf ($results.ReturnValue -eq 10) { 
            $msgBody+=("<br>Defrag analysis for disk " + $_.DriveLetter + " on computer " + $_.__Server + " failed: A defrag engine error occured") 
            Send-Email -msgBody $msgBody -msgSubject $msgSubject
        }       
        #If the return code is 11 a degrag engine error occured 
        ElseIf ($results.ReturnValue -eq 11) { 
            $record="Defrag for disk "+($_.DriveLetter).ToString()+" on computer " +($_.__Server).ToString() ," is not required"
            $record = $record -replace [Environment]::NewLine,"";
            Write-Output $record
        }       
        #Else an unknown error occured 
        Else { 
            $record="Defrag for disk "+($_.DriveLetter).ToString()+" on computer " +($_.__Server).ToString() ," is not required"
            $record = $record -replace [Environment]::NewLine,"";
            Write-Output $record
        }                                      
    } #Close ForEach loop for Defrag Analysis 
    } #End Process Block  
}

Get-DefragStatus -drive $drive
