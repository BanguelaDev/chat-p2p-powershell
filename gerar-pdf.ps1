# Script para gerar PDF a partir do HTML
# Requer: Microsoft Edge ou Chrome instalado

param(
    [string]$InputFile = "PROJETO-CHAT-P2P-POWERSELL.html",
    [string]$OutputFile = "PROJETO-CHAT-P2P-POWERSELL.pdf"
)

Write-Host "=== GERADOR DE PDF - CHAT P2P POWERSELL ===" -ForegroundColor Green
Write-Host ""

# Verificar se o arquivo HTML existe
if (-not (Test-Path $InputFile)) {
    Write-Host "ERRO: Arquivo HTML não encontrado: $InputFile" -ForegroundColor Red
    exit 1
}

Write-Host "Arquivo HTML encontrado: $InputFile" -ForegroundColor Green

# Tentar usar Microsoft Edge (Windows 10/11)
$edgePath = "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe"
if (-not (Test-Path $edgePath)) {
    $edgePath = "${env:ProgramFiles}\Microsoft\Edge\Application\msedge.exe"
}

# Tentar usar Chrome como alternativa
$chromePath = "${env:ProgramFiles}\Google\Chrome\Application\chrome.exe"
if (-not (Test-Path $chromePath)) {
    $chromePath = "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe"
}

$browserPath = $null
$browserName = ""

if (Test-Path $edgePath) {
    $browserPath = $edgePath
    $browserName = "Microsoft Edge"
} elseif (Test-Path $chromePath) {
    $browserPath = $chromePath
    $browserName = "Google Chrome"
}

if (-not $browserPath) {
    Write-Host "ERRO: Nenhum navegador compatível encontrado (Edge ou Chrome)" -ForegroundColor Red
    Write-Host "Instale o Microsoft Edge ou Google Chrome para gerar o PDF" -ForegroundColor Yellow
    exit 1
}

Write-Host "Navegador encontrado: $browserName" -ForegroundColor Green

# Obter caminho absoluto dos arquivos
$htmlPath = (Resolve-Path $InputFile).Path
$pdfPath = Join-Path (Get-Location) $OutputFile

Write-Host "HTML: $htmlPath" -ForegroundColor Cyan
Write-Host "PDF: $pdfPath" -ForegroundColor Cyan
Write-Host ""

# Comando para gerar PDF
$arguments = @(
    "--headless",
    "--disable-gpu",
    "--no-sandbox",
    "--disable-dev-shm-usage",
    "--print-to-pdf=`"$pdfPath`"",
    "--print-to-pdf-no-header",
    "--run-all-compositor-stages-before-draw",
    "--disable-background-timer-throttling",
    "--disable-backgrounding-occluded-windows",
    "--disable-renderer-backgrounding",
    "file:///$($htmlPath -replace '\\', '/')"
)

Write-Host "Gerando PDF..." -ForegroundColor Yellow
Write-Host "Comando: $browserPath $($arguments -join ' ')" -ForegroundColor Gray

try {
    # Executar o comando
    $process = Start-Process -FilePath $browserPath -ArgumentList $arguments -Wait -PassThru -NoNewWindow
    
    if ($process.ExitCode -eq 0) {
        if (Test-Path $pdfPath) {
            $fileSize = (Get-Item $pdfPath).Length
            $fileSizeKB = [math]::Round($fileSize / 1KB, 2)
            
            Write-Host ""
            Write-Host "✅ PDF gerado com sucesso!" -ForegroundColor Green
            Write-Host "Arquivo: $pdfPath" -ForegroundColor Green
            Write-Host "Tamanho: $fileSizeKB KB" -ForegroundColor Green
            Write-Host ""
            Write-Host "Para abrir o PDF, execute:" -ForegroundColor Cyan
            Write-Host "Start-Process `"$pdfPath`"" -ForegroundColor White
        } else {
            Write-Host "ERRO: PDF não foi criado" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "ERRO: Falha ao gerar PDF (código: $($process.ExitCode))" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "ERRO: Exceção ao executar o navegador" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=== CONVERSÃO CONCLUÍDA ===" -ForegroundColor Green
