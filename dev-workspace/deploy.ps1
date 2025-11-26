# Deploy Script - Copies built JARs to server plugins directory
# Run this after building plugins with build-all.ps1

$ErrorActionPreference = "Stop"

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Deploying MCME Plugins to Server" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

$pluginsDir = "..\plugins"

# Check if JARs exist
$jars = @(
    @{Path = "PluginUtils\target\PluginUtils-1.9.1.jar"; Name = "PluginUtils.jar"},
    @{Path = "MCME-Architect\target\MCME-Architect-2.10.6.jar"; Name = "MCME-Architect.jar"},
    @{Path = "MCME-Connect\target\MCME-Connect-1.1.5.jar"; Name = "MCME-Connect.jar"}
)

$allExist = $true
foreach ($jar in $jars) {
    if (-not (Test-Path $jar.Path)) {
        Write-Host "✗ Not found: $($jar.Path)" -ForegroundColor Red
        $allExist = $false
    }
}

if (-not $allExist) {
    Write-Host ""
    Write-Host "Build plugins first with: .\build-all.ps1" -ForegroundColor Yellow
    exit 1
}

# Create backup
$backupDir = "$pluginsDir\backup-$(Get-Date -Format 'yyyy-MM-dd-HHmmss')"
Write-Host "Creating backup in: $backupDir" -ForegroundColor Yellow

if (Test-Path "$pluginsDir\PluginUtils.jar") {
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
    foreach ($jar in $jars) {
        $oldFile = "$pluginsDir\$($jar.Name)"
        if (Test-Path $oldFile) {
            Copy-Item $oldFile $backupDir
            Write-Host "  Backed up: $($jar.Name)"
        }
    }
}

# Copy new JARs
Write-Host ""
Write-Host "Deploying plugins..." -ForegroundColor Yellow
foreach ($jar in $jars) {
    Copy-Item $jar.Path "$pluginsDir\$($jar.Name)" -Force
    Write-Host "✓ Deployed: $($jar.Name)" -ForegroundColor Green
}

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Deployment Complete!" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Restart the server to load new plugins" -ForegroundColor Cyan
