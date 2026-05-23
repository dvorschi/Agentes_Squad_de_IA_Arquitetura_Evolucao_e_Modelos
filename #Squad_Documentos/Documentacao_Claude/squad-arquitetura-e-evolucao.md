# Squad de IA — Arquitetura, Evolução e Modelos de Trabalho

> Documento vivo. Descreve o squad de IA de produtos financeiros da BRQ Digital Solutions — sua origem, arquitetura atual, fluxos de trabalho e modelo de governança.
> Última atualização: 2026-05-23 | Versão atual: v1.9.14

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

### v1.9.3 — Sistema de Versionamento Edenred Sprint Board + Skill `/edenred_jira`

**Contexto:** PM solicitou paridade com o sistema de versionamento do Opea Sprint Board (v1.9.2). O artefato Edenred (edenred_sprint_board_mobbyhub.html) e a calculadora de multi-serviços (anteriormente versionada ad-hoc como v6, v7, v8) agora têm controle semântico de versão, estrutura de pastas por versão, CHANGELOG.md por entrega e espelho para GitHub.

**O que foi construído:**

| Caminho | Descrição |
|---|---|
| `Edenred_Jira/edenred_sprint_board/vX.Y.Z/` | Versão versionada do HTML com CHANGELOG.md |
| `Edenred_Jira/edenred_sprint_board/calculadoras/vX.Y.Z/` | Calculadora multi-serviços versionada com CHANGELOG.md |
| `Edenred_Jira/edenred_sprint_board/README.md` | Índice de versões e convenção semântica |
| `Edenred_Jira/github/edenred_sprint_board/` | Espelho sincronizado para publicação no GitHub |
| `.claude/commands/edenred_jira.md` | Skill com protocolo completo de desenvolvimento e versionamento automático |

**Versão baseline:** v1.0.0 (18/05) — migração do histórico ad-hoc (v6, v7, v8) para versionamento semântico

**Convenção:** MAJOR.MINOR.PATCH — Redesign / Feature / Bug fix (idêntico ao Opea)

**Fluxo automatizado pelo skill `/edenred_jira`:**
1. Apresentar solução → aguardar aprovação → implementar
2. Calcular nova versão → criar pasta vX.Y.Z/ → CHANGELOG.md → atualizar README → sincronizar github/

---

### v1.9.14 — Calibração de Usuário no CLAUDE.md (2026-05-23)

**Contexto:** Documento pessoal do PM (CLAUDE.md — Vitor Hugo Dvorschi) identificado como fonte de calibrações que o agente não conhecia: frame mental, analogias específicas, princípios de trabalho e workflows por tipo de tarefa.

**O que foi implementado:**

| Artefato | Mudança |
|---|---|
| `CLAUDE.md` | ADICIONADO — seção `# CALIBRAÇÃO DE COMUNICAÇÃO`: idioma/tom, calibração de senioridade, 5 analogias de referência, 6 princípios inegociáveis. 233 → 265 linhas. |
| `context/templates/workflows.md` | CRIADO — 5 workflows padrão por tipo de tarefa: Decisão de Produto, PRD, Análise Executiva, Pesquisa/Benchmarking, Arquitetura de IA. |

**Por que importa:** Sem as analogias e princípios, o agente não tem como usar o frame mental do usuário ao explicar conceitos ou priorizar soluções. Os princípios inegociáveis funcionam como filtro implícito em toda resposta.

---

### v1.9.13 — Modularização do CLAUDE.md + Limpeza de Ruído Semântico (2026-05-23)

**Contexto:** Análise multi-agente (prompt-engineer, architect-reviewer, technical-lead) identificou que o CLAUDE.md tinha um bug crítico de formato: 810 das 852 linhas estavam embrulhadas em um wrapper Python morto que nunca executava, gerando ruído semântico. Adicionalmente, a identidade do agente aparecia 5 vezes em seções diferentes, e templates de entrega eram carregados em cada sessão mesmo quando não usados (~7k tokens/sessão de overhead).

**O que foi implementado:**

| Artefato | Mudança |
|---|---|
| `CLAUDE.md` | REFATORADO — 852 → 233 linhas (73% de redução). Wrapper Python removido. Seções redundantes eliminadas: IDENTIDADE DO AGENTE, ÁREAS DE ESPECIALIDADE (~130 linhas em 5 subseções), MENTALIDADE ESPERADA, RESULTADO ESPERADO, PADRÃO DE QUALIDADE. Contexto profissional comprimido para 2 linhas. Seção "Leitura Obrigatória" (context files, playbooks, knowledge base) adicionada diretamente no CLAUDE.md raiz. |
| `Opea_Jira/CLAUDE.md` | CRIADO — Contexto do projeto Opea (ativos CCB/CPR/CPRF/NC/CCV/PCV, temas, objetivo, versão atual do Sprint Board). Carregado automaticamente pelo Claude Code ao trabalhar na pasta. |
| `Edenred_Jira/CLAUDE.md` | CRIADO — Contexto do projeto Edenred (temas MDR/interchange/TPV, economics, objetivo, versão atual). Idem. |
| `context/templates/apresentacoes.md` | CRIADO — Template de apresentações executivas C-Level extraído do CLAUDE.md |
| `context/templates/requisitos.md` | CRIADO — Template de requisitos & produto (12 seções) |
| `context/templates/economics.md` | CRIADO — Template de economics & P&L com variáveis e diferenciações |
| `context/templates/ux-discovery.md` | CRIADO — Template de UX e discovery |
| `context/templates/analytics.md` | CRIADO — Template de big data & analytics com 5 categorias de indicadores |
| `context/templates/engenharia.md` | CRIADO — Template de engenharia, dev e automação |
| `context/templates/compliance.md` | CRIADO — Template de compliance & regulação |

**Estrutura modular resultante:**
```
CLAUDE.md raiz (~233 linhas)      ← identidade + modelo raciocínio + governança + leitura obrigatória
Opea_Jira/CLAUDE.md               ← contexto Opea (carregado automaticamente na pasta)
Edenred_Jira/CLAUDE.md            ← contexto Edenred (carregado automaticamente na pasta)
context/templates/*.md (7 arquivos) ← templates de entrega, consultados sob demanda
```

**Por que importa:** Token budget liberado (~5k tokens/sessão). Contexto de projetos isolado por pasta (não carrega Edenred quando trabalhando em Opea e vice-versa). Templates ficam disponíveis para consulta sem poluir o contexto base. Bug crítico do wrapper Python corrigido.

---

### v1.9.12 — Quadro de Cerimônias na Visão Geral (2026-05-21)

**Contexto:** Squad sem visibilidade centralizada das cerimônias ativas e suas últimas realizações no dashboard visual.

**O que foi implementado:**
- `Organizacao_Squad/squad-overview.html`: Adicionado quadro de cerimônias na aba Visão Geral — Daily (Seg–Sex 09:30), Planning (Seg, início de sprint), Review/Demo e Retrospectiva (Sex, fim de sprint), com resumo da última sessão de cada cerimônia.

---

### v1.9.11 — Dashboard Visual + Consolidação de Documentação (2026-05-21)

**Contexto:** Squad sem artefato visual consolidado — quem precisava entender a arquitetura, agentes ou governança tinha que ler múltiplos arquivos de texto. Documentação dividida entre raiz `Documentacao_Claude/` e `Github/Documentacao_Claude/`, criando risco de dessincronização.

**O que foi implementado:**

| Artefato | Mudança |
|---|---|
| `Organizacao_Squad/squad-overview.html` | CRIADO — dashboard premium HTML standalone (90KB, 8 abas): visão executiva, arquitetura de camadas, 27 agentes com filtro, 4 modos de execução, 4 skills com contexto 2+2, 6 playbooks, knowledge base, governança e timeline de evolução v1.0→v1.9.11 |
| `Organizacao_Squad/COMO-ATUALIZAR.md` | CRIADO — protocolo de atualização do dashboard: quando atualizar, o que mudar no HTML para cada tipo de evolução, fluxo completo de 6 passos |
| `Github/Organizacao_Squad/` | CRIADO — espelho de `Organizacao_Squad/` na pasta de publicação Github/ |
| `Github/Documentacao_Claude/` | CONSOLIDADO — pasta raiz `Documentacao_Claude/` removida; `Github/Documentacao_Claude/` passa a ser fonte única |
| `Github/CLAUDE.md`, `CLAUDE.md`, `memory/feedback_documentacao_squad.md` | ATUALIZADOS — todos os protocolos, memória e playbooks refletem nova cadeia de sync (4 arquivos obrigatórios) |

**Nova cadeia de sync obrigatória:**
1. `changelog/changelog.md`
2. `Github/Documentacao_Claude/squad-arquitetura-e-evolucao.md` (fonte única)
3. `Organizacao_Squad/squad-overview.html`
4. `Github/Organizacao_Squad/squad-overview.html`

**Por que importa:** O squad agora tem um artefato visual de referência — qualquer pessoa (PM, novo agente, stakeholder) pode abrir o HTML no browser e entender o squad completo em 2 minutos. A consolidação da Documentacao_Claude elimina o risco de divergência entre cópias.

---

### v1.9.10 — Rotina de Estudos: Governança de Sugestões + Stack Técnica + Curadoria de Memória (2026-05-20)

**Contexto:** PM compartilhou proposta de AI externo para "rotina de estudos" com Python/LangGraph/SQLite e 5 novos agentes. Squad analisou (ai-operations-analyst, technical-lead, capability-registry) e concluiu: infraestrutura overengineered para ambiente session-based, 5 agentes propostos redundantes com existentes. Resultado: 6 ajustes cirúrgicos aprovados. PM autorizou override explícito do congelamento de features ativo (2026-05-20 a 2026-06-03).

**O que foi implementado:**

| Artefato | Mudança |
|---|---|
| `rejected/README.md` | CRIADO — pasta e protocolo para sugestões rejeitadas com formato obrigatório (motivo + condição para reavaliar). Fecha o ciclo de governança das sugestões. |
| `.claude/agents/research-agent.md` | ATUALIZADO — monitoramento de Stack Técnica: 2 queries na Etapa 1 (Claude Code updates, Python AI stack), 3 novas fontes na Etapa 2 (Claude Code Releases, Anthropic SDK Python, FastAPI Releases), filtro de Stack Técnica na Etapa 3, seção "Novidades Stack Técnica" no template de relatório |
| `.claude/agents/strategic-memory-manager.md` | ATUALIZADO — Protocolo de Curadoria Periódica: revisão mensal (ou a cada 50 novos arquivos) com regras para revogação, supersede, consolidação e saída obrigatória em `decisions/curadoria-[YYYY-MM].md` |
| `.claude/agents/ai-operations-analyst.md` | ATUALIZADO — Análise de Consistência Arquitetural adicionada (5 verificações: boundaries duplicados, referências quebradas, conflitos de regra, contagem do squad, cobertura de fluxos) + nova linha na Cadência de Análise |
| `Github/README.md` | CORRIGIDO — conflito de merge resolvido (mantida versão HEAD simples), contagem atualizada 25→27 agentes, ux-researcher e frontend-developer adicionados |
| `Github/CLAUDE.md` | CORRIGIDO — 3 placeholders [preencher] substituídos por dados reais (cargo BRQ, Opea, Edenred) + context files atualizados para nomes reais |
| `Github/` | SINCRONIZADO — research-agent, strategic-memory-manager, ai-operations-analyst, rejected/README.md |

**O que foi rejeitado (e por quê):**

| Proposta | Motivo da rejeição |
|---|---|
| Python automation para pesquisa | research-agent já cobre com WebSearch nativo |
| LangGraph para orquestração | Duplica o orchestrator.md existente; Claude Code já gerencia fluxo |
| SQLite para persistência | Não persiste entre sessões Claude Code — inútil para o modelo session-based |
| 5 novos agentes propostos | Todos redundantes: knowledge-curator=SMM, pattern-extractor=task-memory, insight-synthesizer=ai-operations, learning-orchestrator=orchestrator, feedback-collector=TMM |

**Por que importa:** Demonstra o modelo correto de evolução do squad com input externo: análise crítica antes de implementar, rejeição documentada em `rejected/`, ajustes cirúrgicos baseados em gaps reais. O squad continua evolution-ready sem acumular complexidade desnecessária.

---

### v1.9.9 — Auditoria P1: Correções de Modelo, Registro e Knowledge Base (2026-05-20)

**Contexto:** Auditoria completa do squad (Alternativa A — 3 dimensões paralelas: documental, uso real, pesquisa externa) identificou 5 gaps P1 que precisavam de correção imediata. Todos aplicados nesta versão.

**Correções aplicadas:**

| Arquivo | Gap | Correção |
|---|---|---|
| `.claude/agents/executive-storyteller.md` | `model: sonnet` quando deveria ser `model: opus` — degradação silenciosa de qualidade em decks C-Level | Alterado para `model: opus` |
| `.claude/agents/capability-registry.md` | `ux-researcher` criado em v1.9.5 sem entrada no registry — violava protocolo de manutenção | Adicionado bloco completo na seção "Camada de Produto e Estratégia" |
| `.claude/commands/opea_produto.md` | `ux-researcher` como "opcional" em Discovery; `payments-economics-analyst` ausente como obrigatório em Economics/P&L | `ux-researcher` → obrigatório em Discovery; `payments-economics-analyst` → obrigatório em Economics (PM movido para opcional) |
| `.claude/agents/ccb-structuring-engine.md` | Duplicata Escritural Digital ausente — risco de elegibilidade de ativos Opea com grandes empresas a partir de jun–out/2026 | Adicionada seção com cronograma e impacto em CCB com garantia de recebíveis |
| `.claude/agents/mdr-pricing-analyst.md` | Decreto 12.712/2025 ausente — vedação VA/VR PAT para combustível impacta diretamente análise Edenred | Adicionada restrição crítica e distinção obrigatória PAT vs. arranjo fechado não-PAT |

**Gaps novos adicionados ao backlog (não cobertos no capability-registry):**
- Gap 5: Agente de documentação técnica customizado para versionamento do squad
- Gap 6: Cobertura compliance/legal para instrumentos regulados (compliance-auditor e legal-advisor ausentes em `.claude/agents/`)
- Gap 7: Validação de qualidade de dados financeiros (reconciliação de ledger, integridade de gravames)

**Origem:** Auditoria Alternativa A com 3 agentes paralelos (ai-operations-analyst, ai-metrics-analyst, research-agent). Auditoria identificou também 5 itens P2 e 3 itens P3 para versões futuras.

---

### v1.9.8 — Template Library, Implementations Registry e Protocolo de Reuso (2026-05-20)

**Contexto:** Squad reiniciava do zero em cada demanda. Agentes sem memória de implementações anteriores → retrabalho recorrente, bugs já corrigidos reaparecendo, padrões reinventados. PM solicitou sistema que tornasse o squad cada vez mais autônomo e que preservasse conhecimento entre sessões.

**O que foi construído:**

| Artefato | Descrição |
|---|---|
| `templates/opea/sprint-board-fix.md` | Template com padrões de código obrigatórios, arquitetura de dados, checklist de regressão para fixes no Sprint Board Opea |
| `templates/opea/new-feature.md` | Template para features novas com estado próprio no Sprint Board Opea |
| `templates/edenred/sprint-board-fix.md` | Template equivalente para o Sprint Board Edenred |
| `templates/edenred/economics-model.md` | Template de economics: decomposição MDR, estrutura P&L, cenários, sensibilidade — com caps PAT 2026 embutidos |
| `memory/projects/opea/implementations.md` | Implementations Registry Opea: histórico de versões SB v1.0 → v1.7.1, padrões reutilizáveis, bugs corrigidos |
| `memory/projects/edenred/implementations.md` | Implementations Registry Edenred: SB v1.0 → v2.0, calculadora v1.0, padrões de economics |
| `.claude/agents/orchestrator.md` | Adicionado: "Protocolo de Reuso — Template Check". Antes de despachar agentes, verificar template disponível → modo ADAPT ou BUILD. Pós-entrega: acionar SMM para atualizar templates e implementations registry. |
| `knowledge/squad-learnings/padroes-e-aprendizados.md` | Adicionada seção: Sistema de Templates e Implementations Registry |

**Mudança de paradigma:**

| Antes (v1.9.7) | Depois (v1.9.8) |
|---|---|
| Agente parte do zero a cada demanda | Orchestrator injeta template como ponto de partida |
| Bugs corrigidos podem ser reintroduzidos | Implementations Registry registra o que foi corrigido e por quê |
| Sem rastro do que foi construído | Cada entrega atualiza o registry do projeto |
| Conhecimento perdido entre sessões | Templates acumulam padrões de código reais |

**Protocolo de manutenção (quem atualiza o quê):**
- `task-memory-manager` → `memory/squad/tasks/` (operacional)
- `strategic-memory-manager` → `templates/` + `memory/projects/` + `knowledge/squad-learnings/padroes-e-aprendizados.md` (padrões e histórico)

**Por que importa:** Squad passa a ser mais inteligente a cada entrega, não estacionário. Entrega → padrão → template → próxima entrega começa com contexto.

---

### v1.9.7 — Solução Marcos Entregáveis (Padrão Reutilizável)

**Contexto:** PM da Opea precisava de uma apresentação de marcos de entrega por sprint para o cliente, com visual polido, conteúdo fiel ao quadro do cliente e totalmente editável. A solução foi desenvolvida iterativamente em 1 sessão (2026-05-19) e documentada como padrão reutilizável do squad.

**O que foi construído:**

| Artefato | Descrição |
|----------|-----------|
| `Opea_Jira/opea_sprint_board/v1.6.0/opea_sprint_board.html` | Sprint Board com aba "Marcos Entregáveis" — 5 layouts, edição inline completa, export standalone |
| `Documentacao_Claude/solucao-marcos-entregaveis.md` | Documento de referência completo: modelo de dados, layouts, decisões técnicas, guia de reutilização |

**Capacidades da solução:**
- **5 layouts** selecionáveis: Kanban Fiel, Kanban Compacto, Premium Dark, Apple Clarity, Apple Midnight
- **Modelo hierárquico**: sprint → card → items + sections (epico → feature → entregas)
- **Edição completa**: nome, datas, cores, items, sections — tudo editável inline
- **Persistência**: `localStorage` — sobrevive a reload sem servidor
- **Export HTML standalone** — apresentação desacoplada do Sprint Board principal
- **Badge MVP**: marcação visual de sprint/release alvo
- **Subitens recuados**: `<span class="mec-sub">` para hierarquia visual dentro de um card

**Decisões técnicas documentadas:**
- `sections` dentro de cards para representar features dentro de épicos (evita card com nome de feature como título de épico)
- Títulos de sections visíveis em visualização mas sem fundo colorido — cor aparece só no modo edição
- Estado global em `window.*` obrigatório (regra do Sprint Board)
- Items como strings HTML puras: suporte a `<s>strikethrough</s>` e `<span class="mec-sub">`

**Como reutilizar:** Ver `Documentacao_Claude/solucao-marcos-entregaveis.md` — cobre adaptação para outro projeto/cliente em 5 passos.

---

### v1.9.7 — Governança de Uso: Protocolo de Entrada + Freeze + Calibração do Research Agent

**Contexto:** Parecer do squad (2026-05-19) identificou 3 melhorias operacionais prioritárias: (1) falta de protocolo que force o uso das skills de produto; (2) risco de overengineering antes de validar o que foi construído; (3) research-agent com filtro de relevância genérico gerando 75% de ruído.

**O que foi implementado:**

| Arquivo | Mudança |
|---|---|
| `CLAUDE.md` | Seção "Governança do Squad — Regras Ativas" adicionada: protocolo de entrada obrigatório via `/opea_produto`/`/edenred_produto` para produto financeiro; congelamento de novas features até 2026-06-03 com condições e exceções documentadas |
| `.claude/agents/research-agent.md` | Filtro de relevância da Etapa 3 substituído por tabela de contextos específicos (Opea/Edenred/Squad) — achado sem impacto direto não gera arquivo em `suggestions/` |
| `Github/agents/research-agent.md` | SINCRONIZADO |

**Por que importa:** Estas 3 mudanças atacam causas operacionais, não gaps de capacidade. O squad está completo para o trabalho que precisa fazer. O risco agora é de não uso e de overengineering, não de falta de agentes.

---

### v1.9.6 — Claude Code maio/2026 + Rotina Remota Research-Agent

**Contexto:** Research-agent (varredura 2026-05-19) identificou novidades relevantes do Claude Code para ambientes Windows multi-agente, e foi diagnosticado que a rotina de 9:30h do research-agent nunca havia sido criada como rotina remota — existia apenas como documentação desde v1.3.

**O que foi implementado:**

| Arquivo | Mudança |
|---|---|
| `orchestrator.md` | Novos flags de background sessions: `--model`, `--effort`, `--add-dir`, `--settings`, `--mcp-config` documentados com exemplos. Permite orquestração mais precisa — Opus para análise regulatória complexa, Haiku para formatação. |
| `playbooks/playbook-sprint-delivery.md` | Nota sobre novos flags de background sessions + compatibilidade PowerShell no Windows (shell padrão desde mai/2026) |
| `research-agent.md` | `--model claude-sonnet-4-6` explícito no comando bg; nota sobre `terminalSequence` para notificação desktop ao final de varreduras longas |
| Rotina `trig_019Vrhg7KHmHMKVGu9eQr1ZQ` | CRIADA — research-agent 9:30h BRT seg-sex, modelo sonnet, repo GitHub squad. Primeira execução: 20/05/2026. |

**Sugestão aplicada:** `suggestions/2026-05-19-claude-code-hooks-powershell-windows.md` → IMPLEMENTADO

---

### v1.9.5 — Governança Baseada em Métricas (5 Recomendações P1-P5)

**Contexto:** Primeiro dashboard real do `ai-metrics-analyst` (2026-05-18) revelou que 20 de 26 agentes tinham 0 ativações em trabalho de produto real. A causa raiz: o squad foi construído para trabalho financeiro complexo, mas o único ponto de entrada existente (`/opea_jira`, `/edenred_jira`) cobria apenas Sprint Board HTML. Toda demanda de produto real (CCB, MDR, P&L, requisitos, discovery) era resolvida sem o squad.

**O que foi implementado:**

| Arquivo | Mudança |
|---|---|
| `.claude/commands/opea_produto.md` | CRIADO — skill de produto Opea: protocolo, 8 tipos de demanda, agentes obrigatórios por tipo, regras invioláveis |
| `.claude/commands/edenred_produto.md` | CRIADO — skill de produto Edenred: protocolo, 6 tipos de demanda, alerta PAT 2026 embutido, agentes obrigatórios por tipo |
| `.claude/agents/orchestrator.md` | ATUALIZADO — padrões "Demanda Produto Opea" e "Demanda Produto Edenred" adicionados |
| `playbooks/playbook-session-close.md` | ATUALIZADO — step condicional de monitoring-frontend-v4 inserido no Passo 1 |
| CronCreate job 3a9d9883 | AGENDADO — ciclo periódico ai-metrics-analyst em 2026-05-28 |
| `.claude/agents/ux-researcher.md` | CRIADO — único gap genuíno do squad: UX Research para Opea (jornadas CCB, Asset Ledger) e Edenred (abastecimento, jornada transacional) |

**Squad total: 27 agentes** (26 anteriores + ux-researcher)

**Por que importa:** Esta versão fecha o gap entre a capacidade do squad (26 agentes financeiros especializados) e o uso real (5-6 agentes para Sprint Board). Com `/opea_produto` e `/edenred_produto` como pontos de entrada, e o routing explícito no orchestrator, `business-analyst-financeiro`, `financial-systems-architect`, `payments-economics-analyst` e os sub-agentes financeiros têm agora um caminho direto para ativação em trabalho de produto real.

---

### v1.9.4 — Governança Baseada em Métricas (3 Recomendações P1)

**Contexto:** Primeiro dashboard real do `ai-metrics-analyst` (2026-05-18) revelou 3 gaps críticos que o squad tinha em operação: 43% de violação do protocolo PE→Orchestrator, 57% de cobertura de task memory e frontend-developer v4 sem validação em produção real.

**O que foi implementado:**

| Arquivo | Mudança |
|---|---|
| `.claude/agents/orchestrator.md` | Gate de protocolo: avisa quando raw input chega sem PE, exceto fast lane Sprint Board. Baseado em evidência quantitativa, não em regra subjetiva. |
| `playbooks/playbook-session-close.md` | Threshold de task-memory abaixado: "qualquer arquivo alterado" substitui "2+ agentes". Motivo e evidência documentados inline. |
| `tests/comportamental/monitoring-frontend-v4.md` | Tracking formal das próximas 5 sessões com frontend-developer — valida se v4 atingiu meta de <20% retrabalho. |
| `Github/` | Todos os arquivos acima sincronizados. |

**Por que importa:** Esta é a primeira vez que o squad evolui a partir de dados operacionais reais, não de design antecipado. O ai-metrics-analyst foi acionado pela primeira vez e suas 3 recomendações P1 foram implementadas na mesma sessão. O ciclo de dados → análise → melhoria funcionou.

---

### v1.9.2 — Sistema de Versionamento Opea Sprint Board + Skill `/opea_jira`

**Contexto:** PM solicitou controle de versionamento semântico para o artefato HTML do Sprint Planner Opea (publicado como artifact no Claude Web), com estrutura de pastas por versão, documentação de cada entrega e espelho para GitHub.

**O que foi construído:**

| Caminho | Descrição |
|---|---|
| `Opea_Jira/opea_sprint_board/vX.Y.Z/` | Versão versionada do HTML com CHANGELOG.md |
| `Opea_Jira/opea_sprint_board/README.md` | Índice de versões e convenção semântica |
| `Opea_Jira/github/opea_sprint_board/` | Espelho sincronizado para publicação no GitHub |
| `.claude/commands/opea_jira.md` | Skill com protocolo completo de desenvolvimento e versionamento automático |

**Versões retroativas migradas:** v1.0.0 (12/05), v1.1.0 (14/05), v1.2.0 (15/05), v1.3.0 (18/05 — atual)

**Convenção:** MAJOR.MINOR.PATCH — Redesign / Feature / Bug fix

**Fluxo automatizado pelo skill `/opea_jira`:**
1. Apresentar solução → aguardar aprovação → implementar
2. Calcular nova versão → criar pasta vX.Y.Z/ → CHANGELOG.md → atualizar README → sincronizar github/

---

### v1.9.0 — Teams Intelligence System (Integração Externa)

**Contexto:** PM solicitou sistema para capturar histórico de conversas 1:1 do Microsoft Teams, classificar por domínio financeiro, aprender estilo de comunicação e sugerir respostas futuras — sem n8n, sem servidor, tudo local.

**O que foi construído:** `teams-integration/` — conjunto de scripts Python CLI que integra Microsoft Graph API com Claude API.

**Componentes:**

| Arquivo | Responsabilidade |
|---|---|
| `src/auth.py` | MSAL device code flow, token cache persistido em JSON |
| `src/fetcher.py` | Chats 1:1 via Graph API, paginação, deduplicação, strip HTML |
| `src/processor.py` | Classificação de conversas por domínio financeiro via Claude API |
| `src/pattern_engine.py` | Análise de mensagens enviadas, geração de `vitor-style.md` |
| `src/faq_generator.py` | FAQ .md por categoria (mín. 3 conversas base) |
| `src/main.py` | CLI: `--fetch`, `--process`, `--patterns`, `--faq`, `--suggest`, `--all` |

**Saída:**
- `knowledge/teams/history/` — histórico bruto + JSON classificado por data
- `knowledge/teams/faq/` — FAQ por domínio (ccb, economics, opea, edenred, regulatório)
- `knowledge/teams/patterns/vitor-style.md` — perfil de estilo de comunicação

**Escopo aprovado:** apenas chats 1:1, sem canais, mensagens de e para o usuário.

**Nota de arquitetura:** Esta não é um agente do squad. É uma ferramenta de integração externa que alimenta a knowledge base do squad com dados reais de conversas do PM.

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

### v1.9.0 — Deploy Completo do Squad (primeiro deploy real)

**Contexto:** Descoberto em 2026-05-18 durante execução do Teste 01: `.claude/agents/` estava vazio desde a criação do squad. Todos os 26 agentes customizados existiam apenas como documentação em `Github/agents/` — o runtime usava agentes genéricos do catálogo.

**O que foi feito:**
Todos os 26 arquivos de `Github/agents/` foram copiados para `.claude/agents/`, ativando o squad completo pela primeira vez.

**Impacto:** Esta é a mudança mais significativa desde a criação do squad. A partir de v1.9.0:
- O `orchestrator` customizado com contexto financeiro, modos de execução e padrões de paralelização está ativo
- O `prompt-engineer` customizado está ativo
- O `qa-test-engineer` especializado em produtos financeiros está ativo
- Os 5 sub-agentes financeiros (CCB, Ledger, SPI, MDR, P&L) estão ativos
- O `frontend-developer` com Sprint Board constraints está ativo
- Os 3 agentes de memória customizados estão ativos
- O `research-agent` financeiro está ativo

**Squad total: 26 agentes ativos** (todos implantados em `.claude/agents/`)

---

### v1.8.7 — Agente Customizado, Conhecimento Propagado e Paralelização

**Contexto:** Terceira rodada de melhorias em 2026-05-15. Gaps: agente executor sem domínio embutido, aprendizados de sessão nunca propagados para base de conhecimento, e sem padrões de paralelização definidos.

**Mudanças aplicadas:**

| Arquivo | Mudança |
|---|---|
| `Github/agents/frontend-developer.md` | Criado agente customizado com arquitetura do Sprint Board, restrições absolutas, bugs conhecidos, Passo 0 + pré-mortem e critérios de fast lane/escalação embutidos |
| `knowledge/squad-learnings/padroes-e-aprendizados.md` | Bugs #3 (data vs localStorage), #4 (currentSprintId stale), #5 (MODULES.label) adicionados |
| `playbooks/playbook-html-fix.md` | Pré-mortem adicionado ao Passo 0 |
| `playbooks/playbook-session-close.md` | Passo 3.5 — loop de retroalimentação de conhecimento |
| `Github/agents/orchestrator.md` | Seção de Padrões de Paralelização com tabela seguro/não-seguro e ganhos esperados |

**Squad total: 26 agentes** (25 anteriores + frontend-developer customizado)

---

### v1.8.6 — Clareza de Roteamento, Sub-agentes e Métricas Periódicas

**Contexto:** Segunda rodada de melhorias de governança em 2026-05-15. Análise identificou 3 gaps adicionais: ambiguidade nos 3 agentes de memória, ai-metrics-analyst e ai-operations-analyst nunca ativados, e 5 sub-agentes financeiros dormentes por falta de critério de roteamento.

**Mudanças aplicadas:**

| Arquivo | Mudança |
|---|---|
| `playbooks/playbook-session-close.md` | Tabela Decisor Rápido de Memória (TMM/SMM/CM) + Passo 5 de Análise de Performance periódica |
| `Github/agents/capability-registry.md` | Critério objetivo de roteamento pai vs sub-agente para FSA e PEA |
| `CLAUDE.md` | Tabela de roteamento direto para todos os 5 sub-agentes financeiros + alerta de dormência + gatilho periódico de métricas |

**Por que importa:** Sub-agentes existem mas não são usados — não por falta de demanda financeira, mas por falta de sinal claro de quando acioná-los. Agentes de métricas existem mas não têm gatilho definido — ficam dormentes indefinidamente sem o Passo 5.

---

### v1.8.5 — Prevenção de Regressão e Protocolo Inviolável

**Contexto:** Análise de performance do squad (2026-05-13 a 2026-05-15) identificou 3 violações de protocolo PE→Orchestrator e 3 rodadas de regressão numa única tarefa. Causa raiz: escopo de análise estreito do agente executor + "efeito continuação" que isenta incorretamente fixes emergentes do ciclo de governança.

**Mudanças aplicadas:**

| Arquivo | Mudança |
|---|---|
| `playbooks/playbook-html-fix.md` | Inserido **Passo 0 — Mapa de Impacto**: antes de qualquer código, listar funções adjacentes, fonte autoritativa dos dados, verificar sessões anteriores. Se >2 funções interdependentes → reclassificar para balanced. |
| `playbooks/playbook-html-fix.md` | Passo 6 (handoff QA) agora exige entrega do mapa de impacto junto ao QA — prevenção upstream, não só detecção. |
| `CLAUDE.md` | Adicionada **Regra Inviolável — Protocolo em Qualquer Fix**: "continuação de fix" não isenta do ciclo PE → Orchestrator. Documentado com histórico de incidentes. |

**Por que importa:** O Passo 0 teria evitado a regressão do label de épico (fix aplicado sem inspecionar `sbPopulateColorSelect`) e antecipado o problema `data` vs `localStorage`. A regra no CLAUDE.md fecha o gap de governança que gerou 3 violações consecutivas.

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

**Regra de sync (atualizada em 2026-05-21):** Toda evolução do squad atualiza em conjunto: `changelog/changelog.md` + `Github/Documentacao_Claude/squad-arquitetura-e-evolucao.md` (fonte única) + `Organizacao_Squad/squad-overview.html` + `Github/Organizacao_Squad/squad-overview.html`.

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
| **ux-researcher** | sonnet | Pesquisa qualitativa com usuários: entrevistas, mapeamento de jornada, friction points, personas financeiras. Especializado em Opea (CCB, Asset Ledger) e Edenred (abastecimento, arranjo fechado). |

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
- Atualizar `Github/Documentacao_Claude/squad-arquitetura-e-evolucao.md` — fonte única (pasta raiz `Documentacao_Claude/` removida em 2026-05-21)
- Atualizar `Organizacao_Squad/squad-overview.html` (artefato visual do squad)
- Sincronizar `Github/Organizacao_Squad/squad-overview.html` (espelho)
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
