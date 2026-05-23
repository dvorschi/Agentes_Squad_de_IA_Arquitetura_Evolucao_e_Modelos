# Solução: Aba "Marcos Entregáveis" — Sprint Board Opea

> Documento de referência para reutilização desta solução em outros projetos ou clientes.
> Criado em: 2026-05-19 | Versão implementada: v1.6.0 do opea_sprint_board

---

## O que é

Uma aba standalone injetada no Sprint Board Opea para apresentar ao cliente os **marcos de entrega por sprint**, organizados em formato Kanban. A aba é completamente independente do restante do Sprint Board — não consome `window.data`, não interfere nas outras abas (Cronograma, Backlog, Marcos, Sprint, Review, etc.).

**Propósito:** Apresentação executiva de entregas de valor para o cliente, sprint a sprint, com visual polido e conteúdo totalmente editável.

---

## Localização do artefato

```
Opea_Jira/opea_sprint_board/v1.6.0/opea_sprint_board.html
```

O código da aba está concentrado em dois blocos no final do arquivo:
- `<style id="mec-styles">` — CSS de todos os layouts
- `<script id="mec-tab-script">` — lógica completa (IIFE autônomo)

---

## Estrutura de dados

O estado global vive em `window.mecData` (obrigatório — nunca `let`/`const` para estado compartilhado no Sprint Board).

```javascript
window.mecData = {
  title: 'Marcos Entregáveis',
  sprints: [
    {
      id: 's10',
      name: 'Sprint 10',
      dates: '22/06 - 03/07',
      hc: '#C8E6C9',      // cor do header da coluna
      mvp: true,           // opcional — exibe badge ⭐ MVP
      cards: [
        {
          id: 'c1001',
          title: 'Asset Ledger (Parametrização)',
          color: '#F8BBD9',
          items: [          // itens diretos do card
            'Verificar Blacklist; (S10)',
            '<span class="mec-sub">Simulação; (S10)</span>'  // subitem recuado
          ],
          sections: [       // sub-blocos dentro do card (opcional)
            {
              title: 'Opea Gerando PDF (MVP)',
              color: '#F0F4C3',
              items: ['Geração de PDF; (S10)', 'Assinatura; (S10)']
            }
          ]
        }
      ]
    }
  ]
}
```

### Regras do modelo de dados

| Regra | Detalhe |
|-------|---------|
| `items` + `sections` coexistem | Um card pode ter ambos: items renderizam primeiro, sections abaixo |
| Subitem recuado | Envolver em `<span class="mec-sub">texto</span>` |
| Strikethrough | Usar `<s>texto</s>` diretamente no item |
| Badge MVP | Adicionar `mvp: true` ao objeto sprint |
| Persistência | `localStorage` com chave `opea_mec_v1` |

---

## Layouts disponíveis (5)

| Layout | Nome | Estilo | Melhor para |
|--------|------|--------|-------------|
| 1 | Kanban Fiel | Fundo claro, headers coloridos, cards com background sólido | Fidelidade ao quadro original do cliente |
| 2 | Kanban Compacto | Colunas 220px, border-left, fonte menor | Impressão / PDF |
| 3 | Kanban Premium Dark | Fundo `#0F0F1A`, cards com barra colorida no topo | Apresentações digitais em projetor |
| 4 | Apple Clarity | Fundo `#F2F2F7`, cards brancos com sombra suave e barra colorida no topo | Apresentações premium de dia |
| 5 | Apple Midnight | Fundo `#1C1C1E`, cards `#3A3A3C`, texto branco hierárquico | Apresentações premium noturnas / telas escuras |

---

## Capacidades de edição (modo ✏️ Editar)

- Sprint: editar nome, datas, cor do header, excluir sprint
- Card: editar título, cor, excluir card
- Section: editar título, cor, excluir section
- Item (card e section): editar texto inline, suporte a HTML (`<s>`, `<span>`)
- Adicionar: nova sprint, novo card, nova section, novo item
- Salvar: persiste em `localStorage`
- Restaurar: reverte para dados padrão (`MEC_DEFAULT`)
- Exportar: gera HTML standalone (usa `forceBrowserDownload`)

---

## Integração com o Sprint Board

A aba é injetada via `DOMContentLoaded` sem tocar no código existente:

```javascript
// Injeta tab no nav
navTabs.appendChild(btn);  // btn com id="tab-mec"

// Injeta view container
main.insertBefore(viewMec, afterNav);  // div#view-mec

// Override de switchTab com cadeia preservada
var _prevSwitch = window.switchTab;
window.switchTab = function(tab) { ... };
```

**Zero impacto** em Cronograma, Backlog, Marcos, Sprint, Review, Retrospectiva, Calculadora, Gantt, PDF, JSON.

---

## Decisões técnicas relevantes para reutilização

### 1. sections vs cards separados

O modelo `sections` dentro de um card foi criado para representar features (ex: "Opea Gerando PDF (MVP)") dentro de um épico (ex: "Asset Ledger (Originação)"), sem criar cards independentes com nomes de features como título de épico.

**Quando usar sections:** quando um card agrupa múltiplas sub-entregas que têm nome próprio mas pertencem ao mesmo épico.

### 2. Títulos de sections visíveis apenas em visualização

Em modo visualização, sections mostram apenas o título em negrito (sem fundo colorido). A cor e o visual de destaque aparecem somente em modo edição — para não poluir a apresentação ao cliente.

### 3. HTML inline nos itens

Items são strings que podem conter HTML. A renderização usa `innerHTML` (não `innerText`), o que permite:
- `<s>texto</s>` — strikethrough
- `<span class="mec-sub">texto</span>` — subitem recuado 14px

### 4. Estado sempre em `window.*`

Regra do Sprint Board: nunca usar `let`/`const` para estado global. Todo estado da aba usa `window.mecData`, `window.mecEditMode`, `window.mecLayout`.

### 5. Export standalone

A função `mecExport()` gera um HTML completo independente, copiando o `<style id="mec-styles">` para o `<head>`. O download usa `forceBrowserDownload(blob, filename, msg)` que trata contextos de iframe vs browser direto.

---

## Como adaptar para outro projeto/cliente

1. **Copiar os dois blocos** (`<style id="mec-styles">` e `<script id="mec-tab-script">`) para qualquer HTML que tenha `.nav-tabs` e `.main`
2. **Trocar `MEC_DEFAULT`** com os dados do novo projeto
3. **Trocar a chave de localStorage** (`opea_mec_v1`) para evitar conflito entre projetos
4. **Ajustar o ícone/nome da aba** na linha `btn.innerHTML='&#128506;&#65039; Entregas'`
5. Se o HTML destino não tem `forceBrowserDownload` ou `toast`, substituir ou criar fallbacks

---

## Histórico de iterações desta solução (Sprint Board Opea)

| Versão | Data | O que mudou |
|--------|------|-------------|
| v1.5.0 | 2026-05-19 | Criação da aba — 3 layouts, dados iniciais do cliente, edição inline |
| v1.6.0 | 2026-05-19 | Sub-indentação S09/S10, badge MVP Sprint 10, cor "Opea Gerando PDF", +2 layouts Apple (Clarity + Midnight), estrutura `sections` dentro de cards, correções visuais de cor e título |

---

## Contato e manutenção

Artefato mantido pelo squad via skill `/opea_jira`. Versões são imutáveis — cada entrega cria nova pasta `vX.Y.Z/`. Para evoluir, invocar `/opea_jira` com a descrição da mudança.
