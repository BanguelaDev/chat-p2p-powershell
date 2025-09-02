# Instruções de Execução - Chat P2P PowerShell

## ⚠️ IMPORTANTE: Política de Execução

O PowerShell está configurado com política restritiva. Para executar os scripts, use um dos métodos abaixo:

### Método 1: Execução com Bypass (Recomendado)
```powershell
powershell -ExecutionPolicy Bypass -File [NOME_DO_SCRIPT]
```

### Método 2: Alterar Política Temporariamente
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Método 3: Executar como Administrador
Clique com botão direito no PowerShell → "Executar como administrador"

## 🚀 Passo a Passo para Executar o Chat

### 1. Verificar Informações de Rede
```powershell
powershell -ExecutionPolicy Bypass -File network-info.ps1
```

**O que verificar:**
- IP Local (ex: 192.168.0.174)
- Status do Firewall
- Conectividade com internet

### 2. Configurar Firewall (Como Administrador)
```powershell
powershell -ExecutionPolicy Bypass -File firewall-setup.ps1
```

**Se der erro de permissão:**
- Clique com botão direito no PowerShell
- Selecione "Executar como administrador"
- Execute novamente o comando

### 3. Iniciar o Servidor (Terminal 1)
```powershell
powershell -ExecutionPolicy Bypass -File chat-p2p.ps1 -Mode server -Port 8080
```

**Aguardar mensagem:** "Servidor iniciado. Aguardando conexão..."

### 4. Conectar Cliente (Terminal 2)
```powershell
powershell -ExecutionPolicy Bypass -File chat-p2p.ps1 -Mode client -IP [IP_DO_SERVIDOR] -Port 8080
```

**Exemplo:**
```powershell
powershell -ExecutionPolicy Bypass -File chat-p2p.ps1 -Mode client -IP 192.168.0.174 -Port 8080
```

## 🔧 Solução de Problemas

### Problema: "Scripts estão desabilitados"
**Solução:** Use sempre `powershell -ExecutionPolicy Bypass -File [SCRIPT]`

### Problema: "Conexão recusada"
**Soluções:**
1. Verifique se o firewall foi configurado
2. Teste conectividade: `ping [IP_DESTINO]`
3. Use porta diferente: `-Port 9000`

### Problema: "Acesso negado" no firewall
**Solução:** Execute como administrador

### Problema: Não recebo mensagens
**Soluções:**
1. Verifique se ambos estão conectados
2. Teste com `Test-NetConnection -ComputerName [IP] -Port [PORTA]`
3. Reinicie ambos os terminais

## 📋 Comandos de Teste Rápido

### Verificar IP Local
```powershell
Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike "127.*"}
```

### Testar Conectividade
```powershell
ping [IP_DESTINO]
```

### Verificar Porta
```powershell
Test-NetConnection -ComputerName [IP] -Port [PORTA]
```

### Verificar Política de Execução
```powershell
Get-ExecutionPolicy
```

## 🎯 Exemplo Completo de Uso

```powershell
# Terminal 1 - Servidor
powershell -ExecutionPolicy Bypass -File chat-p2p.ps1 -Mode server -Port 8080

# Terminal 2 - Cliente (em outra máquina)
powershell -ExecutionPolicy Bypass -File chat-p2p.ps1 -Mode client -IP 192.168.0.174 -Port 8080
```

## 📱 Como Usar o Chat

1. **Enviar mensagem:** Digite e pressione Enter
2. **Sair:** Digite `quit` ou `exit`
3. **Forçar saída:** Ctrl+C

## 🔍 Verificações de Segurança

- ✅ Scripts não modificam sistema
- ✅ Conexões apenas na porta especificada
- ✅ Sem acesso a arquivos do sistema
- ✅ Comunicação apenas entre máquinas especificadas

## 📞 Suporte

Se ainda tiver problemas:
1. Execute `.\test-chat.ps1` para diagnóstico
2. Verifique logs de erro no PowerShell
3. Confirme configuração de rede
4. Teste com porta diferente
