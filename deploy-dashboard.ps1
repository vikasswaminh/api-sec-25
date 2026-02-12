#!/usr/bin/env pwsh
# Cloudflare Pages Dashboard Deployment Script

param(
    [string]$ProjectName = "llm-fw-dashboard"
)

$Green = "`e[92m"
$Yellow = "`e[93m"
$Cyan = "`e[96m"
$Reset = "`e[0m"

Write-Host ""
Write-Host "$Cyan Dashboard Deployment Script$Reset"
Write-Host ""

$DashboardDir = "C:\api-security\cf-dashboard"
Set-Location $DashboardDir

Write-Host "$Yellow Step 1: Installing dependencies...$Reset"
npm ci
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to install dependencies"
    exit 1
}
Write-Host "$Green Dependencies installed$Reset"

Write-Host "$Yellow Step 2: Building...$Reset"
npm run build
if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed"
    exit 1
}
Write-Host "$Green Build successful$Reset"

Write-Host "$Yellow Step 3: Deploying...$Reset"
wrangler pages deploy dist --project-name=$ProjectName

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "$Green Deployment Complete!$Reset"
    Write-Host "$Cyan URL: https://${ProjectName}.pages.dev$Reset"
} else {
    Write-Host "Deployment failed"
}
