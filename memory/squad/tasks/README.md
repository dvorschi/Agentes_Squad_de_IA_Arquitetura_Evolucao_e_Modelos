# Task Memory — Memória Operacional por Tarefa

> Registros de execução de tarefas significativas do squad.
> Gerenciado pelo `task-memory-manager`.
> Alimenta o `ai-metrics-analyst` e informa execuções futuras.

---

## O que vai aqui

Memória operacional de cada entrega significativa:
- Tarefas com 2+ agentes envolvidos
- Tarefas que geraram erro ou retry
- Tarefas de tipo recorrente (features de crédito, P&L, decks, correções HTML)

**O que NÃO vai aqui:**
- Decisões estratégicas permanentes → `memory/squad/decisions/`
- Log operacional geral → `memory/squad/operations-log.md`
- Estado vivo de sessão → gerenciado pelo `context-manager`, não persiste

---

## Formato de Arquivo

**Nome:** `YYYY-MM-DD-[slug-descritivo].md`

**Exemplos:**
- `2026-05-14-ccb-requisitos-originacao.md`
- `2026-05-14-edenred-pnl-modelo-pat.md`
- `2026-05-15-sprint-board-bug-calculadora.md`

Ver formato completo no agente `task-memory-manager.md`.

---

## Índice de Registros

| Data | Tarefa | Produto | Tipo | QA 1ª vez |
|---|---|---|---|---|
| — | — | — | — | — |

> Adicionar entradas neste índice ao criar novos registros.
