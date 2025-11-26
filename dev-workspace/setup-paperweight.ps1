# Paper Paperweight Setup Script
# This downloads and sets up the Paper development bundle for NMS access

$ErrorActionPreference = 'Stop'

Write-Host ''
Write-Host '=====================================' -ForegroundColor Cyan
Write-Host 'Paper Paperweight Development Setup' -ForegroundColor Cyan
Write-Host '=====================================' -ForegroundColor Cyan
Write-Host ''

$mvn = 'C:\Users\dntst\AppData\Local\Temp\apache-maven-3.9.9\bin\mvn.cmd'

if (-not (Test-Path $mvn)) {
    Write-Host 'ERROR: Maven not found' -ForegroundColor Red
    exit 1
}

Write-Host 'This will download and setup Paper dev bundle (may take several minutes)' -ForegroundColor Yellow
Write-Host ''

# Setup PluginUtils
Write-Host '[1/3] Setting up PluginUtils with Paper dev bundle...' -ForegroundColor Yellow
Push-Location 'PluginUtils'
try {
    $ErrorActionPreference = 'Continue'
    & $mvn clean package -DskipTests 2>&1 | ForEach-Object { 
        $line = $_.ToString()
        if ($line -match 'BUILD SUCCESS' -or $line -match 'BUILD FAILURE' -or $line -match 'Downloading' -or $line -match 'Downloaded' -or $line -match 'Decompiling') {
            Write-Host $line
        }
    }
    $ErrorActionPreference = 'Stop'
    Write-Host 'Check PluginUtils paperweight setup complete' -ForegroundColor Green
} catch {
    Write-Host "Warning: PluginUtils setup encountered issues: $_" -ForegroundColor Yellow
} finally {
    Pop-Location
}
Write-Host ''

# Setup MCME-Architect
Write-Host '[2/3] Setting up MCME-Architect with Paper dev bundle...' -ForegroundColor Yellow
Push-Location 'MCME-Architect'
try {
    $ErrorActionPreference = 'Continue'
    & $mvn clean package -DskipTests 2>&1 | ForEach-Object { 
        $line = $_.ToString()
        if ($line -match 'BUILD SUCCESS' -or $line -match 'BUILD FAILURE' -or $line -match 'Downloading' -or $line -match 'Downloaded' -or $line -match 'Decompiling') {
            Write-Host $line
        }
    }
    $ErrorActionPreference = 'Stop'
    Write-Host 'Check MCME-Architect paperweight setup complete' -ForegroundColor Green
} catch {
    Write-Host "Warning: MCME-Architect setup encountered issues: $_" -ForegroundColor Yellow
} finally {
    Pop-Location
}
Write-Host ''

# Setup MCME-Connect
Write-Host '[3/3] Setting up MCME-Connect with Paper dev bundle...' -ForegroundColor Yellow
Push-Location 'MCME-Connect'
try {
    $ErrorActionPreference = 'Continue'
    & $mvn clean package -DskipTests 2>&1 | ForEach-Object { 
        $line = $_.ToString()
        if ($line -match 'BUILD SUCCESS' -or $line -match 'BUILD FAILURE' -or $line -match 'Downloading' -or $line -match 'Downloaded' -or $line -match 'Decompiling') {
            Write-Host $line
        }
    }
    $ErrorActionPreference = 'Stop'
    Write-Host 'Check MCME-Connect paperweight setup complete' -ForegroundColor Green
} catch {
    Write-Host "Warning: MCME-Connect setup encountered issues: $_" -ForegroundColor Yellow
} finally {
    Pop-Location
}
Write-Host ''

Write-Host '=====================================' -ForegroundColor Cyan
Write-Host 'Paperweight Setup Complete!' -ForegroundColor Green
Write-Host '=====================================' -ForegroundColor Cyan
Write-Host ''
Write-Host 'The Paper development bundle has been downloaded and configured.' -ForegroundColor Cyan
Write-Host 'You can now build plugins with NMS access using build-all.ps1' -ForegroundColor Cyan
Write-Host ''
