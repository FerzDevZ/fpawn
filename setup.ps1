# FERZDEVZ FPAWN PRO - WINDOWS AUTO-INSTALLER
# This script compiles and installs FPAWN Pro for Windows environments.

$ErrorActionPreference = "Stop"

Write-Host "╔══════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║    FERZDEVZ FPAWN PRO - WINDOWS INSTALLER    ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════╝" -ForegroundColor Cyan

# Check for Go
if (!(Get-Command go -ErrorAction SilentlyContinue)) {
    Write-Host "[Error] Go is not installed. Please install Go (https://go.dev/dl/) first." -ForegroundColor Red
    exit
}

# Build logic
Write-Host "[1/3] Compiling FPAWN Pro Engine..." -ForegroundColor Green
go build -ldflags="-s -w" -o fpawn.exe .\cmd\fpawn

# Installation logic
Write-Host "[2/3] Deploying binary to local path..." -ForegroundColor Green
$InstallDir = "$HOME\.ferzdevz\bin"
if (!(Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir
}
Move-Item -Path "fpawn.exe" -Destination "$InstallDir\fpawn.exe" -Force

# PATH setup
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($currentPath -notlike "*$InstallDir*") {
    Write-Host "[Info] Adding $InstallDir to User PATH..." -ForegroundColor Blue
    [Environment]::SetEnvironmentVariable("Path", "$currentPath;$InstallDir", "User")
    Write-Host "[Success] PATH updated. Please restart your terminal/PowerShell." -ForegroundColor Green
}

# Configuration setup
Write-Host "[3/3] Initializing Proprietary Core..." -ForegroundColor Green
$ConfigDir = "$HOME\.ferzdevz\fpawn"
if (!(Test-Path $ConfigDir)) {
    New-Item -ItemType Directory -Path $ConfigDir
}

Write-Host "`n──────────────────────────────────────────────────" -ForegroundColor Green
Write-Host "  Installation Complete!" -ForegroundColor Green
Write-Host "  Run 'fpawn' in a new terminal to launch."
Write-Host "──────────────────────────────────────────────────" -ForegroundColor Green
