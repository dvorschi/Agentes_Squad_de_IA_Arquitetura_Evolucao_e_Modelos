# Interpretações Práticas — Regulação Financeira

> Complementa `context/regulatory/bacen-normas.md`. Foco em aplicação prática, não apenas na norma.
> Base de conhecimento para agentes. Atualizada pelo Research Agent quando há novidades.
> Última atualização: 2026-05-14 (research-agent run 2026-05-14)

---

## CCB — Aplicação Prática

### O que valida juridicamente uma CCB

Para uma CCB ter validade jurídica plena:

1. **Assinatura com certificado ICP-Brasil** — sem isso, a CCB não é título executivo extrajudicial. Assinatura por e-mail simples não tem força executória.
2. **Identificação completa do emitente** — CPF/CNPJ, endereço, qualificação
3. **Objeto claro** — valor, taxa, prazo, forma de pagamento
4. **Beneficiário identificado** — a instituição credora
5. **Registro em registradora** — para CCBs com garantia real ou recebíveis

### Erro frequente em produtos digitais

Plataformas aceitam "assinatura eletrônica simples" (clique, SMS, e-mail) pensando que é válido. Para fins de execução judicial, **só vale ICP-Brasil**. Para acordos comerciais sem execução (por exemplo, termos de serviço), assinatura simples pode ser suficiente — mas isso não é CCB.

### CCB Imobiliário — Particularidades

- A garantia (alienação fiduciária do imóvel) precisa de **registro em cartório de registro de imóveis** — não basta registrar na registradora financeira
- O bem imóvel deve estar livre de ônus anteriores (verificar matrícula)
- Prazo de alienação fiduciária: credor pode executar após inadimplência sem processo judicial (Lei 9.514/1997, art. 26)

---

## PIX — Aplicação Prática

### O que o BACEN exige do PSP na prática

- **Disponibilidade mínima:** 99,5% no mês — abaixo disso, sanção
- **Janela de manutenção:** máximo 30 minutos por semana, com comunicação prévia ao BACEN
- **Tempo de resposta:** meta é < 10s, mas o SLA contratual com o BACEN é mais tolerante
- **Fraude:** PSP é corresponsável por fraudes se não implementar os controles mínimos (Device ID, velocidade de transações, marcadores de risco)

### Limites e Restrições

- **Limite noturno obrigatório:** entre 20h e 6h, limite padrão de R$ 1.000 por transação (usuário pode solicitar aumento com prazo de 24h)
- **Devolução:** prazo de até D+90 para devolução por erro. Após isso, precisa de ação judicial
- **Contestação de fraude (MED 2.0 — vigente 02/02/2026):** usuário tem 80 dias para reportar — PSP deve exibir botão de contestação obrigatório no comprovante PIX. Rastreamento de fraude em 5 níveis de transferência. Bloqueio cautelar de até 72h para fundos suspeitos. PSP tem 7–10 dias úteis para devolução.

### PIX Garantido — O que é na prática

Modalidade onde o pagador compra parcelado via PIX. O PSP do pagador garante o pagamento ao recebedor mesmo que o pagador não pague as parcelas. O PSP faz a cobrança parcelada ao cliente e assume o risco de crédito. Ainda em regulação e fase de expansão.

---

## Arranjos de Pagamento — Linha de Corte Regulatória

### Quando o arranjo fechado precisa de autorização BACEN

Obrigatório quando **qualquer um** destes limites é ultrapassado em 12 meses:
- Volume de transações: > R$ 500 milhões
- Usuários finais ativos: > 500.000

Abaixo desses limites: isenção automática (Circ. BACEN 3.952/2019).

**Implicação para Edenred:** Se o arranjo crescer além desses limites, precisa de autorização como IP — processo demorado e custoso. Deve ser monitorado.

### O que muda ao se tornar IP autorizada

- Patrimônio mínimo exigido (varia por tipo de IP)
- Auditoria independente anual
- Política de segurança cibernética aprovada pelo BACEN
- Plano de continuidade de negócios
- Relatório anual de riscos
- Prazo de processo de autorização: 12-24 meses

---

## KYC na Prática — O que é "suficiente"

### Onboarding PF (Pessoa Física)

**Mínimo regulatório (BACEN Circ. 3.978/2020):**
- Nome completo, CPF, data de nascimento
- Endereço
- Renda declarada (ou estimada)
- Validação de identidade (foto de documento + selfie — biometria facial recomendada)

**Para crédito (CCB):**
- Consulta SCR (Sistema de Crédito Responsável — BACEN)
- Consulta Serasa/SPC
- Análise de capacidade de pagamento

### Onboarding PJ (Pessoa Jurídica — KYB)

- CNPJ, razão social, atividade (CNAE)
- Sócios e representantes legais (verificar cada um com KYC PF)
- **Beneficiário final** (obrigatório): quem detém > 25% da empresa
- Contrato social ou declaração de beneficiário final
- Consulta COAF se aplicável (setores de risco)

### PEP (Pessoa Exposta Politicamente)

Exige due diligence reforçada — não pode ser recusado automaticamente, mas precisa de aprovação de nível superior e monitoramento contínuo.

---

## LGPD Aplicada a Produtos Financeiros

### Bases Legais Mais Usadas no Setor

| Base Legal | Quando usar |
|---|---|
| **Execução de contrato** | Uso de dados para executar o serviço financeiro contratado (não precisa de consentimento explícito) |
| **Consentimento** | Uso de dados para marketing, compartilhamento com parceiros, Open Finance |
| **Legítimo interesse** | Uso para prevenção a fraude, análise de risco (desde que não sobreponha direito do titular) |
| **Obrigação legal** | Reporte ao COAF, envio de dados ao BACEN, declaração de IR |

### Erros Comuns em Produtos Financeiros

- Pedir consentimento para o que é obrigação legal (gera confusão e não é necessário)
- Misturar bases legais (usar consentimento onde a base é execução de contrato — aí revogação do consentimento não pode impedir a execução do serviço)
- Não ter DPA (Data Processing Agreement) com fornecedores que processam dados financeiros

---

## Red Flags que Atraem Atenção do BACEN

| Situação | Por que preocupa |
|---|---|
| Alta taxa de chargeback (> 1% do volume) | Sinal de fraude ou problema operacional |
| Crescimento rápido sem controles de AML | Risco de uso para lavagem de dinheiro |
| Saldos não utilizados acima do patrimônio | IP pode não ter lastro para devolver saldos |
| Falhas sistêmicas recorrentes no PIX | Viola SLA de disponibilidade — multa BACEN |
| Ausência de política de PLD aprovada | Autuação imediata |
| Beneficiário final não identificado (PJ) | Violação de KYB — risco de sanção |

---

## Cibersegurança BACEN — 14 Controles Mínimos Obrigatórios (Vigente: 01/03/2026)

> Normativos: Resolução BCB nº 538/2025 e Resolução CMN nº 5.274/2025 (atualizam normas de 2021)
> Impacto: todas as instituições autorizadas pelo BCB, incluindo provedores de serviços críticos (nuvem, processamento)
> Adicionado em 2026-05-14 pelo Research Agent.

### Os 14 Controles

| # | Controle | Descrição Prática |
|---|---|---|
| 1 | Autenticação e Criptografia | MFA obrigatório e criptografia de dados em trânsito e repouso |
| 2 | Detecção de Intrusão | IDS/IPS — sistemas de prevenção e detecção de invasões |
| 3 | Proteção contra Vazamento | DLP — controles para prevenção de vazamento de dados |
| 4 | Defesa contra Malware | Proteção específica contra códigos maliciosos |
| 5 | Rastreabilidade | Logs e trilhas de auditoria para evidência regulatória |
| 6 | Backups | Gestão e proteção de cópias de segurança |
| 7 | Gestão de Vulnerabilidades | Avaliação, testes e correção contínua de vulnerabilidades |
| 8 | Controle de Acesso | Revisão periódica de permissões, incluindo terceiros |
| 9 | Hardening | Configuração segura de sistemas e equipamentos |
| 10 | Segmentação de Rede | Firewall, segmentação e monitoramento de tráfego |
| 11 | Gestão de Certificados | Proteção de chaves privadas e certificados digitais |
| 12 | Segurança de APIs | Proteção em integrações de sistemas eletrônicos |
| 13 | Inteligência de Ameaças | Monitoramento na internet, deep web, dark web e grupos privados |
| 14 | Testes de Invasão | Pentest anual com documentação mantida por 5 anos |

### Atenção especial para ambientes PIX e STR

Ambientes que processam PIX e STR recebem requisitos adicionais de isolamento e proteção de credenciais — restrições mais rigorosas de segmentação e acesso.

### Impacto Prático para Opea e Edenred

- Qualquer BaaS, processador ou provedor de nuvem que a Opea ou Edenred usem também precisa cumprir estes controles
- DPAs com fornecedores devem ser revisados para incluir evidências de conformidade com esta resolução
- Pentest anual com plano de ação: se não há processo formal, este é um gap de conformidade imediato

---

## Fintechs e IPs — Novas Exigências de Capital e Autorização (2026)

> Adicionado em 2026-05-14 pelo Research Agent.

### Capital Mínimo Reajustado

| Tipo de IP | Capital Mínimo Anterior | Capital Mínimo 2026 |
|---|---|---|
| Instituição de Pagamento (geral) | R$ 1 milhão | R$ 9,2 milhões |
| Provedora de conta transacional PIX | — | R$ 5 milhões (a partir de 01/01/2026) |

### Autorização Prévia Obrigatória

A partir de 2026, fintechs precisam de autorização prévia do BACEN antes de iniciar operações, declarando detalhadamente todas as modalidades de serviços de pagamento que pretendem oferecer. O prazo de adequação foi antecipado de 2029 para maio de 2026.

### Equiparação ao Banco Tradicional

As fintechs entram no mesmo perímetro regulatório dos bancos: governança, compliance, prestação de informações ao Fisco e controles de cibersegurança equiparados.

### Implicação para Edenred

Se o arranjo PAT da Edenred ultrapassar os limites de isenção (R$ 500M em volume ou 500K usuários ativos), passa a exigir autorização como IP com capital mínimo de R$ 9,2M e todos os requisitos do perímetro regulatório BACEN.

---

## Ativos Virtuais — Marco Regulatório BACEN (vigente parcialmente em maio/2026)

> Resoluções BCB 519, 520 e 521. Vigência de obrigações informacionais: 04/05/2026.
> Adicionado em 2026-05-14 pelo Research Agent.

As três resoluções inauguram o marco regulatório das SPSAVs (Sociedades Prestadoras de Serviços de Ativos Virtuais):
- Critérios de autorização, funcionamento e fiscalização
- Obrigação de prestação de informações sobre operações com ativos virtuais vigente desde 4 de maio de 2026

**Relevância para Opea/Edenred:** Baixa relevância direta. Porém, o movimento de tokenização de recebíveis e CCBs pode eventualmente cruzar com este marco — monitorar.
