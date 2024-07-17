$ErrorActionPreference = "slentlycontinue"

function Install-Scoop {
  if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "Installing scoop."
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
  }
  Write-Host "Installing scoop buckets."
  $requirements = Get-Content "$PSScriptRoot/requirements/scoop_bucket.txt"
  $requirements | ForEach-Object {
    scoop bucket add $_
  }
  Write-Host "Installing scoop applications."
  $requirements = Get-Content "$PSScriptRoot/requirements/scoop_application.txt"
  $requirements | ForEach-Object {
    scoop install $_
  }
}


function Install-VisualStudioCodeExtensions {
  if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    Write-Host "Visual studio code is not installed."
    return 1
  }
  Write-Host "Installing visual studio code extensions."
  $requirements = Get-Content "$PSScriptRoot/requirements/visual_studio_code.txt"
  $requirements | ForEach-Object {
    code --install-extension $_
  }
}


function Configure-VisualStudioCode {
  if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    Write-Warning "Visual studio code is not installed."
    return 1
  }
  $installed_path = Get-Command code | Select-Object -ExpandProperty Path
  foreach ($path in $installed_paths) {
    if ($path -like "*Microsoft VS Code\*") {
      $vscode_path = "$ENV:USERPROFILE/AppData/Roaming/Code/User"
    } elseif ($path -like "*scoop\apps\vscode\current\*") {
      $vscode_path = "$ENV:USERPROFILE/scoop/apps/vscode/current/data/user-data/User"
    }
  }
  Write-Host "Configuring visual studio code."
  Get-ChildItem -Path "$vscode_path" -ErrorAction SilentlyContinue | Where-Object Extension -in ".json" | Remove-Item -Recurse -Force
  New-Item -Path "$vscode_path" -ItemType Directory -Force
  Copy-Item -Path "$PSScriptRoot/config/vscode/*" -Destination "$vscode_path" -Recurse -Force
}

function Check-Os {
  if ($env:OS -ne "Windows_NT") {
    Write-Warning "This script does not support the os."
    return 1
  }
}

function Show-Menu {
  Write-Host "1. Install scoop."
  Write-Host "2. Install visual studio code extensions."
  Write-Host "3. Configure visual studio code."
  Write-Host "all. Every thing."
  Write-Host "q. Quit."
  Write-Host ""
}

do {
  Check-Os
  Show-Menu
  $choice = Read-Host "Enter your choice"
  switch ($choice) {
    "1" { Install-Scoop }
    "2" { Install-VisualStudioCodeExtensions }
    "3" { Configure-VisualStudioCode }
    "all" {
      Install-Scoop
      Install-VisualStudioCodeExtensions
      Configure-VisualStudioCode
    }
    "q" { break }
    default { Write-Warning "Invalid choice. Please try again." }
  }
} while ($choice -ne "q")
