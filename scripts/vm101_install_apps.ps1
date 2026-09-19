# ==============================================================================
# vm101_install_apps.ps1 — Instalação dos 10 Pacotes Solicitados via Winget
# ==============================================================================
$ErrorActionPreference = "Continue"

$packages = @(
    @{ Name = "7-Zip"; Id = "7zip.7zip" },
    @{ Name = ".NET 8 Desktop Runtime (LTS)"; Id = "Microsoft.DotNet.DesktopRuntime.8" },
    @{ Name = ".NET 9 Desktop Runtime"; Id = "Microsoft.DotNet.DesktopRuntime.9" },
    @{ Name = "Java Temurin 17 JRE"; Id = "EclipseAdoptium.Temurin.17.JRE" },
    @{ Name = "Visual C++ 2015-2022 (x64)"; Id = "Microsoft.VCRedist.2015+.x64" },
    @{ Name = "Visual C++ 2015-2022 (x86)"; Id = "Microsoft.VCRedist.2015+.x86" },
    @{ Name = "Visual C++ All-in-One (abbodi1406)"; Id = "abbodi1406.vcredist" },
    @{ Name = "Google Chrome"; Id = "Google.Chrome" },
    @{ Name = "VLC Media Player"; Id = "VideoLAN.VLC" },
    @{ Name = "LibreOffice LTS"; Id = "TheDocumentFoundation.LibreOffice" }
)

Write-Host "=== INICIANDO INSTALAÇÃO DOS 10 PACOTES NA VM 101 ===" -ForegroundColor Cyan

foreach ($pkg in $packages) {
    Write-Host "[*] Instalando: $($pkg.Name) ($($pkg.Id))..." -ForegroundColor Yellow
    $process = Start-Process -FilePath "winget" -ArgumentList "install --exact --id $($pkg.Id) --silent --accept-package-agreements --accept-source-agreements --disable-interactivity" -NoNewWindow -PassThru -Wait
    if ($process.ExitCode -eq 0) {
        Write-Host "[OK] $($pkg.Name) instalado com sucesso!" -ForegroundColor Green
    } else {
        Write-Host "[WARN] $($pkg.Name) retornou código: $($process.ExitCode)" -ForegroundColor DarkYellow
    }
}

Write-Host "=== INSTALAÇÃO CONCLUÍDA ===" -ForegroundColor Cyan
