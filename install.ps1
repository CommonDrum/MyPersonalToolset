winget install Git.Git
winget install cmake

# Install PowerShell 7
$PowerShellReleasesUrl = "https://api.github.com/repos/PowerShell/PowerShell/releases/latest"
$LatestRelease = Invoke-RestMethod -Uri $PowerShellReleasesUrl
$LatestVersion = $LatestRelease.tag_name
$DownloadUrl = "https://github.com/PowerShell/PowerShell/releases/download/$LatestVersion/PowerShell-$LatestVersion-win-x64.msi"
$InstallerPath = "$env:TEMP\PowerShell-$LatestVersion-win-x64.msi"

Invoke-WebRequest -Uri $DownloadUrl -OutFile $InstallerPath
Start-Process -FilePath msiexec.exe -ArgumentList "/package $InstallerPath /quiet ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ENABLE_PSREMOTING=1 REGISTER_MANIFEST=1" -Wait
Remove-Item $InstallerPath

# Set PowerShell 7 as the default shell
$pwshPath = "${env:ProgramFiles}\PowerShell\7\pwsh.exe"
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows" -Name "Load" -Value "`"$pwshPath`"" -PropertyType String -Force

if (!(Get-Command cargo -ErrorAction SilentlyContinue)) {
    Write-Host "Cargo not found, installing Rust and Cargo..."
    Invoke-WebRequest -Uri "https://win.rustup.rs" -OutFile "rustup-init.exe"
    .\rustup-init.exe -y
    Remove-Item "rustup-init.exe"
    $env:Path += ";$env:USERPROFILE\.cargo\bin"
} else {
    Write-Host "Cargo is already installed."
}

Write-Host "Installing zoxide..."
winget install ajeetdsouza.zoxide



Write-Host "Installing starship..."
cargo install starship


$commandToAdd = "`nInvoke-Expression (& { (zoxide init powershell | Out-String) })"


$profilePath = PowerShell.exe -NoProfile -Command "echo $profile"

if (-Not (Test-Path $profilePath)) {
    New-Item -Path $profilePath -ItemType File
}

Add-Content -Path $profilePath -Value $commandToAdd
Add-Content -Path $PROFILE -Value 'Invoke-Expression (&starship init powershell)'


Write-Host "Installing FiraCode Nerd Font..."
$FONT_URL = "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip"
$FONT_DIR = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"
Invoke-WebRequest -Uri $FONT_URL -OutFile "$env:TEMP\FiraCode.zip"
Expand-Archive -Path "$env:TEMP\FiraCode.zip" -DestinationPath $FONT_DIR
Remove-Item "$env:TEMP\FiraCode.zip"
