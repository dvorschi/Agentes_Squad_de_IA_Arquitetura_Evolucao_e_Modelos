# Playbook: Modelagem de Economics — Pagamentos e Crédito

> Aplicar sempre que a demanda envolver P&L, MDR, unit economics, pricing ou viabilidade financeira.
> Agente principal: `payments-economics-analyst`.
> Leitura recomendada: `context/business/edenred.md` ou `context/business/opea.md` conforme o produto.

---

## Quando Usar Este Playbook

- Modelagem de MDR e decomposição de receita
- P&L de produto novo ou existente
- Unit economics por transação, cliente ou contrato
- Análise de viabilidade econômica de feature ou produto
- Pricing strategy (definição ou revisão de tarifas)
- Revenue share e estrutura de parcerias financeiras
- Qualquer decisão que precise de números para embasar

---

## Pré-condições Obrigatórias

- [ ] Identificar o produto exato (Edenred / Opea / transversal)
- [ ] Identificar a audiência do modelo (uso interno / apresentação C-Level / decisão regulatória)
- [ ] Verificar se há dados históricos disponíveis ou se o modelo é greenfield (premissas puras)
- [ ] Confirmar o horizonte de análise (mensal / anual / LTV)

---

## Execução — Passo a Passo

### Passo 1 — Identificação do Modelo Financeiro

1. Nomear o produto financeiro e seu modelo de monetização
2. Identificar todos os participantes do fluxo financeiro
3. Mapear quem paga, quem recebe, quem intermedia
4. Verificar se há regulação aplicável que afeta pricing (ex: teto de interchange BACEN)

### Passo 2 — Levantamento de Variáveis

Listar todas as variáveis do modelo:

```
Variáveis de Volume:
- TPV mensal / anual
- Número de transações
- Ticket médio
- Mix de modalidades (crédito à vista / parcelado / débito / PIX / closed-loop)

Variáveis de Receita:
- MDR por modalidade
- Take rate
- Tarifas fixas (emissão, manutenção, antecipação)
- Revenue share com parceiros

Variáveis de Custo:
- Interchange (se arranjo aberto)
- Fee de bandeira
- Custo de processamento por transação
- Custo de fraude / chargeback
- Custo de capital (se crédito)
- Provisão de inadimplência (se crédito)
```

### Passo 3 — Declaração de Premissas

**OBRIGATÓRIO: toda premissa deve ser declarada explicitamente.**

Formato:
```
Premissa 1: TPV inicial de R$ 10M/mês — baseado em [fonte/benchmark/estimativa conservadora]
Premissa 2: MDR médio de 1,5% — baseado em [tabela negociada/benchmark de mercado]
Premissa 3: Churn de 2%/mês — baseado em [dado histórico/estimativa de mercado]
```

Premissa sem fonte = risco de modelo. Declarar a incerteza é melhor que omiti-la.

### Passo 4 — Estrutura de Receitas

```
Receita Bruta
= TPV × MDR (ou take rate)
+ Tarifas fixas
+ Outras receitas (float, parcerias)

Deduções
- Interchange (pass-through ao emissor, se arranjo aberto)
- Fee de bandeira (pass-through, se arranjo aberto)
- Impostos sobre receita (PIS/COFINS/ISS — verificar regime)

= Receita Líquida
```

### Passo 5 — Estrutura de Custos Variáveis

```
Custos Variáveis (por transação)
- Custo de processamento
- Custo de fraude / chargeback (% do TPV)
- Custo de capital (se financiamento)
- Provisão de perdas (se crédito)

= Margem de Contribuição
```

### Passo 6 — Unit Economics

Calcular para a menor unidade relevante:

**Por transação:**
- Receita média por transação
- Custo variável por transação
- Contribuição unitária (R$ e %)

**Por cliente (mensal e LTV):**
- Receita mensal por cliente
- Custo de servir por cliente
- CAC (Custo de Aquisição)
- LTV = contribuição mensal × meses de vida esperada
- LTV/CAC: meta mínima = 3x para produto saudável

**Por contrato (se crédito):**
- Valor financiado
- Spread líquido
- Custo de originação
- Perda esperada
- Margem ajustada ao risco

### Passo 7 — Validação de Margem

- Margem de contribuição positiva? Se não, o produto não é viável.
- Margem suficiente para cobrir custos fixos alocados?
- Margem defensável se o volume ficar 30% abaixo do base?

### Passo 8 — Cenários (obrigatório — mínimo 3)

| Parâmetro | Pessimista | Base | Otimista |
|---|---|---|---|
| TPV mensal | [valor] | [valor] | [valor] |
| MDR / take rate | [valor] | [valor] | [valor] |
| Churn | [valor] | [valor] | [valor] |
| **Receita líquida** | | | |
| **Margem de contribuição** | | | |
| **EBITDA do produto** | | | |

### Passo 9 — Breakeven

- Volume mínimo para cobrir custos variáveis (ponto de equilíbrio da margem de contribuição)
- Volume mínimo para cobrir custos totais alocados (EBITDA zero)
- Prazo estimado para atingir breakeven
- Sensibilidade: qual variável mais impacta o breakeven?

### Passo 10 — Visão Executiva

Produzir resumo de 1 página com:
- Modelo de monetização em uma frase
- Principais premissas (máximo 5)
- Resultado base (receita, margem, EBITDA)
- Breakeven
- Recomendação: viável / inviável / viável com ajuste de [variável]

---

## ⚠️ Alerta: Modelagem de Arranjos de Benefícios PAT (Edenred)

> Aplicável sempre que o modelo envolver MDR ou P&L do produto Edenred (Ticket Restaurante, Alimentação, Flex).

Desde fevereiro de 2026, os arranjos do PAT têm **tetos regulatórios obrigatórios**:

| Parâmetro | Premissa antiga (livre) | Premissa atual (regulada) |
|---|---|---|
| **MDR máximo** | Negociado livremente | **3,6%** (teto Fase 1 — fev/2026) |
| **Intercâmbio máximo** | Sem teto | **2%** entre participantes |
| **Prazo de liquidação** | Até 30 dias | **Até 15 dias** |
| **Exclusividade de rede** | Rede credenciada própria | **Abertura obrigatória desde mai/2026** para operadoras > 500K trabalhadores |

**Regra:** Nunca modelar P&L do Edenred usando MDR histórico livre. Declarar sempre que as premissas de MDR respeitam o teto PAT de 3,6%.

**Revisão necessária em nov/2026:** interoperabilidade total PAT — revisar premissas de receita de credenciamento.

---

## Checklist de Qualidade

- [ ] Todas as premissas estão declaradas com fonte ou justificativa
- [ ] Pelo menos 3 cenários modelados
- [ ] Unit economics calculado (mínimo por transação ou por cliente)
- [ ] Breakeven identificado
- [ ] Resultado do cenário pessimista é defensável para a diretoria
- [ ] Nenhum float foi contabilizado como receita garantida sem análise de saldo médio
- [ ] MDR nunca foi tratado como receita bruta sem descontar interchange (se arranjo aberto)

---

## Entrega para Executive Reviewer

Se o modelo vai para C-Level ou cliente:
- Passar pelo `executive-reviewer` antes da entrega
- Garantir que números têm contexto (benchmarks, comparativos)
- Garantir que premissas estão visíveis, não enterradas em notas de rodapé
