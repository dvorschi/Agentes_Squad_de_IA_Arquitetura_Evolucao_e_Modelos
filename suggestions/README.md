# Suggestions — Melhorias Pendentes de Aprovação

Toda sugestão de melhoria para o squad fica aqui até ser aprovada ou rejeitada pelo usuário.

> **Verificação automática:** No início de cada sessão Claude Code, verificar se há arquivos com status PENDENTE e alertar o usuário antes de continuar.

---

## Formato de Arquivo

Nome: `YYYY-MM-DD-[slug].md`
Exemplo: `2026-05-14-qa-criterio-modo-executivo.md`

## Estrutura de Cada Sugestão

```markdown
---
data: YYYY-MM-DD
origem: [agente que identificou | research-agent | usuário]
status: PENDENTE | APROVADO | REJEITADO
tipo: ALERTA_CRITICO | SUGESTAO_MELHORIA
prioridade: alta | média | baixa
prazo: [data-limite se ALERTA_CRITICO, senão omitir]
---

## O que mudou no mundo externo
[contexto da mudança que motivou a sugestão]

## Impacto no squad
[o que precisa ser atualizado e por quê]

## Mudança proposta
[ações específicas com arquivos a atualizar]
```

---

## Distinção ALERTA_CRITICO vs SUGESTAO_MELHORIA

| Tipo | Quando usar | Tratamento |
|---|---|---|
| `ALERTA_CRITICO` | Norma regulatória em vigor, prazo próximo, impacto direto no negócio | Bypass da fila normal — tratar na mesma sessão |
| `SUGESTAO_MELHORIA` | Melhoria operacional, nova feature do Claude, otimização de agente | Fila normal — revisar quando conveniente |

---

## Fluxo

```
Sugestão identificada
       ↓
Arquivo criado aqui (status: PENDENTE)
       ↓
Usuário recebe alerta no início da próxima sessão
       ↓
Usuário aprova → mudança aplicada → changelog atualizado → status APROVADO
Usuário rejeita → motivo registrado → status REJEITADO
```
