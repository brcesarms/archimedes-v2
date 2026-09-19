# ==============================================================================
# vm101_debloat_tweaks.ps1 — Debloat, Telemetria e Modo Escuro no Windows 11
# Inspirado no win-toolbox-tui (brcesarms)
# ==============================================================================
$ErrorActionPreference = "SilentlyContinue"

Write-Host "=== INICIANDO DEBLOAT E OTIMIZACAO DO WINDOWS 11 ===" -ForegroundColor Cyan

# 1. Remocao de Bloatwares AppX (LinkedIn, WhatsApp, TikTok, etc.)
$bloatPatterns = @(
    "*LinkedIn*",
    "*WhatsApp*",
    "*Clipchamp*",
    "*TikTok*",
    "*Instagram*",
    "*Spotify*",
    "*BingNews*",
    "*BingWeather*",
    "*XboxGamingOverlay*",
    "*XboxSpeechToTextOverlay*",
    "*MicrosoftSolitaireCollection*",
    "*ZuneMusic*",
    "*ZuneVideo*"
)

Write-Host "[*] Removendo pacotes AppX indesejados..." -ForegroundColor Yellow
foreach ($pattern in $bloatPatterns) {
    Get-AppxPackage -AllUsers -Name $pattern | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
    Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like $pattern } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
}
Write-Host "[OK] Bloatwares AppX processados." -ForegroundColor Green

# 2. Desativar Servico de Telemetria (DiagTrack)
Write-Host "[*] Desativando serviço DiagTrack..." -ForegroundColor Yellow
Stop-Service -Name "DiagTrack" -Force -ErrorAction SilentlyContinue
Set-Service -Name "DiagTrack" -StartupType Disabled -ErrorAction SilentlyContinue
Write-Host "[OK] Serviço DiagTrack desativado." -ForegroundColor Green

# 3. Chaves de Registro de Telemetria
Write-Host "[*] Aplicando restrição de telemetria no Registro..." -ForegroundColor Yellow
$dataColPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
if (-not (Test-Path $dataColPath)) { New-Item -Path $dataColPath -Force | Out-Null }
Set-ItemProperty -Path $dataColPath -Name "AllowTelemetry" -Value 0 -Type DWord -Force

$privacyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy"
if (-not (Test-Path $privacyPath)) { New-Item -Path $privacyPath -Force | Out-Null }
Set-ItemProperty -Path $privacyPath -Name "TailoredExperiencesWithDiagnosticDataEnabled" -Value 0 -Type DWord -Force
Write-Host "[OK] Chaves de telemetria aplicadas." -ForegroundColor Green

# 4. Ativacao do Tema Escuro (Dark Mode)
Write-Host "[*] Ativando Tema Escuro..." -ForegroundColor Yellow
$themePath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
if (-not (Test-Path $themePath)) { New-Item -Path $themePath -Force | Out-Null }
Set-ItemProperty -Path $themePath -Name "AppsUseLightTheme" -Value 0 -Type DWord -Force
Set-ItemProperty -Path $themePath -Name "SystemUsesLightTheme" -Value 0 -Type DWord -Force
Write-Host "[OK] Tema Escuro ativado!" -ForegroundColor Green

Write-Host "=== DEBLOAT E TWEAKS CONCLUIDOS COM SUCESSO ===" -ForegroundColor Cyan
