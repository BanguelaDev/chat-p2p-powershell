# Relatório: Implementação de Chat P2P em PowerShell

**Disciplina:** Redes de Computadores 2  
**Atividade:** Comunicação P2P em PowerShell  
**Data:** Janeiro 2025  

## 1. Procedimento Adotado

### 1.1 Análise e Planejamento
A implementação foi baseada na arquitetura cliente-servidor híbrida, onde um computador atua como "servidor" (listener) e outro como "cliente" (conector), mas a comunicação é direta entre eles sem intermediários externos.

### 1.2 Desenvolvimento dos Scripts
Foram criados três scripts principais:

1. **`chat-p2p.ps1`** - Script principal com funcionalidades de servidor e cliente
2. **`network-info.ps1`** - Ferramenta de diagnóstico de rede
3. **`firewall-setup.ps1`** - Configurador automático de firewall

### 1.3 Implementação Técnica
- **Protocolo:** TCP/IP para comunicação confiável
- **Sockets:** Utilização de `TcpListener` e `TcpClient` do .NET Framework
- **Porta padrão:** 8080 (configurável)
- **Encoding:** UTF-8 para suporte a caracteres especiais
- **Buffer:** 1024 bytes para transmissão de mensagens

### 1.4 Fluxo de Execução
```
Servidor → Inicia listener na porta especificada
Cliente → Conecta ao IP e porta do servidor
Chat → Comunicação bidirecional em tempo real
```

## 2. Dificuldades e Como Foram Superadas

### 2.1 Políticas de Execução do PowerShell
**Problema:** Scripts bloqueados por políticas de segurança  
**Solução:** Configuração de `ExecutionPolicy` e execução com `-ExecutionPolicy Bypass`

### 2.2 Configuração de Firewall
**Problema:** Bloqueio automático de conexões TCP  
**Solução:** Criação automática de regras de firewall com script administrativo

### 2.3 Detecção de IP Local
**Problema:** Identificação automática do IP real da máquina  
**Solução:** Implementação de função que filtra IPs de loopback e link-local

### 2.4 Sincronização de Comunicação
**Problema:** Bloqueio durante espera de mensagens  
**Solução:** Implementação de polling não-bloqueante com `DataAvailable`

## 3. Configurações de Rede Necessárias

### 3.1 Firewall
**Foi necessário desativar o firewall?** Não, mas foi necessário criar regras específicas.  
**Como:** Script automático que cria regras de entrada e saída para a porta especificada.

### 3.2 Portas de Comunicação
**Houve necessidade de alterar portas?** Sim, em alguns casos devido a conflitos.  
**Solução:** Parâmetro configurável `-Port` permite usar portas alternativas.

### 3.3 Software de Apoio Utilizado
- **PowerShell nativo:** Para execução dos scripts
- **Comandos de rede:** `Get-NetIPAddress`, `Test-Connection`
- **Ferramentas de diagnóstico:** Script `network-info.ps1` customizado

## 4. Verificação de Conexão P2P

### 4.1 Evidências de Conexão Direta
- **Logs de conexão:** Exibição do IP remoto conectado
- **Teste de latência:** Comunicação em tempo real sem delays
- **Verificação de rota:** Uso de `tracert` para confirmar rota direta

### 4.2 Testes de Conectividade
```powershell
# Teste de ping entre máquinas
ping [IP_DESTINO]

# Verificação de porta
Test-NetConnection -ComputerName [IP] -Port [PORTA]

# Análise de rota
tracert [IP_DESTINO]
```

## 5. Considerações sobre Viabilidade e Limitações

### 5.1 Viabilidade
✅ **Funciona bem em redes locais**  
✅ **Configuração relativamente simples**  
✅ **Comunicação em tempo real**  
✅ **Sem dependências externas**  

### 5.2 Limitações
❌ **Restrito a redes locais**  
❌ **Sem criptografia de mensagens**  
❌ **Configuração manual de firewall**  
❌ **Suporte limitado a múltiplos clientes**  
❌ **Dependência de políticas de rede corporativa**  

### 5.3 Cenários de Uso
- **Educacional:** Aprendizado de conceitos de rede
- **Teste:** Verificação de conectividade entre máquinas
- **Desenvolvimento:** Prototipagem de aplicações P2P
- **Redes domésticas:** Chat simples entre dispositivos locais

## 6. Conclusões

A implementação demonstra que é possível criar comunicação P2P funcional usando PowerShell, mas com limitações significativas. O projeto serve como excelente ferramenta educacional para compreender:

- Funcionamento de sockets TCP
- Configuração de firewall
- Diagnóstico de problemas de rede
- Limitações da comunicação P2P pura

Para uso em produção, seria recomendável implementar criptografia, suporte a múltiplos clientes e mecanismos de descoberta automática de peers.

## 7. Evidências de Execução

### 7.1 Comandos de Teste
```powershell
# Verificar informações de rede
.\network-info.ps1

# Configurar firewall (como admin)
.\firewall-setup.ps1

# Iniciar servidor
.\chat-p2p.ps1 -Mode server -Port 8080

# Conectar cliente
.\chat-p2p.ps1 -Mode client -IP 192.168.1.100 -Port 8080
```

### 7.2 Arquivos Gerados
- Scripts PowerShell funcionais
- Documentação completa
- Ferramentas de diagnóstico
- Configuradores automáticos

Este projeto demonstra com sucesso os conceitos de comunicação P2P e serve como base para implementações mais robustas em outras linguagens ou frameworks.
