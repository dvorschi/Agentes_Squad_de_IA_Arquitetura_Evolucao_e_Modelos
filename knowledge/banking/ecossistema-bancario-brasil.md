# Ecossistema Bancário Brasileiro

> Base de conhecimento para agentes. Atualizada pelo Research Agent quando há novidades relevantes.
> Última atualização: 2026-05-14

---

## Sistema Financeiro Nacional (SFN)

### Estrutura de Regulação

| Órgão | Papel |
|---|---|
| **CMN** | Conselho Monetário Nacional — normas gerais do SFN |
| **BACEN** | Banco Central do Brasil — regulação e supervisão prudencial |
| **CVM** | Comissão de Valores Mobiliários — mercado de capitais |
| **SUSEP** | Superintendência de Seguros Privados |
| **PREVIC** | Superintendência de Previdência Complementar |

### Tipos de Instituições Autorizadas pelo BACEN

| Tipo | Exemplos | Atividades permitidas |
|---|---|---|
| **Banco Múltiplo** | Itaú, Bradesco, Santander | Captação, crédito, câmbio, custódia |
| **Banco Comercial** | Caixa, BB | Captação à vista, crédito |
| **Banco de Investimento** | BTG, XP | Crédito de médio/longo prazo, mercado de capitais |
| **Cooperativa de Crédito** | Sicredi, Sicoob | Serviços aos cooperados |
| **Instituição de Pagamento (IP)** | Nubank, PicPay, Edenred | Conta de pagamento, transferências, sem crédito |
| **Sociedade de Crédito Direto (SCD)** | Creditas (SCD) | Crédito com capital próprio, sem captação |
| **Sociedade de Empréstimo entre Pessoas (SEP)** | — | Crédito peer-to-peer (marketplace) |
| **Correspondente bancário** | Lotéricas, agentes | Intermediação de serviços bancários |

---

## Infraestrutura do SPB (Sistema de Pagamentos Brasileiro)

### Sistemas de Liquidação

| Sistema | Operador | Função |
|---|---|---|
| **STR** | BACEN | Sistema de Transferência de Reservas — liquidação bruta em tempo real (LBTR), grandes valores |
| **SPI** | BACEN | Sistema de Pagamentos Instantâneos — PIX, 24x7, valor qualquer |
| **SILOC** | CIP | Liquidação de DOC e TED de varejo |
| **COMPE** | BACEN/BB | Câmara de compensação de cheques |
| **CEC** | CIP | Câmara de cessão de crédito |

### Câmaras e Infraestruturas

| Infraestrutura | Papel |
|---|---|
| **B3** | Câmara de ações, derivativos, títulos públicos — registro e liquidação |
| **CIP/Núclea** | Processamento de pagamentos de varejo, registro de recebíveis |
| **CERC** | Central de Recebíveis — registro e agenda de recebíveis de cartão |
| **Câmara FX** | Liquidação de câmbio interbancário |

---

## Banking as a Service (BaaS)

### Modelos de BaaS no Brasil

| Modelo | Descrição | Exemplos |
|---|---|---|
| **IP + Correspondente** | Fintech atua como correspondente de banco licenciado | Dock, Zoop |
| **IP próprio** | Fintech com autorização própria do BACEN | Nubank, PicPay |
| **SCD** | Crédito com capital próprio, sem captação de terceiros | Modelo para fintechs de crédito |
| **Banco digitalizado** | Banco tradicional com stack digital | C6, Inter |

### Principais Provedores de BaaS

- **Dock** — processamento de cartões, conta digital, emissão
- **Zoop** — subadquirência e gateway
- **Conductor** — processamento de cartões
- **OpenBank** — infraestrutura bancária white-label

---

## Conta de Pagamento vs Conta Corrente

| Característica | Conta de Pagamento (IP) | Conta Corrente (Banco) |
|---|---|---|
| Regulação | BACEN Res. 4.282/2013 | Banco Central — normas gerais |
| Captação de depósitos | **Não permitida** | Permitida |
| Crédito próprio | **Não permitido** (sem SCD) | Permitido |
| FDIC / FGC | **Não coberto** | Coberto até R$ 250K |
| Rendimento automático | Possível (acordo comercial) | Poupança, CDB |
| Saldo pré-pago | Obrigatório manter em ativos seguros | N/A |

**Implicação para Opea:** A bancarização via CCB usa IPs como veículo de desembolso. O crédito em si é da instituição financeira cedente, não da IP.

---

## Open Finance no Brasil

### Fases de Implementação (concluídas)

| Fase | Conteúdo |
|---|---|
| Fase 1 | Dados de produtos e serviços das instituições (público) |
| Fase 2 | Dados cadastrais e transacionais do cliente (com consentimento) |
| Fase 3 | Iniciação de pagamento e encaminhamento de proposta de crédito |
| Fase 4 | Dados de câmbio, investimentos, seguros e previdência |

### Impacto Prático

- Portabilidade de dados de crédito via API — histórico do cliente pode ser consultado com consentimento
- Iniciação de pagamento (ITP) sem necessidade de conta no banco pagador
- Proposta de crédito cross-institution — cliente pode ter proposta de um banco apresentada por outro

---

## Prioridades Regulatórias BACEN 2025–2026

> Adicionado em 2026-05-14 pelo Research Agent. Fonte: Celcoin/BACEN declarações públicas.

Temas prioritários oficialmente declarados pelo Banco Central para o biênio:

1. **PIX** — Novas modalidades (Automático, Aproximação, BolePIX, Internacional em estudo)
2. **Open Finance** — Expansão de dados, portabilidade de crédito
3. **Tokenização** — Ativos reais e financeiros on-chain (RWA)
4. **Inteligência Artificial** — Regulamentação de uso de IA em decisões de crédito e risco
5. **Crédito** — Portabilidade de crédito sem garantia via Open Finance, iniciando pelas modalidades sem garantia
6. **Ativos Virtuais** — Marco regulatório BACEN (Res. 519, 520, 521) com SPSAVs

---

## Claude / Anthropic — Novidades Relevantes para o Squad (maio/2026)

> Adicionado em 2026-05-14 pelo Research Agent.
> Seção de ferramental — relevante para o squad de IA da BRQ.

### Claude Code Agent View (lançado 11/05/2026 — Research Preview)

Dashboard CLI unificado para gerenciar múltiplas sessões Claude Code em paralelo:

- `claude agents` — abre o dashboard com lista de todas as sessões ativas
- `claude --bg "tarefa"` — inicia sessão em background
- `claude attach <id>` — reconecta a sessão existente
- Cada sessão recebe sua própria git worktree — evita conflitos entre agentes paralelos
- Estado salvo em `~/.claude/` — sessões sobrevivem ao fechamento do terminal

**Implicação para o squad:** Pipelines multi-agente podem ser gerenciados numa única tela. Útil para quando o Orchestrator despacha múltiplos agentes simultâneos — o PM pode acompanhar em tempo real sem perder contexto entre sessões.

### Claude for Small Business (lançado 13/05/2026)

15 workflows automáticos para PMEs com integrações nativas em: PayPal, QuickBooks, HubSpot, Canva, Docusign, Google Workspace, Microsoft 365. Parcerias com CDFIs para expansão de crédito a pequenos negócios.

**Relevância para o squad:** Baixa impacto direto. O produto atende PMEs, não operações B2B enterprise como Opea/Edenred. Porém, as integrações PayPal e DocuSign são relevantes como referência de casos de uso de agentes em produtos financeiros.

### Agents for Financial Services (publicado 05/05/2026)

Anthropic publicou conteúdo específico sobre uso de agentes Claude em serviços financeiros. Página retirada no momento da varredura (404) — monitorar republicação.

### Novos Limites de Uso e Planos (06/05/2026)

Anthropic ajustou limites de uso e preços de tokens em resposta à competição com OpenAI. Sessões paralelas consomem quota proporcionalmente — relevante para planejamento de custo do squad.
