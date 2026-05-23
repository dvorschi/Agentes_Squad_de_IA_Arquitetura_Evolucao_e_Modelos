# Como Atualizar o Artefato de Organização do Squad

> **Obrigação:** Este artefato (`squad-overview.html`) deve ser atualizado após TODA evolução do squad — junto com changelog, squad-arquitetura-e-evolucao.md e Github/. Os quatro se movem juntos.

---

## O que é este diretório

`Organizacao_Squad/` contém o artefato visual oficial que descreve o squad de IA para qualquer pessoa que precise entender como ele funciona.

| Arquivo | Propósito |
|---------|-----------|
| `squad-overview.html` | Dashboard visual completo do squad — abre no browser |
| `COMO-ATUALIZAR.md` | Este arquivo — protocolo de atualização |

---

## Quando atualizar

Atualizar `squad-overview.html` sempre que houver:

- Novo agente adicionado ou removido
- Novo playbook criado
- Nova skill (`/command`) criada
- Mudança de modelo de um agente (sonnet ↔ opus)
- Mudança de responsabilidade de um agente
- Nova versão do Sprint Board Opea ou Edenred
- Nova regra de governança ou protocolo
- Mudança em modos de execução
- Novo sub-agente ou reclassificação de boundary
- Atualização regulatória relevante (ex: novos caps PAT, PIX MED 2.0)
- Qualquer mudança que altere o squad-arquitetura-e-evolucao.md

---

## O que atualizar no HTML

O arquivo `squad-overview.html` é um HTML standalone autocontido. Para atualizar:

### 1. Versão e data no cabeçalho

Localizar e atualizar as duas ocorrências de versão/data:

```
<!-- No header badges -->
<div class="badge badge-purple"><span class="badge-dot"></span>v1.9.10</div>

<!-- No parágrafo de contexto do header -->
Versão v1.9.10 · Atualizado em 2026-05-21
```

### 2. Novo agente

Adicionar card na grid `#agentsGrid` (seção `id="agentes"`):

```html
<div class="agent-card" data-layer="[CAMADA]">
  <div class="agent-header">
    <span class="agent-name">[nome-do-agente]</span>
    <span class="agent-model model-[opus|sonnet]">[Opus|Sonnet]</span>
  </div>
  <div class="agent-desc">[Descrição em 2-3 linhas]</div>
  <span class="agent-layer layer-[CAMADA]">[Nome da Camada]</span>
</div>
```

**Valores de `data-layer`:** `intel` | `produto` | `memoria` | `arq` | `econ` | `qa` | `sub` | `exec`

Atualizar também:
- O contador no filter-btn correspondente
- O stat card "Agentes Especializados" no overview (atualmente 27)
- O diagrama de camadas na seção `id="arquitetura"` se necessário

### 3. Nova versão de Sprint Board

Na seção `id="projetos"`, localizar o badge e a linha de versão do produto (Opea ou Edenred) e atualizar.

### 4. Novo playbook ou skill

Na seção `id="playbooks"`:
- Skills: adicionar novo `card` no grid de 4
- Playbooks: adicionar novo `playbook-card` com número sequencial

### 5. Nova regra de governança

Na seção `id="governanca"`, adicionar linha na tabela "Regras Invioláveis" ou no card de "Obrigações Pós-Entrega".

### 6. Nova entrada no histórico

Na seção `id="evolucao"`, inserir novo `tl-item` no TOPO da timeline:

```html
<div class="tl-item">
  <div class="tl-dot [tl-dot-major se major]"></div>
  <div class="tl-version [tl-version-major se major]">vX.Y.Z — YYYY-MM-DD</div>
  <div class="tl-title">[Título curto]</div>
  <div class="tl-desc">[Descrição do que mudou e por quê]</div>
</div>
```

### 7. Alerta de freeze ou regulatório

Na seção `id="overview"`, o bloco `.alert` já existe. Atualizar texto ou remover quando o freeze expirar (2026-06-03).

---

## Fluxo completo de atualização pós-mudança no squad

Após qualquer mudança no squad, o agente responsável deve executar na ordem:

```
1. changelog/changelog.md                                    → adicionar entrada
2. Github/Documentacao_Claude/squad-arquitetura-e-evolucao.md → seção de evolução + catálogo (fonte única — raiz foi removida em 2026-05-21)
3. Organizacao_Squad/squad-overview.html                     → este artefato visual
4. Github/Organizacao_Squad/squad-overview.html              → espelho do item 3
5. Organizacao_Squad/COMO-ATUALIZAR.md                       → este arquivo (se protocolo mudou)
6. Github/Organizacao_Squad/COMO-ATUALIZAR.md                → espelho do item 5
```

**Nunca atualizar apenas um deles** — todos devem refletir o mesmo estado do squad.

---

## Abrir o arquivo no browser

O arquivo `squad-overview.html` é completamente standalone — sem dependências externas. Abre diretamente no navegador:

```
Duplo clique no arquivo
→ ou arrasta para uma aba do browser
→ ou: File → Open File → squad-overview.html
```

---

## Quem é responsável pela atualização

O `strategic-memory-manager` coordena a atualização deste artefato ao final de entregas enterprise ou após mudanças arquiteturais no squad. O `task-memory-manager` registra a atualização em `memory/squad/tasks/`.

Em sessões simples (fix de Sprint Board, ajuste pontual), a atualização pode ser feita diretamente pelo agente executor antes de encerrar a entrega.

---

*Criado em: 2026-05-21 | Manter atualizado junto com squad-arquitetura-e-evolucao.md*
