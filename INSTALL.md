# Guia de Instalação — Squad de Agentes

---

## Instalação Automática (recomendado)

### Windows
```powershell
.\install.ps1
```

### Mac/Linux
```bash
chmod +x install.sh && ./install.sh
```

---

## Instalação Manual

### 1. Copiar os agentes

Os agentes ficam em `~/.claude/agents/`. O Claude Code carrega automaticamente todo arquivo `.md` nesta pasta como um agente disponível.

**Windows:**
```powershell
Copy-Item .\agents\* "$env:USERPROFILE\.claude\agents\" -Force
```

**Mac/Linux:**
```bash
cp agents/* ~/.claude/agents/
```

### 2. Criar a estrutura de projeto

Escolha (ou crie) o diretório raiz do seu projeto. Copie a estrutura de suporte:

```
seu-projeto/
├── CLAUDE.md              ← instruções para o Claude Code
├── context/               ← briefing dos seus produtos
├── playbooks/             ← protocolos de execução
├── knowledge/             ← base de conhecimento de domínio
├── memory/squad/          ← decisões e log de operações
├── suggestions/           ← melhorias pendentes
├── approved/              ← histórico de governança
└── changelog/             ← versionamento do squad
```

**Windows:**
```powershell
$dest = "C:\caminho\para\seu-projeto"
Copy-Item .\context $dest -Recurse -Force
Copy-Item .\playbooks $dest -Recurse -Force
Copy-Item .\knowledge $dest -Recurse -Force
Copy-Item .\memory $dest -Recurse -Force
Copy-Item .\suggestions $dest -Recurse -Force
Copy-Item .\approved $dest -Recurse -Force
Copy-Item .\changelog $dest -Recurse -Force
Copy-Item .\Documentacao_Claude $dest -Recurse -Force
Copy-Item .\CLAUDE.md $dest -Force
```

**Mac/Linux:**
```bash
DEST="/caminho/para/seu-projeto"
cp -r context playbooks knowledge memory suggestions approved changelog Documentacao_Claude CLAUDE.md "$DEST/"
```

### 3. Abrir o projeto no Claude Code

```bash
cd seu-projeto
claude
```

O Claude Code detectará o `CLAUDE.md` e carregará as instruções do squad automaticamente.

---

## Configuração inicial

### 3.1 — Preencher context files

Edite os arquivos em `context/business/` com os dados reais dos seus produtos:

| Arquivo | O que preencher |
|---|---|
| `produto-credito.md` | Nome do produto, domínios funcionais, artefatos técnicos, regulação aplicável |
| `produto-pagamentos.md` | Modelo de negócio, economics, métricas, regulação |
| `empresa.md` | Nome da empresa, cargo do PM, tom de comunicação, benchmarks |

Campos marcados com `[preencher]` são obrigatórios. Os demais são sugestões de estrutura.

### 3.2 — Ajustar o CLAUDE.md

No `CLAUDE.md`, localize a seção do perfil do PM e atualize:
- Cargo e empresa
- Produtos e clientes ativos
- Especialidades relevantes

### 3.3 — Verificar os agentes

No Claude Code, rode:
```
/agents
```
Você deve ver os 27 agentes do squad listados.

---

## Verificação pós-instalação

```bash
# Verificar agentes instalados
ls ~/.claude/agents/ | grep -E "orchestrator|product-manager|executive-storyteller"

# Testar o squad
claude
# Então: "Orquestrador, faça um diagnóstico rápido do squad instalado"
```

---

## Atualização

Para atualizar o squad com uma nova versão:

```powershell
# Windows
.\install.ps1 -Update

# Mac/Linux
./install.sh --update
```

O instalador sobrescreve apenas os agentes — não toca em context files, memory ou changelog.

---

## Cadência recomendada pós-instalação

Para squads com maior autonomia, configure rotinas automáticas via Claude Code:

```
# No Claude Code, acione o schedule para criar rotinas recorrentes:
/schedule
```

**Rotinas recomendadas (configurar em claude.ai/code/routines):**

| Rotina | Frequência | O que faz |
|---|---|---|
| `research-agent` | Seg-sex 09:30 | Varre BACEN, fintech, Anthropic — gera relatório de inteligência |
| `operations-log-lembrete` | Seg-sex 09:40 | Gera template datado para registrar sessões do dia |
| `ai-metrics-analyst` | Segundas 09:40 | Dashboard semanal de KPIs do squad |

---

## Desinstalação

```powershell
# Windows — remover apenas agentes do squad (não toca outros agentes)
$squadAgents = @(
    "orchestrator","prompt-engineer","execution-engine","capability-registry",
    "product-manager","business-analyst-financeiro","executive-storyteller",
    "executive-reviewer","ux-researcher",
    "financial-systems-architect","ccb-structuring-engine","ledger-specialist",
    "spi-spb-architect","solution-architect","technical-lead",
    "payments-economics-analyst","mdr-pricing-analyst","pnl-modeler","data-product-strategist",
    "frontend-developer","qa-test-engineer",
    "context-manager","strategic-memory-manager","task-memory-manager",
    "ai-operations-analyst","ai-metrics-analyst","research-agent"
)
foreach ($a in $squadAgents) {
    Remove-Item "$env:USERPROFILE\.claude\agents\$a.md" -Force -ErrorAction SilentlyContinue
}
```
