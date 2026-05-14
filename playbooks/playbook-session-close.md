# Playbook: Encerramento de Sessão

> Executar ao final de toda sessão com entrega significativa.
> Objetivo: garantir que memória, contexto e métricas sejam preservados para a próxima sessão.
> Agente coordenador: `context-manager` ou `orchestrator`.

---

## Quando Usar Este Playbook

**Obrigatório** se a sessão envolveu:
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
- Micro-tarefa de 1 agente concluída sem problemas

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

## Checklist de Encerramento

```
[ ] Passo 1 — task-memory registrada (se 2+ agentes ou erros)
[ ] Passo 2 — snapshot de contexto (se sessão longa ou multi-produto)
[ ] Passo 3 — decisão estratégica registrada (se houver)
[ ] Passo 4 — operations-log.md atualizado
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
