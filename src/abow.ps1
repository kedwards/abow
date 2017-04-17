#
# Name  :   abow
# Author:   edwardk3 <kevin.edwards@enbridge.com>
#       :   kedwards <kedwards@livity.consulting>
# Desc  :   Downloads, installs, and configures a linux enviornment for Ansible
#
Clear-Host

Set-Variable -Name 'install_path' -Value "linux2"

Set-Variable -Name 'wasp' -Value "$PSScriptRoot\WASP.dll"
Set-Variable -Name 'abow_home' -Value "$HOME\$install_path"
Set-Variable -Name 'babun_version' -Value '1.2.0'
Set-Variable -Name 'babun_src' -Value 'http://projects.reficio.org/babun/download'
Set-Variable -Name 'cmdr_version' -Value 'v1.3.2'
Set-Variable -Name 'cmdr_src' -Value "https://github.com/cmderdev/cmder/releases/download/$cmdr_version/cmder_mini.zip"
Set-Variable -Name 'mrm_build' -Value $True
Set-Variable -Name 'mrm_src' -Value 'http://bit.ly/2oj7uSh' # https://github.com/kedwards/ansible-babun-bootstrap/install.sh
Set-Variable -Name 'error_install_path' -Value 'Error: {0} path exists, remove this path or use the -install_path command line argument to install to a new directory.'

If (Test-Path $wasp) {
    Import-Module $wasp
} Else {
    Write-Host "\nError: WASP.dll not found or cannot be loaded.\n"
    Pause
    Exit
}

If (Test-Path $abow_home) {
    Write-Host ("$error_install_path" -f $abow_home)
	#Pause
    #Exit
}

$o_babun = New-Object –TypeName PSObject –Prop (@{
    'Name' = 'Babun';
    'Ver' = $babun_version;
    'Src' = $babun_src;
    'Dest' = "$abow_home\babun.zip";
    'Path' = "$abow_home\babun"
})

$o_cmdr = New-Object –TypeName PSObject –Prop (@{
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
    $shell.namespace($abow_home).Copyhere($zip.items(), 0x14) # 0x4 = hides dialog box, 0x10 = overwrite,  0x14 = hide and overwrite

    Write-Host ".ok"
}

function Do-Get
{
    param([Parameter(Mandatory=$true)][object]$dep)

    Write-Host -NoNewline ("Retrieving {0}.." -f $dep.Name) 

    If (!( Test-Path $dep.Dest)) {
        $webc = New-Object System.Net.WebClient
        $webc.DownloadFile($dep.Src, $dep.Dest)
    }

    Write-Host ".ok"
}

function Do-Main
{
    param(
        [Parameter(Mandatory=$false)][string]$root = $abow_home,
		[Parameter(Mandatory=$false)][bool]$mrm_build = $mrm_build,
        [Parameter(Mandatory=$false)][array]$comps = $deps
    )

    if (!(Test-Path $root)) { New-Item -ItemType Directory -Force -Path $root > $null }

    foreach ($dep in $comps)
    {
        Do-Get $dep
        Do-Unzip $dep
    }

    Start-Process $abow_home\babun-$babun_version\install.bat -ArgumentList '/t', "$abow_home"

    while (!($process = Select-Window mintty | Select-Object -first 1).ProcessId)
    {
        Start-Sleep -s 10
    }
	
	if ($mrm_build) {
		$process = Select-Window mintty
        $process | Send-Keys "zsh <+9curl -sL ${mrm_src}+0" 
        Start-Sleep -m 500
        $process | Send-Keys "{ENTER}"
        Start-Sleep -s 5
        $process | Set-WindowPosition -Minimize
	}
}

Do-Main