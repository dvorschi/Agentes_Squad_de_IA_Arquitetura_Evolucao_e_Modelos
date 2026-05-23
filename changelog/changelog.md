# Changelog — Squad de Agentes

> Registro versionado de toda mudança aplicada ao squad.
> Atualizado automaticamente após cada modificação aprovada.

---

## Formato de Entrada

```markdown
## [versão] — [data]

### Tipo
Novo agente | Atualização de agente | Novo playbook | Context file | Infraestrutura | Governança

### Mudanças
- [arquivo]: [o que mudou]

### Motivo
[por que essa mudança foi feita]

### Aprovação
[quem aprovou — usuário / research-agent / ai-operations-analyst]
```

---

## v1.9.0 — 2026-05-15

### Tipo
Nova integração externa — Teams Intelligence System

### Mudanças
- `teams-integration/src/auth.py`: autenticação MSAL device code flow, token cache persistido
- `teams-integration/src/fetcher.py`: captura chats 1:1 via Microsoft Graph API, paginação, deduplicação, strip HTML
- `teams-integration/src/processor.py`: classifica conversas via Claude API (8 categorias de domínio)
- `teams-integration/src/pattern_engine.py`: analisa mensagens enviadas por Vitor, gera vitor-style.md
- `teams-integration/src/faq_generator.py`: gera FAQ .md por categoria (mín. 3 conversas base)
- `teams-integration/src/main.py`: CLI com flags --fetch, --process, --patterns, --faq, --suggest, --all
- `teams-integration/requirements.txt`: dependências pinadas (msal, anthropic, rich, tenacity)
- `teams-integration/config/.env.example`: template de configuração documentado
- `teams-integration/README.md`: setup em 5 passos

### Motivo
PM solicitou sistema para capturar histórico de conversas 1:1 do Teams, classificar por domínio financeiro, aprender estilo de comunicação e sugerir respostas futuras. Substitui processo manual de busca de contexto antes de responder stakeholders.

### Aprovação
Usuário (escopo 1:1, sem canais, bidirecional)

---

## v1.0.0 — [data de instalação]

### Tipo
Fundação do squad — instalação inicial

### Mudanças
- `agents/orchestrator.md`: instalado
- `agents/prompt-engineer.md`: instalado
- `agents/qa-test-engineer.md`: instalado
- `agents/product-manager.md`: instalado
- `agents/executive-storyteller.md`: instalado
- `agents/business-analyst-financeiro.md`: instalado
- `agents/financial-systems-architect.md`: instalado
- `agents/technical-lead.md`: instalado
- `agents/strategic-memory-manager.md`: instalado
- `agents/ai-operations-analyst.md`: instalado
- `agents/context-manager.md`: instalado
- `agents/payments-economics-analyst.md`: instalado
- `agents/data-product-strategist.md`: instalado
- `agents/solution-architect.md`: instalado
- `agents/executive-reviewer.md`: instalado
- `agents/research-agent.md`: instalado
- `context/business/`: preenchido com dados do produto
- `CLAUDE.md`: configurado com contexto do PM

### Motivo
Instalação inicial do squad de agentes especializados em produtos financeiros.

### Aprovação
Usuário
