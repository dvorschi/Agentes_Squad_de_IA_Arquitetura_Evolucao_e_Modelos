# Infraestrutura de Pagamentos — Brasil

> Base de conhecimento para agentes. Atualizada pelo Research Agent quando há novidades relevantes.
> Última atualização: 2026-05-14 (research-agent run 2026-05-14)

---

## Ecossistema de Cartões

### Participantes do Arranjo Aberto

```
Portador (consumidor)
       ↓  apresenta cartão
Estabelecimento (merchant)
       ↓  captura transação
Credenciadora (acquirer) — ex: Stone, Getnet, Cielo
       ↓  processa e encaminha
Bandeira (scheme) — Visa, Mastercard, Elo
       ↓  roteamento e regras
Banco Emissor — ex: Itaú, Nubank
       ↓  autoriza transação (verifica limite)
Resultado: aprovado / reprovado
```

### Fluxo Financeiro de Liquidação

```
D+0: Transação aprovada
D+1: Credenciadora registra recebível
D+2 (débito) / D+30/D+∞ (crédito): Liquidação ao merchant
```

**Antecipação de recebíveis:** Merchant pode antecipar D+30 para D+1 pagando taxa de desconto.

---

## MDR — Merchant Discount Rate

### Composição Detalhada

| Componente | Quem recebe | Faixa típica (crédito à vista) |
|---|---|---|
| **Interchange** | Banco Emissor | 0,5% – 1,5% |
| **Fee de bandeira** | Visa/Mastercard/Elo | 0,1% – 0,3% |
| **Fee da credenciadora** | Stone/Getnet/Cielo | 0,2% – 0,8% |
| **MDR Total cobrado ao merchant** | — | **1,0% – 3,0%** |

### Variáveis que Afetam o MDR

- **Modalidade:** débito < PIX < crédito à vista < crédito parcelado
- **Segmento:** supermercado (baixo) < restaurante < e-commerce (alto)
- **Volume:** quanto maior o TPV do merchant, menor o MDR negociado
- **Risco:** e-commerce tem MDR maior por maior taxa de chargeback
- **Bandeira:** Elo tem tabelas diferentes de Visa/Mastercard

### Regras de Interchange BACEN

O BACEN regula tetos de interchange para cartões de débito e pré-pagos:
- **Débito:** limite de 0,5% por transação (Res. BACEN 4.432/2015)
- **Crédito:** sem teto regulatório — mercado livre
- **Pré-pago (benefícios):** sem teto para arranjos fechados isentos

---

## PIX — Sistema de Pagamentos Instantâneos

### Arquitetura Técnica

```
Pagador → PSP pagador → SPI (BACEN) → PSP recebedor → Recebedor
```

- **DICT:** Diretório de Identificadores de Contas Transacionais — repositório de chaves PIX
- **Liquidação:** bruta em tempo real no STR para valores > R$ 100K; compensação intraday para menores
- **Mensageria:** ISO 20022 (padrão internacional de mensagens financeiras)

### Modalidades PIX

| Modalidade | Descrição | Status |
|---|---|---|
| PIX comum | Transferência P2P e P2B instantânea | Ativo |
| PIX Cobrança | QR Code estático e dinâmico para cobranças | Ativo |
| PIX Agendado | Transferência com data futura | Ativo |
| **PIX Garantido** | Crédito parcelado via PIX — liquidação diferida | Em expansão |
| **PIX por Aproximação** | NFC + PIX | Em implementação |
| **PIX Automático** | Débito recorrente autorizado | Em implementação |
| **PIX Internacional** | Transferência cross-border | Em estudo BACEN |

### SLAs Obrigatórios

- Disponibilidade: 24x7 incluindo feriados
- Resposta: < 10 segundos (meta operacional BACEN)
- Consulta DICT: síncrona em tempo real
- Contingência: PSP obrigado a ter plano de contingência aprovado pelo BACEN

---

## Sub-adquirência e Facilitadores de Pagamento

### Estrutura

```
Merchant → Sub-adquirente / Facilitador → Credenciadora → Bandeira → Emissor
```

**Sub-adquirentes comuns:** PagSeguro, Mercado Pago, PicPay (como adquirente), iugu, Pagar.me

**Características:**
- Sub-adquirente assume o risco de chargeback do merchant
- Precisa de contrato com credenciadora habilitada
- Pode oferecer split de pagamento (marketplace)
- MDR cobrado do merchant inclui spread do sub-adquirente sobre o MDR da credenciadora

---

## Agenda de Recebíveis

### O que é

Repositório centralizado dos recebíveis futuros de um merchant — direito de receber dos credenciadores pelas transações processadas.

### Regulação (BACEN Res. 4.734/2019)

- Todo recebível de cartão > R$ 1.000 deve ser registrado em registradora autorizada
- Merchant pode:
  - **Livre movimentação:** receber normalmente nos vencimentos
  - **Trava:** ceder recebíveis como garantia de empréstimo (cessão fiduciária)
  - **Cessão:** vender recebíveis com desconto (antecipação)

### Registradoras Autorizadas

| Registradora | Foco |
|---|---|
| **CERC** | Recebíveis de cartão, crédito para PMEs |
| **CIP/Núclea** | Recebíveis de cartão, processamento interbancário |

---

## Arranjos Fechados (Closed-Loop)

### Diferença para Arranjo Aberto

| Característica | Aberto (Visa/MC) | Fechado (Edenred/VR) |
|---|---|---|
| Aceitação | Universal | Rede credenciada específica |
| Interchange | Sim — vai ao emissor | Não — sem emissor externo |
| Bandeira | Sim — Visa/MC/Elo | Não (ou bandeira própria) |
| Regulação BACEN | Obrigatória | Isenta se volume < R$ 500M |
| Controle do MDR | Compartilhado | Total pelo operador |

### Vantagem econômica do fechado

Sem interchange externo, toda a margem do MDR fica no operador. O custo de processamento é direto com a credenciadora (sem bandeira na cadeia).

---

## Chargeback

### Fluxo de Contestação

```
1. Portador contesta transação no emissor
2. Emissor notifica bandeira → bandeira notifica credenciadora
3. Credenciadora notifica merchant (prazo para contestar: 7–15 dias)
4. Merchant contesta com evidência OU aceita o chargeback
5. Se sem evidência → débito no merchant (estorno do recebível)
6. Bandeira julga em caso de disputa entre emissor e credenciadora
```

### Tipos Comuns

- **Fraude** — transação não reconhecida pelo portador
- **Não entregue** — produto/serviço não recebido
- **Qualidade** — produto diferente do anunciado
- **Processamento** — erro na captura (valor errado, duplicidade)

---

## PAT — Abertura dos Arranjos de Benefícios (2026)

> Fonte: Decreto Nov/2025 + Portaria MTE. Vigência em fases a partir de fev/2026.
> Impacto direto para Edenred.

### O que mudou

O Programa de Alimentação do Trabalhador (PAT) passou por reestruturação profunda que desmantela os modelos verticalmente integrados dos arranjos fechados de benefícios alimentação/refeição.

### Cronograma de Implementação

| Fase | Data | Obrigação |
|---|---|---|
| **Fase 1** | Fevereiro de 2026 | Teto de MDR (3,6%) e teto de intercâmbio (2%), prazo de liquidação reduzido para 15 dias |
| **Fase 2** | 11 de maio de 2026 | Abertura de arranjo para operadoras com > 500K trabalhadores — outras empresas podem atuar em etapas separadas |
| **Fase 3** | Novembro de 2026 | Interoperabilidade total — vale-refeição/alimentação aceito em qualquer maquininha, independente de bandeira ou operadora |

### Nova Estrutura de Tarifas (Fase 1 — em vigor)

| Componente | Teto Regulatório |
|---|---|
| **MDR** | Máximo 3,6% |
| **Intercâmbio** | Máximo 2% (sem cobranças adicionais) |
| **Liquidação ao merchant** | Prazo máximo de 15 dias (antes: 30 dias) |

### Separação Operacional (Fase 2 — em vigor desde 11/mai/2026)

Operadoras com > 500 mil trabalhadores devem permitir que diferentes empresas atuem em etapas separadas:
- Emissão do cartão
- Credenciamento do merchant
- Autorização de transação
- Liquidação financeira

### Restrições Mantidas

- Benefício restrito a compras de alimentação — proibido em academias, farmácias, planos de saúde, educação
- Proibido cashback
- Proibido vantagens indiretas para empregadores

### Impacto para Edenred

O modelo closed-loop histórico (Edenred controlando toda a cadeia) está regulatoriamente encerrado para operações com > 500K trabalhadores. A interoperabilidade total em novembro de 2026 significa que o cartão Edenred deve funcionar em qualquer maquininha. Isso altera fundamentalmente o P&L do arranjo fechado — o diferencial competitivo migra de exclusividade de rede para qualidade de serviço, precificação e benefícios ao empregador/trabalhador.

---

## PIX — Atualizações 2026

> Adicionado em 2026-05-14 pelo Research Agent.

### MED 2.0 — Mecanismo Especial de Devolução (vigente desde 02/02/2026)

O MED 2.0 é a principal inovação de segurança do PIX em 2026:

- **Rastreamento em 5 níveis:** O sistema consegue rastrear o caminho do dinheiro por até 5 transferências sequenciais em contas diferentes — antes era limitado ao destinatário imediato
- **Botão de contestação obrigatório:** PSPs são obrigados a exibir botão de contestação diretamente no comprovante PIX, eliminando a necessidade de central de atendimento
- **Bloqueio imediato:** Fundos devem ser congelados imediatamente ao receber notificação de fraude
- **Prazo de devolução:** Processamento em até 80 dias da transação original; devolução em 7–10 dias úteis se fundos disponíveis

### Bloqueio Cautelar (vigente desde fevereiro/2026)

Bancos podem reter preventivamente valores recebidos via PIX por até 72 horas quando houver suspeita de fraude ou movimentação irregular. Objetivo: tempo para análise sem congelar definitivamente o valor legítimo.

### PIX Automático

Modalidade funcionando como débito automático: a empresa envia cobranças automáticas recorrentes para pagamento via PIX. Diferente do PIX Agendado (iniciado pelo pagador) — aqui é o recebedor que dispara a cobrança. Ainda em fase de expansão e regulamentação pelos PSPs.

### PIX por Aproximação (NFC)

Pagamento presencial via tecnologia NFC — o usuário aproxima o celular da maquininha para iniciar pagamento PIX. Em implementação pelos PSPs em 2026.

### Cobrança Híbrida — BolePIX

Cobrança que combina boleto e QR Code PIX num único documento. Previsão de lançamento: outubro de 2026 (segundo cronograma BACEN).
