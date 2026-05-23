# rejected/ — Histórico de Sugestões Rejeitadas

Sugestões que foram analisadas e rejeitadas pelo usuário. O motivo da rejeição é registrado para evitar que a mesma sugestão seja regenerada no futuro sem novo contexto.

---

## Quando mover um arquivo para cá

Quando uma sugestão em `suggestions/` for revisada e rejeitada, mova o arquivo para esta pasta e adicione a seção `## Rejeição` ao arquivo.

---

## Formato obrigatório ao rejeitar

Adicione ao final do arquivo `.md` da sugestão:

```markdown
## Rejeição

**Data:** [YYYY-MM-DD]
**Decidido por:** [usuário | revisão de squad]

### Motivo
[Por que foi rejeitada — ex: já existe solução equivalente, overengineering, fora de escopo, contexto mudou]

### Condição para reavaliar
[O que precisaria mudar para essa sugestão ser retomada — ex: "quando volume de memory/ passar de 200 arquivos" | "nunca — solução definitiva"]
```

---

## Regras

- Nunca deletar arquivos desta pasta — o histórico de rejeições é parte da governança
- Se o contexto mudar e a sugestão voltar a ser relevante, mover de volta para `suggestions/` com novo status `PENDENTE` e nota explicando a retomada
- O research-agent deve verificar `rejected/` antes de criar nova sugestão similar em `suggestions/`
