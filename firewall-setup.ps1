# Script para configurar regras de firewall para o chat P2P
# Execute como Administrador

param(
    [Parameter(Mandatory=$false)]
    [int]$Port = 8080
)

# Verificar se está rodando como administrador
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Este script deve ser executado como Administrador!" -ForegroundColor Red
    Write-Host "Clique com o botão direito no PowerShell e selecione 'Executar como administrador'" -ForegroundColor Yellow
    exit
}

Write-Host "=== CONFIGURAÇÃO DE FIREWALL PARA CHAT P2P ===" -ForegroundColor Cyan
Write-Host "Porta: $Port" -ForegroundColor Yellow
Write-Host ""

try {
    # Regra de entrada para TCP
    $ruleNameIn = "Chat P2P - Entrada TCP $Port"
    Write-Host "Criando regra de entrada: $ruleNameIn" -ForegroundColor Green
    
    New-NetFirewallRule -DisplayName $ruleNameIn `
                        -Direction Inbound `
                        -Protocol TCP `
                        -LocalPort $Port `
                        -Action Allow `
                        -Profile Any `
                        -Description "Permite conexões de entrada para chat P2P na porta $Port"
    
    Write-Host "✓ Regra de entrada criada com sucesso" -ForegroundColor Green
    
    # Regra de saída para TCP
    $ruleNameOut = "Chat P2P - Saída TCP $Port"
    Write-Host "Criando regra de saída: $ruleNameOut" -ForegroundColor Green
    
    New-NetFirewallRule -DisplayName $ruleNameOut `
                        -Direction Outbound `
                        -Protocol TCP `
                        -RemotePort $Port `
                        -Action Allow `
                        -Profile Any `
                        -Description "Permite conexões de saída para chat P2P na porta $Port"
    
    Write-Host "✓ Regra de saída criada com sucesso" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "=== REGRAS CRIADAS COM SUCESSO ===" -ForegroundColor Green
    Write-Host "Agora você pode executar o chat P2P sem problemas de firewall" -ForegroundColor White
    
} catch {
    Write-Host "Erro ao criar regras de firewall: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Verifique se você está executando como administrador" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Para remover as regras, execute:" -ForegroundColor Yellow
Write-Host "Remove-NetFirewallRule -DisplayName 'Chat P2P*'" -ForegroundColor White
