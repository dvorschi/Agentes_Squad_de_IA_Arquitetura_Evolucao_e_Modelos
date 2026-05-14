# Playbook: Ciclo Completo de Entrega por Sprint

> Aplicar no início de cada sprint ou entrega estruturada para o cliente.
> Garante rastreabilidade, qualidade e atualização da memória operacional do squad.

---

## Quando Usar Este Playbook

- Início de planejamento de nova sprint
- Entrega de features ou correções ao cliente (Opea ou Edenred)
- Ciclo completo de uma demanda que passa por múltiplos agentes
- Revisão de sprint (sprint review) com o cliente
- Qualquer entrega que precisa de rastreabilidade completa

---

## Visão Geral do Ciclo

```
Demanda recebida
       ↓
  Prompt Engineer (estrutura)
       ↓
  Orchestrator (plano de execução)
       ↓
  Agentes especializados (execução)
       ↓
  QA Test Engineer (validação técnica)
       ↓
  Executive Reviewer (validação executiva — se for para cliente)
       ↓
  Entrega ao cliente
       ↓
  Atualização de memória operacional
```

---

## Execução — Passo a Passo

### Fase 1 — Planejamento de Sprint

**Responsável:** PM + Orchestrator

1. Definir objetivo do sprint em uma frase (North Star da sprint)
2. Listar as histórias candidatas com estimativas
3. Priorizar por valor de negócio, risco técnico e dependências
4. Definir capacidade do time (em pontos ou dias)
5. Confirmar Definition of Ready para cada história:
   - [ ] Objetivo claro e escopo delimitado
   - [ ] Critérios de aceite escritos em BDD
   - [ ] Dependências mapeadas (externas e internas)
   - [ ] Estimativa de esforço validada

**Artefato de saída:** Sprint backlog priorizado com DoR validado

### Fase 2 — Estruturação pelo Prompt Engineer

Para demandas que saem da fast lane:

1. Receber a demanda bruta do PM
2. Aplicar o diagnóstico: objetivo / contexto / escopo / público / critérios de sucesso
3. Produzir o prompt refinado para o Orchestrator
4. Declarar riscos de interpretação explicitamente

**Artefato de saída:** Prompt refinado estruturado

### Fase 3 — Orquestração

1. Orchestrator recebe o prompt refinado
2. Classificar a tarefa: Simples / Média / Complexa / Crítica
3. Definir execution_mode: speed / balanced / enterprise / emergency
4. Selecionar agentes (máximo 5, justificar exceção)
5. Definir ordem: paralelo vs. sequencial
6. Produzir o Plano de Orquestração em markdown

**Artefato de saída:** Plano de Orquestração com tabela de agentes e ordem de atuação

> **Claude Code Agent View (Research Preview — mai/2026):** Para tarefas longas (geração de requisitos completos, modelagem financeira, deck executivo), usar `claude --bg "tarefa"` para disparar o agente em background e `claude agents` para monitorar todas as sessões ativas em painel unificado. Cada sessão recebe git worktree própria — sem conflitos de arquivo entre agentes simultâneos. Feature em Research Preview: testar antes de adotar como padrão obrigatório.

### Fase 4 — Execução pelos Agentes Especializados

Seguir a sequência definida no Plano de Orquestração.

**Para cada agente executor:**
- [ ] Ler o contexto do produto (context/business/opea.md ou edenred.md)
- [ ] Ler o playbook específico da tarefa (se existir)
- [ ] Executar dentro do escopo definido
- [ ] Documentar decisões relevantes tomadas durante a execução
- [ ] Sinalizar se algo fora do escopo foi identificado (sem executar)

### Fase 5 — Validação Técnica (QA)

**Responsável:** `qa-test-engineer`

1. Receber a entrega do agente executor
2. Executar o checklist de qualidade técnica
3. Validar happy path + edge cases + regressão
4. Se aprovado: emitir "QA APROVADO" com sumário
5. Se reprovado: emitir "QA REPROVADO — Retry N/2" com localização exata e correção específica

**Protocolo de retry:**
- Retry 1: agente executor corrige → QA re-valida
- Retry 2: agente executor corrige → QA re-valida
- Retry 3: "QA BLOQUEADO" → Orchestrator repleja com nova abordagem

### Fase 6 — Revisão Executiva (para entregas ao cliente)

**Responsável:** `executive-reviewer`

Obrigatório quando:
- Entrega vai diretamente para o cliente
- Artefato é deck, executive summary ou PRD compartilhado
- Apresentação para C-Level ou board

1. Executive Reviewer recebe o artefato aprovado pelo QA
2. Aplica os 6 filtros: clareza / hierarquia / consistência / completude / audiência / credibilidade
3. Se aprovado: "APROVADO para entrega"
4. Se reprovado: lista de ajustes com severidade

### Fase 7 — Entrega ao Cliente

1. Confirmar que QA aprovou (obrigatório)
2. Confirmar que Executive Reviewer aprovou (se aplicável)
3. Registrar a entrega no operations-log.md
4. Comunicar ao cliente com contexto: o que foi entregue, o que foi corrigido, o que vem a seguir

### Fase 8 — Atualização de Memória Operacional

**Após cada entrega — obrigatório:**

**AI Operations Analyst atualiza `memory/squad/operations-log.md`:**
```
| [data] | [produto] | [demanda] | [execution_mode] | [agentes] | [QA resultado] | [retries] | [obs] |
```

**Strategic Memory Manager atualiza `memory/squad/decisions/`:**
- Se houve decisão de produto relevante → `opea-decisions.md` ou `edenred-decisions.md`
- Se houve decisão técnica ou de processo → registrar com contexto completo

---

## Sprint Review com o Cliente

### Estrutura da Sprint Review

```
1. Objetivo do sprint (1 slide / 1 frase)
2. O que foi planejado vs. o que foi entregue
3. Demonstração das features entregues
4. Métricas do sprint (velocidade, qualidade, bugs resolvidos)
5. Impedimentos encontrados e como foram resolvidos
6. Próximo sprint: preview das prioridades
7. Perguntas e alinhamentos
```

### Artefato de Saída (Sprint Summary para o cliente)

```markdown
## Sprint [N] — [produto] | [datas]

### Objetivo
[Uma frase — o que o sprint pretendia entregar]

### Entregues
- [feature/fix 1]: [impacto para o cliente]
- [feature/fix 2]: [impacto para o cliente]

### Não entregues (e por quê)
- [item]: [motivo — técnico / prioridade / dependência]

### Métricas
- Stories planejadas: X | Entregues: Y | Taxa: Z%
- Bugs corrigidos: N
- Dívida técnica tratada: [sim/não — detalhe]

### Impedimentos resolvidos
- [impedimento]: [como foi resolvido]

### Preview próxima sprint
- [prioridade 1]
- [prioridade 2]
- [prioridade 3]
```

---

## Checklist de Fechamento de Sprint

- [ ] Todos os stories planejados foram entregues ou reclassificados
- [ ] QA aprovou todas as entregas de código
- [ ] Executive Reviewer aprovou artefatos que foram para o cliente
- [ ] Operations log atualizado
- [ ] Decisões relevantes registradas no Strategic Memory Manager
- [ ] Sprint Review com cliente realizado (se aplicável)
- [ ] Backlog da próxima sprint refinado e priorizado
- [ ] Impedimentos identificados foram documentados para retrospectiva
