#!/usr/bin/env bash
# Squad de Agentes — Instalador Mac/Linux
# Uso: ./install.sh
# Uso (atualizar apenas agentes): ./install.sh --update

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_TARGET="$HOME/.claude/agents"
UPDATE_ONLY=false

if [[ "$1" == "--update" ]]; then
    UPDATE_ONLY=true
fi

SQUAD_AGENTS=(
    "orchestrator" "prompt-engineer" "qa-test-engineer" "product-manager"
    "executive-storyteller" "business-analyst-financeiro" "financial-systems-architect"
    "technical-lead" "strategic-memory-manager" "ai-operations-analyst"
    "context-manager" "payments-economics-analyst" "data-product-strategist"
    "solution-architect" "executive-reviewer" "research-agent"
)

echo ""
echo "Squad de Agentes — Instalador"
echo "================================"

# Criar pasta de agentes se não existir
mkdir -p "$AGENTS_TARGET"

# Copiar agentes
echo ""
echo "Instalando agentes em $AGENTS_TARGET..."
COPIED=0
MISSING=0

for agent in "${SQUAD_AGENTS[@]}"; do
    src="$SCRIPT_DIR/agents/$agent.md"
    if [[ -f "$src" ]]; then
        cp "$src" "$AGENTS_TARGET/$agent.md"
        echo "  OK  $agent.md"
        ((COPIED++))
    else
        echo "  FALTANDO  $agent.md"
        ((MISSING++))
    fi
done

echo ""
echo "$COPIED agentes instalados."
if [[ $MISSING -gt 0 ]]; then
    echo "$MISSING arquivos não encontrados — verifique a pasta agents/"
fi

# Se --update, encerrar aqui
if [[ "$UPDATE_ONLY" == true ]]; then
    echo ""
    echo "Modo --update: apenas agentes atualizados. Context files e estrutura não alterados."
    exit 0
fi

# Instalação completa: estrutura de projeto
echo ""
echo "Instalação de estrutura de projeto"
echo "Onde você quer instalar a estrutura do squad?"
echo "(Enter para usar o diretório atual: $(pwd))"
read -r PROJECT_DIR

if [[ -z "$PROJECT_DIR" ]]; then
    PROJECT_DIR="$(pwd)"
fi

mkdir -p "$PROJECT_DIR"

FOLDERS=("context" "playbooks" "knowledge" "memory" "suggestions" "approved" "changelog" "Documentacao_Claude")

for folder in "${FOLDERS[@]}"; do
    src_folder="$SCRIPT_DIR/$folder"
    if [[ -d "$src_folder" ]]; then
        cp -r "$src_folder" "$PROJECT_DIR/"
        echo "  OK  $folder/"
    fi
done

if [[ -f "$SCRIPT_DIR/CLAUDE.md" ]]; then
    if [[ ! -f "$PROJECT_DIR/CLAUDE.md" ]]; then
        cp "$SCRIPT_DIR/CLAUDE.md" "$PROJECT_DIR/CLAUDE.md"
        echo "  OK  CLAUDE.md"
    else
        echo "  PULADO  CLAUDE.md já existe — não sobrescrito"
    fi
fi

echo ""
echo "Instalação concluída!"
echo ""
echo "Próximos passos:"
echo "  1. Preencher context/business/ com dados dos seus produtos"
echo "  2. Ajustar CLAUDE.md com seu cargo e contexto"
echo "  3. Abrir o projeto: cd '$PROJECT_DIR' && claude"
echo ""
