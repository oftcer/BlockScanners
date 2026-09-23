#Requires -RunAsAdministrator
<#
.SYNOPSIS
  BlockScanners — bloqueia ranges de IPs de scanners de internet no Firewall do Windows.

.DESCRIPTION
  Cria regras de firewall inbound (Block) para redes conhecidas de:
  Shodan, Censys, Shadowserver, BinaryEdge e ZoomEye.

.NOTES
  Author : oftcer
  Site   : https://oftcer.com
  Project: BlockScanners
#>

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "  BlockScanners" -ForegroundColor Cyan
Write-Host "  oftcer — https://oftcer.com" -ForegroundColor DarkGray
Write-Host ""
Write-Host "[+] Aplicando regras de bloqueio no Firewall do Windows..." -ForegroundColor Yellow

# Nome da regra => CIDR remoto
$rules = [ordered]@{
    "BlockScanners - Shodan 1"       = "198.20.87.0/24"
    "BlockScanners - Shodan 2"       = "185.163.109.0/24"
    "BlockScanners - Shodan 3"       = "71.6.165.0/24"
    "BlockScanners - Shodan 4"       = "66.240.236.0/24"
    "BlockScanners - Censys 1"       = "167.94.138.0/24"
    "BlockScanners - Censys 2"       = "167.94.145.0/24"
    "BlockScanners - Shadowserver 1" = "64.62.202.0/24"
    "BlockScanners - Shadowserver 2" = "204.42.253.0/24"
    "BlockScanners - BinaryEdge 1"   = "185.244.25.0/24"
    "BlockScanners - ZoomEye 1"      = "103.120.226.0/24"
}

$created = 0
$skipped = 0
$failed  = 0

foreach ($name in $rules.Keys) {
    $cidr = $rules[$name]

    $existing = Get-NetFirewallRule -DisplayName $name -ErrorAction SilentlyContinue
    if ($existing) {
        Write-Host "  [=] Ja existe: $name" -ForegroundColor DarkGray
        $skipped++
        continue
    }

    try {
        New-NetFirewallRule `
            -DisplayName $name `
            -Direction Inbound `
            -RemoteAddress $cidr `
            -Action Block `
            -Profile Any `
            -Enabled True | Out-Null

        Write-Host "  [+] Criada: $name ($cidr)" -ForegroundColor Green
        $created++
    }
    catch {
        Write-Host "  [!] Falha: $name — $($_.Exception.Message)" -ForegroundColor Red
        $failed++
    }
}

Write-Host ""
Write-Host "[*] Resumo: $created criada(s), $skipped ja existente(s), $failed falha(s)." -ForegroundColor Cyan

if ($failed -gt 0) {
    Write-Host "[!] Algumas regras nao foram aplicadas. Verifique se esta rodando como Administrador." -ForegroundColor Red
    exit 1
}

Write-Host "[OK] Regras aplicadas com sucesso!" -ForegroundColor Green
Write-Host ""
