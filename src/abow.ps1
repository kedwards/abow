#
# Name  :   Ansible Babun On Windows (ABOW)
# Author:   kedwards <kedwards@livity.consulting>
#           edwardk3 <kevin.edwards@enbridge.com>
# Desc  :   Downloads, installs, and configures a linux enviornment for Ansible
# 
Clear-Host

Set-Variable -Name 'wasp' -Value "$PSScriptRoot\WASP.dll"
Set-Variable -Name 'linux_home' -Value "$HOME\linux"
Set-Variable -Name 'babun_version' -Value '1.2.0'
Set-Variable -Name 'cmdr_version' -Value 'v1.3.2'

If ( Test-Path $wasp) {
    Import-Module $wasp
} Else
{
    Write-Host "Error: WASP.dll not found or cannot be loaded..Exiting"
    Exit
}

$o_babun = New-Object –TypeName PSObject –Prop (@{
    'Name' = 'Babun';
    'Ver' = $babun_version;
    'Src' = 'http://projects.reficio.org/babun/download';
    'Dest' = "$linux_home\babun.zip";
    'Path' = "$linux_home\babun"
})

$o_cmdr = New-Object –TypeName PSObject –Prop (@{
    'Name' = 'Cmdr';
    'Ver' = $cmdr_version;
    'Src' = "https://github.com/cmderdev/cmder/releases/download/$cmdr_version/cmder_mini.zip";
    'Dest' = "$linux_home\cmdr.zip";
    'Path' = $linux_home
})

$deps = @(
    $o_babun
    $o_cmdr
)

function Do-Unzip
{
    param([Parameter(Mandatory=$true)][object]$dep)
        
    Write-Host -NoNewline Unzipping $dep.Dest..
    
    $shell = new-object -com shell.application
    $zip = $shell.namespace($dep.Dest)
    $shell.namespace($linux_home).Copyhere($zip.items(), 0x14) #0x4 = hides dialog box, 0x10 = overwrite,  0x14 = hide and overwrite
    
    Write-Host ".ok"
}

function Do-Get
{
    param([Parameter(Mandatory=$true)][object]$dep)
    
    Write-Host -NoNewline Retrieving $dep.Name..
    
    If (!( Test-Path $dep.Dest)) {
        $webc = New-Object System.Net.WebClient
        $webc.DownloadFile($dep.Src, $dep.Dest)
    }
        
    Write-Host ".ok"
}

function Do-Main
{
    param(
        [Parameter(Mandatory=$false)][string]$root = $linux_home,
        [Parameter(Mandatory=$false)][array]$comps = $deps
    )
    
    if (!(Test-Path $root)) { New-Item -ItemType Directory -Force -Path $root > $null }
    
    foreach ($dep in $comps) 
    {  
        Do-Get $dep
        Do-Unzip $dep
    }            
       
    Start-Process $linux_home\babun-$babun_version\install.bat -ArgumentList '/t', "$linux_home"

    while (!(Select-Window mintty | Select-Object -first 1).ProcessId)
    {
        Start-Sleep -s 10
    }
    
    Select-Window mintty | Set-WindowPosition -Minimize
    Select-Window mintty | Send-Keys 'zsh <+9curl -sL http://bit.ly/2oz3TN5+0'
    Start-Sleep -m 500
    Select-Window mintty | Send-Keys "{ENTER}"
}

Do-Main