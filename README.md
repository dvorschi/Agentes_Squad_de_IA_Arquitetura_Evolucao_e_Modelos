# Squad de Agentes — Copiloto Executivo de Produtos Financeiros

Squad multi-agente para Claude Code, especializado em produtos financeiros: crédito, pagamentos, meios de pagamento, compliance BACEN e comunicação executiva.

Desenvolvido para PMs, Product Leads e consultores de produto que atuam em bancos, fintechs e instituições financeiras reguladas.

**Versão atual:** v1.9.19 · **27 agentes** · **4 cadências automáticas**

---

## O que é este squad

**27 agentes especializados** organizados em camadas: inteligência, produto, arquitetura financeira, economics, qualidade, memória e operação. Cada agente tem domínio claro e boundaries definidos. O Orchestrator decide qual agente (ou combinação) atende cada demanda.

### Agentes incluídos

**Inteligência e Coordenação**
| Agente | Especialidade |
|---|---|
| `orchestrator` | Pipeline multi-agente, roteamento, plano de execução |
| `prompt-engineer` | Estruturação de demandas brutas em prompts precisos |
| `execution-engine` | Gerencia execução: dependências, checkpoints, retry, rollback |
| `capability-registry` | Matriz de capacidades: o que cada agente faz, não faz, boundaries |

**Produto e Estratégia**
| Agente | Especialidade |
|---|---|
| `product-manager` | Requisitos, épicos, features, histórias, critérios de aceite |
| `business-analyst-financeiro` | Discovery, AS-IS/TO-BE, regras de negócio, refinamento |
| `executive-storyteller` | Decks C-Level, board presentations, executive summaries |
| `executive-reviewer` | Validação final pré-cliente ou C-Level |
| `ux-researcher` | Pesquisa qualitativa, jornadas, personas e discovery com usuários |

**Arquitetura Financeira (+ sub-agentes)**
| Agente | Especialidade |
|---|---|
| `financial-systems-architect` | Regulação BACEN, conformidade, fluxo financeiro, riscos |
| `ccb-structuring-engine` | CCB: Lei 10.931, ICP-Brasil, imutabilidade, registro |
| `ledger-specialist` | Asset Ledger, gravames, cessão, FIDC/CRI/CRA, CERC/Núclea |
| `spi-spb-architect` | PIX/SPI, MED 2.0, DICT, bloqueio cautelar, arquitetura PSP |
| `solution-architect` | Arquitetura técnica: APIs, event-driven, integrações SPB |
| `technical-lead` | Trade-offs técnicos, orientação de implementação |

**Economics e Dados (+ sub-agentes)**
| Agente | Especialidade |
|---|---|
| `payments-economics-analyst` | MDR, P&L, unit economics, viabilidade econômica |
| `mdr-pricing-analyst` | Decomposição MDR, interchange, caps PAT, benchmarks |
| `pnl-modeler` | P&L multi-cenário, breakeven, LTV/CAC, análise de sensibilidade |
| `data-product-strategist` | KPIs, dashboards executivos, analytics de produto |

**Execução**
| Agente | Especialidade |
|---|---|
| `frontend-developer` | Sprint Board HTML, CSS, JavaScript — artefatos visuais standalone |

**Qualidade**
| Agente | Especialidade |
|---|---|
| `qa-test-engineer` | Validação técnica pré-entrega, severidade P0-P3 |

**Memória e Operação**
| Agente | Especialidade |
|---|---|
| `context-manager` | Continuidade de sessão, snapshots, handoffs |
| `strategic-memory-manager` | Decisões estratégicas permanentes |
| `task-memory-manager` | Memória operacional por tarefa: erros, resolução, aprendizados |
| `ai-operations-analyst` | Análise qualitativa de processo e performance |
| `ai-metrics-analyst` | Métricas quantitativas: erro/retrabalho/uso por agente |
| `research-agent` | Monitoramento regulatório BACEN, PIX, fintech, Claude |

---

## Pré-requisitos

- [Claude Code](https://claude.ai/code) instalado (CLI, desktop app ou extensão VS Code/JetBrains)
- Conta Anthropic com acesso ao Claude Code
- PowerShell (Windows) ou Bash (Mac/Linux) para o instalador

---

## Instalação rápida

**Windows (PowerShell):**
```powershell
.\install.ps1
```

**Mac/Linux (Bash):**
```bash
chmod +x install.sh && ./install.sh
```

O instalador copia os 27 agentes para `~/.claude/agents/` e a estrutura de contexto para o diretório do projeto.

Veja `INSTALL.md` para instalação manual passo a passo.

---

## Estrutura de arquivos

```
agents/              → 27 agentes Claude Code (.md)
context/
  business/          → briefing dos seus produtos (preencher)
  regulatory/        → normas BACEN (informação pública)
  templates/         → templates de entrega por tipo de tarefa
playbooks/           → protocolos de execução por tipo de tarefa
knowledge/           → base de conhecimento de domínio financeiro
  banking/           → ecossistema bancário Brasil
  payments/          → infraestrutura de pagamentos, MDR, PIX
  regulatory/        → interpretações práticas BACEN/regulação
  squad-learnings/   → padrões, bugs documentados, aprendizados
memory/squad/
  decisions/         → decisões estratégicas por produto
  tasks/             → memória operacional por tarefa
  operations-log.md  → log geral de execuções (atualizar por sessão)
suggestions/         → melhorias pendentes de aprovação do PM
approved/            → histórico de sugestões aprovadas
changelog/           → versionamento de evoluções do squad
CLAUDE.md            → instruções para o Claude Code neste projeto
```

---

## Primeiros passos após instalar

1. Preencher `context/business/` com dados reais dos seus produtos
2. Ajustar `CLAUDE.md` com seu cargo, empresa e contexto profissional
3. Invocar via Claude Code: `"Orquestrador, quero [demanda]"`
4. Ao final de cada sessão: seguir `playbooks/playbook-session-close.md`

---

## Cadência automática recomendada

O squad funciona melhor com 3 rotinas recorrentes configuradas em [claude.ai/code/routines](https://claude.ai/code/routines):

| Rotina | Frequência | Função |
|---|---|---|
| **research-agent** | Seg-sex 09:30 | Varredura de inteligência externa: BACEN, regulação, Anthropic |
| **operations-log-lembrete** | Seg-sex 09:40 | Template datado para registrar sessões — mantém rastreabilidade |
| **ai-metrics-analyst** | Segundas 09:40 | Dashboard semanal de KPIs: retries, QA, ativação de agentes |

Configure via `/schedule` no Claude Code ou crie manualmente em claude.ai/code/routines.

**Por que importa:** sem operations log atualizado, o ai-metrics-analyst não tem dados reais para análise. Sem research-agent rodando, o knowledge base fica defasado. Cadência = autonomia crescente do squad.

---

## Documentação completa

Ver `Documentacao_Claude/squad-arquitetura-e-evolucao.md` — arquitetura, fluxo, modos de execução, catálogo completo e histórico de evolução v1.0 → v1.9.19.

---

## Licença

MIT — use, adapte e evolua à vontade.
