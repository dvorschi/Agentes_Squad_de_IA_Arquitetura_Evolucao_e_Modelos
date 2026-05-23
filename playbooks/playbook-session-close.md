# Playbook: Encerramento de Sessão

> Executar ao final de toda sessão com entrega significativa.
> Objetivo: garantir que memória, contexto e métricas sejam preservados para a próxima sessão.
> Agente coordenador: `context-manager` ou `orchestrator`.

---

## Quando Usar Este Playbook

**Obrigatório** se a sessão envolveu:
- **Qualquer arquivo alterado** — independente de 1 ou múltiplos agentes
- 2 ou mais agentes trabalhando em sequência
- Qualquer erro ou retry durante a execução
- Feature, requisito, modelo ou deck entregue ao cliente ou à liderança
- Decisão que afeta arquitetura, produto ou regulação

**Opcional** (mas recomendado) se:
- Sessão teve mais de 30 minutos de trabalho
- Múltiplos produtos (Opea e Edenred na mesma sessão)
- Qualquer mudança em agentes, playbooks ou context files

**Pular** se:
- Sessão foi apenas conversacional (perguntas, explicações)
- Nenhum arquivo foi alterado

> **Por que o threshold foi abaixado:** análise `ai-metrics-analyst` de 2026-05-18 revelou cobertura de task memory em 57% — as sessões sem registro eram exatamente as com violação de protocolo e bugs silenciosos. Regra "2+ agentes" deixava sessões de 1 agente sem memória mesmo quando havia aprendizado crítico.

---

## Decisor Rápido — Qual Agente de Memória?

| O que aconteceu na sessão | Agente correto | Por quê |
|---|---|---|
| 2+ agentes envolvidos, ou houve erro/retry | `task-memory-manager` | Memória operacional: agentes, erros, resolução, aprendizados |
| Decisão sobre arquitetura, produto ou regulação que deve ser lembrada em sessões futuras | `strategic-memory-manager` | Decisões permanentes — não operações |
| Sessão longa (>1h) ou cobriu Opea e Edenred na mesma sessão | `context-manager` | Snapshot do estado vivo da sessão |
| Apenas conversacional, nenhum arquivo alterado | Nenhum | Não há o que registrar |

> Regra mnemônica: **TMM = o que fizemos hoje. SMM = o que decidimos para sempre. CM = onde estamos agora.**
> Os três podem ser acionados na mesma sessão se os três critérios forem verdadeiros.

---

## Execução — 4 Passos

### Passo 1 — Memória Operacional (obrigatório se 2+ agentes ou houve erro)

**Agente:** `task-memory-manager`

```
Acionar com:
"task-memory-manager, registre esta sessão em memory/squad/tasks/"
```

O agente vai preencher:
- Tipo e produto da tarefa
- Agentes envolvidos e qualidade de cada um
- Erros encontrados e como foram resolvidos
- Arquivos alterados
- Aprendizados para execuções futuras

**Critério de conclusão:** arquivo criado em `memory/squad/tasks/YYYY-MM-DD-[slug].md`

**Subitem — Frontend-developer Monitoring (condicional):**
Se `frontend-developer` foi acionado nesta sessão → registrar entrada na tabela de `tests/comportamental/monitoring-frontend-v4.md` com os seguintes campos:
- Data da sessão
- Descrição da tarefa (1 linha)
- Execution mode (qual skill foi disparada)
- Rounds necessários (1 = sem retrabalho, 2+ = retrabalho)
- Implementação correta? (Sim/Não — houve bug?)
- Regressão identificada? (Sim/Não — função adjacente quebrou?)
- Protocolo PE→Orchestrator seguido? (Sim/Não)
- Task memory registrada? (Sim/Não)
- Resultado (Aprovado/Reprovado/Alerta)
- Observações (dados relevantes para análise posterior)

> Este subitem é crítico para validar a meta de redução de retrabalho para <20% nas próximas 5 sessões técnicas com o agente.

---

### Passo 2 — Snapshot de Contexto (obrigatório se sessão longa ou multi-produto)

**Agente:** `context-manager`

```
Acionar com:
"context-manager, faça snapshot do estado atual da sessão"
```

O agente vai capturar:
- O que foi trabalhado nesta sessão
- Estado atual dos produtos (Opea / Edenred)
- Decisões tomadas que afetam a próxima sessão
- O que ficou pendente

**Critério:** snapshot gerado e comunicado ao usuário para aprovação

---

### Passo 3 — Decisões Estratégicas (obrigatório se houve decisão de arquitetura, produto ou regulação)

**Agente:** `strategic-memory-manager`

```
Acionar com:
"strategic-memory-manager, registre as decisões estratégicas desta sessão"
```

**Critério de acionar:**
- Decisão sobre arquitetura técnica
- Decisão sobre direção de produto
- Interpretação regulatória consolidada
- Qualquer decisão que deva ser lembrada em sessões futuras sem precisar ser reexplicada

**Não acionar** para decisões operacionais (como resolver um erro) — essas ficam no task-memory.

---

### Passo 3.5 — Loop de Retroalimentação de Conhecimento (se houve aprendizado técnico novo)

Após registrar o task memory (Passo 1), verificar: **a sessão produziu algum aprendizado que ainda não está em `knowledge/squad-learnings/padroes-e-aprendizados.md`?**

Exemplos que devem ser propagados:
- Bug novo descoberto (causa raiz + fix + regra derivada)
- Padrão de orquestração que funcionou ou falhou
- Restrição arquitetural do Sprint Board confirmada ou corrigida
- Armadilha nova identificada

Se sim → atualizar `padroes-e-aprendizados.md` com a nova entrada antes de encerrar a sessão.

> Este passo é o que transforma execuções em conhecimento permanente. Sem ele, o task-memory acumula aprendizados que nunca chegam aos agentes executores nas sessões futuras.

---

### Passo 4 — Log de Operações (sempre)

**Arquivo:** `memory/squad/operations-log.md`

Adicionar entrada manual ou pedir ao `ai-operations-analyst`:

```markdown
### [YYYY-MM-DD] — [tipo de operação]

**Agentes envolvidos:** [lista]
**Demanda:** [o que foi solicitado — 1 linha]
**Entregável:** [o que foi produzido — 1 linha]
**Qualidade:** [QA aprovado? erros encontrados?]
**Observações:** [o que foi relevante — opcional]
```

---

### Passo 5 — Análise de Performance (a cada ~10 sessões ou quando qualidade cair)

**Gatilho:** taxa de aprovação QA 1ª rodada abaixo de 85%, ou acúmulo de ~10 sessões registradas desde a última análise.

**Agentes:**
```
ai-metrics-analyst  →  calcula métricas por agente (erro, retrabalho, uso, custo)
ai-operations-analyst  →  interpreta os números e propõe melhorias de processo
```

Executar nesta ordem: metrics primeiro, operations depois (operations depende dos dados do metrics).

> Este passo é o único que não é por sessão — é periódico. Sem ele, ai-metrics-analyst e ai-operations-analyst ficam dormentes indefinidamente e o squad para de evoluir com base em dados.

---

## Checklist de Encerramento

```
[ ] Decisor de memória consultado (tabela acima) — qual(is) agente(s) acionar?
[ ] Passo 1 — task-memory registrada (se qualquer arquivo foi alterado)
[ ] Passo 1b — QA formal: se arquivos de código foram alterados → qa-test-engineer acionado antes de encerrar?
[ ] Passo 2 — snapshot de contexto (se sessão longa ou multi-produto)
[ ] Passo 3 — decisão estratégica registrada (se houver)
[ ] Passo 3.5 — loop de retroalimentação: aprendizados novos propagados para padroes-e-aprendizados.md?
[ ] Passo 4 — operations-log.md atualizado
[ ] Passo 5 — análise de performance (se ~10 sessões acumuladas ou QA < 85%)
[ ] suggestions/ verificado — há novos PENDENTE?
[ ] changelog/changelog.md atualizado (se squad foi modificado)
[ ] Github/ sincronizado (se documentação foi atualizada)
```

---

## Por que Este Playbook Existe

Sem encerramento estruturado:
- task-memory-manager nunca é acionado → ai-metrics-analyst não tem dados
- Erros da sessão anterior se repetem na próxima
- Decisões ficam apenas no histórico de conversa (que se perde)
- O squad cresce em arquitetura mas não em aprendizado operacional

Com encerramento consistente em 5-10 sessões:
- ai-metrics-analyst já tem dados reais para análise
- Padrões de execução bem-sucedidos são identificados
- Erros recorrentes param de se repetir
- O squad evolui com base em evidência, não em intuição

---

## Tempo Estimado

| Sessão simples | Sessão complexa |
|---|---|
| Passo 4 apenas: 2 min | Todos os 4 passos: 10-15 min |
