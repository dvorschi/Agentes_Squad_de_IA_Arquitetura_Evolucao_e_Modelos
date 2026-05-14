# Squad de Agentes — Instalador Windows (PowerShell)
# Uso: .\install.ps1
# Uso (atualizar apenas agentes): .\install.ps1 -Update

param(
    [switch]$Update
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$agentsTarget = "$env:USERPROFILE\.claude\agents"
$squadAgents = @(
    "orchestrator", "prompt-engineer", "qa-test-engineer", "product-manager",
    "executive-storyteller", "business-analyst-financeiro", "financial-systems-architect",
    "technical-lead", "strategic-memory-manager", "ai-operations-analyst",
    "context-manager", "payments-economics-analyst", "data-product-strategist",
    "solution-architect", "executive-reviewer", "research-agent"
)

Write-Host ""
Write-Host "Squad de Agentes — Instalador" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

# Criar pasta de agentes se nao existir
if (-not (Test-Path $agentsTarget)) {
    New-Item -ItemType Directory -Path $agentsTarget -Force | Out-Null
    Write-Host "Pasta criada: $agentsTarget" -ForegroundColor Green
}

# Copiar agentes
Write-Host ""
Write-Host "Instalando agentes em $agentsTarget..." -ForegroundColor Yellow
$copied = 0
$missing = 0

foreach ($agent in $squadAgents) {
    $src = "$scriptDir\agents\$agent.md"
    if (Test-Path $src) {
        Copy-Item $src "$agentsTarget\$agent.md" -Force
        Write-Host "  OK  $agent.md" -ForegroundColor Green
        $copied++
    } else {
        Write-Host "  FALTANDO  $agent.md" -ForegroundColor Red
        $missing++
    }
}

Write-Host ""
Write-Host "$copied agentes instalados." -ForegroundColor Green
if ($missing -gt 0) {
    Write-Host "$missing arquivos nao encontrados — verifique a pasta agents/" -ForegroundColor Red
}

# Se -Update, encerrar aqui
if ($Update) {
    Write-Host ""
    Write-Host "Modo -Update: apenas agentes atualizados. Context files e estrutura nao alterados." -ForegroundColor Cyan
    exit 0
}

# Instalacao completa: estrutura de projeto
Write-Host ""
Write-Host "Instalacao de estrutura de projeto" -ForegroundColor Yellow
Write-Host "Onde voce quer instalar a estrutura do squad?"
Write-Host "(Enter para usar o diretorio atual: $(Get-Location))"
$projectDir = Read-Host "Diretorio de destino"

if ([string]::IsNullOrWhiteSpace($projectDir)) {
    $projectDir = Get-Location
}

if (-not (Test-Path $projectDir)) {
    New-Item -ItemType Directory -Path $projectDir -Force | Out-Null
}

$folders = @("context", "playbooks", "knowledge", "memory", "suggestions", "approved", "changelog", "Documentacao_Claude")

foreach ($folder in $folders) {
    $srcFolder = "$scriptDir\$folder"
    if (Test-Path $srcFolder) {
        Copy-Item $srcFolder $projectDir -Recurse -Force
        Write-Host "  OK  $folder\" -ForegroundColor Green
    }
}

if (Test-Path "$scriptDir\CLAUDE.md") {
    $claudeMdDest = "$projectDir\CLAUDE.md"
    if (-not (Test-Path $claudeMdDest)) {
        Copy-Item "$scriptDir\CLAUDE.md" $claudeMdDest -Force
        Write-Host "  OK  CLAUDE.md" -ForegroundColor Green
    } else {
        Write-Host "  PULADO  CLAUDE.md ja existe — nao sobrescrito" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Instalacao concluida!" -ForegroundColor Cyan
Write-Host ""
Write-Host "Proximos passos:" -ForegroundColor White
Write-Host "  1. Preencher context/business/ com dados dos seus produtos" -ForegroundColor White
Write-Host "  2. Ajustar CLAUDE.md com seu cargo e contexto" -ForegroundColor White
Write-Host "  3. Abrir o projeto: cd '$projectDir' && claude" -ForegroundColor White
Write-Host ""
