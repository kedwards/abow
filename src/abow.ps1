param(
    [String]$install_path = "linux",
    [switch]$ignore_exist = $false,
    [switch]$ignore_abb = $false
)

#
# Name  :   abow
# Author:   edwardk3 <kevin.edwards@enbridge.com>
#       :   kedwards <kedwards@livity.consulting>
# Desc  :   Downloads, installs, and configures a linux enviornment for Ansible
#
# Requirements:
#   - Wasp: https://archive.codeplex.com/?p=wasp
#
#   - ps.exe < 3.* requires:
#     $PSScriptRoot = Split-Path MyInvocation.MyCommand.Path -Parent
#     or
#     $PSScriptRoot = Split-Path $script:MyInvocation.MyCommand.Path
#
if(!$PSScriptRoot){ $PSScriptRoot = $PSScriptRoot = Split-Path $script:MyInvocation.MyCommand.Path }
Set-Variable -Name 'wasp' -Value "$PSScriptRoot\WASP.dll"
Set-Variable -Name 'abow_home' -Value "C:\Users\$env:UserName\$install_path"
Set-Variable -Name 'babun_version' -Value '1.2.0'
Set-Variable -Name 'babun_src' -Value 'http://projects.reficio.org/babun/download'
Set-Variable -Name 'cmdr_version' -Value 'v1.3.6'
Set-Variable -Name 'cmdr_src' -Value "https://github.com/cmderdev/cmder/releases/download/$cmdr_version/cmder_mini.zip"
Set-Variable -Name 'abb_src' -Value 'http://bit.ly/abb-install' # https://github.com/kedwards/ansible-babun-bootstrap/install.sh
Set-Variable -Name 'error_install_path' -Value "Error: {0} path exists: `
`n`tYou have the following choices to resolve this error. `
`n`t1. Remove the {0} directory and rerun the command `
`t./abow
`n`t2. Use the -install_path arg to install to a new directory `
`t./abow -install_path linux2 `
`n`t3. Use the -ignore_exist arg to force install (Not Recommended) `
`t./abow -ignore_exist `
"
Set-Variable -Name 'error_wasp_notfound' -Value "Error: WASP.dll not found or cannot be loaded `
`n`tDownload the wasp.dll and place it next to the abow script `
`n`tWasp: Wasp: https://archive.codeplex.com/?p=wasp `
"

Clear-Host

If (Test-Path $wasp) {
    Import-Module $wasp
} Else {
    Write-Host ("$error_wasp_notfound" -f $wasp)
    Pause
    Exit
}

If ((Test-Path $abow_home) -and (!($ignore_exist))) {
    Write-Host ("$error_install_path" -f $abow_home)
    Pause
    Exit
}

$o_babun = New-Object -TypeName PSObject -Prop (@{
    'Name' = 'Babun';
    'Ver' = $babun_version;
    'Src' = $babun_src;
    'Dest' = "$abow_home\babun.zip";
    'Path' = "$abow_home\babun"
})

$o_cmdr = New-Object -TypeName PSObject -Prop (@{
    'Name' = 'Cmdr';
    'Ver' = $cmdr_version;
    'Src' = $cmdr_src;
    'Dest' = "$abow_home\cmdr.zip";
    'Path' = $abow_home
})

$deps = @(
    $o_babun
    $o_cmdr
)

function Do-Unzip
{
    param([Parameter(Mandatory=$true)][object]$dep)

    Write-Host -NoNewline ("Unzipping {0}.." -f $dep.Dest)

    $shell = new-object -com shell.application
    $zip = $shell.namespace($dep.Dest)
    $shell.namespace($abow_home).Copyhere($zip.items(), 0x14) # 0x4 = hides dialog box, 0x10 = overwrite, 0x14 = hide and overwrite
    Write-Host ".ok"
}

function Do-Get
{
    param([Parameter(Mandatory=$true)][object]$dep)

    If (!( Test-Path $dep.Dest)) {
        Write-Host -NoNewline ("Retrieving {0}.." -f $dep.Name)
        $webc = New-Object System.Net.WebClient
        $webc.DownloadFile($dep.Src, $dep.Dest)
        Write-Host ".ok"
    }
}

function Do-Abb
{
    $process = Select-Window mintty
    $process | Send-Keys "zsh <+9curl -sL ${abb_src}+0"
    Start-Sleep -m 500
    $process | Send-Keys "{ENTER}"
    Start-Sleep -s 5
    #$process | Set-WindowPosition -Minimize
}

function Do-Main
{
    param(
        [Parameter(Mandatory=$false)][string]$root = $abow_home,
        [Parameter(Mandatory=$false)][array]$comps = $deps
    )

    if (!(Test-Path $root)) { New-Item -ItemType Directory -Force -Path $root > $null }

    if (!(Test-Path $abow_home\.babun))
    {
        if (!(Test-Path $abow_home\babun-1.2.0\dist\babun.zip))
        {
            Do-Get $o_babun
            Do-Unzip $o_babun
        }

        if (!(Test-Path $o_cmdr.dest))
        {
            Do-Get $o_cmdr
            Do-Unzip $o_cmdr
        }
        Start-Process $abow_home\babun-$babun_version\install.bat -ArgumentList '/t', "$abow_home"

        while (!($process = Select-Window mintty | Select-Object -first 1).ProcessId)
        {
	         Start-Sleep -s 10
        }

        if (!($ignore_abb))
        {
            Do-Abb
        }

        Remove-Item $abow_home\babun-$babun_version -recurse

        exit

    } else {
        Start-Process $abow_home\.babun\babun.bat

        while (!($process = Select-Window mintty | Select-Object -first 1).ProcessId)
        {
	        Start-Sleep -s 10
        }

        Do-Abb
    }
}

Do-Main
