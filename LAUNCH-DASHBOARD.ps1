#!/usr/bin/env pwsh
# LLM-FW Dashboard Launcher
# Run this to view your dashboard properly

$Green = "`e[92m"
$Cyan = "`e[96m"
$Yellow = "`e[93m"
$Reset = "`e[0m"

Write-Host ""
Write-Host "$Cyan╔══════════════════════════════════════════════════════════╗$Reset"
Write-Host "$Cyan║         LLM-FW Security Dashboard Launcher               ║$Reset"
Write-Host "$Cyan╚══════════════════════════════════════════════════════════╝$Reset"
Write-Host ""

$DashboardPath = "C:\api-security\cf-dashboard\dist"

# Method 1: Try Python (simplest)
Write-Host "$Yellow Method 1: Starting with Python...$Reset"
Set-Location $DashboardPath
$PythonProcess = Start-Process python -ArgumentList "-m", "http.server", "8080" -PassThru -WindowStyle Hidden

Start-Sleep -Seconds 2

if ($PythonProcess.Responding) {
    Write-Host "$Green ✓ Server started successfully!$Reset"
    Write-Host ""
    Write-Host "$Cyan Dashboard URL: http://localhost:8080$Reset"
    Write-Host ""
    Start-Process "http://localhost:8080"
    Write-Host "Press any key to stop the server..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Stop-Process -Id $PythonProcess.Id -Force
    Write-Host "$Green Server stopped.$Reset"
}
else {
    # Method 2: Try Node
    Write-Host "$Yellow Method 2: Trying Node.js...$Reset"
    $NodeProcess = Start-Process npx -ArgumentList "http-server", "-p", "8080" -PassThru -WindowStyle Hidden
    Start-Sleep -Seconds 2
    
    if ($NodeProcess.Responding) {
        Write-Host "$Green ✓ Server started!$Reset"
        Start-Process "http://localhost:8080"
        Write-Host "Press any key to stop..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        Stop-Process -Id $NodeProcess.Id -Force
    }
}

Write-Host ""
Write-Host "$Green Dashboard closed. Run this script again to restart.$Reset"
Write-Host ""
