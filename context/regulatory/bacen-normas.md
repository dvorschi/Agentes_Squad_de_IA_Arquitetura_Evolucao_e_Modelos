# Contexto Regulatório — Principais Normas BACEN

> Referência rápida para agentes que trabalham com produtos financeiros regulados.
> Consultar sempre antes de qualquer análise de conformidade.

---

## Crédito — CCB e Títulos de Crédito

| Norma | Tema | O que determina |
|---|---|---|
| **Lei 10.931/2004** | CCB | Define a Cédula de Crédito Bancário: emissor, portador, garantias, exigibilidade |
| **BACEN Res. 4.966/2021** | Instrumentos de crédito | Regras para emissão, registro e gestão de instrumentos de crédito no SFN |
| **Lei 8.929/1994** | CPR | Cédula de Produto Rural — emissão por produtores rurais e cooperativas |
| **Lei 6.385/1976 + CVM** | NC | Nota Comercial — instrumento de captação de curto prazo |
| **Lei 9.514/1997** | Alienação fiduciária | Alienação fiduciária de imóvel — base do CCB Imobiliário |

### Requisitos Técnicos para CCB
- Assinatura eletrônica com ICP-Brasil (DOC-ICP) — obrigatória para validade jurídica
- Registro em sistema de registro de ativos autorizado pelo BACEN
- Gravame deve ser registrado em registradora autorizada (CERC ou CIP/Núclea)
- Imutabilidade após emissão — CCB emitida não pode ser alterada, apenas endossada ou cedida

---

## Pagamentos Instantâneos — PIX

| Norma | Tema | O que determina |
|---|---|---|
| **BACEN Res. BCB 1/2020** | PIX — regulamento | Regras gerais do PIX: participação, chaves, horários, limites, contestação |
| **BACEN Res. BCB 150/2021** | Arranjo PIX | Regras do arranjo de pagamento instantâneo |
| **BACEN Res. BCB 72/2021** | PIX Garantido | Modalidade de PIX com liquidação diferida para crédito |
| **BACEN Circ. 4.093/2021** | SPI — Sistema | Regras técnicas do Sistema de Pagamentos Instantâneos |

### Requisitos Técnicos PIX
- Liquidação em até 10 segundos (modo padrão) — SLA obrigatório
- Disponibilidade 24x7 incluindo feriados e fins de semana
- Resposta do DICT em tempo real para consulta de chaves
- Mensageria ISO 20022 para comunicação com o SPI
- Idempotência obrigatória em toda transação

---

## PIX — Obrigações Operacionais 2026

> Vigentes em 2026 — obrigatórias para todos os PSPs participantes do PIX.

| Obrigação | Vigência | O que exige |
|---|---|---|
| **MED 2.0 — Botão de contestação** | 02/fev/2026 | Comprovante de PIX deve ter botão de contestação visível e funcional |
| **MED 2.0 — Rastreamento 5 níveis** | 02/fev/2026 | Rastrear fraude em até 5 níveis de transferência (antes: apenas destinatário imediato) |
| **Bloqueio Cautelar** | fev/2026 | PSP pode reter PIX recebido por até 72h em caso de suspeita de fraude coordenada |
| **PIX Automático** | em expansão | Nova modalidade: recebedor dispara a cobrança recorrente (diferente do PIX Agendado) |
| **PIX por Aproximação (NFC)** | em implementação | Pagamento presencial por NFC iniciando transação PIX |
| **BolePIX** | previsão out/2026 | Boleto + QR Code PIX num único documento de cobrança híbrida |

**Impacto prático:** Features de PIX que não incluam o botão de contestação e o suporte ao rastreamento MED 2.0 estão em não-conformidade regulatória. O Financial Systems Architect deve validar qualquer feature PIX contra estas obrigações.

---

## Arranjos de Pagamento

| Norma | Tema | O que determina |
|---|---|---|
| **Lei 12.865/2013** | SPB — Sistema de Pagamentos | Base legal dos arranjos e instituições de pagamento |
| **BACEN Res. 80/2021** | Arranjos de pagamento | Regulação de arranjos abertos e fechados |
| **BACEN Circ. 3.952/2019** | Arranjos fechados | Isenção de autorização para arranjos fechados com volume < R$ 500M |
| **BACEN Res. 4.282/2013** | Instituições de Pagamento | Tipos: emissor, credenciador, iniciador — requisitos de autorização |

### Tipos de Instituição de Pagamento
- **Emissor de moeda eletrônica** — mantém contas de pagamento pré-pagas
- **Emissor de instrumento de pagamento pós-pago** — cartão de crédito
- **Credenciador** — habilita estabelecimentos a aceitar pagamentos
- **Iniciador de transação de pagamento** — autorizado pelo Open Finance

---

## Registradoras e Recebíveis

| Norma | Tema | O que determina |
|---|---|---|
| **BACEN Res. 4.734/2019** | Recebíveis de cartão | Registro obrigatório de recebíveis de cartão, trava, cessão |
| **BACEN Res. 4.993/2022** | Portabilidade de recebíveis | Regras de portabilidade de agenda de recebíveis |
| **BACEN Circ. 3.978/2020** | Registradoras | Autorização e funcionamento de registradoras |

### Registradoras Autorizadas
- **CERC** — Central de Recebíveis: foco em recebíveis de cartão e crédito
- **CIP/Núclea** — Câmara Interbancária de Pagamentos: processamento e liquidação

---

## Open Finance

| Norma | Tema | O que determina |
|---|---|---|
| **BACEN Res. BCB 32/2020** | Open Finance | Compartilhamento de dados entre instituições autorizadas |
| **BACEN Res. BCB 86/2021** | APIs Open Finance | Padrões técnicos de APIs (versão, autenticação OAuth 2.0, FAPI) |
| **BACEN Res. BCB 154/2021** | Open Insurance | Extensão para seguros |

---

## Proteção de Dados e Segurança

| Norma | Tema | O que determina |
|---|---|---|
| **Lei 13.709/2018 (LGPD)** | Proteção de dados pessoais | Bases legais para tratamento de dados financeiros — consentimento explícito obrigatório |
| **BACEN Res. 4.658/2018** | Segurança cibernética | Requisitos de segurança para IFs: política de segurança, CISO, CSIRT, cloud |
| **PCI-DSS v4.0** | Segurança de dados de cartão | Tokenização, criptografia, segregação de ambiente — obrigatório para adquirentes/emissores |
| **BACEN Res. 4.557/2017** | Gestão de riscos | Framework de gestão de risco operacional |

---

## KYC e AML (Prevenção a Crimes Financeiros)

| Norma | Tema | O que determina |
|---|---|---|
| **BACEN Circ. 3.978/2020** | AML/PLD | Política de prevenção à lavagem de dinheiro — monitoramento, COAF |
| **BACEN Res. 4.753/2019** | KYC digital | Onboarding digital com biometria — dispensada presença física |
| **COAF Res. 36/2021** | Comunicações ao COAF | Obrigações de comunicação de operações suspeitas |
| **Lei 9.613/1998** | Crimes de lavagem** | Lei de lavagem de dinheiro — base legal do AML |

---

## Boas Práticas para Agentes

- **Dúvida sobre interpretação regulatória → escalar para jurídico/compliance**, não assumir
- **Toda feature com impacto regulatório precisa do Financial Systems Architect** antes da implementação
- **Dados financeiros têm requisitos de auditoria e imutabilidade** — não é CRUD comum
- **Penalidades BACEN são severas** — multas, intervenção, cassação de autorização
- **Compliance não é feature opcional** — é requisito de existência do produto
