# Script para verificar informações de rede e conectividade
# Útil para diagnosticar problemas de conexão P2P

Write-Host "=== INFORMAÇÕES DE REDE ===" -ForegroundColor Cyan
Write-Host ""

# IP Local
Write-Host "IP Local:" -ForegroundColor Yellow
$localIPs = Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike "127.*" -and $_.IPAddress -notlike "169.254.*"}
foreach ($ip in $localIPs) {
    Write-Host "  $($ip.IPAddress) ($($ip.InterfaceAlias))" -ForegroundColor Green
}
Write-Host ""

# Gateway padrão
Write-Host "Gateway Padrão:" -ForegroundColor Yellow
$gateway = Get-NetRoute -DestinationPrefix "0.0.0.0/0" | Select-Object -First 1
if ($gateway) {
    Write-Host "  $($gateway.NextHop)" -ForegroundColor Green
} else {
    Write-Host "  Não encontrado" -ForegroundColor Red
}
Write-Host ""

# Status do Firewall
Write-Host "Status do Firewall:" -ForegroundColor Yellow
$firewallStatus = Get-NetFirewallProfile | Select-Object Name, Enabled
foreach ($profile in $firewallStatus) {
    $status = if ($profile.Enabled) { "ATIVO" } else { "INATIVO" }
    $color = if ($profile.Enabled) { "Red" } else { "Green" }
    Write-Host "  $($profile.Name): $status" -ForegroundColor $color
}
Write-Host ""

# Portas em uso
Write-Host "Portas em uso (TCP):" -ForegroundColor Yellow
$tcpConnections = Get-NetTCPConnection -State Listen | Select-Object LocalPort, State | Sort-Object LocalPort | Select-Object -First 10
foreach ($conn in $tcpConnections) {
    Write-Host "  Porta $($conn.LocalPort): $($conn.State)" -ForegroundColor Green
}
Write-Host ""

# Teste de conectividade
Write-Host "Teste de conectividade:" -ForegroundColor Yellow
$testIPs = @("8.8.8.8", "1.1.1.1", "208.67.222.222")
foreach ($ip in $testIPs) {
    $ping = Test-Connection -ComputerName $ip -Count 1 -Quiet
    $status = if ($ping) { "OK" } else { "FALHA" }
    $color = if ($ping) { "Green" } else { "Red" }
    Write-Host "  $ip`: $status" -ForegroundColor $color
}
Write-Host ""

# Informações sobre interfaces de rede
Write-Host "Interfaces de Rede:" -ForegroundColor Yellow
$interfaces = Get-NetAdapter | Where-Object {$_.Status -eq "Up"}
foreach ($interface in $interfaces) {
    Write-Host "  $($interface.Name): $($interface.Status) - $($interface.InterfaceDescription)" -ForegroundColor Green
}
Write-Host ""

Write-Host "=== FIM DAS INFORMAÇÕES ===" -ForegroundColor Cyan
