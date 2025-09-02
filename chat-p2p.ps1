# Chat P2P em PowerShell
# Este script permite comunicação direta entre dois computadores via sockets TCP
# Uso: .\chat-p2p.ps1 [-Mode] [-IP] [-Port]

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("server", "client")]
    [string]$Mode = "server",
    
    [Parameter(Mandatory=$false)]
    [string]$IP = "127.0.0.1",
    
    [Parameter(Mandatory=$false)]
    [int]$Port = 8080
)

# Configurações
$bufferSize = 1024
$encoding = [System.Text.Encoding]::UTF8

# Função para obter IP local
function Get-LocalIP {
    $localIP = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias Ethernet* | Where-Object {$_.IPAddress -notlike "169.254.*"} | Select-Object -First 1).IPAddress
    if (-not $localIP) {
        $localIP = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias Wi-Fi* | Where-Object {$_.IPAddress -notlike "169.254.*"} | Select-Object -First 1).IPAddress
    }
    if (-not $localIP) {
        $localIP = "127.0.0.1"
    }
    return $localIP
}

# Função para exibir informações de conexão
function Show-ConnectionInfo {
    Write-Host "=== CHAT P2P POWERSELL ===" -ForegroundColor Cyan
    Write-Host "Modo: $Mode" -ForegroundColor Yellow
    Write-Host "IP Local: $(Get-LocalIP)" -ForegroundColor Green
    Write-Host "Porta: $Port" -ForegroundColor Green
    
    if ($Mode -eq "server") {
        Write-Host "Aguardando conexões em: $(Get-LocalIP):$Port" -ForegroundColor Green
        Write-Host "Para conectar, execute em outro computador:" -ForegroundColor White
        Write-Host ".\chat-p2p.ps1 -Mode client -IP $(Get-LocalIP) -Port $Port" -ForegroundColor White
    } else {
        Write-Host "Conectando a: $IP`:$Port" -ForegroundColor Green
    }
    Write-Host "Pressione Ctrl+C para sair" -ForegroundColor Red
    Write-Host "================================" -ForegroundColor Cyan
    Write-Host ""
}

# Função para enviar mensagens
function Send-Message {
    param($stream, $message)
    try {
        $data = $encoding.GetBytes($message)
        $stream.Write($data, 0, $data.Length)
        $stream.Flush()
        return $true
    } catch {
        Write-Host "Erro ao enviar mensagem: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Função para receber mensagens
function Receive-Message {
    param($stream)
    try {
        $buffer = New-Object byte[] $bufferSize
        $bytesRead = $stream.Read($buffer, 0, $bufferSize)
        if ($bytesRead -gt 0) {
            $message = $encoding.GetString($buffer, 0, $bytesRead)
            return $message.Trim()
        }
        return $null
    } catch {
        Write-Host "Erro ao receber mensagem: $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

# Modo Servidor
if ($Mode -eq "server") {
    Show-ConnectionInfo
    
    try {
        # Criar listener TCP
        $listener = New-Object System.Net.Sockets.TcpListener([System.Net.IPAddress]::Any, $Port)
        $listener.Start()
        
        Write-Host "Servidor iniciado. Aguardando conexão..." -ForegroundColor Green
        
        # Aceitar conexão
        $client = $listener.AcceptTcpClient()
        $stream = $client.GetStream()
        
        Write-Host "Cliente conectado de: $($client.Client.RemoteEndPoint)" -ForegroundColor Green
        Write-Host "Chat iniciado! Digite suas mensagens:" -ForegroundColor Cyan
        Write-Host ""
        
        # Loop principal do servidor
        $running = $true
        while ($running) {
            # Verificar se há mensagens para receber
            if ($stream.DataAvailable) {
                $receivedMessage = Receive-Message -stream $stream
                if ($receivedMessage) {
                    Write-Host "[RECEBIDO] $receivedMessage" -ForegroundColor Yellow
                }
            }
            
            # Verificar se há input do usuário
            if ([Console]::KeyAvailable) {
                $key = [Console]::ReadKey($true)
                if ($key.Key -eq [ConsoleKey]::Enter) {
                    Write-Host ""
                    $message = Read-Host "Você"
                    if ($message -eq "quit" -or $message -eq "exit") {
                        $running = $false
                        break
                    }
                    
                    if ($message) {
                        $success = Send-Message -stream $stream -message $message
                        if ($success) {
                            Write-Host "[ENVIADO] $message"
                        }
                    }
                }
            }
            
            Start-Sleep -Milliseconds 100
        }
        
    } catch {
        Write-Host "Erro no servidor: $($_.Exception.Message)" -ForegroundColor Red
    } finally {
        if ($stream) { $stream.Close() }
        if ($client) { $client.Close() }
        if ($listener) { $listener.Stop() }
        Write-Host "Servidor encerrado." -ForegroundColor Red
    }
}

# Modo Cliente
else {
    Show-ConnectionInfo
    
    try {
        # Conectar ao servidor
        $client = New-Object System.Net.Sockets.TcpClient
        $client.Connect($IP, $Port)
        $stream = $client.GetStream()
        
        Write-Host "Conectado ao servidor!" -ForegroundColor Green
        Write-Host "Chat iniciado! Digite suas mensagens:" -ForegroundColor Cyan
        Write-Host ""
        
        # Loop principal do cliente
        $running = $true
        while ($running) {
            # Verificar se há mensagens para receber
            if ($stream.DataAvailable) {
                $receivedMessage = Receive-Message -stream $stream
                if ($receivedMessage) {
                    Write-Host "[RECEBIDO] $receivedMessage" -ForegroundColor Yellow
                }
            }
            
            # Verificar se há input do usuário
            if ([Console]::KeyAvailable) {
                $key = [Console]::ReadKey($true)
                if ($key.Key -eq [ConsoleKey]::Enter) {
                    Write-Host ""
                    $message = Read-Host "Você"
                    if ($message -eq "quit" -or $message -eq "exit") {
                        $running = $false
                        break
                    }
                    
                    if ($message) {
                        $success = Send-Message -stream $stream -message $message
                        if ($success) {
                            Write-Host "[ENVIADO] $message"
                        }
                    }
                }
            }
            
            Start-Sleep -Milliseconds 100
        }
        
    } catch {
        Write-Host "Erro no cliente: $($_.Exception.Message)" -ForegroundColor Red
    } finally {
        if ($stream) { $stream.Close() }
        if ($client) { $client.Close() }
        Write-Host "Cliente desconectado." -ForegroundColor Red
    }
}
