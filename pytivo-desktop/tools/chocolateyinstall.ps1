﻿$packageName    = 'pytivo-desktop'
$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url            = 'http://www.pytivodesktop.com/win32/pyTivo_1.6.16.exe'
$checksum       = '97D84F8CBE73CB78AD01E46B12FF544A602A82F1FF69BB46BB28AAE60747FB5B'
$validExitCodes = @(0)
$bits           = Get-ProcessorBits
$ahkExe         = 'AutoHotKey'
$ahkFile        = Join-Path $toolsDir "PDInstall.ahk"

if((get-process "PyTivoTray" -ea SilentlyContinue) -eq $Null){ 
    Write-Host "PyTivoTray currently NOT running." 
  }else{ 
    Write-Host "Stopping PyTivoTray process(es)..."
    Stop-Process -processname PyTivoTray -force
  }


if((get-process "PyTivo" -ea SilentlyContinue) -eq $Null){ 
    Write-Host "PyTivo currently NOT running." 
  }else{ 
    Write-Host "Stopping PyTivo process(es)..."
    Stop-Process -processname PyTivo -force
  }

if((get-process "PyTivoDesktop" -ea SilentlyContinue) -eq $Null){ 
    Write-Host "PyTivoDesktop currently NOT running." 
  }else{ 
    Write-Host "Stopping PyTivoDesktop process(es)..."
    Stop-Process -processname PyTivoDesktop -force
  }
  


Start-Process $ahkExe $ahkFile

$packageArgs = @{
  packageName    = $packageName
  unzipLocation  = $toolsDir
  fileType       = 'exe' 
  url            = $url
  silentArgs     = '' 
  validExitCodes = $validExitCodes
  softwareName   = 'pyTivo' 
  checksum       = $checksum
  checksumType   = 'sha256'
  }
  
Install-ChocolateyPackage @packageArgs

$exe  = "pyTivoTray.exe"

if ($bits -eq 64)
   {
     $exePath  = join-path "${env:ProgramFiles(x86)}" "\pyTivo"
    } else {
     $exePath  = join-path "${env:ProgramFiles}" "\pyTivo"
    }
	  
Install-ChocolateyShortcut -shortcutFilePath "$env:Public\Desktop\pyTivo.lnk" -targetPath "$exePath\$exe" -WorkingDirectory "$exePath"
Install-ChocolateyShortcut -shortcutFilePath "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\pyTivo.lnk" -targetPath "$exePath\$exe" -WorkingDirectory "$exePath"
