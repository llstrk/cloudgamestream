Param([Parameter(Mandatory=$false)] [Switch]$Main)

If (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $Arguments = "& '" + $MyInvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $Arguments
    Break
}

if($Main -eq $true) {
    $WorkDir = ".\Bin"
}else{
    $WorkDir = "..\Bin"
}

Import-Module BitsTransfer

$path = "$WorkDir\vbcable.zip"
if(![System.IO.File]::Exists($path))
{
	Write-Host "Downloading VBCABLE..."
	Start-BitsTransfer "https://download.vb-audio.com/Download_CABLE/VBCABLE_Driver_Pack43.zip" $path
}

Write-Host "Installing VBCABLE..."
Expand-Archive -Path "$WorkDir\vbcable.zip" -DestinationPath "$WorkDir\vbcable"
Start-Process -FilePath "$WorkDir\vbcable\VBCABLE_Setup_x64.exe" -ArgumentList "-i","-h" -NoNewWindow -Wait