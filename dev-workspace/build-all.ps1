# MCME Plugin Development - Build Script
# Builds all plugins in the correct dependency order

$ErrorActionPreference = 'Stop'

Write-Host '=====================================' -ForegroundColor Cyan
Write-Host 'MCME Plugin Development Build Script' -ForegroundColor Cyan
Write-Host '=====================================' -ForegroundColor Cyan
Write-Host ''

# Maven path
$mvn = 'C:\Users\dntst\AppData\Local\Temp\apache-maven-3.9.9\bin\mvn.cmd'

if (-not (Test-Path $mvn)) {
    Write-Host "ERROR: Maven not found at $mvn" -ForegroundColor Red
    Write-Host 'Please ensure Maven is installed' -ForegroundColor Red
    exit 1
}

Write-Host "Using Maven: $mvn" -ForegroundColor Green
Write-Host ''

# Build PluginUtils first (required dependency)
Write-Host '[1/3] Building PluginUtils...' -ForegroundColor Yellow
Push-Location 'PluginUtils'
try {
    & $mvn clean install -DskipTests
    if ($LASTEXITCODE -ne 0) {
        throw 'PluginUtils build failed'
    }
    Write-Host 'Check PluginUtils built successfully' -ForegroundColor Green
} catch {
    Write-Host "Error PluginUtils build failed: $_" -ForegroundColor Red
    Pop-Location
    exit 1
} finally {
    Pop-Location
}
Write-Host ''

# Build MCME-Architect
Write-Host '[2/3] Building MCME-Architect...' -ForegroundColor Yellow
Push-Location 'MCME-Architect'
try {
    & $mvn clean package -DskipTests
    if ($LASTEXITCODE -ne 0) {
        throw 'MCME-Architect build failed'
    }
    Write-Host 'Check MCME-Architect built successfully' -ForegroundColor Green
} catch {
    Write-Host "Error MCME-Architect build failed: $_" -ForegroundColor Red
    Pop-Location
    exit 1
} finally {
    Pop-Location
}
Write-Host ''

# Build MCME-Connect
Write-Host '[3/3] Building MCME-Connect...' -ForegroundColor Yellow
Push-Location 'MCME-Connect'
try {
    & $mvn clean package -DskipTests
    if ($LASTEXITCODE -ne 0) {
        throw 'MCME-Connect build failed'
    }
    Write-Host 'Check MCME-Connect built successfully' -ForegroundColor Green
} catch {
    Write-Host "Error MCME-Connect build failed: $_" -ForegroundColor Red
    Pop-Location
    exit 1
} finally {
    Pop-Location
}
Write-Host ''

# Summary
Write-Host '=====================================' -ForegroundColor Cyan
Write-Host 'Build Complete!' -ForegroundColor Green
Write-Host '=====================================' -ForegroundColor Cyan
Write-Host ''
Write-Host 'Built JARs:' -ForegroundColor Yellow
Write-Host '  - PluginUtils/target/PluginUtils-1.9.1.jar'
Write-Host '  - MCME-Architect/target/MCME-Architect-2.10.6.jar'
Write-Host '  - MCME-Connect/target/MCME-Connect-1.1.5.jar'
Write-Host ''
Write-Host 'To deploy: Copy JARs to ../plugins/ directory' -ForegroundColor Cyan
Write-Host ''
