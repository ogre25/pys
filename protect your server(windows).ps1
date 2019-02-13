If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  # Relaunch as an elevated process:
  Start-Process powershell.exe "-noexit","-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
 }

new-item -itemtype file -name execute-result.log
$currentfilepath=split-path -parent $Myinvocation.mycommand.definition
set-location $currentfilepath
Set-ExecutionPolicy -scope process -ExecutionPolicy RemoteSigned

function chrdpdefport
{
  #get rdp port key
  $rdpdefportkey = "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\rdp-tcp"
  #get rdp port number value
  $rdpdefportval = Get-Itemproperty -path $rdpdefportkey -name PortNumber
  #rdp port number value exist
  if ($rdpdefportval -eq $false)
  {
     #if no exist creat it 
     New-ItemProperty -path $rdpdefportkey -PropertyType dword -name PortNumber
   }
   else
   {
      #input new rdp port number  value
      $inputnewportnum = read-host "please input your new rdp portnumber"
      #chang it in registry
      Set-ItemProperty -path $rdpdefportkey -Name $rdpdefportval -Value $inputnewportnum
    }
 }

function remevepri
{
# remove everyone privileges on all
get-psdrive | where-object {$_.Provider -match "FileSystem"} | select-object -property root | foreach-object { icacls $_.root /inheritance:e /remove "everyone"}
}

function rnameadmin
{
#input new administrator name
$anyna = read-host "please input your new administrator name"
#rename administrator to any
Rename-LocalUser -name administrator -newname $anyna
}

function distylauser
#disable type username of last logo on 
{
#get key of last logo on
$lastlogoonkey = HKLM:\Software\Microsoft\WindowsNT\CurrentVersion\Winlogon
#get value of last logo on
$lastlogonval = Get-Itemproperty -path $lastlogonkey -name DontDisplayLastUserName
if ($lastlogonval -eq $false)
  {
     #if no exist creat it 
     New-ItemProperty -path $lastlogoonkey -PropertyType string -name DontDisplayLastUserName 
   }
   else
   {
      #chang it in registry
      Set-ItemProperty -path $lastlogoonkey -Name $lastlogonval -Value "1"
    }
 }
function menu
{
     param(
           [string] $title = "protect your server"
     )
     cls
     Write-Host "================ $Title ================"
    
     Write-Host "1: Press '1' change rdp default port."
     Write-Host "2: Press '2' remove privileges of everyone on something."
     Write-Host "3: Press '3' rename administrator to any."
     Write-Host "4: Press '4' disable type username of last logo on"
     Write-Host "Q: Press 'Q' to quit."
     Write-Host -ForegroundColor 10 "protect server 1.0 code by ogre25 mail: ogre25@126.com"
}
do
{
     Menu
     $input = Read-Host "Please make a selection"
     switch ($input)
     {
            '1'{
                cls
                chrdpdefport
                
            } '2' {
                   cls
                   remevepri
                  
            } '3' {
                    cls
                    rnameadmin
                 
            } '4' {
                    cls
                    distylauser
                    
            } 'q' {
                    return
            }
      }
      pause
}
until ($input -eq 'q')

