# Playbook: Apresentação Executiva — Deck C-Level e Board

> Aplicar para criação de decks, executive summaries e apresentações para diretoria, board ou cliente.
> Agente principal: `executive-storyteller`.
> Revisão obrigatória: `executive-reviewer` antes de qualquer entrega para cliente ou C-Level.

---

## Quando Usar Este Playbook

- Deck para reunião C-Level (CEO, CFO, COO, CTO)
- Board presentation
- Executive summary para cliente (Opea ou Edenred)
- Pitch de produto ou feature para aprovação executiva
- Apresentação de resultados de sprint / OKRs / KPIs
- Proposta de parceria ou go-to-market para stakeholders externos

---

## Pré-condições Obrigatórias

- [ ] Definir a audiência: CEO / CFO / Diretor / Board / Cliente externo
- [ ] Definir o objetivo: informar / persuadir / obter decisão / apresentar resultado
- [ ] Definir o nível de detalhe: executivo (máx. 10 slides) ou board (máx. 15 slides)
- [ ] Verificar se há números financeiros — se sim, validar com `payments-economics-analyst` antes
- [ ] Verificar se há impacto regulatório — se sim, consultar `financial-systems-architect`

---

## Execução — Passo a Passo

### Passo 1 — Definir a Decisão ou Ação Esperada

Toda apresentação executiva deve terminar com uma decisão solicitada ou próximos passos claros. Definir isso **antes** de estruturar o deck.

Exemplos:
- "Aprovação do orçamento de R$ X para o projeto Y"
- "Validação da estratégia de pricing para Q3"
- "Autorização para avançar com parceria Z"

Se não há decisão clara, o deck é informativo — estruturar como tal (sem pressão por aprovação ao final).

### Passo 2 — Estrutura com Framework SCR (Situação-Complicação-Resolução)

```
Situação     → O que é verdade hoje (fatos, contexto atual)
Complicação  → O que mudou / o problema / a oportunidade
Pergunta     → O que precisamos decidir ou resolver?
Resolução    → Recomendação direta + evidências
```

### Passo 3 — Estrutura de Slides

**Para C-Level (máx. 10 slides):**

| Slide | Conteúdo | Mensagem-chave |
|---|---|---|
| 1 | Título e posicionamento | Uma linha que define o tema |
| 2 | Situação atual | O que é verdade hoje |
| 3 | Complicação / Problema | O que mudou ou precisa mudar |
| 4 | Pergunta-chave | O que precisa ser decidido |
| 5 | Recomendação | A resposta direta — conclusão antes da evidência |
| 6-7 | Evidências | Dados, benchmarks, análises que sustentam |
| 8 | Alternativas descartadas | Por que as outras opções não foram escolhidas |
| 9 | Plano de ação | Próximos passos, responsáveis, prazo |
| 10 | Métricas de sucesso | Como saberemos que funcionou |

**Para Executive Summary (1 página):**

```
Contexto: [2-3 linhas — o que está acontecendo]
Problema: [1-2 linhas — o que precisa ser resolvido]
Recomendação: [1-2 linhas — o que fazer]
Impacto esperado: [financeiro + operacional + regulatório]
Próximos passos: [3-5 bullets com owner e prazo]
```

### Passo 4 — Regras de Mensagem por Slide

**Uma ideia por slide.** A mensagem-chave é uma frase completa que comunica a conclusão — não o tópico.

```
ERRADO:  "Análise de inadimplência CCB — Q1 2026"
CORRETO: "Inadimplência CCB cresceu 2,3pp em Q1 — ação imediata no processo de 
          originação reduz exposição em 18%"
```

Regras:
- Máximo 5 bullets por slide
- Conclusão primeiro, evidência depois
- Número sempre com contexto (vs. meta / período anterior / mercado)
- Linguagem ativa — nunca passiva em mensagens-chave

### Passo 5 — Validação de Dados

Antes de finalizar:
- [ ] Todos os números têm fonte ou origem declarada
- [ ] Comparativos estão presentes (vs. meta, vs. Q anterior, vs. benchmark)
- [ ] Premissas estão visíveis — não enterradas em notas
- [ ] Números financeiros foram validados pelo `payments-economics-analyst`

### Passo 6 — Calibração para a Audiência

| Audiência | Nível de detalhe | Linguagem | Foco |
|---|---|---|---|
| CEO | Mínimo — decisão + impacto | Estratégico, negócio | "Por que isso importa?" |
| CFO | Financeiro detalhado | Números, margem, risco | "Qual o impacto no P&L?" |
| CTO/CPO | Técnico + produto | Arquitetura, roadmap | "Como vamos construir?" |
| Board | Macro, governança | Risco, regulação, resultado | "Estamos expostos a quê?" |
| Cliente externo | Resultado do trabalho | Parceria, entrega, próximos passos | "O que foi feito / o que vem?" |

### Passo 7 — Revisão pelo Executive Reviewer

**Obrigatório** antes de qualquer entrega para cliente ou C-Level.

Passar o artefato para o `executive-reviewer` com:
- Contexto da audiência
- Objetivo da apresentação (decisão esperada)
- Qualquer restrição de conteúdo

---

## Checklist de Qualidade

- [ ] Decisão ou próximos passos claros ao final
- [ ] Mensagem principal visível em 30 segundos de leitura
- [ ] Nenhum slide com mais de 5 bullets
- [ ] Todos os números têm contexto comparativo
- [ ] Linguagem calibrada para a audiência
- [ ] Máx. 10 slides (C-Level) ou 15 slides (Board)
- [ ] Executive Reviewer aprovou antes da entrega

---

## Armadilhas Comuns (evitar)

- **"Data dump"** — apresentar todos os dados disponíveis em vez dos dados relevantes
- **Suspense invertido** — construir contexto antes de dar a conclusão (executivos não têm paciência)
- **Jargão não traduzido** — "SPI", "MDR", "FIDC" sem contexto para quem não é do setor
- **Premissas ocultas** — número defensável internamente mas que desmorona na primeira pergunta
- **Sem dono nos próximos passos** — ação sem responsável não é ação
