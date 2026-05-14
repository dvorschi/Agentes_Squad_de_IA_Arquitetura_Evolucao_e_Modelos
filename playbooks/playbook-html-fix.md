# Playbook: Correção e Melhoria em HTML — Opea Sprint Board

> Aplicar sempre que a demanda envolver mudança no `opea_sprint_planner_*.html`.
> Leitura obrigatória: `context/business/opea.md` antes de executar.

---

## Quando Usar Este Playbook

- Correção de bug no Sprint Board (qualquer versão)
- Adição de campo, elemento ou funcionalidade pontual
- Ajuste visual (CSS, layout, cor, espaçamento)
- Correção de lógica isolada em uma função
- Qualquer mudança no HTML standalone do Opea

---

## Pré-condições Obrigatórias

Antes de qualquer mudança:

- [ ] Ler `context/business/opea.md` — entender o contexto do produto
- [ ] Identificar **qual arquivo** é alvo: `_premium_final.html` ou `_cliente_final.html`
- [ ] Entender o **escopo exato** da mudança — o que entra e o que NÃO entra
- [ ] Verificar se a mudança afeta **localStorage** (maior risco de regressão)
- [ ] Verificar se a mudança toca o **modo executivo/cliente** (zero tolerância para quebra)

---

## Execução — Passo a Passo

### Passo 1 — Diagnóstico

1. Ler a seção do arquivo próxima ao local da mudança (± 100 linhas de contexto)
2. Identificar as variáveis envolvidas — são `window.*` ou locais?
3. Mapear quais funções são chamadas pela área afetada
4. Verificar se há dependência com localStorage (leitura/escrita)
5. Confirmar o comportamento atual (o que está errado / o que precisa mudar)

### Passo 2 — Planejamento da Mudança

1. Definir a mudança mínima necessária — o menor escopo que resolve o problema
2. Identificar o que **não pode ser alterado** (regras de negócio, layout em modo cliente)
3. Verificar se há padrão similar já implementado no arquivo para seguir consistência
4. Declarar variáveis globais como `window.*` — NUNCA `let`/`const` para estado compartilhado

### Passo 3 — Implementação

1. Aplicar a mudança no escopo definido
2. Seguir o padrão do arquivo existente (formatação, nomenclatura, estilo)
3. Não adicionar comentários desnecessários — código claro dispensa explicação
4. Se adicionando função nova: verificar colisão de nome com funções existentes

### Passo 4 — Validação de Regressão

Verificar que os seguintes fluxos continuam funcionando após a mudança:

- [ ] Criar novo sprint — fluxo completo
- [ ] Adicionar história ao backlog
- [ ] Mover história entre lanes (Backlog → Em Andamento → Concluído)
- [ ] Fechar sprint e registrar no histórico
- [ ] Abrir Sprint Board em nova aba (localStorage persiste?)
- [ ] Alternar entre modo interno e modo executivo/cliente
- [ ] Calculadora — abre e calcula corretamente
- [ ] Aba Marcos — exibe dados corretos (não dados de outro produto)

### Passo 5 — Validação do Escopo Solicitado

- [ ] O problema original foi resolvido?
- [ ] O comportamento esperado está correto?
- [ ] Nenhum efeito colateral foi introduzido?

### Passo 6 — Entrega para QA

Passar para o `qa-test-engineer` com:
- Descrição da mudança feita
- Localização exata no arquivo (função/linha)
- Fluxos que foram testados
- Fluxos de regressão que precisam ser validados

---

## Restrições Absolutas

Estas regras nunca podem ser violadas:

| Proibido | Por quê |
|---|---|
| `let` ou `const` para variáveis globais | Colisão de escopo no HTML único — usar `window.*` |
| `data:` URL em iframes | Bloqueado em artifact viewers — usar `srcdoc` |
| Alterar regras de negócio sem solicitação | Risco de corromper lógica de produto |
| Modificar layout em modo executivo/cliente sem autorização | Impacto direto na apresentação ao cliente |
| Remover ou renomear funções existentes | Pode quebrar chamadas em outros pontos do arquivo |
| Alterar comportamento do localStorage sem análise | Risco de perda de dados do usuário |

---

## Exemplos de Fast Lane (sem PE nem Orchestrator)

Estas mudanças qualificam para fast lane direta:

- Corrigir texto de label, placeholder ou mensagem de confirmação
- Ajustar cor via CSS pontual
- Corrigir variável `let` para `window.*` em função isolada
- Adicionar opção em dropdown existente
- Corrigir cálculo em função com resultado errado (sem impacto em outros cálculos)

---

## Exemplos que NÃO qualificam para fast lane

- Mudança em persistência (localStorage)
- Nova feature com estado próprio
- Impacto em modo executivo/cliente
- Mudança em mais de 2 funções interdependentes
- Novo fluxo de sprint lifecycle
