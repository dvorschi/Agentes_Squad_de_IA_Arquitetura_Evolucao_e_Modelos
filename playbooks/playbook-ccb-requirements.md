# Playbook: Requisitos para Features CCB / Crédito — Opea

> Aplicar para qualquer demanda envolvendo CCB, CPR, CPRF, NC, Asset Ledger ou fluxo de crédito regulado.
> Leitura obrigatória: `context/business/opea.md` e `context/regulatory/bacen-normas.md`.
> Agentes envolvidos: `business-analyst-financeiro`, `financial-systems-architect`, `product-manager`.

---

## Quando Usar Este Playbook

- Nova feature no fluxo de originação, formalização ou desembolso de CCB
- Feature envolvendo Asset Ledger (registro, custódia, gravame, cessão)
- Integração com registradoras (CERC, CIP/Núclea)
- Mudança em fluxo de assinatura digital (ICP-Brasil)
- Feature envolvendo CPR, CPRF, NC, CCV ou PCV
- Qualquer mudança com impacto regulatório no produto Opea

---

## Pré-condições Obrigatórias

- [ ] Ler `context/business/opea.md` — entender o produto e seus instrumentos
- [ ] Ler `context/regulatory/bacen-normas.md` — identificar normas aplicáveis
- [ ] Identificar o **tipo de instrumento** (CCB / CPR / NC / etc.)
- [ ] Identificar o **estágio do fluxo** impactado (originação / formalização / registro / cessão)
- [ ] Confirmar se há impacto em **registradora** (CERC ou CIP/Núclea)

---

## Execução — Passo a Passo

### Passo 1 — Contexto Regulatório

Mapear a regulação aplicável ao instrumento:

```
CCB Imobiliário:
  - Lei 10.931/2004 (CCB)
  - Lei 9.514/1997 (alienação fiduciária de imóvel)
  - BACEN Res. 4.966/2021 (instrumentos de crédito)
  - ICP-Brasil (assinatura digital válida juridicamente)

CPR / CPRF:
  - Lei 8.929/1994 (CPR)
  - Regulação MAPA/BCB para CPRF

NC:
  - Instrução CVM / Lei de mercado de capitais
  - ANBIMA para registro
```

### Passo 2 — Mapeamento AS-IS (Estado Atual)

Para cada feature, documentar como o processo funciona hoje:

```markdown
## AS-IS: [nome do processo]

### Fluxo Atual
1. [Participante] realiza [ação] usando [sistema/canal]
2. [Participante] realiza [ação] usando [sistema/canal]
...

### Problemas Identificados
- [Problema 1]: [impacto operacional / regulatório / para o cliente]
- [Problema 2]: [impacto]

### Workarounds Atuais
- [O que as pessoas fazem hoje para contornar o problema]
```

### Passo 3 — Definição do Estado Futuro (TO-BE)

```markdown
## TO-BE: [nome do processo]

### Fluxo Proposto
1. [Participante] realiza [ação] usando [sistema/canal melhorado]
2. [Participante] realiza [ação] usando [sistema/canal melhorado]
...

### Melhorias Esperadas
- [Melhoria 1]: [benefício mensurável]
- [Melhoria 2]: [benefício mensurável]

### Gap Analysis
| Situação | AS-IS | TO-BE | Ação necessária |
|---|---|---|---|
```

### Passo 4 — Regras de Negócio Obrigatórias

Documentar explicitamente para cada feature:

**Para CCB:**
- [ ] Imutabilidade após emissão — CCB emitida não pode ser alterada
- [ ] Assinatura com ICP-Brasil é obrigatória para validade jurídica
- [ ] Registro em sistema autorizado pelo BACEN é obrigatório
- [ ] Prazo de registro: definir prazo conforme norma aplicável
- [ ] Gravame: registrar alienação fiduciária em cartório ou registradora

**Para Asset Ledger:**
- [ ] Escrituração deve ser imutável — log auditável obrigatório
- [ ] Propriedade do ativo deve ser rastreável desde a emissão
- [ ] Cessão de crédito: due diligence + registro + notificação ao devedor
- [ ] Gravames: registro, consulta e baixa integrados com CERC/CIP

**Para qualquer instrumento:**
- [ ] Dados do tomador: KYC obrigatório (BACEN Circ. 3.978/2020)
- [ ] PLD/AML: monitoramento de operações suspeitas
- [ ] LGPD: consentimento explícito para tratamento de dados financeiros

### Passo 5 — Identificar Integrações Externas

Para cada feature, mapear:

| Sistema externo | Tipo de integração | SLA esperado | Fallback |
|---|---|---|---|
| CERC (registradora) | API REST | Síncrono — resposta em < 5s | Fila assíncrona |
| CIP/Núclea | API REST / mensageria | Síncrono / D+0 | Reprocessamento |
| ClickSign/DocuSign | API REST | Webhook de confirmação | Polling de status |
| Biometria/KYC | API REST | Síncrono — resposta em < 10s | Manual com flag de revisão |
| ICP-Brasil | PKI | Validação síncrona | Rejeição com log |

### Passo 6 — Requisitos Técnicos Obrigatórios

Para qualquer feature de crédito regulado:

- [ ] **Idempotência** — toda operação financeira precisa de chave de idempotência
- [ ] **Imutabilidade** — registros financeiros não podem ser deletados, apenas corrigidos com trilha de auditoria
- [ ] **Auditabilidade** — log imutável de quem fez o quê e quando
- [ ] **Assinatura digital** — validação ICP-Brasil antes de emissão
- [ ] **Tratamento de falha** — o que acontece se a registradora está fora?
- [ ] **Concorrência** — dois usuários não podem emitir o mesmo CCB simultaneamente

### Passo 7 — Critérios de Aceite (BDD/Gherkin)

Para cada história:

```gherkin
Cenário: [nome do cenário]
  Dado [estado inicial / contexto]
  Quando [ação do usuário ou evento]
  Então [resultado esperado no sistema]
  E [resultado adicional se houver]

Cenário de exceção: [falha ou edge case]
  Dado [estado inicial]
  Quando [ação que gera erro]
  Então [comportamento esperado do sistema — mensagem de erro, rollback, notificação]
```

### Passo 8 — Matriz de Requisitos

```markdown
| ID | Requisito | Tipo | Prioridade | Norma | Feature | Critérios de Aceite | Status |
|---|---|---|---|---|---|---|---|
| REQ-001 | [título] | Funcional | Must Have | Lei 10.931 | [feature] | CA-01, CA-02 | Em análise |
| REQ-002 | [título] | Regulatório | Must Have | BACEN Res. 4.966 | [feature] | CA-03 | Em análise |
```

---

## Checklist de Qualidade Pré-PM

Antes de passar para o `product-manager` escrever o PRD:

- [ ] AS-IS documentado sem suposições
- [ ] TO-BE com melhorias mensuráveis
- [ ] Gap Analysis completo
- [ ] Todas as regras de negócio explicitadas (nada implícito)
- [ ] Regulação aplicável identificada
- [ ] Integrações externas mapeadas com SLA e fallback
- [ ] Critérios de aceite verificáveis e testáveis pelo QA
- [ ] Requisitos de imutabilidade e auditabilidade incluídos
- [ ] Financial Systems Architect validou a conformidade regulatória

---

## Riscos Típicos em Features CCB (monitorar sempre)

| Risco | Probabilidade | Impacto | Mitigação |
|---|---|---|---|
| Emissão sem registro na registradora | Médio | Crítico (nulidade da CCB) | Registro síncrono obrigatório |
| Assinatura sem ICP-Brasil válido | Baixo | Crítico (invalidade jurídica) | Validação antes de emissão |
| Perda de dados de formação | Baixo | Alto (auditoria BACEN) | Log imutável + backup |
| Cessão sem notificação ao devedor | Médio | Alto (nulidade da cessão) | Notificação automática pós-cessão |
| Falha de integração com CERC | Médio | Alto (CCB não registrada) | Fila de retry + alerta operacional |
