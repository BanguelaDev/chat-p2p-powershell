# Chat P2P em PowerShell

Este projeto implementa um chat ponto a ponto (P2P) entre dois computadores utilizando PowerShell e sockets TCP, sem necessidade de servidor intermediário.

## Arquivos do Projeto

- **`chat-p2p.ps1`** - Script principal do chat P2P
- **`network-info.ps1`** - Script para verificar informações de rede
- **`firewall-setup.ps1`** - Script para configurar firewall (requer admin)
- **`README.md`** - Este arquivo de instruções

## Pré-requisitos

- Windows 10/11 com PowerShell 5.1 ou superior
- Acesso de administrador para configuração de firewall
- Dois computadores na mesma rede local

## Como Usar

### 1. Configuração Inicial

Primeiro, execute o script de informações de rede para verificar a configuração:

```powershell
.\network-info.ps1
```

### 2. Configuração do Firewall (Recomendado)

Execute como administrador para criar regras de firewall:

```powershell
.\firewall-setup.ps1
```

### 3. Iniciar o Chat

#### No Computador 1 (Servidor):
```powershell
.\chat-p2p.ps1 -Mode server -Port 8080
```

#### No Computador 2 (Cliente):
```powershell
.\chat-p2p.ps1 -Mode client -IP [IP_DO_COMPUTADOR_1] -Port 8080
```

## Parâmetros

- **`-Mode`**: Define o modo de operação (`server` ou `client`)
- **`-IP`**: IP do servidor (apenas para modo cliente)
- **`-Port`**: Porta de comunicação (padrão: 8080)

## Funcionalidades

- ✅ Comunicação bidirecional em tempo real
- ✅ Detecção automática de IP local
- ✅ Tratamento de erros robusto
- ✅ Interface colorida e intuitiva
- ✅ Suporte a múltiplas portas

## Comandos do Chat

- Digite sua mensagem e pressione Enter para enviar
- Digite `quit` ou `exit` para sair
- Pressione `Ctrl+C` para encerrar forçadamente

## Solução de Problemas

### Problema: Conexão recusada
- Verifique se o firewall está configurado
- Confirme se a porta não está sendo usada por outro serviço
- Verifique se os computadores estão na mesma rede

### Problema: Não consigo ver mensagens
- Verifique se ambos os computadores estão conectados
- Teste a conectividade com `ping` entre as máquinas
- Verifique se não há bloqueios de rede corporativa

### Problema: Erro de permissão
- Execute o PowerShell como administrador
- Verifique as políticas de execução: `Get-ExecutionPolicy`

## Limitações

- Funciona apenas em redes locais
- Requer configuração manual de firewall
- Não possui criptografia de mensagens
- Suporte limitado a um cliente por servidor

## Exemplo de Uso Completo

```powershell
# Terminal 1 - Servidor
.\chat-p2p.ps1 -Mode server -Port 9000

# Terminal 2 - Cliente
.\chat-p2p.ps1 -Mode client -IP 192.168.1.100 -Port 9000
```

## Segurança

⚠️ **ATENÇÃO**: Este chat não possui criptografia e transmite mensagens em texto plano. Use apenas em redes confiáveis para fins educacionais.

## Suporte

Para problemas ou dúvidas, verifique:
1. Logs de erro no PowerShell
2. Configuração de rede com `network-info.ps1`
3. Status do firewall
4. Conectividade entre as máquinas
