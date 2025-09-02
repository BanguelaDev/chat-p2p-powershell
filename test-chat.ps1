# Script de teste para o Chat P2P
# Este script demonstra como testar a funcionalidade do chat

Write-Host "=== TESTE DO CHAT P2P ===" -ForegroundColor Cyan
Write-Host ""

# Verificar se os scripts existem
$scripts = @("chat-p2p.ps1", "network-info.ps1", "firewall-setup.ps1")
$missingScripts = @()

foreach ($script in $scripts) {
    if (Test-Path $script) {
        Write-Host "✓ $script encontrado" -ForegroundColor Green
    } else {
        Write-Host "✗ $script não encontrado" -ForegroundColor Red
        $missingScripts += $script
    }
}

if ($missingScripts.Count -gt 0) {
    Write-Host ""
    Write-Host "Scripts faltando: $($missingScripts -join ', ')" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=== INSTRUÇÕES DE TESTE ===" -ForegroundColor Yellow
Write-Host ""

Write-Host "1. PRIMEIRO, verifique as informações de rede:" -ForegroundColor White
Write-Host "   .\network-info.ps1" -ForegroundColor Green
Write-Host ""

Write-Host "2. CONFIGURE o firewall (como administrador):" -ForegroundColor White
Write-Host "   .\firewall-setup.ps1" -ForegroundColor Green
Write-Host ""

Write-Host "3. EM UM TERMINAL, inicie o servidor:" -ForegroundColor White
Write-Host "   .\chat-p2p.ps1 -Mode server -Port 8080" -ForegroundColor Green
Write-Host ""

Write-Host "4. EM OUTRO TERMINAL, conecte o cliente:" -ForegroundColor White
Write-Host "   .\chat-p2p.ps1 -Mode client -IP [IP_DO_SERVIDOR] -Port 8080" -ForegroundColor Green
Write-Host ""

Write-Host "5. TESTE a comunicação:" -ForegroundColor White
Write-Host "   - Digite mensagens em ambos os terminais" -ForegroundColor White
Write-Host "   - Verifique se as mensagens aparecem no outro terminal" -ForegroundColor White
Write-Host "   - Digite 'quit' para sair" -ForegroundColor White
Write-Host ""

Write-Host "=== DICAS IMPORTANTES ===" -ForegroundColor Yellow
Write-Host ""

Write-Host "• Execute o PowerShell como administrador para configurar firewall" -ForegroundColor White
Write-Host "• Use portas diferentes se 8080 estiver ocupada" -ForegroundColor White
Write-Host "• Verifique se ambos os computadores estão na mesma rede" -ForegroundColor White
Write-Host "• Use o comando 'ping' para testar conectividade básica" -ForegroundColor White
Write-Host ""

Write-Host "=== COMANDOS DE DIAGNÓSTICO ===" -ForegroundColor Yellow
Write-Host ""

Write-Host "Testar conectividade:" -ForegroundColor White
Write-Host "   ping [IP_DESTINO]" -ForegroundColor Green
Write-Host ""

Write-Host "Verificar porta:" -ForegroundColor White
Write-Host "   Test-NetConnection -ComputerName [IP] -Port [PORTA]" -ForegroundColor Green
Write-Host ""

Write-Host "Verificar políticas de execução:" -ForegroundColor White
Write-Host "   Get-ExecutionPolicy" -ForegroundColor Green
Write-Host ""

Write-Host "=== FIM DO TESTE ===" -ForegroundColor Cyan
