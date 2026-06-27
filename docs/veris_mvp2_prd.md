# PRD - Veris MVP 2

## 1. Contexto

O MVP 1 do Veris cobre o fluxo essencial de registro rapido de atividades do bebe:

- Registrar `Mamou`.
- Registrar `Dormiu`.
- Registrar `Acordou`.
- Persistir localmente.
- Exibir atividades em uma timeline agrupada por dia.

O MVP 2 deve evoluir o produto sem perder a premissa central: registrar e consultar informacoes importantes do bebe com poucos toques.

## 2. Objetivo Do MVP 2

Transformar o Veris de um simples log de eventos em um diario diario minimamente confiavel para pais e cuidadores.

O MVP 2 deve permitir:

- Corrigir erros de registro.
- Remover registros acidentais.
- Registrar um novo tipo de atividade essencial: fralda.
- Visualizar um resumo simples do dia.
- Entender rapidamente o estado atual do bebe, por exemplo: ultima mamada, se esta dormindo, ha quanto tempo dorme e quantas fraldas foram trocadas hoje.

## 3. Principio De Produto

O app deve continuar sendo rapido primeiro e detalhado apenas quando necessario.

Fluxo principal:

```text
Abrir app -> tocar na atividade -> registro criado
```

Fluxo secundario:

```text
Tocar em uma atividade -> editar horario, tipo ou observacao opcional
```

O MVP 2 nao deve transformar o registro rapido em formulario obrigatorio.

## 4. Escopo Do MVP 2

### Incluido

- Edicao de atividade.
- Exclusao de atividade.
- Registro de fralda.
- Resumo diario.
- Estado atual do bebe.
- Protecao contra taps repetidos e flood nos botoes de acao.
- Pequenos refinamentos de UX.

### Fora Do Escopo

- Login.
- Cadastro de usuario.
- Supabase Auth.
- Sincronizacao remota.
- Compartilhamento entre cuidadores.
- Multiplos bebes.
- Notificacoes.
- Graficos complexos.
- Exportacao.
- Widgets.
- IA.
- Subtipos de fralda, como xixi ou coco.

## 5. Por Que Supabase Fica Fora Do MVP 2

Supabase continua sendo importante para a visao do produto, mas nao deve entrar neste MVP.

Motivos:

- O modelo de dados ainda deve estabilizar.
- Edicao e exclusao mudam a forma como eventos precisam ser sincronizados.
- Sincronizar antes de ter boa UX local pode gerar retrabalho.
- O MVP 2 ainda pode ser validado inteiramente local-first.

Recomendacao:

```text
MVP 1: registro local rapido
MVP 2: diario local confiavel
MVP 3: login, backup e sync opcional com Supabase
```

## 6. Personas E Contexto De Uso

Usuario principal:

- Pai, mae ou cuidador.
- Usa o app com pressa.
- Pode estar com o bebe no colo.
- Pode errar o toque.
- Pode lembrar de registrar uma atividade alguns minutos depois.
- Precisa corrigir horarios manualmente.

Implicacao:

- O app precisa permitir "registrar agora" e "ajustar depois".

## 7. Funcionalidades

## 7.1 Registro Rapido

Manter os botoes principais na tela inicial.

Botoes do MVP 2:

- `Mamou`
- `Dormiu`
- `Acordou`
- `Fralda`

Ao tocar em `Mamou`, `Dormiu` ou `Acordou`:

- Registrar imediatamente com o horario atual.
- Exibir feedback discreto.
- Atualizar timeline e resumo diario.

Ao tocar em `Fralda`:

- Registrar imediatamente com horario atual.
- Exibir feedback discreto.
- Atualizar timeline e resumo diario.

## 7.2 Edicao De Atividade

O usuario deve poder tocar em uma atividade existente para abrir uma tela ou bottom sheet de edicao.

Campos editaveis:

- Tipo da atividade.
- Data.
- Horario.

Campos opcionais:

- Observacao curta.

Regras:

- Edicao deve atualizar a timeline imediatamente.
- Se mudar a data, o item deve ir para o grupo correto.
- Se mudar o horario, a ordenacao deve ser recalculada.

## 7.3 Exclusao De Atividade

O usuario deve poder excluir uma atividade.

UX recomendada:

- Acao `Excluir` dentro da edicao.
- Confirmacao simples antes de remover.

Texto sugerido:

```text
Excluir atividade?
Essa acao nao pode ser desfeita.
```

Opcional:

- Snackbar com `Desfazer` apos excluir.

## 7.4 Protecao Contra Taps Repetidos

O app deve proteger o usuario contra registros duplicados causados por taps acidentais, lag visual ou toque repetido rapido.

Essa protecao nao deve transformar o app em algo lento. Ela deve apenas evitar duplicacoes improvaveis no uso real.

Regras recomendadas:

- Enquanto uma atividade esta sendo salva localmente, o botao correspondente deve ficar temporariamente desabilitado.
- O mesmo botao nao deve registrar mais de uma atividade em uma janela curta de tempo.
- O app deve ter tambem uma protecao global para evitar muitas atividades criadas em sequencia por taps muito rapidos em botoes diferentes.

Valores sugeridos:

```text
Cooldown por botao: 800ms
Cooldown global entre registros: 250ms
Limite de burst global: no maximo 6 registros em 3 segundos
```

Comportamento esperado:

- Se o usuario tocar duas vezes rapidamente em `Mamou`, apenas o primeiro toque deve registrar.
- Se o usuario tocar em `Mamou` e logo em seguida em `Dormiu`, o segundo toque so deve registrar se respeitar o cooldown global.
- Taps ignorados por throttle nao devem exibir erro agressivo.
- O feedback visual pode ser um estado pressed/disabled rapido no botao.
- A protecao deve ficar na camada de acao/registro, nao apenas na UI, para evitar duplicacao mesmo se o evento vier de mais de um caminho.

## 7.5 Resumo Diario

A tela inicial deve exibir um resumo curto do dia antes da timeline.

Cards ou linhas de resumo:

- Ultima mamada.
- Sono atual ou ultima soneca.
- Total de sonecas finalizadas no dia.
- Fraldas trocadas hoje.

Exemplo:

```text
Hoje

Ultima mamada: 18:42
Dormindo ha: 35 min
Sonecas hoje: 3
Fraldas hoje: 5
```

Regras:

- Se nao houver mamada no dia, mostrar `Ainda nao registrada`.
- Se houver `Dormiu` sem `Acordou` depois, considerar que o bebe esta dormindo.
- Se houver `Dormiu` seguido de `Acordou`, calcular duracao da soneca.
- Se houver eventos inconsistentes, nao bloquear o usuario; apenas calcular com o melhor esforco.

## 7.6 Estado Atual Do Bebe

O app deve destacar o estado atual quando possivel.

Estados possiveis:

- `Dormindo`
- `Acordado`
- `Sem informacao suficiente`

Regra simples:

- Se a ultima atividade entre `Dormiu` e `Acordou` for `Dormiu`, estado atual = `Dormindo`.
- Se a ultima atividade entre `Dormiu` e `Acordou` for `Acordou`, estado atual = `Acordado`.
- Se nao houver nenhuma das duas, estado atual = `Sem informacao suficiente`.

Exemplo de exibicao:

```text
Dormindo desde 15:55
```

ou:

```text
Acordada desde 17:10
```

## 7.7 Timeline

Manter agrupamento por dia.

Cada item deve exibir:

- Horario.
- Tipo da atividade.
- Observacao, quando existir.

Exemplo:

```text
Hoje

18:42  Mamou
17:58  Fralda
17:10  Acordou
15:55  Dormiu
```

## 8. Modelo De Dados

Entidade: `BabyActivity`

Campos:

```text
id: string
type: ActivityType
occurredAt: DateTime
createdAt: DateTime
updatedAt: DateTime?
note: string?
```

Enum `ActivityType`:

```text
feeding
sleepStarted
sleepEnded
diaper
```

Labels:

```text
feeding -> Mamou
sleepStarted -> Dormiu
sleepEnded -> Acordou
diaper -> Fralda
```

## 9. Design E UX

Manter a direcao minimalista do MVP 1.

Principios:

- Poucas cores.
- Fundo claro.
- Texto legivel.
- Botoes grandes.
- Bottom sheets simples.
- Sem cards aninhados.
- Sem dashboards densos.
- Animacoes discretas.

Tela inicial recomendada:

```text
Veris
Hoje, 26 de junho

[Estado atual]
Dormindo desde 15:55

[Resumo do dia]
Ultima mamada   18:42
Fraldas hoje    5
Sonecas hoje    3

[Acoes rapidas]
Mamou | Dormiu | Acordou | Fralda

[Timeline]
Hoje
18:42 Mamou
17:58 Fralda
```

## 10. Arquitetura Recomendada

Manter a arquitetura do MVP 1 e evoluir sem grande refatoracao.

Sugestao:

```text
features/
  activities/
    data/
      activity_repository.dart
      local_activity_storage.dart
    domain/
      baby_activity.dart
      activity_type.dart
      daily_summary.dart
      activity_summary_service.dart
      activity_rate_limiter.dart
    presentation/
      activity_home_page.dart
      edit_activity_sheet.dart
      widgets/
        quick_action_button.dart
        daily_summary_card.dart
        current_status_card.dart
        activity_timeline.dart
        activity_list_item.dart
```

Servicos de dominio:

- `ActivitySummaryService`
  - Calcula estado atual.
  - Calcula ultima mamada.
  - Conta fraldas do dia.
  - Conta sonecas finalizadas.
- `ActivityRateLimiter`
  - Impede duplicacao acidental por taps repetidos.
  - Aplica cooldown por tipo de atividade.
  - Aplica cooldown e limite de burst global.

## 11. Regras De Calculo

### Ultima Mamada

- Buscar a atividade `feeding` mais recente do dia.
- Exibir horario.

### Estado Atual

- Buscar a ultima atividade entre `sleepStarted` e `sleepEnded`.
- Se for `sleepStarted`, esta dormindo.
- Se for `sleepEnded`, esta acordado.

### Sonecas Hoje

- Contar pares `sleepStarted` -> `sleepEnded` dentro do dia.
- Se houver `sleepStarted` sem `sleepEnded`, nao contar como finalizada.

### Dormindo Ha

- Se estado atual for dormindo, calcular diferenca entre agora e `occurredAt` do ultimo `sleepStarted`.

### Fraldas Hoje

- Contar atividades `diaper` do dia.

## 12. Criterios De Aceite

### Registro De Fralda

- Dado que o usuario esta na tela inicial, ao tocar em `Fralda`, uma atividade `Fralda` deve ser criada imediatamente com horario atual.
- A atividade deve aparecer imediatamente na timeline.
- O registro de fralda nao deve abrir formulario, bottom sheet ou modal no fluxo principal.

### Edicao

- Ao tocar em uma atividade, deve abrir uma interface de edicao.
- O usuario deve conseguir alterar horario e tipo.
- Ao salvar, a timeline deve refletir a alteracao.
- Ao alterar data/horario, o agrupamento e ordenacao devem ser recalculados.

### Exclusao

- O usuario deve conseguir excluir uma atividade.
- A atividade excluida deve desaparecer da timeline.
- O resumo diario deve ser recalculado.

### Resumo Diario

- O resumo deve mostrar a ultima mamada do dia.
- O resumo deve mostrar quantidade de fraldas do dia.
- O resumo deve mostrar quantidade de sonecas finalizadas.
- Se o bebe estiver dormindo, o app deve mostrar desde que horario.

### Protecao Contra Taps Repetidos

- Ao tocar duas vezes rapidamente no mesmo botao, apenas uma atividade deve ser criada.
- O mesmo tipo de atividade nao deve ser registrado mais de uma vez dentro do cooldown por botao.
- O app nao deve permitir um volume anormal de atividades em uma janela curta de tempo.
- A protecao deve ser aplicada antes de salvar a atividade localmente.
- Taps ignorados por throttle nao devem quebrar a interface nem exibir erro intrusivo.

### Persistencia

- Atividades novas, editadas e excluidas devem persistir apos fechar e abrir o app.

## 13. Testes

### Unitarios

- Calculo de ultima mamada.
- Calculo de estado atual.
- Calculo de `dormindo ha`.
- Contagem de fraldas por dia.
- Contagem de sonecas finalizadas.
- Agrupamento apos edicao de data.
- Ordenacao apos edicao de horario.
- Bloqueio de duplicacao no mesmo botao dentro do cooldown.
- Bloqueio por cooldown global.
- Bloqueio por limite de burst global.

### Widget Tests

- Registrar fralda com um toque.
- Editar horario de uma atividade.
- Excluir atividade.
- Verificar que duplo tap rapido no mesmo botao cria apenas uma atividade.
- Renderizar resumo diario sem dados.
- Renderizar resumo diario com dados.

## 14. Prompt Para Codex

```text
Implemente o MVP 2 descrito neste PRD.

Contexto:
- O MVP 1 ja permite registrar Mamou, Dormiu e Acordou localmente e exibir timeline agrupada por dia.
- Preserve a simplicidade e a velocidade do registro rapido.

Escopo:
- Adicionar atividade Fralda com registro imediato em um toque.
- Permitir editar atividade existente: tipo, data, horario e observacao opcional.
- Permitir excluir atividade existente com confirmacao simples.
- Criar resumo diario com ultima mamada, estado atual do bebe, sonecas finalizadas e fraldas do dia.
- Adicionar protecao contra taps repetidos: cooldown por botao, cooldown global e limite de burst global.
- Manter persistencia local.
- Adicionar testes unitarios para os calculos de resumo.
- Adicionar testes unitarios para o rate limiter.
- Adicionar testes de widget para registro de fralda, edicao, exclusao e duplo tap rapido.

Nao implementar:
- Supabase.
- Login.
- Sincronizacao.
- Multiplos bebes.
- Notificacoes.

Cuide para manter o design minimalista, com botoes grandes, textos claros, poucos elementos visuais e fluxo rapido.
```

## 15. Possivel MVP 3

O MVP 3 pode focar em:

- Supabase Auth.
- Backup remoto opcional.
- Sincronizacao local-first.
- Resolucao simples de conflitos.
- Multiplos dispositivos.
- Compartilhamento com outro cuidador.
