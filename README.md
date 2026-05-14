# Squad de IA — Arquitetura, Evolução e Modelos de Trabalho

> Documento vivo. Descreve o squad de IA de produtos financeiros da BRQ Digital Solutions — sua origem, arquitetura atual, fluxos de trabalho e modelo de governança.
> Última atualização: 2026-05-14 | Versão atual: v1.8.1

---

## 1. Contexto e Objetivo

### Quem usa o squad

O squad foi construído para atender o trabalho de um **PM Sênior VI / Especialista em Produtos Financeiros** na BRQ Digital Solutions. O PM atua em dois clientes principais:

- **Opea** — originação, formalização, bancarização e Asset Ledger para instrumentos financeiros regulados pelo BACEN: CCB Imobiliário, CPR, CPRF, NC, CCV e PCV.
- **Edenred** — meios de pagamento, arranjo fechado (closed-loop), abastecimento, economics de MDR, interchange, adquirência, P&L e parcerias financeiras.

### O que o squad faz

O squad é um conjunto de agentes de IA especializados que trabalham de forma coordenada para:

- Estruturar decisões executivas e artefatos de produto
- Criar requisitos, épicos, features e critérios de aceite com precisão regulatória
- Modelar economics (MDR, P&L, unit economics, pricing)
- Construir apresentações C-Level
- Corrigir e evoluir artefatos técnicos (Sprint Board HTML)
- Monitorar regulação BACEN e novidades do mercado
- Manter memória estratégica entre sessões

### O que o squad NÃO é

- Não é um chatbot genérico. Cada agente tem escopo, ferramentas e regras de ouro específicos.
- Não é autônomo sem supervisão. Sugestões de melhoria aguardam aprovação humana antes de serem aplicadas.
- Não substitui decisão executiva. Estrutura, modela, analisa — a decisão final é sempre do PM.

---

## 2. Evolução do Squad

### v1.0 — Squad Fundacional

**Contexto:** Squad inicial com agentes genéricos do catálogo base do Claude Code.

**O que existia:**
- `prompt-engineer` — estruturação de demandas
- `orchestrator` — coordenação de agentes
- Agentes de engenharia genéricos (frontend, backend, QA, etc.)

**Problemas identificados:**
- Nenhum agente com contexto financeiro ou regulatório
- Sem contexto de produto (Opea, Edenred desconhecidos)
- Sem playbooks para tarefas repetidas
- Orchestrator sem critérios objetivos de seleção de agentes
- Fast lane subjetiva — difícil saber quando usar
- Nenhuma camada de economics ou dados
- Sem mecanismo de revisão executiva antes de entregas para cliente

---

### v1.1 — Instalação dos Agentes Especializados

**Contexto:** Diagnóstico da v1.0 identificou gaps críticos. Quatro agentes especializados foram instalados e enriquecidos.

**Agentes adicionados:**

| Agente | Função |
|---|---|
| `context-manager` | Gestão do estado operacional VIVO da sessão (substituiu agente genérico de infraestrutura que existia no arquivo) |
| `payments-economics-analyst` | Modelagem de MDR, P&L, unit economics, take rate, pricing |
| `solution-architect` | Arquitetura técnica ponta-a-ponta: APIs, event-driven, integrações SPB |
| `data-product-strategist` | KPIs, analytics strategy, dashboards executivos, cohort analysis |
| `executive-reviewer` | Última camada antes de entrega: valida clareza, consistência, prontidão executiva |

**Melhorias no `orchestrator`:**
- Adição das camadas "Economics e Dados" e "Arquitetura Financeira" no catálogo
- Boundaries explícitos documentados: CM vs SMM, SA vs FSA
- Fast lane com critérios objetivos para Sprint Board Opea
- Novos padrões de orquestração: Decisão de Pricing, Nova Feature Financeira, Produto Regulado

---

### v1.2 — Context Files, Playbooks e Revisão Executiva

**Contexto:** Agentes sem contexto de produto produzem saídas genéricas que precisam ser reescritas. Tarefas repetidas sem playbook reinventam a roda a cada execução.

**Context Files criados** (`context/`):

| Arquivo | Conteúdo |
|---|---|
| `context/business/opea.md` | Instrumentos financeiros, artefato Sprint Board, restrições técnicas críticas |
| `context/business/edenred.md` | Modelo de negócio, economics, arranjo fechado, métricas-chave |
| `context/business/brq.md` | Papel do PM, tom executivo, benchmarks de qualidade |
| `context/regulatory/bacen-normas.md` | Normas BACEN por produto: CCB, PIX, arranjos, KYC/AML, LGPD |

**Playbooks criados** (`playbooks/`):

| Arquivo | Cobre |
|---|---|
| `playbook-html-fix.md` | Correções e melhorias no Sprint Board Opea |
| `playbook-economics-model.md` | Modelagem de MDR, P&L, unit economics |
| `playbook-executive-deck.md` | Decks C-Level, executive summaries, SCR framework |
| `playbook-ccb-requirements.md` | Requisitos de features CCB e crédito regulado |
| `playbook-sprint-delivery.md` | Ciclo completo de entrega por sprint |

**Regra derivada:** Todo agente executor lê o context file do produto antes de iniciar qualquer tarefa. Tarefas com playbook correspondente seguem o playbook — elimina necessidade do Prompt Engineer em tarefas repetidas.

---

### v1.8.1 — Consistência Operacional

**O que foi corrigido:**
- `CLAUDE.md`: protocolo de encerramento de sessão + regra de manutenção do capability-registry
- `playbooks/playbook-session-close.md`: criado — 4 passos, checklist, critérios de quando aplicar cada passo
- `capability-registry.md`: protocolo de manutenção adicionado — quando/como/quem atualiza
- `Github/README.md`: atualizado para 25 agentes, tabela reorganizada por camada
- `Github/CLAUDE.md`: alinhado com CLAUDE.md principal

**Por que importa:** Sem o playbook-session-close, o task-memory-manager da v1.8.0 nunca seria acionado na prática. Sem o protocolo de manutenção, o capability-registry derivaria silenciosamente. São as peças que fecham o loop operacional.

---

### v1.8 — Camada de Operação: Runtime, Métricas e Inteligência Proativa

**Contexto:** Squad com cognição excelente mas zero runtime operacional. Sem memória de execução por tarefa, sem métricas por agente, sem motor de controle de dependências e retry, sem cascade proativo para alertas regulatórios. Esta versão fecha os gaps de operação dentro dos limites do Claude Code (session-based, sem infraestrutura externa).

**Novos agentes:**

| Agente | Função |
|---|---|
| `task-memory-manager` | Memória operacional por tarefa: agentes, decisões, erros, resolução, aprendizados. Armazena em `memory/squad/tasks/`. Acionar ao fim de toda entrega significativa. |
| `execution-engine` | Gerencia execução de planos: dependency graph, checkpoints, retry com contexto de falha, rollback controlado, execution log. Complementa o orchestrator (que planeja, não executa). |
| `capability-registry` | Matriz completa de capacidades: o que cada agente faz, não faz, inputs, outputs, dependências, riscos. Inclui gaps identificados. Consultar quando boundary for ambíguo. |
| `ai-metrics-analyst` | Métricas quantitativas: taxa de erro/retrabalho/uso por agente, alertas de saúde (subutilizado, redundante, caro), custo Opus vs Sonnet. Complementa o `ai-operations-analyst`. |

**Novos padrões de orquestração no orchestrator:**

| Padrão | Trigger | Fluxo |
|---|---|---|
| Cascade Proativo | ALERTA_CRITICO em suggestions/ | FSA → PM → executive-storyteller → executive-reviewer → novos itens em suggestions/ para aprovação |
| Análise de Performance | Periódico | ai-metrics-analyst → ai-operations-analyst → recomendações |
| Fim de Entrega | Pós-QA aprovado (enterprise/balanced com erros) | task-memory-manager registra execução |

**Nova infraestrutura:**
- `memory/squad/tasks/` — diretório de memória operacional por tarefa

**Squad total: 25 agentes** (21 anteriores + 4 novos de operação)

---

### v1.7 — Sub-agentes de Domínio (Onda 1 + Onda 2)

**Contexto:** Squad com 16 agentes bem definidos mas sem profundidade especializada em domínios de alto volume de uso. A decisão foi criar sub-agentes focados onde o ROI é imediato — CCB/Opea e Economics/Edenred.

**Sub-agentes criados:**

| Sub-agente | Pai | Domínio |
|---|---|---|
| `ccb-structuring-engine` | `financial-systems-architect` | Estruturação CCB: cláusulas, ICP-Brasil, imutabilidade, registro em registradora |
| `ledger-specialist` | `financial-systems-architect` | Asset Ledger, escrituração, gravames, alienação fiduciária, cessão, FIDC/CRI/CRA, CERC/Núclea |
| `spi-spb-architect` | `financial-systems-architect` | PIX/SPI: integração técnica, MED 2.0, DICT, bloqueio cautelar, arquitetura PSP |
| `mdr-pricing-analyst` | `payments-economics-analyst` | MDR decomposição, interchange, caps PAT, benchmarks competitivos, pricing por MCC/volume |
| `pnl-modeler` | `payments-economics-analyst` | P&L multi-cenário, unit economics, breakeven, LTV/CAC, projeção cohort-based |

**Padrão de uso:**
- **Pai:** amplitude regulatória e estratégica
- **Sub-agente:** profundidade técnica no domínio específico
- **Não acionar em paralelo** — ou o pai ou o sub-agente
- **Acesso direto permitido:** Orchestrator pode rotear direto ao sub-agente quando a demanda é exclusivamente do domínio

**Squad total:** 21 agentes (16 originais + 5 sub-agentes de domínio)

---

### v1.5 — Aplicação de Sugestões Críticas (PAT, PIX MED 2.0, Agent View)

**Contexto:** Research Agent identificou 3 mudanças críticas — 2 regulatórias já em vigor — que tornavam context files e playbooks incompatíveis com a realidade do mercado.

**O que foi atualizado:**

| Arquivo | Mudança |
|---|---|
| `context/business/edenred.md` | Adicionada seção "⚠️ CENÁRIO REGULATÓRIO PAT 2026" — 3 fases, tetos MDR 3,6% e intercâmbio 2%, impacto no modelo closed-loop |
| `context/regulatory/bacen-normas.md` | Adicionada seção "PIX — Obrigações Operacionais 2026" — MED 2.0, botão de contestação obrigatório, bloqueio cautelar 72h |
| `playbooks/playbook-economics-model.md` | Alerta PAT: premissas antigas vs. reguladas — MDR livre proibido para Edenred |
| `playbooks/playbook-sprint-delivery.md` | Nota Agent View — `claude --bg` e `claude agents` para pipelines paralelos |
| `knowledge/regulatory/interpretacoes-praticas.md` | Seção PIX atualizada com MED 2.0 (5 níveis de rastreamento, botão obrigatório) |
| `orchestrator.md` | Regra de ouro: `claude agents` para pipelines enterprise com agentes paralelos |

**Achados críticos que motivaram esta versão:**
- **PAT Fase 2** — em vigor desde 11/mai/2026. Edenred nominalmente afetada. Operadoras >500K trabalhadores devem abrir arranjos. O context file descrevia modelo incompatível com a regulação.
- **PIX MED 2.0** — em vigor desde 02/fev/2026. Botão de contestação obrigatório no comprovante PIX. Rastreamento de fraude em 5 níveis. Bloqueio cautelar de 72h.
- **Claude Code Agent View** — Research Preview mai/2026. Dashboard unificado de sessões paralelas via `claude agents`.

---

### v1.6 — Pacote de Publicação GitHub

**Contexto:** Squad estabilizado e documentado — empacotamento para publicação aberta no GitHub como referência para PMs de produtos financeiros.

**O que foi criado:** Pasta `Github/` com estrutura completa para publicação:

| Arquivo/Pasta | Conteúdo |
|---|---|
| `Github/README.md` | Descrição do squad, agentes, pré-requisitos, instalação rápida |
| `Github/INSTALL.md` | Guia de instalação manual passo a passo |
| `Github/install.ps1` | Instalador Windows (PowerShell) com suporte a `-Update` |
| `Github/install.sh` | Instalador Mac/Linux (Bash) com suporte a `--update` |
| `Github/CLAUDE.md` | Template com `[preencher]` em dados sensíveis de cliente |
| `Github/agents/` | 16 agentes squad-específicos (cópia verbatim) |
| `Github/context/business/` | Templates sanitizados: `produto-credito.md`, `produto-pagamentos.md`, `empresa.md` |
| `Github/context/regulatory/` | `bacen-normas.md` as-is (informação pública) |
| `Github/playbooks/` | 5 playbooks as-is |
| `Github/knowledge/` | 4 arquivos de knowledge base as-is |
| `Github/memory/squad/` | Templates limpos para decisions e operations-log |
| `Github/suggestions/README.md` | Estrutura com distinção ALERTA_CRITICO vs SUGESTAO_MELHORIA |
| `Github/approved/README.md` | Estrutura de histórico de governança |
| `Github/changelog/changelog.md` | Formato apenas, sem histórico real |
| `Github/Documentacao_Claude/` | squad-arquitetura-e-evolucao.md (cópia) |

**Regra de sync:** Toda evolução do squad atualiza em conjunto: `changelog/changelog.md` + `Documentacao_Claude/squad-arquitetura-e-evolucao.md` + `Github/Documentacao_Claude/squad-arquitetura-e-evolucao.md`.

---

### v1.3 — Sistema de Evolução Contínua

**Contexto:** Squad com boa execução mas sem mecanismo de aprendizado e atualização. Knowledge base estática, sem monitoramento regulatório, sem registro de decisões.

**O que foi construído:**

**Knowledge Base** (`knowledge/`):

| Arquivo | Conteúdo |
|---|---|
| `knowledge/banking/ecossistema-bancario-brasil.md` | SFN, tipos de instituições autorizadas, STR, SPI, BaaS, Open Finance |
| `knowledge/payments/infraestrutura-pagamentos.md` | Ecossistema de cartões, MDR, PIX, sub-adquirência, agenda de recebíveis, arranjos fechados |
| `knowledge/regulatory/interpretacoes-praticas.md` | Aplicação prática de CCB, PIX, KYC, arranjos fechados, LGPD, red flags BACEN |
| `knowledge/squad-learnings/padroes-e-aprendizados.md` | Bugs conhecidos, padrões de orquestração, decisões de arquitetura do squad |

**Infraestrutura de Memória** (`memory/squad/`):

| Arquivo | Responsável |
|---|---|
| `memory/squad/decisions/opea-decisions.md` | Strategic Memory Manager — decisões estratégicas do produto Opea |
| `memory/squad/decisions/edenred-decisions.md` | Strategic Memory Manager — decisões estratégicas do produto Edenred |
| `memory/squad/operations-log.md` | AI Operations Analyst — log de operações, métricas de performance do squad |

**Governança de Sugestões** (`suggestions/`, `approved/`, `changelog/`):
- Suggestions: sugestões aguardando aprovação
- Approved: histórico de decisões aprovadas
- Changelog: registro versionado de todas as mudanças no squad

**Research Agent** (`research-agent.md`):
- Monitoramento de BACEN, PIX, fintech, Claude/Anthropic
- Busca dinâmica de novas fontes a cada execução
- Cria sugestões — nunca aplica mudanças diretamente
- Distingue ALERTA_CRITICO (prazo regulatório) de SUGESTAO_MELHORIA

**Rotina agendada:** 9:30h seg-sex — verifica pendências em `suggestions/` e oferece opções de Research Agent.

---

## 3. Arquitetura Atual

### Diagrama de Camadas

```
┌─────────────────────────────────────────────────────────┐
│                  CAMADA DE INTELIGÊNCIA                  │
│            prompt-engineer → orchestrator                │
└─────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────┐
│                CAMADA DE PRODUTO E ESTRATÉGIA            │
│         product-manager │ executive-storyteller          │
└─────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────┐
│           CAMADA DE ARQUITETURA FINANCEIRA               │
│  financial-systems-architect │ solution-architect        │
│  business-analyst-financeiro │ technical-lead            │
└─────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────┐
│              CAMADA DE ECONOMICS E DADOS                 │
│  payments-economics-analyst │ data-product-strategist    │
└─────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────┐
│              CAMADA DE EXECUÇÃO                          │
│   frontend │ backend │ fullstack │ devops │ security     │
└─────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────┐
│               CAMADA DE QA E QUALIDADE                   │
│   qa-test-engineer (código) │ executive-reviewer (exec)  │
└─────────────────────────────────────────────────────────┘
                            ↑
┌─────────────────────────────────────────────────────────┐
│           CAMADA DE MEMÓRIA E OPERAÇÃO                   │
│  context-manager │ strategic-memory-manager              │
│  ai-operations-analyst │ research-agent                  │
└─────────────────────────────────────────────────────────┘
```

---

## 4. Catálogo de Agentes por Camada

### Camada de Inteligência

| Agente | Modelo | Responsabilidade |
|---|---|---|
| **prompt-engineer** | sonnet | Estrutura e refina o prompt antes de qualquer execução. Acionado sempre como primeiro passo. |
| **orchestrator** | sonnet | Recebe prompt refinado, seleciona agentes, define sequência, cria plano de execução. Nunca edita arquivos. |

### Camada de Produto e Estratégia

| Agente | Modelo | Responsabilidade |
|---|---|---|
| **product-manager** | sonnet | PRDs, épicos, features, histórias de usuário, critérios de aceite, OKRs, roadmaps, backlog. |
| **executive-storyteller** | opus | Apresentações C-Level, board decks, executive summaries, narrativas estratégicas. |

### Camada de Memória e Operação

| Agente | Modelo | Responsabilidade |
|---|---|---|
| **context-manager** | sonnet | Estado operacional VIVO da sessão: snapshots, handoffs entre agentes, compressão de contexto. **Gerencia o PRESENTE.** |
| **strategic-memory-manager** | sonnet | Memória histórica permanente: decisões estratégicas, glossário, padrões aprovados. **Gerencia o PASSADO.** |
| **task-memory-manager** | sonnet | Memória operacional por tarefa: agentes envolvidos, decisões, erros, resolução, aprendizados. Acionar ao fim de entregas significativas. Armazena em `memory/squad/tasks/`. |
| **execution-engine** | sonnet | Gerencia execução de planos do orchestrator: dependency graph, checkpoints, retry com contexto, rollback, execution log. |
| **capability-registry** | sonnet | Matriz de capacidades do squad: o que cada agente faz, não faz, inputs/outputs, dependências, gaps. Consultar quando boundary for ambíguo. |
| **ai-operations-analyst** | sonnet | Análise qualitativa de processo: performance geral, gargalos, melhorias operacionais. |
| **ai-metrics-analyst** | sonnet | Análise quantitativa: taxa de erro/retrabalho/uso por agente, alertas de saúde, custo Opus vs Sonnet. Complementa o ai-operations-analyst. |
| **research-agent** | sonnet | Inteligência externa: BACEN, PIX, fintech, Claude/Anthropic. Busca novas fontes dinamicamente. Cria sugestões — nunca aplica. |

### Camada de Arquitetura Financeira

| Agente | Modelo | Responsabilidade |
|---|---|---|
| **financial-systems-architect** | opus | **O QUÊ**: regulação BACEN, conformidade, fluxo financeiro correto, CCB, PIX, arranjos, CERC, Núclea. |
| **solution-architect** | opus | **COMO**: arquitetura técnica ponta-a-ponta, APIs, event-driven, integrações SPB. Read-only — nunca escreve código. |
| **business-analyst-financeiro** | sonnet | Discovery, AS-IS/TO-BE, BPMN, regras de negócio, gaps funcionais, refinamento pré-PM. |
| **technical-lead** | sonnet | Trade-offs técnicos, define abordagem de implementação, orienta executores, evita overengineering. |

### Camada de Economics e Dados

| Agente | Modelo | Responsabilidade |
|---|---|---|
| **payments-economics-analyst** | sonnet | MDR, interchange, P&L, unit economics, take rate, revenue share, pricing, viabilidade econômica. |
| **data-product-strategist** | sonnet | KPIs de produto, analytics strategy, dashboards executivos, cohort analysis, BI para Opea e Edenred. |

### Camada de QA e Qualidade

| Agente | Modelo | Responsabilidade |
|---|---|---|
| **qa-test-engineer** | sonnet | Validação técnica pré-entrega: código, fluxos, dados, regressão. Obrigatório em toda entrega com código. |
| **executive-reviewer** | opus | Validação executiva: narrativa, clareza, consistência numérica. Obrigatório antes de entrega para cliente ou C-Level. |

### Sub-agentes de Domínio (Onda 1 + Onda 2)

| Sub-agente | Pai | Modelo | Domínio |
|---|---|---|---|
| **ccb-structuring-engine** | financial-systems-architect | opus | Estruturação CCB: cláusulas obrigatórias, ICP-Brasil, imutabilidade, registro, CCB Imobiliário, CPR, NC |
| **ledger-specialist** | financial-systems-architect | opus | Asset Ledger, escrituração, gravames, alienação fiduciária, cessão de crédito, FIDC/CRI/CRA, CERC/Núclea |
| **spi-spb-architect** | financial-systems-architect | opus | PIX/SPI: integração ICOM, MED 2.0, DICT, bloqueio cautelar 72h, arquitetura de PSP no SPB |
| **mdr-pricing-analyst** | payments-economics-analyst | sonnet | MDR decomposição, interchange por bandeira, caps PAT (3,6%/2%), benchmarks competitivos, pricing por MCC |
| **pnl-modeler** | payments-economics-analyst | sonnet | P&L multi-cenário, unit economics, breakeven, LTV/CAC, análise de sensibilidade, projeção cohort |

### Demais camadas (engenharia, infra, segurança, dados)

Frontend, backend, fullstack, DevOps, segurança, dados — ver catálogo completo no `orchestrator.md`.

---

## 5. Fluxo de Trabalho Padrão

### Pipeline Completo

```
Usuário
  ↓ demanda
[1] prompt-engineer — estrutura e refina o prompt
  ↓ prompt refinado
[2] orchestrator — seleciona agentes, define execução_mode, cria plano
  ↓ plano de orquestração
[3] agentes especializados — executam em paralelo ou sequência conforme plano
  ↓ entregáveis
[4] qa-test-engineer — valida código (se houver)
[4] executive-reviewer — valida narrativa (se for entrega executiva)
  ↓ entrega validada
Usuário
```

**Exceções ao pipeline padrão:**

| Exceção | Quando | O que muda |
|---|---|---|
| **Fast Lane** | Micro-tarefas com critérios objetivos | Pula PE e Orchestrator — direto para execução + QA |
| **Conversacional** | Pergunta, explicação, exploração de conceito | Resposta direta, sem agentes |

---

## 6. Modos de Execução

O `execution_mode` é definido pelo Orchestrator **antes** de selecionar os agentes.

| Modo | Máx. agentes | Quando usar | Agentes típicos |
|---|---|---|---|
| **speed** | 2 | Bug simples, ajuste de texto, correção pontual, micro-tarefa | executor + qa-test-engineer |
| **balanced** | 4 | Feature nova simples, apresentação, economics, sem impacto regulatório | technical-lead + executor + qa-test-engineer ± especialista |
| **enterprise** | 6 | Feature regulada, novo produto, integração sistêmica, impacto em múltiplos fluxos | business-analyst-financeiro + FSA + SA + technical-lead + executor + QA |
| **emergency** | 3 | P0 em produção, dado incorreto, rollback necessário | debugger + error-detective + executor + QA |

---

## 7. Fast Lane — Critérios Objetivos

A fast lane elimina a overhead de PE + Orchestrator para micro-tarefas de baixo risco.

**Critérios obrigatórios — TODOS devem ser verdadeiros:**
- Arquivo único
- Mudança pontual e bem delimitada
- Risco baixo (sem impacto em outros fluxos)
- Agente único óbvio

**Fast Lane Automática — Sprint Board Opea (`opea_sprint_planner_*.html`)**

Qualificam automaticamente:
- Correção de texto, label, placeholder ou cópia
- Ajuste de cor, espaçamento, tamanho de fonte (CSS pontual)
- Correção de variável `let` para `window.*`
- Ajuste de lógica de exibição condicional
- Correção de cálculo isolado em função específica
- Adição de campo de texto ou dropdown sem nova lógica de estado

Excluem a fast lane:
- Mudança que afeta localStorage
- Mudança que impacta mais de 2 funções interdependentes
- Nova feature com estado próprio
- Qualquer mudança em modo executivo/apresentação

---

## 8. Padrões de Orquestração

### Fast Lane (micro-tarefas)
```
1. [Execução] agente especialista
2. [Validação] qa-test-engineer
```

### Tarefa de Código (feature, bug fix)
```
1. [Análise] code-reviewer
2. [Execução] frontend / fullstack
3. [Validação] qa-test-engineer
```

### Apresentação C-Level
```
execution_mode: balanced
Playbook: playbook-executive-deck.md
1. [Narrativa] executive-storyteller
2. [Dados] payments-economics-analyst ou data-product-strategist
3. [Revisão] executive-reviewer
```

### Nova Feature Financeira
```
execution_mode: enterprise
1. [Discovery] business-analyst-financeiro
2. [Economics] payments-economics-analyst
3. [Produto] product-manager
4. [Regulação] financial-systems-architect
5. [Arquitetura] solution-architect
6. [Liderança] technical-lead
7. [Execução] executor
8. [Validação] qa-test-engineer
```

### Produto Regulado / BACEN / CCB / Pagamentos
```
execution_mode: enterprise
1. [Discovery] business-analyst-financeiro
2. [Economics] payments-economics-analyst
3. [Regulação] financial-systems-architect
4. [Arquitetura] solution-architect
5. [Compliance] compliance-auditor
6. [Produto] product-manager
7. [Validação] qa-test-engineer
```

### Decisão de Pricing / Economics
```
execution_mode: balanced
1. [Modelagem] payments-economics-analyst
2. [Regulação] financial-systems-architect
3. [Produto] product-manager
4. [Narrativa] executive-storyteller
```

### Pesquisa Regulatória / Inteligência Externa
```
execution_mode: speed
1. [Pesquisa] research-agent (protocolo completo)
   — busca fontes novas + verifica prioritárias
   — filtra por relevância Opea/Edenred
   — atualiza knowledge base
   — cria sugestões em suggestions/
   — gera relatório
```

### Melhoria Contínua do Squad
```
execution_mode: balanced
1. [Análise] ai-operations-analyst
2. [Contexto] context-manager
3. [Memória] strategic-memory-manager
4. [Orquestração] orchestrator
5. [Prompt] prompt-engineer
```

---

## 9. Infraestrutura de Conhecimento

### Context Files (`context/`) — O que é o produto

Briefing de produto. Leitura obrigatória antes de qualquer tarefa relacionada ao produto.

| Arquivo | Conteúdo |
|---|---|
| `context/business/opea.md` | Instrumentos financeiros, Sprint Board (restrições técnicas absolutas), AS-IS dos fluxos |
| `context/business/edenred.md` | Modelo de negócio, arranjo fechado, economics, métricas-chave |
| `context/business/brq.md` | Papel do PM, tom executivo, benchmarks de qualidade |
| `context/regulatory/bacen-normas.md` | Normas BACEN por produto |

### Playbooks (`playbooks/`) — Como fazer

Protocolo de execução para tarefas repetidas. Elimina retrabalho e garante consistência.

| Arquivo | Cobre |
|---|---|
| `playbook-html-fix.md` | Sprint Board: diagnóstico → mudança → regressão → QA |
| `playbook-economics-model.md` | MDR, P&L, unit economics: 10 passos + templates |
| `playbook-executive-deck.md` | Decks C-Level: SCR framework, max slides, executive reviewer obrigatório |
| `playbook-ccb-requirements.md` | Requisitos CCB: ICP-Brasil, imutabilidade, registradora, BDD/Gherkin |
| `playbook-sprint-delivery.md` | Ciclo de entrega: planning → PE → execução → QA → cliente → memória |

### Knowledge Base (`knowledge/`) — Por que o mercado funciona assim

Conhecimento de domínio financeiro. Atualizado pelo Research Agent.

| Arquivo | Cobre |
|---|---|
| `knowledge/banking/ecossistema-bancario-brasil.md` | SFN, SPB, BaaS, Open Finance |
| `knowledge/payments/infraestrutura-pagamentos.md` | Cartões, MDR, PIX, recebíveis, chargebacks |
| `knowledge/regulatory/interpretacoes-praticas.md` | CCB, PIX, KYC, arranjos, LGPD aplicada |
| `knowledge/squad-learnings/padroes-e-aprendizados.md` | Bugs do squad, padrões aprovados, armadilhas |

### Memória do Squad (`memory/squad/`) — O que decidimos

| Arquivo | Responsável | Conteúdo |
|---|---|---|
| `decisions/opea-decisions.md` | Strategic Memory Manager | Decisões estratégicas de produto/regulação Opea |
| `decisions/edenred-decisions.md` | Strategic Memory Manager | Decisões estratégicas de produto/economics Edenred |
| `operations-log.md` | AI Operations Analyst | Log de execuções, métricas de performance |

---

## 10. Governança e Evolução Contínua

### Ciclo de Evolução

```
Research Agent encontra novidade
        ↓
Cria arquivo em suggestions/
  tipo: ALERTA_CRITICO (urgente) ou SUGESTAO_MELHORIA (normal)
        ↓
Usuário é alertado no início da próxima sessão
        ↓
Usuário aprova, rejeita ou modifica
        ↓
Aprovada: mover para approved/ + aplicar mudança + atualizar changelog/
Rejeitada: arquivar com motivo
```

### Verificação Obrigatória no Início de Sessão

Ao iniciar qualquer sessão:
1. Verificar arquivos com status `PENDENTE` em `suggestions/`
2. Se houver: alertar o usuário antes de qualquer outra atividade
3. Se não houver: prosseguir normalmente

### Rotina Diária (9:30h seg-sex)

A rotina agendada:
1. Verifica `suggestions/` e lista pendências
2. Pergunta ao usuário qual modo do Research Agent executar:
   - **A** — Varredura completa
   - **B** — Foco regulatório BACEN
   - **C** — Foco Anthropic/Claude
   - **D** — Pular hoje

### Obrigações Pós-Entrega

Após qualquer mudança no squad:
- Registrar entrada em `changelog/changelog.md`
- Atualizar `Documentacao_Claude/squad-arquitetura-e-evolucao.md`
- Sincronizar `Github/Documentacao_Claude/squad-arquitetura-e-evolucao.md` (cópia do item acima)
- Acionar Strategic Memory Manager se for decisão estratégica

---

## 11. Decisões de Arquitetura do Squad

### Boundary: context-manager vs strategic-memory-manager

| | context-manager | strategic-memory-manager |
|---|---|---|
| **O que gerencia** | Estado operacional VIVO da sessão atual | Decisões históricas permanentes |
| **Horizonte temporal** | Presente (esta sessão) | Passado (histórico acumulado) |
| **Quando acionar** | Sessões longas, multi-produto, handoffs entre agentes | Após decisão estratégica, entrega enterprise |
| **Onde persiste** | Contexto da sessão | `memory/squad/decisions/` |

**Por que importa:** Confundir os dois leva o CM a registrar coisas que deveriam ser esquecidas, e o SMM a ter contexto de sessão desnecessariamente.

### Boundary: financial-systems-architect vs solution-architect

| | financial-systems-architect | solution-architect |
|---|---|---|
| **Pergunta que responde** | O QUÊ precisa ser feito | COMO fazer tecnicamente |
| **Domínio** | Regulação, compliance, fluxo financeiro | APIs, event-driven, microservices, resiliência |
| **Quando acionar** | Qualquer feature de produto financeiro regulado | Qualquer nova integração ou arquitetura de serviço |
| **Ordem** | Antes do SA | Depois do FSA, antes do Technical Lead |

**Por que importa:** O FSA define os requisitos regulatórios. O SA define como atendê-los tecnicamente. Inverter a ordem leva a arquitetura técnica sem validação regulatória.

### Seleção de Modelo por Tipo de Tarefa

| Modelo | Quando usar |
|---|---|
| **Opus** | Análise financeira complexa, revisão arquitetural, decisões regulatórias de alto risco, executive-reviewer, FSA, SA, executive-storyteller |
| **Sonnet** | A maioria das tarefas: PM, BA, payments-economics-analyst, QA, research-agent, orchestrator |

**Por que importa:** Opus tem custo e latência maiores. Usar onde o nível de raciocínio justifica o custo.

### Agente de QA único para produtos financeiros

O `qa-test-engineer` customizado é o único agente de QA acionado para validação de código em produtos financeiros. O `qa-expert` genérico é redundante nesse contexto.

---

## 12. Aprendizados Técnicos

### Bug #1 — `let` vs `window.*` em HTML standalone

**Sintoma:** Dados de uma aba exibindo informações do produto errado. Calculadora bloqueada.
**Causa:** `let` tem escopo de bloco — em artifact viewers, o isolamento cria escopo separado para cada bloco.
**Regra:** Toda variável global compartilhada usa `window.nomeVariavel`, nunca `let`/`const`.

### Bug #2 — `data:` URL vs `srcdoc` em iframes

**Sintoma:** Calculadora integrada não abria no artifact viewer.
**Causa:** `data:` URL é bloqueado por política de segurança em artifact viewers e browsers modernos.
**Regra:** Iframes com conteúdo inline usam `srcdoc="..."`, nunca `src="data:text/html,..."`.

### Padrão de orquestração que reduz retrabalho

Quando o agente pula a leitura do context file antes de executar, a taxa de retrabalho sobe. Leitura obrigatória do context file é enforçada no início de toda execução de produto.

### Armadilhas a evitar

| Armadilha | Como evitar |
|---|---|
| Modificar o que não foi solicitado no Sprint Board (~8.000 linhas) | Ler escopo com atenção, tocar só o necessário |
| Criar agente novo para cobrir sobreposição | Verificar catálogo antes de criar — ajustar boundary se necessário |
| Usar Opus onde Sonnet resolve | Opus apenas para análise financeira complexa, revisão arquitetural, decisões regulatórias de alto risco |
| Assumir premissas sem declarar | Sempre declarar premissas com fonte ou grau de incerteza |

---

## 13. Referência Rápida — Quando Acionar Cada Agente

| Situação | Agentes principais |
|---|---|
| Pedido de feature nova no Sprint Board | fast lane (html-fix) ou balanced com technical-lead + frontend + QA |
| Preciso de requisitos para feature de CCB | business-analyst-financeiro → financial-systems-architect → product-manager |
| Preciso modelar MDR ou P&L | payments-economics-analyst (playbook-economics-model.md) |
| Preciso de apresentação para C-Level | executive-storyteller → payments-economics-analyst → executive-reviewer |
| Tem bug crítico em produção | emergency: debugger → error-detective → executor → QA |
| Preciso saber se novidade regulatória afeta produto | research-agent → financial-systems-architect |
| Preciso saber como integrar com registradora | solution-architect (após FSA definir o quê) |
| Preciso de dashboard de KPIs | data-product-strategist |
| Sessão longa com múltiplos produtos | context-manager ao trocar de Opea para Edenred |

---

*Documento gerado em 2026-05-14. Atualizar após cada evolução relevante do squad via `changelog/changelog.md`.*
