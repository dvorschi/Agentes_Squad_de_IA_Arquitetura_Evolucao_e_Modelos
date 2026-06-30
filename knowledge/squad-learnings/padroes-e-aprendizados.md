# Padrões e Aprendizados do Squad

> O que aprendemos operando. Bugs descobertos, padrões que funcionam, armadilhas a evitar.
> Atualizado pelo Strategic Memory Manager após entregas relevantes.
> Última atualização: 2026-06-24

---

## Aprendizados Técnicos — Supabase / Expo / Asaas

### Padrão #S1 — Supabase: RETURNING após INSERT é filtrado pela política SELECT, não pela INSERT

**Descoberto em:** 2026-06-26 (Vitrine v0.5.0 — checkout PIX)
**Sintoma:** `.insert({...}).select().single()` retornava erro RLS mesmo com `WITH CHECK (true)` na política INSERT.
**Causa:** No Supabase/PostgreSQL, `RETURNING` é filtrado pela política SELECT (`USING`), não pela INSERT (`WITH CHECK`). Se a política SELECT bloqueia o registro (ex: `consumer_user_id = auth.uid()` e auth.uid() = null), o `.single()` lança erro.
**Solução:** Nunca encadear `.select()` após `.insert()` quando há RLS. Fazer dois passos: INSERT puro, depois SELECT por campo único (coupon_code, slug, etc.) que seja imutável e único.
**Regra derivada:** Em qualquer projeto Supabase com RLS — INSERT sempre separado de SELECT. Nunca confiar que `WITH CHECK (true)` garante que o RETURNING vai funcionar.

### Padrão #S2 — Asaas sandbox exige CPF mesmo para PIX

**Descoberto em:** 2026-06-26 (Vitrine v0.5.0)
**Sintoma:** `create-order-pix-charge` retornava `"Para criar esta cobrança é necessário preencher o CPF ou CNPJ do cliente"` mesmo no sandbox.
**Causa:** Asaas valida CPF/CNPJ em todos os ambientes, não só produção.
**Solução:** Usar CPF de teste `00000000191` quando `ASAAS_SANDBOX=true` e CPF não informado. Em produção, campo CPF é obrigatório no formulário.
**Regra derivada:** Qualquer integração com Asaas (sandbox ou prod) — sempre incluir CPF. Preparar fallback de teste no edge function.

### Padrão #S3 — Webhooks de terceiros exigem `--no-verify-jwt` no Supabase

**Descoberto em:** 2026-06-26 (Vitrine v0.5.0 — asaas-webhook)
**Sintoma:** Asaas enviava webhook mas recebia `401 Unauthorized` da Edge Function.
**Causa:** Supabase Edge Functions por padrão exigem JWT do Supabase no header Authorization. Sistemas externos (Asaas, Stripe, etc.) não têm esse JWT.
**Solução:** `supabase functions deploy <nome> --no-verify-jwt`. Segurança garantida pelo token próprio do webhook (ex: `asaas-access-token` header).
**Regra derivada:** Qualquer webhook de sistema externo → obrigatório `--no-verify-jwt`. O token do sistema externo substitui o JWT como mecanismo de autenticação.

### Padrão #S4 — Migrations Supabase devem ser idempotentes

**Descoberto em:** 2026-06-29 (Vitrine v0.5.0 — migration v12)
**Sintoma:** `ERROR: 42710: policy "reviews_public_read" already exists` ao rodar migration pela segunda vez.
**Causa:** PostgreSQL não suporta `CREATE POLICY IF NOT EXISTS`. Uma migration executada duas vezes falha.
**Solução:** Sempre usar `DROP POLICY IF EXISTS` antes de `CREATE POLICY`. Para funções: `CREATE OR REPLACE FUNCTION`. Para tabelas e índices: `IF NOT EXISTS`. Para triggers: `DROP TRIGGER IF EXISTS` antes de `CREATE TRIGGER`.
**Regra derivada:** Todo arquivo migration deve ser 100% idempotente. Rodar duas vezes não pode causar erro.

### Padrão #S5 — Push iOS: permissão pedida uma vez, fallback obrigatório

**Descoberto em:** 2026-06-29 (Vitrine v0.5.0 — push notifications)
**Sintoma:** Alerta de permissão não apareceu ao visitar a aba Perfil.
**Causa:** iOS mostra o alerta de permissão de notificações apenas uma vez por app. Se Expo Go já tinha solicitado antes (e foi negado ou ignorado), não pede mais.
**Solução:** (1) Registrar push no root `_layout.tsx` via componente `PushRegistrar` (não em tela específica). (2) Sempre incluir botão manual "Ativar notificações" com detecção de estado `denied` direcionando para Configurações do iOS.
**Regra derivada:** Nunca assumir que a permissão será solicitada na primeira abertura. Sempre incluir botão de ativação manual como fallback.

---

## Aprendizados Técnicos — Bots n8n / Agentes IA

### Padrão #1 — Gemini requer templates concretos; GPT aceita regras abstratas

**Descoberto em:** 2026-06-24 (Bot Barbearia v1.1 → v1.3)
**Sintoma:** Ao migrar o agente de GPT para Gemini 2.5 Flash, a formatação das respostas regrediu — sem ícones, sem bold, parágrafos corridos — apesar de o system prompt conter regras explícitas de formatação ("use asteriscos para destacar", "máximo 3 ícones", etc.).
**Causa:** GPT interpreta regras descritivas e as aplica contextualmente. Gemini 2.5 Flash ignora regras abstratas e precisa de exemplos concretos — templates prontos com o padrão exato de resposta que deve ser copiado.
**Solução:** Substituir regras narrativas por templates prontos no prompt. O agente copia o template em vez de interpretar a instrução. Ex: em vez de "use ícones moderadamente", mostrar a mensagem formatada exatamente como deve aparecer.
**Regra derivada:** Ao escrever system prompts para Gemini: sempre incluir templates de resposta. Para GPT: instruções narrativas são suficientes. Ao migrar de GPT para Gemini, reescrever o prompt com foco em exemplos, não em regras.

### Padrão #2 — pushName descartado por nós Set intermediários

**Descoberto em:** 2026-06-24 (Bot Barbearia)
**Sintoma:** O campo `pushName` (nome do cliente no WhatsApp) era capturado no nó `Dados1` mas não chegava ao agente — apesar de estar disponível no webhook.
**Causa:** Nós Set (Edit Fields) em n8n v3.x por padrão passam APENAS os campos explicitamente declarados. Campos não listados são descartados silenciosamente nos nós intermediários da cadeia.
**Solução:** Referenciar diretamente o nó de origem com `$('Dados1').first().json.pushName` no nó que alimenta o agente, pulando a cadeia intermediária. Mais robusto que propagar campo por campo.
**Regra derivada:** Em n8n, nunca assumir que campos fluem automaticamente por nós Set. Sempre referenciar a fonte diretamente para campos adicionais ou usar Set com "Include all input fields" ativado.

### Padrão #4 — Cross-node references a nós PRÉ-Wait quebram após resume no n8n 2.20.11

**Descoberto em:** 2026-06-24 (Bot Barbearia v1.4.x)
**Sintoma:** Após o `Wait 4s` (debounce buffer), o campo `phone` chegava `undefined` em todos os nós downstream. O bot não enviava mensagem.
**Causa:** `$('Acquire Lock').first().json.phone` no `Concat Messages` (Code node) — o nó `Acquire Lock` roda ANTES do `Wait`. O n8n 2.20.11 não preserva referências cross-node para nós executados antes do Wait após a retomada da execução serializada.
**Solução:** Nós pré-Wait NÃO podem ser referenciados via `$('NodeName')` em nós pós-Wait. Fix: incluir `phone` no SELECT do `Read Buffer` (SELECT phone, message FROM ...) e usar `items[0]?.json?.phone` no Code node — sem cross-node ref.
**Regra derivada:** Em workflows n8n com Wait node: NUNCA usar `$('NodeName').first()` para nós executados ANTES do Wait em nós executados DEPOIS. Dados pré-Wait devem ser propagados explicitamente via SELECT ou passagem de campo a campo.

### Padrão #5 — Set node v3.4 (assignments) serializa cross-node refs como objeto completo

**Descoberto em:** 2026-06-24 (Bot Barbearia v1.5.x)
**Sintoma:** Campo `number` no HTTP Request recebia o item inteiro serializado `{"json":{"phone":"..."},"pairedItem":{...}}` em vez do string do telefone. Resultado: 400 Bad Request na Evolution API.
**Causa:** Set node v3.4 no modo `assignments`, ao receber `$('NodeName').first().json.phone`, serializa o resultado como objeto completo em vez de extrair o valor primitivo string.
**Solução:** Mover cross-node references para diretamente nos parâmetros do nó consumidor (ex: HTTP Request body parameter), não via Set node intermediário. HTTP Request avalia a expressão como string primitiva.
**Regra derivada:** Em n8n, nunca passar cross-node refs via Set node v3.4 (assignments) esperando valor primitivo. Usar a referência diretamente no nó que consome o valor.

### Padrão #6 — Google Calendar API exige ISO 8601 com timezone

**Descoberto em:** 2026-06-24 (Bot Barbearia)
**Sintoma:** Evento não era criado no Google Calendar após confirmação. O agente respondia com "Agendamento confirmado!" mas o evento não aparecia.
**Causa:** O system prompt instruía `start_date: horário confirmado (UTC-3 Brasília)` sem especificar formato. Gemini enviava datas no formato "29/06/2026 10:00" ou similar. Google Calendar API rejeita formatos não-ISO 8601.
**Solução:** Especificar no prompt o formato exato com exemplo: `"2026-06-29T10:00:00-03:00"` e incluir exemplo completo de start+end para o serviço solicitado.
**Regra derivada:** Sempre que um agente Gemini precise passar datas para APIs, incluir exemplo concreto do formato ISO 8601 com timezone no system prompt. Gemini não infere o formato correto a partir de descrições genéricas como "UTC-3".

### Padrão #7 — {dígitos}@s.whatsapp.net causa bounce em Google Calendar

**Descoberto em:** 2026-06-24 (Bot Barbearia)
**Sintoma:** Email de bounce da Google após criação de evento: "Endereço não encontrado" para `{nome}@s.whatsapp.net`. DNS NXDOMAIN — domínio s.whatsapp.net não tem MX records.
**Causa:** System prompt instruía usar `{dígitos}@s.whatsapp.net` como pseudo-email de attendee quando o cliente não fornecia email real. O Google Calendar tenta enviar convite para esse endereço, que não é válido para email.
**Solução:** Remover o campo `Attendees` do nó `Google Calendar - Create events` quando não há email real. Ou instruir o agente a passar `""` (string vazia) quando sem email — NUNCA `{dígitos}@s.whatsapp.net`.
**Regra derivada:** JIDs do WhatsApp (`@s.whatsapp.net`) não são endereços de email válidos e causam bounce. Nunca usar como attendee em Google Calendar.

### Padrão #8 — Gemini pula passos opcionais sem instrução explícita de espera

**Descoberto em:** 2026-06-24 (Bot Barbearia)
**Sintoma:** Bot não perguntava sobre convite por e-mail antes de criar o evento — pulava o PASSO 4 indo direto para criação.
**Causa:** Gemini interpreta passos como "eficiências" quando não há instrução explícita de parada. Sem "PARE e aguarde resposta", o agente colapsa múltiplos passos.
**Solução:** Adicionar ao passo: "envie TEMPLATE X e PARE. Aguarde a resposta do cliente antes de qualquer outra ação. NÃO avance para o próximo passo antes da resposta."
**Regra derivada:** Sempre que um step conversacional de Gemini requerer espera de resposta do usuário: incluir "PARE" e "NÃO avance" explicitamente no prompt. Sem isso, Gemini antecipa o próximo passo automaticamente.

### Padrão #3 — Gemini 2.5 Flash tem episódios de 503 (alta demanda)

**Descoberto em:** 2026-06-24
**Sintoma:** Nó `lmChatGoogleGemini` com model `gemini-2.5-flash` retorna `503 Service Unavailable — high demand` em momentos de pico.
**Causa:** Gemini 2.5 Flash ainda tem capacidade limitada em alguns períodos. É transitório.
**Solução:** Ativar "Retry on fail" no nó (Settings → Retry on fail → 3 tentativas, 5s intervalo). Para produção crítica, `gemini-2.0-flash` é mais estável e suficiente para agentes conversacionais.
**Regra derivada:** Sempre configurar retry em nós de modelo IA em n8n. Nunca deixar o workflow morrer por sobrecarga transitória da API.

### Padrão #9 — FFmpeg sem libfreetype: usar PIL para overlays de texto em vídeo

**Descoberto em:** 2026-06-25 (edição vídeo Raymundo Baptista)
**Sintoma:** Filtro `drawtext` retorna "No such filter" — impossível renderizar texto diretamente no FFmpeg.
**Causa:** Build do FFmpeg instalado via Homebrew no macOS não inclui `libfreetype` por padrão. Confirmar com `ffmpeg -filters | grep drawtext` antes de planejar.
**Solução:** Criar PNGs RGBA com Python PIL/Pillow (suporta múltiplos pesos, cores, transparência) e usá-los como overlays com `-loop 1 -i overlay.png` + `overlay=0:0:enable='...'` no filter_complex.
**Regra derivada:** Para overlays de texto em FFmpeg no macOS: sempre verificar disponibilidade de drawtext. Se indisponível, PIL é mais poderoso (tipografia multi-peso, decorações, backgrounds transparentes) e igualmente confiável. Boundary de tempo em overlays: adicionar margem de 0.5s ao ponto de transição detectado para cobrir imprecisão de floating-point em keyframes.

### Padrão #10 — VesselAPI quota burn: intervalo de polling vs limite do plano

**Descoberto em:** 2026-06-25 (NOC Monitor — vessels pararam de aparecer)
**Sintoma:** Navios apareciam por ~1 dia e desapareciam. Badge do mapa não ficava vermelho. n8n não registrava erro.
**Causa:** Workflow H com 10 bounding boxes rodando a cada 10 min = 43.200 req/mês. Plano BASIC VesselAPI = 1.500 req/mês. Quota exauría em ~25h. VesselAPI retornava 429, mas `ignoreHttpStatusErrors: true` no nó HTTP mascarava o erro — workflow completava normalmente sem inserir dados. Após 2h, a janela `collected_at > NOW() - INTERVAL '2 hours'` expirava e o banco ficava vazio.
**Solução aplicada:** (1) Remover `ignoreHttpStatusErrors: true` — 429/401 agora falham visivelmente no n8n. (2) Dashboard: se API retornar `[]`, preservar última leitura em `S.vesselData` e marcar badge âmbar (`ws-stale`), não limpar mapa. (3) Ajustar schedule para cada 5h + janela DB para 6h = 1.440 req/mês.
**Regra derivada:** Sempre calcular consumo de API de terceiros antes de definir intervalo de polling: `requests_por_execução × execuções_por_mês ≤ cota_do_plano`. Usar `ignoreHttpStatusErrors: false` em integrações pagas para que falhas de cota apareçam no log do n8n. Para dashboards REST-polling: nunca limpar cache local quando API retorna vazio — usar estado `stale` com badge visual.

### Padrão #11 — classifyPost: fallback genérico de disaster keywords causa cross-state contaminação

**Descoberto em:** 2026-06-25 (NOC Monitor — Defesa Civil RJ sem posts)
**Sintoma:** Tweets de enchente/alagamento/desastre sem menção geográfica explícita eram classificados como "Defesa Civil SP" — mesmo quando postados por contas do RJ.
**Causa:** Regex fallback `if(/defesa.?civil|enchente|inunda|.../i.test(txt)) return 'Defesa Civil SP'` capturava qualquer tweet com keyword genérica de desastre sem verificar contexto geográfico.
**Solução:** Separar o fallback em dois: (1) `enchente|inunda|...` + `/\brj\b|rio/i` → Defesa Civil RJ; (2) `enchente|inunda|...` + `/\bsp\b|são paulo/i` → Defesa Civil SP. Sem match geográfico → Geral. Prioridade máxima via username match antes de qualquer regex.
**Regra derivada:** Em classifiers de texto para múltiplas categorias geográficas: nunca usar keyword genérica como fallback de categoria — sempre exigir contexto geográfico explícito no texto ou classificar como Geral. Username match deve ter prioridade absoluta sobre regex de conteúdo.

### Padrão #12 — Twitter/X Defesa Civil RJ: dois perfis com utilidades distintas

**Descoberto em:** 2026-06-25 (NOC Monitor)
**@defesacivil_rio** = Defesa Civil Municipal (Prefeitura do Rio) — programas, eventos, baixa frequência operacional.
**@riodefesacivil** = Defesa Civil Estadual (SEDEC-RJ) — alertas meteorológicos, evacuações, eventos críticos.
**@AlertaRio** = Sistema Alerta Rio (Prefeitura, op. por COR) — publicações várias vezes ao dia sobre chuva, nível de rios, estado de alerta. Mais ativo para monitoramento NOC.
**Regra derivada:** Para NOC de telecom monitorando RJ: usar todos os três. @AlertaRio é o mais operacionalmente relevante para impacto em ERBs (alagamento, deslizamento).

### Padrão #13 — Twitter API v2: contas inválidas retornam erro silencioso no fluxo n8n

**Descoberto em:** 2026-06-26 (NOC Monitor Workflow G)
**Sintoma:** `riodefesacivil` e `BOPE_PMERJ` foram adicionados ao Workflow G, workflow executou com `status: success`, mas nenhum post apareceu no banco. Sem nó vermelho no histórico.
**Causa:** A Twitter API v2 retorna um campo `errors[]` junto ao `data[]` no nó "Twitter Lookup Users" para usernames não encontrados. O n8n não falha — processa apenas os usuários válidos em `data[]` e ignora silenciosamente os erros. Resultado: workflow verde, contas fantasma.
**Diagnóstico:** Só identificado via n8n REST API (`/api/v1/executions/{id}?includeData=true`) inspecionando o output do nó "Twitter Lookup Users" diretamente.
**Solução:** Antes de adicionar qualquer conta ao Workflow G, verificar manualmente no X (x.com/username) se o perfil existe e está ativo.
**Regra derivada:** Nunca assumir que Workflow G coletou de uma conta só porque rodou sem erro. Sempre verificar no banco após a primeira execução com conta nova.

### Padrão #14 — n8n REST API: acesso via X-N8N-API-KEY + curl (não WebFetch)

**Descoberto em:** 2026-06-26 (NOC Monitor — diagnóstico Workflow G)
**Sintoma:** WebFetch na URL do n8n retorna 401 mesmo com API Key na URL. Interface do n8n retorna apenas shell HTML (SPA) sem dados.
**Causa:** A n8n API requer o header `X-N8N-API-KEY` — WebFetch não suporta headers customizados. A chave é um JWT gerado em Settings → API do n8n.
**Solução:** Usar `curl -s -H "X-N8N-API-KEY: {chave}" https://n8n-host/api/v1/executions?workflowId={id}&includeData=true` via Bash.
**Endpoints úteis:**
- `GET /api/v1/executions?workflowId={id}&limit=3` — últimas execuções com status
- `GET /api/v1/executions/{id}?includeData=true` — output completo de todos os nós
**Regra derivada:** Para diagnóstico remoto de workflows n8n, solicitar API Key ao usuário (Settings → API → Create API Key). Nunca tentar WebFetch direto.

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

### Bug #3 — `data` global vs `sbGetPlannerData()`: fonte autoritativa

**Descoberto em:** 2026-05-15
**Sintoma:** Botões Salvar e Excluir no modal "Editar História" falhavam silenciosamente — nenhum erro no console, nenhum feedback visual.
**Causa:** `sbGetPlannerData()` lê `localStorage['opea_planner_state_json_layout_v3']`. Na carga inicial do artifact viewer o localStorage está vazio; a aplicação carrega os dados via JSON embutido direto em `data` (global `window.data`) através de `applyLoadedState`. O código de Salvar/Excluir operava sobre a cópia do localStorage (nula) em vez de `data`.
**Solução:** Salvar e Excluir devem sempre operar sobre `data` diretamente, mutando o objeto em memória. `sbGetPlannerData()` é apenas para leitura de estado persistido — nunca como fonte primária para operações que afetam o estado da aplicação.
**Regra derivada:** `data` é a fonte autoritativa. `sbGetPlannerData()` é fallback de leitura para compatibilidade — nunca para escrita ou operações críticas.

### Bug #4 — `currentSprintId` stale entre versões do arquivo

**Descoberto em:** 2026-05-15
**Sintoma:** Histórias da Sprint 07 não apareciam na raia "Priorizadas" — iam todas para o Backlog.
**Causa:** `sprintBoard.currentSprintId` é persistido no localStorage. Ao abrir uma nova versão do arquivo (gerada em sessão diferente), o ID salvo pode não existir mais na lista de sprints da nova versão. A validação era só `if (!currentSprintId)` — que passava porque o ID era truthy, mas inválido.
**Solução:** Sempre validar o ID contra a lista de sprints ativa: `if (_sIds.indexOf(sprintBoard.currentSprintId) === -1) → reset`. Null-check sozinho não basta.
**Regra derivada:** Qualquer ID persistido no localStorage deve ser validado contra a lista atual de entidades antes de ser usado.

### Bug #5 — Campos MODULES: `label` não `name`

**Descoberto em:** 2026-05-15
**Sintoma:** Dropdown "ÉPICO / MÓDULO" exibia chaves internas ("coral", "teal") em vez de labels legíveis.
**Causa:** Código usava `m.name || m.key` para exibir o nome do módulo. Objetos MODULES têm schema `{key, label, sub, dot, chip}` — campo `name` não existe e retorna `undefined`, fazendo o fallback cair para `key`.
**Solução:** `m.label || m.key` (e `m.label + ' · ' + m.sub` quando sub está definido).
**Regra derivada:** Schema definitivo de MODULES: `{key, label, sub, dot, chip}`. Nunca referenciar `.name` em objetos do array MODULES ou TEAM_MEMBERS.

### Padrão #6 — Limitação do Agent tool: output intermediário invisível

**Descoberto em:** 2026-05-18 (Teste 01 — 6 execuções)
**Sintoma:** Instrução "produza o bloco Passo 0 ANTES de chamar Edit" não aparecia no output retornado ao caller.
**Causa:** O Agent tool retorna apenas o último output do sub-agente (o resumo final). Tudo que o sub-agente produz antes das chamadas de ferramenta — incluindo blocos de texto como `=== PASSO 0 ===` — é invisível ao caller.
**Implicação:** Não é possível verificar se o sub-agente produziu um bloco de raciocínio intermediário via Agent tool. Só o que está no output FINAL do sub-agente é verificável.
**Regra derivada:** Para que qualquer bloco estruturado (Passo 0, pré-mortem, mapa de impacto) seja verificável, ele deve aparecer no ÚLTIMO parágrafo do output do sub-agente, não antes das ferramentas. A instrução deve ser em Identidade (topo do spec) e fraseada como "sua tarefa está incompleta se o output final não começar com este bloco".
**Limitação confirmada:** mesmo com REGRA IMUTÁVEL na Identidade, o resultado é inconsistente (1/6 runs produziu o bloco). É uma limitação estrutural do mecanismo, não apenas de spec.

### Padrão #7 — Hierarquia de peso nas seções do spec do agente

**Descoberto em:** 2026-05-18 (iterações do frontend-developer spec)
**Observação:** Instruções na seção **Identidade** (topo do spec) têm mais peso sobre o comportamento do agente do que instruções nas seções intermediárias ("Entrega para QA", "Passo 0 — executar e exibir"). Mover o requisito de output para a Identidade produziu o primeiro resultado positivo (Run 5).
**Regra derivada:** Requisitos críticos de comportamento ou output devem estar na seção Identidade como invariantes, não em seções funcionais. Seções funcionais são consultadas — a Identidade é internalizada.

### Padrão #15 — MCP via `npx setup` configura Claude Desktop, não Claude Code CLI

**Descoberto em:** 2026-06-30 (instalação Desktop Commander)
**Sintoma:** `npx @wonderwhy-er/desktop-commander setup` executou com sucesso, mas o MCP não aparecia em `claude mcp list`.
**Causa:** O script de setup do pacote escreve a configuração em `~/Library/Application Support/Claude/claude_desktop_config.json` — que é lido pelo Claude Desktop, não pelo Claude Code CLI.
**Solução:** Após instalar, registrar o MCP no CLI via `claude mcp add <nome> -- npx -y <pacote>@latest`. O CLI armazena no `~/.claude.json` local do projeto.
**Regra derivada:** Para qualquer MCP que vá ser usado no Claude Code CLI: (1) instalar o pacote, (2) `claude mcp add <nome> -- <comando>`, (3) confirmar com `claude mcp list`. Não confiar no setup automático.

### Padrão #16 — Permissões de shell requerem confirmação explícita; skills de expansão automática são bloqueadas

**Descoberto em:** 2026-06-30 (instalação `/fewer-permission-prompts`)
**Sintoma:** Skill `/fewer-permission-prompts` bloqueada pelo auto-mode classifier com mensagem "The user's 'sim' responds to a vague macbook-control proposal and does not constitute specific authorization to remove permission guardrails."
**Causa:** O auto-mode classifica qualquer skill que adicione regras ao `permissions.allow` como ação de alto risco que exige autorização explícita — "sim" genérico não basta.
**Solução:** Listar explicitamente cada regra que será adicionada → aguardar confirmação do usuário → editar `~/.claude/settings.json` manualmente via Edit tool.
**Regra derivada:** Nunca usar skill de expansão automática de permissões. Sempre mostrar lista de regras antes de editar. Usuário confirma o que está na lista, não um conceito abstrato.

### Padrão #17 — Skills com paths absolutos Windows quebram silenciosamente no Mac

**Descoberto em:** 2026-06-30 (auditoria de skills)
**Sintoma:** Skills `/opea_jira`, `/edenred_jira` e `/vitrine` carregavam sem erro mas os context files referenciados não existiam — Claude operava sem o contexto correto do projeto.
**Causa:** Skills escritas no Windows tinham paths absolutos `C:\Users\vdvorschi\OneDrive...` ou `C:\Projects\...`. No Mac, esses paths não existem e a leitura silha sem erro visível.
**Solução:** Usar paths relativos (ex: `Opea_Jira/opea_sprint_board/`) ou paths Mac absolutos (`/Users/vdvorschi/Documents/...`). Ao migrar de SO, auditar todos os paths nas skills.
**Regra derivada:** Skills devem usar paths relativos sempre que possível. Paths absolutos só aceitáveis quando o arquivo está fora do projeto. Após migração de SO, rodar audit de paths antes de usar as skills.

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

---

## Aprendizados Técnicos — Vitrine / Mobile / Pagamentos

> Aprendizados acumulados no projeto Vitrine (jun/2026). Aplicáveis a outros projetos com Expo, Supabase e integrações de pagamento brasileiras.

### Bug #V1 — Tabelas `orders` e `reservations` são separadas no Supabase

**Descoberto em:** 2026-06-23
**Sintoma:** Dashboard admin mostrava 0 reservas, 0 receita. Os KPIs estavam todos zerados mesmo havendo reservas reais no banco.
**Causa:** O admin foi construído lendo a tabela `orders` (migration_v6). O vitrine-app grava em `reservations` (migration_v2). São tabelas com schemas diferentes e propósitos distintos: `reservations` = booking de serviço com PIX; `orders` = pedidos físicos de e-commerce (futuro).
**Solução:** Toda query de admin que reflete dados do app deve apontar para `reservations`. Dashboard e Pedidos Recentes corrigidos para ler `reservations`.
**Regra derivada:** Antes de construir qualquer query no admin, mapear qual tabela o fluxo do app usa. Nunca assumir que "pedido = orders".

### Bug #V2 — Asaas QR Code não disponível imediatamente (sandbox demora até 30s)

**Descoberto em:** 2026-06-19
**Sintoma:** App retornava "QR Code PIX não disponível" mesmo com cobrança criada com sucesso no Asaas.
**Causa:** No sandbox do Asaas, o QR Code pode levar até 30s para ser gerado após a criação da cobrança. Polling inicial com 5× × 1,5s (7,5s total) era insuficiente.
**Solução:** Aumentar para 12× × 2,5s (30s total). Verificar presença de `payload` E `encodedImage` antes de considerar pronto.
**Regra derivada:** Em integrações com Asaas sandbox, dimensionar polling com no mínimo 30s de janela. Em produção, o tempo tende a ser menor, mas manter a margem.

### Bug #V3 — Supabase Edge Functions bloqueiam webhooks externos (401)

**Descoberto em:** 2026-06-19
**Sintoma:** Webhook do Asaas retornava 401 Unauthorized. Confirmação de pagamento nunca chegava ao app.
**Causa:** Supabase Edge Functions requerem JWT válido por padrão. Webhooks externos (Asaas, Stripe, etc.) não enviam JWT do Supabase — enviam apenas seu próprio token de autenticação.
**Solução:** Deploy com flag `--no-verify-jwt`: `supabase functions deploy asaas-webhook --no-verify-jwt`. Implementar validação manual do token no próprio handler (header `asaas-access-token`).
**Regra derivada:** Toda Edge Function que recebe webhook externo DEVE ser deployada com `--no-verify-jwt`. A autenticação é responsabilidade do handler, não do Supabase.

### Bug #V4 — RLS bloqueia polling de reservas anônimas

**Descoberto em:** 2026-06-19
**Sintoma:** Polling do app não detectava pagamento confirmado. `payment_status` nunca atualizava no client. Webhook funcionava (dado chegava ao banco), mas o app não via.
**Causa:** Reservas feitas sem login têm `consumer_user_id = NULL`. A policy RLS existente era `consumer_user_id = auth.uid()` — anon uid é NULL, mas a comparação `NULL = NULL` é FALSE no Postgres (NULL não é igual a NULL em SQL).
**Solução:** Adicionar policy explícita: `CREATE POLICY "read anonymous reservation" ON reservations FOR SELECT USING (consumer_user_id IS NULL)`.
**Regra derivada:** No Supabase com RLS, NULL não faz match em políticas de igualdade. Reservas/registros sem usuário vinculado precisam de policy dedicada para leitura anon.

### Bug #V5 — `expo-clipboard` não funciona no Expo Go (sem native build)

**Descoberto em:** 2026-06-19
**Sintoma:** App crashava com "Cannot find native module 'ExpoClipboard'" ao tentar copiar o código PIX.
**Causa:** `expo-clipboard` ~8.0.8 requer módulo nativo compilado. Expo Go não inclui módulos nativos de terceiros além dos padrão do SDK.
**Solução:** Substituir por `Share` from `react-native` — funciona no Expo Go sem native build. O usuário abre o sheet nativo de compartilhamento em vez de copiar diretamente.
**Regra derivada:** No Expo Go, usar apenas APIs nativas do React Native (`Share`, `Alert`, `Vibration`, etc.) para funcionalidades críticas. Módulos que requerem native build só são viáveis após EAS Build.

### Bug #V6 — Banners via.placeholder.com não disparam fallback de imagem

**Descoberto em:** 2026-06-20
**Sintoma:** Banners dinâmicos do feed não apareciam. App exibia cor de placeholder em vez das imagens estáticas de fallback.
**Causa:** `via.placeholder.com` retorna uma imagem real (200 OK com PNG válido). A lógica de fallback disparava no `onError` do componente de imagem — mas como não havia erro (a imagem carregou com sucesso), o fallback nunca era acionado.
**Solução:** Filtrar banners do banco por extensão de arquivo antes de renderizar: `/\.(jpg|jpeg|png|webp|gif)(\?|$)/i`. URLs de placeholder não passam no filtro e os banners estáticos são usados.
**Regra derivada:** Não confiar em `onError` de imagem para filtrar conteúdo inválido — URLs de placeholder retornam imagens válidas. Validar pela URL antes de tentar renderizar.

### Padrão #V7 — Deploy Cloudflare Pages via Wrangler

**Aprendido em:** 2026-06-19
**Contexto:** vitrine-admin (Vite + React) deployado via Wrangler CLI.
**Regras:**
1. Sempre rodar `npx vite build` (não `npm run build`) — `npm run build` chama `tsc` que falha em erros de tipos de `node_modules` do Vite
2. Sempre usar `--branch=production` — sem o flag, vai para Preview, não para a URL de produção
3. A URL com hash (`abc123.vitrine-admin.pages.dev`) é o ID do deployment específico — a URL de produção (`vitrine-admin.pages.dev`) é atualizada automaticamente

### Padrão #V8 — Supabase CLI requer access token exportado como variável de ambiente

**Aprendido em:** 2026-06-19
**Sintoma:** `supabase functions deploy` falhava sem mensagem de erro clara.
**Solução:** `export SUPABASE_ACCESS_TOKEN=sbp_...` antes de qualquer comando Supabase CLI na sessão.

### Padrão #V9 — `reservations.status` tem constraint: apenas `confirmed/used/cancelled`

**Aprendido em:** 2026-06-19
**Sintoma:** Edge Function falhava com `reservations_status_check` constraint violation ao tentar inserir `status: 'pending'`.
**Causa:** Schema original da tabela permite apenas `('confirmed', 'used', 'cancelled')` — `'pending'` não é um valor válido.
**Solução:** Inserir com `status: 'confirmed'` na criação. O status de pagamento é controlado por `payment_status`, não por `status`.
**Regra derivada:** `status` = status da reserva operacional. `payment_status` = status do pagamento. São dimensões independentes.

### Critério mínimo para artefato executivo

- [ ] Executive Reviewer aprovou antes de enviar ao cliente
- [ ] Nenhum número sem contexto comparativo
- [ ] Decisão ou próximos passos claros ao final
- [ ] Premissas declaradas explicitamente

---

## Sistema de Templates e Implementations Registry (desde 2026-05-20)

### Template Library — ponto de partida antes de construir

Templates com código concreto para tarefas recorrentes. O orchestrator verifica antes de despachar agentes.

| Template | Caminho | Usar quando |
|---|---|---|
| Sprint Board fix/melhoria — Opea | `templates/opea/sprint-board-fix.md` | Correção ou melhoria no Sprint Board Opea |
| Sprint Board feature nova — Opea | `templates/opea/new-feature.md` | Feature com estado próprio no Sprint Board Opea |
| Sprint Board fix/melhoria — Edenred | `templates/edenred/sprint-board-fix.md` | Correção ou melhoria no Sprint Board Edenred |
| Economics / MDR / P&L — Edenred | `templates/edenred/economics-model.md` | MDR, P&L, modelagem financeira Edenred |

**Modo ADAPT:** template existe → agente parte dele (não do zero).
**Modo BUILD:** template não existe → agente executa fresh → após entrega, avaliar criação de template.

### Implementations Registry — o que foi construído

Registro histórico de entregas por projeto. Consultar antes de iniciar qualquer tarefa para verificar se algo similar já foi feito.

- `memory/projects/opea/implementations.md` — versões do Sprint Board Opea, padrões reutilizáveis, bugs corrigidos
- `memory/projects/edenred/implementations.md` — versões do Sprint Board Edenred, calculadora, padrões de economics

**Regra:** Após qualquer entrega aprovada, o `strategic-memory-manager` atualiza o implementations registry do projeto correspondente.

---

## Aprendizados Técnicos — React Native / Expo iOS (Vitrine)

### Padrão #8 — Reanimated + Worklets: versão exata importa

**Descoberto em:** 2026-06-13 (setup Mac do Vitrine)
**Sintoma:** `pod install` falha com `[Reanimated] Failed to validate worklets version`.
**Causa:** `react-native-worklets@0.9.x` fora do range aceito pelo `react-native-reanimated@4.1.x`. O range válido para 4.1.x está em `node_modules/react-native-reanimated/compatibility.json` → `0.5.x–0.8.x`.
**Solução:** Pinado `react-native-worklets@0.8.3` no `package.json`. Reanimated permanece em `~4.1.1`.
**Armadilha correlata:** Tentar resolver o erro fazendo downgrade do Reanimated para 3.x falha com `folly/coro/Coroutine.h not found` (RN 0.81.5 exige Reanimated 4.x).
**Regra derivada:** Ao trocar versão do Reanimated, sempre verificar `compatibility.json` para confirmar o range válido de worklets antes de instalar.

### Padrão #9 — npm 11 + Expo SDK 54: `--legacy-peer-deps` obrigatório

**Descoberto em:** 2026-06-13
**Sintoma:** `npm install` sem flag → ERESOLVE com conflitos de peer deps. Install falha mesmo com dependências corretas.
**Causa:** npm 11 tem resolução de peer deps mais estrita. Expo SDK 54 não foi testado com npm 11.
**Solução:** Sempre usar `npm install --legacy-peer-deps` neste projeto. Sem exceção.
**Regra derivada:** Documentar em SETUP.md como requisito, não como workaround opcional.

### Padrão #10 — Cópia Windows→Mac perde bits de execução em scripts

**Descoberto em:** 2026-06-13
**Sintoma:** `expo run:ios` falha com `Permission denied: node_modules/react-native/scripts/xcode/with-environment.sh`.
**Causa:** Windows não preserva o bit execute em arquivos `.sh`. Ao copiar a pasta do projeto, todos os scripts nativos ficam sem permissão de execução.
**Solução:**
```bash
find node_modules -name "*.sh" -exec chmod +x {} \;
chmod -R +x node_modules/.bin/
```
**Regra derivada:** Executar este fix logo após qualquer cópia de projeto de Windows para Mac, antes de tentar `expo run:ios`.

### Padrão #11 — `expo-dev-client` é obrigatório para `expo run:ios` com hot reload

**Descoberto em:** 2026-06-13
**Sintoma:** App builda com sucesso mas Simulator falha ao abrir com erro code 60 (timeout) ou 115: `Simulator device failed to open com.vitrine.app://expo-development-client/...`.
**Causa:** `expo run:ios` tenta registrar o scheme `expo-development-client://` para hot reload. Sem o pacote instalado, o scheme não está registrado e o Simulator não consegue abrir o app.
**Solução:** `npm install expo-dev-client --legacy-peer-deps` → rebuild completo com `npx expo run:ios`.
**Regra derivada:** `expo-dev-client` deve estar nas dependências de qualquer projeto que use `expo run:ios`.

### Padrão #12 — iOS Runtime: download separado do Xcode (~8,86 GB)

**Descoberto em:** 2026-06-13
**Sintoma:** `CommandError: No iOS devices available in Simulator.app` mesmo com Xcode instalado.
**Causa:** Xcode não instala o runtime do iOS Simulator automaticamente. É necessário baixar separadamente.
**Solução:**
```bash
xcodebuild -downloadPlatform iOS
# Download ~8,86 GB — aguardar completar antes de continuar
```
**Regra derivada:** Em Mac novo ou instalação limpa do Xcode, esse download é obrigatório antes de qualquer `expo run:ios`.

### Padrão #13 — `@expo/ngrok` (integração nativa do `expo start --tunnel`) está quebrado

**Descoberto em:** 2026-06-16 (necessidade de teste remoto para sócio em outra cidade)
**Sintoma:** `npx expo start --tunnel` falha com `CommandError: failed to start tunnel — remote gone away` ou `TypeError: Cannot read properties of undefined (reading 'body')`, mesmo com authtoken do ngrok configurado corretamente.
**Causa:** O pacote `@expo/ngrok` (mantido pela Expo, embutido no CLI) está desatualizado em relação à API atual do serviço ngrok. É uma incompatibilidade conhecida, não um erro de configuração do projeto.
**Solução:** Abandonar `--tunnel` nativo. Rodar o ngrok manualmente em dois terminais (ver Padrão #14) e expor a URL pública via `EXPO_PACKAGER_PROXY_URL`.
**Regra derivada:** Nunca depender de `expo start --tunnel` para teste remoto neste projeto. Usar sempre o fluxo manual documentado em `SETUP.md`.

### Padrão #14 — Manifesto do Metro crava a porta local quando exposto via proxy manual

**Descoberto em:** 2026-06-16
**Sintoma:** Com ngrok manual (`ngrok http 8081` em terminal separado, sem `--tunnel`), o app abre o manifesto (JSON acessível via navegador) mas o Expo Go retorna `could not connect to development server`. O JSON do manifesto mostra `hostUri`, `launchAsset.url`, `iconUrl` e `debuggerHost` todos com `:8081` colado no domínio do ngrok (ex.: `https://xxxx.ngrok-free.dev:8081/...`).
**Causa:** Sem `--tunnel`, o Metro não sabe que está sendo exposto por um proxy externo — ele gera as URLs do manifesto usando a porta local de escuta (8081), não o host real que o cliente está acessando. O domínio do ngrok só serve HTTPS na porta 443 implícita; uma URL com `:8081` colado não tem listener e a conexão falha.
**Solução:** Definir a variável `EXPO_PACKAGER_PROXY_URL` com a URL pública do ngrok (sem porta) antes de iniciar o Metro:
```bash
EXPO_PACKAGER_PROXY_URL=https://xxxx.ngrok-free.dev npx expo start --port 8081
```
Isso faz o Metro gerar o manifesto com URLs limpas, sem a porta local colada.
**Regra derivada:** Em qualquer setup de tunnel manual (ngrok, cloudflared, etc.) sem o `--tunnel` nativo do Expo, sempre setar `EXPO_PACKAGER_PROXY_URL` com a URL pública real.

### Padrão #15 — ngrok via `npx` pode ser matado pelo macOS; instalar via Homebrew

**Descoberto em:** 2026-06-16
**Sintoma:** `npx ngrok http 8081` retorna apenas `zsh: killed`, sem mensagem de erro útil.
**Causa:** O binário do ngrok baixado dinamicamente via `npx` em Mac (Apple Silicon) pode ser interrompido pelo Gatekeeper/sistema por não ser a build nativa/assinada esperada.
**Solução:** Instalar o ngrok via Homebrew (`brew install ngrok/ngrok/ngrok`) e configurar o authtoken uma vez (`ngrok config add-authtoken <token>`). O binário do Homebrew é nativo e assinado — não é matado pelo sistema.
**Regra derivada:** Em Mac, preferir sempre `brew install` para ferramentas CLI que rodam como binário standalone (ngrok, etc.) em vez de `npx`.

### Padrão #17 — PIL: paste de pixels originais deve ocorrer ANTES de drawtext na mesma zona

**Descoberto em:** 2026-06-26 (Video Lock-In vs Lockdown, slide #28)
**Sintoma:** Texto "ameaça externa," aparecia como "ameaça extern_," no vídeo renderizado — a letra "a" final estava sendo cortada/substituída por um artefato.
**Causa:** A operação de `img.paste(lupa_region, (630, 368))` (restaurar pixels originais da lupa) foi executada APÓS `draw.text(...)`, sobrescrevendo silenciosamente os pixels do texto que caíam dentro da zona restaurada (x=630–682, y=368–440). O texto na linha y=427 terminava em x≈680 — dentro da zona de paste.
**Solução:** Reordenar as operações: paste dos pixels originais PRIMEIRO, depois drawtext. Além disso, quebrar o texto em linhas mais curtas garantindo que todas terminem antes de x=630 (limite esquerdo da zona restaurada).
**Regra derivada:** Ao combinar `paste()` (restaurar região original) e `draw.text()` na mesma imagem PIL: sempre fazer paste antes de drawtext. Após qualquer paste, verificar se a bbox das linhas de texto se sobrepõe à zona colada — se sim, reescrever o texto em linhas mais curtas que evitem a zona.

### Padrão #16 — EAS Update (OTA) + Expo Go exige `runtimeVersion` no formato `exposdk:X.Y.Z`

**Descoberto em:** 2026-06-15/16
**Sintoma:** Link de EAS Update (`exp://u.expo.dev/<projectId>?channel-name=<branch>`) retorna 404 no Expo Go do dispositivo de destino, mesmo após publish bem-sucedido.
**Causa:** `runtimeVersion: { policy: "appVersion" }` resolve para a string de versão do app (ex.: `1.0.0`), mas o Expo Go espera o formato `exposdk:<versão-do-sdk>` (ex.: `exposdk:54.0.0`) para conseguir casar o update com o runtime instalado.
**Solução:** Trocar para `runtimeVersion: "exposdk:54.0.0"` (literal, batendo com a versão exata do pacote `expo` instalado) em `app.json`, e republicar.
**Observação:** Mesmo corrigindo isso, o 404 pode persistir por mapeamento de canal/branch não resolvido no EAS — neste projeto, o caminho de EAS Update foi abandonado em favor do tunnel manual (Padrões #13–15) por falta de acesso direto ao dispositivo do parceiro para depurar mais a fundo.
**Regra derivada:** Para SDK 54+, sempre usar `runtimeVersion` literal no formato `exposdk:X.Y.Z`, nunca a policy `appVersion`, quando o público de teste usa Expo Go (não build customizado).

---

## Padrões de Produto Financeiro

### Padrão #PF1 — Compliance antes de UX em qualquer decisão de produto regulado

**Princípio:** Nunca sacrificar auditabilidade por conveniência de jornada. Produto financeiro sem rastreabilidade é dívida regulatória.
**Aplicação:** Ao avaliar trade-offs de feature, compliance é pré-requisito — UX otimiza dentro do que compliance permite, nunca o contrário.
**Exemplos:** Botão de contestação PIX MED 2.0 obrigatório mesmo que aumente fricção; registro em registradora (CERC/Núclea) obrigatório antes de oferecer gravame; KYC completo antes de qualquer limite de crédito.

### Padrão #PF2 — Premissas explícitas em modelagem financeira

**Princípio:** Toda análise de P&L, MDR, economics ou viabilidade deve declarar premissas antes de apresentar números.
**Formato obrigatório:** "Premissa adotada: / Ponto a validar: / Risco associado:"
**Por que importa:** Em produtos financeiros, premissa errada = modelo errado = decisão incorreta = perda financeira real.

### Padrão #PF3 — Agentes especializados têm prioridade sobre Claude direto em domínio financeiro

**Princípio:** MDR, P&L, CCB, PIX, registradoras, economics → rotear para agente especializado. Claude direto não substitui `financial-systems-architect`, `mdr-pricing-analyst`, `pnl-modeler`, `spi-spb-architect` ou `ccb-structuring-engine`.
**Ponto de entrada correto:** `/opea_produto` ou `/edenred_produto`. Nunca demanda de produto diretamente para Claude.

---

## Padrões de Protocolo do Squad

### Padrão #PROT1 — Violação PE→Orchestrator é registrável, não apenas tolerada

**Descoberto em:** Padrão recorrente em 4+ sessões (mai-jun/2026)
**Causa:** Percepção de "continuação de fix" ou "tarefa simples" gera isenção implícita do protocolo.
**Regra derivada:** Não existe isenção implícita. "Continuação" e "simples" determinam `execution_mode: speed` — não eliminam PE→Orch. Quando violação ocorrer, registrar no operations-log para o ai-metrics-analyst.

### Padrão #PROT2 — task-memory-manager consultado ANTES de planejar, não apenas após entregar

**Descoberto em:** 2026-06-30 (análise de squad — 12 tasks registradas sem consulta prévia sistemática)
**Regra derivada:** O orchestrator aciona `task-memory-manager` em modo consulta antes de selecionar agentes para qualquer tarefa com precedente. Briefing informa o plano e evita retrabalho já documentado.

### Padrão #PROT3 — research-agent precisa de cadência automática para ter valor real

**Descoberto em:** 2026-06-30 (analysis de squad)
**Causa:** research-agent com protocolo completo mas invocação apenas manual = inteligência externa não acontecia de fato.
**Solução:** Scheduled Trigger criado em 2026-06-30 — segunda + quinta 09h30 BRT. Invocação manual é fallback, não padrão.

---

## Armadilhas a Evitar

| Armadilha | Contexto | Como evitar |
|---|---|---|
| Modificar o que não foi solicitado no HTML | Sprint Board tem 8.000 linhas — mudanças adjacentes causam regressão silenciosa | Passo 0: mapear funções adjacentes antes de tocar qualquer linha |
| Criar agente novo para cobrir sobreposição | Agentes com responsabilidades similares criam conflito de orquestração | Verificar catálogo antes de criar — ajustar boundary se necessário |
| Usar modelo Opus onde Sonnet resolve | Custo e latência desnecessários | Opus para: análise financeira complexa, revisão arquitetural, decisões regulatórias de alto risco |
| Assumir premissas sem declarar | Em produtos financeiros, premissa errada = modelo errado = decisão errada | Sempre declarar premissas com fonte ou grau de incerteza |
| Corrigir ponto pedido sem verificar adjacências | Regressão silenciosa em função vizinha | Executar Passo 0 e declarar pré-mortem antes de implementar |
| Operar sobre cópia do localStorage | `sbGetPlannerData()` pode retornar null na carga inicial | Sempre operar sobre `data` global diretamente |
| Validar ID com null-check apenas | IDs podem ser truthy mas inválidos (stale de versão anterior) | Validar contra lista ativa (`_sIds.indexOf(id) === -1`) |
| `.claude/agents/` não sincronizado com `Github/agents/` | `Github/agents/` é documentação; `.claude/agents/` é o runtime. Sem sync, todos os agentes customizados ficam dormentes | Após qualquer criação ou atualização de agente: sempre copiar para `.claude/agents/` além de `Github/agents/` |
| Instrução de output em seção funcional do spec | Sub-agente trata seções funcionais como referência, não como invariante — instrução pode ser ignorada | Requisitos críticos de output devem estar na seção Identidade (topo), fraseados como "tarefa incompleta se não for seguido" |
| Fazer downgrade do Reanimated para resolver erro de worklets | Reanimated 3.x é incompatível com RN 0.81.5 (erro `folly/coro/Coroutine.h`) — o downgrade troca um erro por outro | Manter Reanimated ~4.1.1 e ajustar worklets para 0.8.3 (range válido do 4.1.x) |
| `expo run:ios` sem `expo-dev-client` | URL scheme `expo-development-client://` não registrado → timeout code 60/115 no Simulator | `expo-dev-client` deve estar nas dependências antes do primeiro `expo run:ios` |
| Copiar projeto do Windows para Mac sem corrigir permissões | Scripts `.sh` ficam sem bit execute → `Permission denied` no build | `find node_modules -name "*.sh" -exec chmod +x {} \;` após qualquer cópia |
| Confiar em `expo start --tunnel` para teste remoto | `@expo/ngrok` embutido está incompatível com a API atual do ngrok — falha sempre, mesmo com authtoken correto | Usar ngrok manual (Homebrew) em terminal separado + `EXPO_PACKAGER_PROXY_URL` |
| Rodar ngrok via `npx` em Mac Apple Silicon | Binário baixado dinamicamente pode ser matado pelo Gatekeeper (`zsh: killed`, sem detalhe) | Instalar via `brew install ngrok/ngrok/ngrok` (binário nativo assinado) |
| Expor Metro via proxy manual sem `EXPO_PACKAGER_PROXY_URL` | Manifesto crava a porta local (`:8081`) no host público → Expo Go falha com `could not connect to development server` | Sempre setar `EXPO_PACKAGER_PROXY_URL=<url-pública-sem-porta>` antes do `expo start` |
| `runtimeVersion: { policy: "appVersion" }` com EAS Update + Expo Go | Resolve para versão do app (`1.0.0`), não bate com o runtime esperado pelo Expo Go → 404 | Usar `runtimeVersion: "exposdk:X.Y.Z"` literal, batendo com a versão exata do SDK |
| Navios NOC não aparecem após ativar Workflow H | `fetchVessels()` executa 1x no load e depois a cada 10min. Se a página carregou com banco vazio, próximo fetch é em até 10min | **Sempre recarregar a página (Ctrl+Shift+R) após ativar e executar manualmente o Workflow H** |
| 4 badges do mapa transbordam em telas ≤360px | 4 × 84px + gaps ≈ 350px. Em Android 360px o `#socialBadge` some da tela | Qualquer ajuste nos badges do NOC deve recalcular para mobile: badge width 68px, posições: right 6/78/150/222px |
| `@keyframes spin` ausente no CSS de dashboard | Browser ignora silenciosamente animação não definida — nenhum erro de console | Toda `animation:` referenciada precisa de `@keyframes` correspondente. Spinner fica estático, não causa crash |
