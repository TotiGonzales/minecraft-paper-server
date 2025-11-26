# Initial Setup Script
# Run this once to verify everything is configured correctly

$ErrorActionPreference = 'Stop'

Write-Host ''
Write-Host '=====================================' -ForegroundColor Cyan
Write-Host 'MCME Plugin Development Environment' -ForegroundColor Cyan
Write-Host 'Initial Setup Verification' -ForegroundColor Cyan
Write-Host '=====================================' -ForegroundColor Cyan
Write-Host ''

# Check Java
Write-Host '[1/4] Checking Java...' -ForegroundColor Yellow
$ErrorActionPreference = 'Continue'
$javaVersion = (java -version 2>&1)[0]
$ErrorActionPreference = 'Stop'
if ($javaVersion) {
    Write-Host "  Check Java found: $javaVersion" -ForegroundColor Green
    
    if ($javaVersion -notmatch '21|22|23|24') {
        Write-Host '  Warning: Java 21+ recommended' -ForegroundColor Yellow
    }
} else {
    Write-Host '  Error Java not found. Please install Java 21 or higher' -ForegroundColor Red
    exit 1
}

# Check Maven
Write-Host ''
Write-Host '[2/4] Checking Maven...' -ForegroundColor Yellow
$mvn = 'C:\Users\dntst\AppData\Local\Temp\apache-maven-3.9.9\bin\mvn.cmd'
if (Test-Path $mvn) {
    $ErrorActionPreference = 'Continue'
    $mavenVersion = (& $mvn --version 2>&1)[0]
    $ErrorActionPreference = 'Stop'
    if ($mavenVersion) {
        Write-Host "  Check Maven found: $mavenVersion" -ForegroundColor Green
    } else {
        Write-Host '  Error Maven executable found but failed to run' -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "  Error Maven not found at: $mvn" -ForegroundColor Red
    Write-Host '  Please download and extract Maven' -ForegroundColor Yellow
    exit 1
}

# Check Project Structure
Write-Host ''
Write-Host '[3/4] Checking project structure...' -ForegroundColor Yellow
$projects = @('PluginUtils', 'MCME-Architect', 'MCME-Connect')
$allFound = $true

foreach ($project in $projects) {
    $pomPath = Join-Path $project 'pom.xml'
    if (Test-Path $pomPath) {
        Write-Host "  Check Found: $project" -ForegroundColor Green
    } else {
        Write-Host "  Error Missing: $project\pom.xml" -ForegroundColor Red
        $allFound = $false
    }
}

if (-not $allFound) {
    Write-Host ''
    Write-Host '  Project structure incomplete' -ForegroundColor Red
    exit 1
}

# Check Server JAR
Write-Host ''
Write-Host '[4/4] Checking server files...' -ForegroundColor Yellow
if (Test-Path '..\paper.jar') {
    Write-Host '  Check Server JAR found' -ForegroundColor Green
} else {
    Write-Host '  Warning Server JAR not found at ..\paper.jar' -ForegroundColor Yellow
    Write-Host '    This is needed to run the server' -ForegroundColor Yellow
}

if (Test-Path '..\plugins') {
    Write-Host '  Check Plugins directory exists' -ForegroundColor Green
} else {
    Write-Host '  Warning Plugins directory not found' -ForegroundColor Yellow
}

# Summary
Write-Host ''
Write-Host '=====================================' -ForegroundColor Cyan
Write-Host 'Setup Verification Complete!' -ForegroundColor Green
Write-Host '=====================================' -ForegroundColor Cyan
Write-Host ''
Write-Host 'Next steps:' -ForegroundColor Cyan
Write-Host '  1. Run .\build-all.ps1 to build all plugins'
Write-Host '  2. Run .\deploy.ps1 to copy JARs to server'
Write-Host '  3. Start server with: cd ..; java -Xmx2G -jar paper.jar nogui'
Write-Host ''
Write-Host 'Documentation:' -ForegroundColor Cyan  
Write-Host '  - QUICKSTART.md - Quick start guide'
Write-Host '  - README.md     - Full documentation'
Write-Host '  - VSCODE-SETUP.md - VS Code configuration'
Write-Host ''
Write-Host 'Ready to build? Run: .\build-all.ps1' -ForegroundColor Yellow
Write-Host ''
