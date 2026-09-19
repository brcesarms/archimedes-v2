# Pure ASCII PowerShell Audit Script
Write-Host "=== PROGRAMAS INSTALADOS ==="
Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*, HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName } | Select-Object DisplayName, DisplayVersion | Sort-Object DisplayName | Format-Table -AutoSize

Write-Host "=== SERVICO DIAGTRACK ==="
Get-Service -Name DiagTrack -ErrorAction SilentlyContinue | Select-Object Name, Status, StartType

Write-Host "=== TEMA ESCURO ==="
Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -ErrorAction SilentlyContinue | Select-Object AppsUseLightTheme, SystemUsesLightTheme

Write-Host "=== TELEMETRIA ==="
Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -ErrorAction SilentlyContinue | Select-Object AllowTelemetry
