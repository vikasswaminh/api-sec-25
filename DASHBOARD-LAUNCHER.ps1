#!/usr/bin/env pwsh
# LLM-FW Dashboard Launcher for Windows
# This script starts a local web server for the dashboard

param(
    [int]$Port = 8080,
    [switch]$Build = $false
)

$Red = "`e[91m"
$Green = "`e[92m"
$Yellow = "`e[93m"
$Cyan = "`e[96m"
$Reset = "`e[0m"

Write-Host ""
Write-Host "$Cyan========================================$Reset"
Write-Host "$Cyan  LLM-FW Dashboard Launcher$Reset"
Write-Host "$Cyan========================================$Reset"
Write-Host ""

$DashboardDir = Join-Path $PSScriptRoot "cf-dashboard"

# Check if dashboard directory exists
if (-not (Test-Path $DashboardDir)) {
    Write-Host "$Red Error: Dashboard directory not found at:$Reset"
    Write-Host "  $DashboardDir"
    Write-Host ""
    Write-Host "Make sure you're running this from the api-security folder."
    exit 1
}

# Build if requested
if ($Build) {
    Write-Host "$Yellow Building dashboard...$Reset"
    Set-Location $DashboardDir
    npm run build
    if ($LASTEXITCODE -ne 0) {
        Write-Host "$Red Build failed!$Reset"
        exit 1
    }
    Write-Host "$Green Build successful!$Reset"
    Write-Host ""
}

# Check if dist folder exists
$DistDir = Join-Path $DashboardDir "dist"
if (-not (Test-Path $DistDir)) {
    Write-Host "$Yellow Dashboard not built yet. Building now...$Reset"
    Set-Location $DashboardDir
    npm run build
    if ($LASTEXITCODE -ne 0) {
        Write-Host "$Red Build failed!$Reset"
        exit 1
    }
}

# Check if Python is available
$PythonAvailable = $false
try {
    $PythonVersion = python --version 2>&1
    if ($PythonVersion -match "Python") {
        $PythonAvailable = $true
    }
} catch {}

# Check if Node.js http-server is available
$NodeServerAvailable = $false
try {
    $HttpServerVersion = npx http-server --version 2>&1
    $NodeServerAvailable = $true
} catch {}

Set-Location $DistDir

Write-Host "$Cyan Starting web server on port $Port...$Reset"
Write-Host ""

if ($PythonAvailable) {
    Write-Host "$Green Using Python HTTP server$Reset"
    Write-Host ""
    Write-Host "$Yellow Dashboard will be available at:$Reset"
    Write-Host "  $Cyan http://localhost:$Port$Reset"
    Write-Host ""
    Write-Host "$Yellow Press Ctrl+C to stop$Reset"
    Write-Host ""
    python -m http.server $Port
}
elseif ($NodeServerAvailable) {
    Write-Host "$Green Using Node.js http-server$Reset"
    Write-Host ""
    Write-Host "$Yellow Dashboard will be available at:$Reset"
    Write-Host "  $Cyan http://localhost:$Port$Reset"
    Write-Host ""
    Write-Host "$Yellow Press Ctrl+C to stop$Reset"
    Write-Host ""
    npx http-server -p $Port
}
else {
    # Fallback to PowerShell
    Write-Host "$Green Using PowerShell HTTP listener$Reset"
    Write-Host ""
    Write-Host "$Yellow Dashboard will be available at:$Reset"
    Write-Host "  $Cyan http://localhost:$Port$Reset"
    Write-Host ""
    Write-Host "$Yellow Press Ctrl+C to stop$Reset"
    Write-Host ""
    
    # Simple PowerShell web server
    $Listener = New-Object System.Net.HttpListener
    $Listener.Prefixes.Add("http://localhost:$Port/")
    $Listener.Start()
    
    Write-Host "Server running. Press Ctrl+C to stop."
    
    try {
        while ($Listener.IsListening) {
            $Context = $Listener.GetContext()
            $Request = $Context.Request
            $Response = $Context.Response
            
            $Url = $Request.Url.LocalPath
            if ($Url -eq "/") { $Url = "/index.html" }
            
            $FilePath = Join-Path $DistDir $Url.TrimStart("/")
            $FilePath = $FilePath -replace "/", "\"
            
            if (Test-Path $FilePath -PathType Leaf) {
                $Content = Get-Content $FilePath -Raw -ErrorAction SilentlyContinue
                $ContentType = "text/plain"
                
                if ($FilePath.EndsWith(".html")) { $ContentType = "text/html" }
                elseif ($FilePath.EndsWith(".css")) { $ContentType = "text/css" }
                elseif ($FilePath.EndsWith(".js")) { $ContentType = "application/javascript" }
                elseif ($FilePath.EndsWith(".svg")) { $ContentType = "image/svg+xml" }
                elseif ($FilePath.EndsWith(".json")) { $ContentType = "application/json" }
                
                $Response.ContentType = $ContentType
                $Response.StatusCode = 200
                
                $Buffer = [System.Text.Encoding]::UTF8.GetBytes($Content)
                $Response.OutputStream.Write($Buffer, 0, $Buffer.Length)
            }
            else {
                $Response.StatusCode = 404
                $Message = "404 - File Not Found: $Url"
                $Buffer = [System.Text.Encoding]::UTF8.GetBytes($Message)
                $Response.OutputStream.Write($Buffer, 0, $Buffer.Length)
            }
            
            $Response.Close()
        }
    }
    finally {
        $Listener.Stop()
        $Listener.Close()
    }
}
