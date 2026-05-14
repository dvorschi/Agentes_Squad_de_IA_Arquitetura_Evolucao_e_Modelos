# Padrões e Aprendizados do Squad

> O que aprendemos operando. Bugs descobertos, padrões que funcionam, armadilhas a evitar.
> Atualizado pelo Strategic Memory Manager após entregas relevantes.
> Última atualização: 2026-05-14

---

## Aprendizados Técnicos — Sprint Board (Opea)

### Bug #1 — `let` vs `window.*` em HTML standalone

**Descoberto em:** 2026-05-13
**Sintoma:** Dados da aba "Marcos" exibiam informações do produto Opea em vez do produto correto. Calculadora ficava bloqueada no artifact viewer.
**Causa:** Uso de `let` para variáveis globais compartilhadas em HTML de arquivo único. `let` tem escopo de bloco — em contextos como artifact viewers, o isolamento de contexto cria escopo separado para cada bloco.
**Solução:** Toda variável global compartilhada deve usar `window.nomeVariavel` em vez de `let nomeVariavel`.
**Regra derivada:** Ver `playbooks/playbook-html-fix.md` — restrições absolutas.

### Bug #2 — `data:` URL vs `srcdoc` em iframes

**Descoberto em:** 2026-05-13
**Sintoma:** Calculadora integrada ao Sprint Board não abria no artifact viewer do Claude.
**Causa:** `data:` URL para conteúdo de iframe é bloqueado por política de segurança em artifact viewers e alguns browsers modernos.
**Solução:** Usar `srcdoc="..."` em vez de `src="data:text/html,..."` para iframes com conteúdo inline.
**Regra derivada:** Adicionada ao `playbooks/playbook-html-fix.md`.

---

## Padrões de Orquestração que Funcionam

### Fast lane funciona bem para

- Correções de texto/label no Sprint Board
- Ajustes de CSS pontuais (cor, espaçamento)
- Correção de variável `let` → `window.*`
- Adição de opção em dropdown existente

**Por que funciona:** Escopo pequeno, agente único óbvio, sem impacto em estado ou localStorage.

### Fast lane falha quando

- A mudança parece simples mas toca localStorage
- O pedido envolve "a mesma coisa que você fez antes" mas em contexto diferente
- O agente não leu o context file antes de executar

**Padrão identificado:** Quando o agente pula a leitura de `context/business/opea.md`, a taxa de retrabalho sobe. Leitura obrigatória de context file deve ser enforçada no início de toda execução.

---

## Padrões de Comunicação Executiva

### O que funciona com este PM

- Resposta no formato: Contexto → Problema → Diagnóstico → Alternativas → Recomendação → Riscos → Impacto → Próximos passos
- Premissas declaradas explicitamente quando informação está faltando
- Tom executivo direto — sem introduções genéricas
- Números com contexto comparativo (vs. meta, vs. benchmark)

### O que não funciona

- Respostas genéricas sem especificidade do domínio financeiro
- Listar opções sem dar recomendação clara
- Linguagem passiva em comunicação executiva
- Jargão técnico não traduzido para impacto de negócio

---

## Decisões de Arquitetura do Squad

### Boundary: `context-manager` vs `strategic-memory-manager`

**Decisão (2026-05-14):** Os dois agentes coexistem com funções distintas.
- `context-manager` = estado operacional VIVO desta sessão (curto prazo)
- `strategic-memory-manager` = decisões históricas permanentes (longo prazo)

**Por que importa:** Confundir os dois leva o context-manager a registrar coisas que deveriam ser esquecidas, e o SMM a ter contexto de sessão desnecessariamente.

### Boundary: `solution-architect` vs `financial-systems-architect`

**Decisão (2026-05-14):** Atuam em sequência em produtos regulados.
- `financial-systems-architect` → O QUÊ: regulação, compliance, fluxo financeiro correto
- `solution-architect` → COMO: APIs, event-driven, resiliência, integrações SPB

**Por que importa:** O FSA define os requisitos. O SA define como atendê-los tecnicamente. Inverter a ordem leva a arquitetura técnica sem validação regulatória.

### Agentes genéricos vs especializados para QA

**Decisão (2026-05-14):** Para este squad, apenas o `qa-test-engineer` customizado deve ser acionado para validação. O `qa-expert` genérico é redundante no contexto de produtos financeiros.

---

## Padrões de Qualidade Aprovados

### Critério mínimo para feature do Sprint Board

- [ ] Não quebra localStorage existente
- [ ] Modo executivo/cliente sem regressão visual
- [ ] Variáveis globais usando `window.*`
- [ ] Testado em nova aba (simula novo usuário)

### Critério mínimo para artefato executivo

- [ ] Executive Reviewer aprovou antes de enviar ao cliente
- [ ] Nenhum número sem contexto comparativo
- [ ] Decisão ou próximos passos claros ao final
- [ ] Premissas declaradas explicitamente

---

## Armadilhas a Evitar

| Armadilha | Contexto | Como evitar |
|---|---|---|
| Modificar o que não foi solicitado no HTML | Sprint Board tem 8.000 linhas — mudanças adjacentes causam regressão silenciosa | Ler escopo com atenção, tocar só o necessário |
| Criar agente novo para cobrir sobreposição | Agentes com responsabilidades similares criam conflito de orquestração | Verificar catálogo antes de criar — ajustar boundary se necessário |
| Usar modelo Opus onde Sonnet resolve | Custo e latência desnecessários | Opus para: análise financeira complexa, revisão arquitetural, decisões regulatórias de alto risco |
| Assumir premissas sem declarar | Em produtos financeiros, premissa errada = modelo errado = decisão errada | Sempre declarar premissas com fonte ou grau de incerteza |
