############################################################################## 
## 
## Test-Uri 
## 
## From Windows PowerShell Cookbook (O'Reilly) 
## by Lee Holmes (http://www.leeholmes.com/guide) 
## 
##############################################################################
<# 
  
.SYNOPSIS 
  
Connects to a given URI and returns status about it: URI, response code, 
and time taken. 
  
.EXAMPLE 
  
PS > Test-Uri http://10.220.0.140:443/BrowserWeb/servlet/BrowserServlet/
  
Uri : "http://10.220.0.140:443/BrowserWeb/servlet/BrowserServlet" 
StatusCode : 200 
StatusDescription : OK 
ResponseLength : 34001 
TimeTaken : 459.0009 
  
#>

param( 
    ## The URI to test 
    $Uri = "http://10.220.0.140:443/BrowserWeb/servlet/BrowserServlet",
    ## Output file name
    $outputPath = "C:/TSS/ServiceMonitor/logs/Siteavailability.csv"
)

$request = $null 
#Write-Output "trace-01"
#Write-Output $PSVersionTable.PSVersion
$time = try 
{ 
    #Write-Output "trace-02"
    ## Request the URI, and measure how long the response took. 
    #$request = Invoke-WebRequest -Uri $uri
    #Invoke-WebRequest -UseBasicParsing -Uri  "http://10.220.0.140:443/BrowserWeb/servlet/BrowserServlet"
    $result = Measure-Command { $request = Invoke-WebRequest -UseBasicParsing -Uri $uri } 
    #Write-Output "trace-02-2"
    $result.TotalMilliseconds 
    #Write-Output "trace-03"
} 
catch 
{ 
    Write-Output "Error happened"
    ## If the request generated an exception (i.e.: 500 server 
    ## error or 404 not found), we can pull the status code from the 
    ## Exception.Response property 
    $request = $_.Exception.Response 
    $time = -1 
}

#Write-Output $time
#Write-Output "trace-05"

$result = [PSCustomObject] @{ 
    Time = Get-Date; 
    Uri = $uri; 
    StatusCode = [int] $request.StatusCode; 
    StatusDescription = $request.StatusDescription; 
    ResponseLength = $request.RawContentLength; 
    TimeTaken = $time; 
    
}

#Write-Output "trace-06"

$result

$result | Export-Csv -Path $outputPath -NoTypeInformation -Append


