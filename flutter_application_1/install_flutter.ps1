# Install Flutter via Cursor/PowerShell - run this in Cursor terminal
# Run: powershell -ExecutionPolicy Bypass -File install_flutter.ps1

$flutterDir = "C:\flutter"
$flutterZip = "$env:TEMP\flutter_windows.zip"
$flutterUrl = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.5-stable.zip"

# 1. Download (skip if zip already exists and is big enough)
if (-not (Test-Path $flutterZip) -or (Get-Item $flutterZip).Length -lt 500000000) {
    Write-Host "Downloading Flutter SDK (~1GB). This may take 5-10 minutes..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $flutterUrl -OutFile $flutterZip -UseBasicParsing
    Write-Host "Download done." -ForegroundColor Green
} else {
    Write-Host "Using existing download." -ForegroundColor Green
}

# 2. Extract to C:\
Write-Host "Extracting to C:\flutter ..." -ForegroundColor Yellow
if (Test-Path $flutterDir) { Remove-Item $flutterDir -Recurse -Force }
Expand-Archive -Path $flutterZip -DestinationPath "C:\" -Force
Write-Host "Extract done." -ForegroundColor Green

# 3. Add to user PATH
$binPath = "C:\flutter\bin"
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -notlike "*$binPath*") {
    [Environment]::SetEnvironmentVariable("Path", "$userPath;$binPath", "User")
    Write-Host "Added Flutter to PATH (User)." -ForegroundColor Green
} else {
    Write-Host "Flutter already in PATH." -ForegroundColor Green
}

Write-Host ""
Write-Host "Flutter installed at C:\flutter" -ForegroundColor Cyan
Write-Host "Close and reopen Cursor terminal (or restart Cursor), then run: flutter doctor" -ForegroundColor Cyan
