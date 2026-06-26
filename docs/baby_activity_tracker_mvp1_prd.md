# PRD - Baby Activity Tracker MVP 1

## 1. Visao Geral

O objetivo do MVP 1 e criar um aplicativo mobile simples em Flutter para registrar rapidamente atividades basicas de um bebe: mamou, dormiu e acordou.

A principal premissa do produto e permitir que o responsavel registre uma atividade em poucos cliques, idealmente em ate dois toques:

1. Abrir o app.
2. Tocar em uma acao rapida, como `Mamou`, `Dormiu` ou `Acordou`.

O app deve funcionar localmente, sem login e sem internet. Supabase, autenticacao e sincronizacao remota ficam fora do MVP 1.

## 2. Inspiracao Visual

O design deve seguir uma linha minimalista, limpa e amigavel, inspirado no app/site Amy Food Journal: https://www.amyfoodjournal.com/

Referencias de direcao visual observadas no Amy:

- Experiencia simples, com baixa friccao.
- Sensacao de "registrar como em um app de notas".
- Interface clara, direta e sem excesso de configuracoes.
- Tipografia grande o suficiente para leitura rapida.
- Uso de bastante espaco em branco.
- Elementos com cantos arredondados.
- Acoes principais sempre muito evidentes.
- Aparencia moderna, calma e acolhedora.

Para este app, adaptar essa linguagem para o contexto de acompanhamento de bebe:

- Paleta suave.
- Fundo claro.
- Botoes grandes.
- Poucos elementos por tela.
- Sem dashboards complexos no MVP.
- Foco em registro rapido e timeline do dia.

## 3. Objetivos Do MVP 1

- Permitir registrar atividades do bebe rapidamente.
- Salvar atividades localmente no dispositivo.
- Exibir uma timeline de atividades agrupada por dia.
- Permitir visualizar horarios ao lado de cada atividade.
- Manter a experiencia simples, bonita e util desde a primeira tela.

## 4. Nao Objetivos Do MVP 1

Ficam fora deste MVP:

- Login/cadastro de usuario.
- Supabase Auth.
- Sincronizacao com Supabase.
- Cadastro de multiplos bebes.
- Relatorios avancados.
- Graficos.
- Compartilhamento com outro responsavel.
- Notificacoes.
- Widgets.
- Edicao avancada de atividades.
- Controle de quantidade de leite.
- Controle de mama esquerda/direita.
- Exportacao de dados.

## 5. Plataforma

Inicialmente o app sera desenvolvido em Flutter com foco em iOS Simulator.

O app deve ser implementado de forma que Android possa ser suportado depois sem grandes alteracoes, mas Android nao precisa ser validado no MVP 1.

## 6. Publico-Alvo

Pais, maes ou cuidadores de bebes pequenos que precisam registrar rapidamente eventos recorrentes do dia a dia.

Contexto de uso:

- Usuario pode estar com o bebe no colo.
- Usuario pode estar com sono ou com pressa.
- Usuario nao quer preencher formularios.
- Usuario precisa de botoes grandes e obvios.
- Usuario quer saber rapidamente quando foi a ultima mamada, soneca ou despertar.

## 7. Principio Central De UX

Registrar uma atividade deve ser mais rapido do que escrever uma nota.

Fluxo principal:

```text
Abrir app -> tocar no botao da atividade -> atividade aparece na timeline
```

Nao deve haver confirmacao modal apos tocar no botao. O feedback deve ser visual e imediato.

## 8. Funcionalidades

### 8.1 Registrar Atividade

Na tela principal, exibir uma area de acoes rapidas com tres botoes:

- `Mamou`
- `Dormiu`
- `Acordou`

Ao tocar em um botao:

- Criar uma atividade com o horario atual.
- Salvar localmente.
- Atualizar a timeline imediatamente.
- Exibir um feedback discreto, por exemplo uma pequena mensagem: `Mamou registrado agora`.

### 8.2 Timeline Do Dia

A tela principal deve exibir as atividades registradas.

Regras:

- Agrupar atividades por dia.
- Mostrar primeiro o dia atual.
- Dentro do dia, ordenar atividades da mais recente para a mais antiga.
- Exibir o horario ao lado de cada atividade.
- Exibir um label amigavel para cada tipo.

Exemplo:

```text
Hoje

18:42  Mamou
17:10  Acordou
15:55  Dormiu

Ontem

22:30  Mamou
21:05  Dormiu
```

### 8.3 Estado Vazio

Quando ainda nao houver atividades, mostrar um estado vazio simples:

```text
Nenhuma atividade registrada hoje.
Use os botoes acima para registrar a primeira.
```

O estado vazio deve ser visualmente leve, sem card grande demais ou texto excessivo.

### 8.4 Persistencia Local

As atividades devem persistir localmente.

Sugestao para MVP:

- Usar `shared_preferences` apenas se o objetivo for simplicidade extrema.
- Preferencialmente usar `Hive`, `Isar`, `Drift` ou `sqflite` se o objetivo for estudar persistencia local com mais realismo.

Para este MVP, a recomendacao e usar `Hive` ou `Isar`, pois sao simples para um app local-first pequeno.

### 8.5 Exclusao Simples

Opcional no MVP 1, mas desejavel:

- Permitir remover uma atividade via swipe ou botao discreto.
- Exibir confirmacao simples antes de remover.

Se isso aumentar muito o escopo, deixar para MVP 1.1.

## 9. Modelo De Dados

Entidade: `BabyActivity`

Campos:

```text
id: string
type: activity type
occurredAt: DateTime
createdAt: DateTime
```

Enum `ActivityType`:

```text
feeding
sleepStarted
sleepEnded
```

Labels de exibicao:

```text
feeding -> Mamou
sleepStarted -> Dormiu
sleepEnded -> Acordou
```

Sugestao de icones:

```text
feeding -> bottle, heart ou droplet
sleepStarted -> moon
sleepEnded -> sun
```

## 10. Arquitetura Sugerida

Manter a arquitetura simples, mas organizada.

Estrutura sugerida:

```text
lib/
  main.dart
  app.dart
  features/
    activities/
      data/
        activity_repository.dart
        local_activity_storage.dart
      domain/
        baby_activity.dart
        activity_type.dart
      presentation/
        activity_home_page.dart
        widgets/
          quick_action_button.dart
          activity_timeline.dart
          activity_day_section.dart
          activity_list_item.dart
```

Gerenciamento de estado:

- Usar `Riverpod`, `Provider` ou `ValueNotifier`.
- Para MVP 1, `ValueNotifier` ou `ChangeNotifier` e suficiente.
- Se o objetivo for estudar uma arquitetura mais escalavel, usar `Riverpod`.

Recomendacao:

- Usar `Riverpod` se voce quiser que o projeto sirva como portfolio tecnico.
- Usar `ValueNotifier` se voce quiser terminar o MVP mais rapido.

## 11. Tela Principal

A tela principal deve conter:

1. Header simples.
2. Resumo curto da ultima atividade.
3. Botoes grandes de acao rapida.
4. Timeline agrupada por dia.

Layout sugerido:

```text
Baby Log
Hoje, 26 de junho

Ultima atividade
Mamou as 18:42

[ Mamou ] [ Dormiu ] [ Acordou ]

Hoje
18:42  Mamou
17:10  Acordou
15:55  Dormiu
```

## 12. Design System

### 12.1 Estilo Geral

- Minimalista.
- Calmo.
- Leve.
- Inspirado em apps de notas modernos.
- Visual acolhedor, mas sem parecer infantil demais.

### 12.2 Cores

Paleta sugerida:

```text
Background: #FBFAF7
Surface:    #FFFFFF
Primary:    #69D6D2
Text:       #1F2933
Muted:      #7B8794
Border:     #E5E7EB
AccentPink: #FF9CB2
AccentBlue: #9BE8E4
```

Regras:

- Evitar roxo escuro, gradientes pesados e excesso de sombras.
- Usar cor primaria apenas em acoes importantes.
- Usar fundos suaves e bastante respiro.

### 12.3 Tipografia

- Usar a fonte padrao do sistema.
- Titulos com peso 600 ou 700.
- Textos secundarios com cor muted.
- Horarios devem ser faceis de escanear.

Tamanhos sugeridos:

```text
Titulo da tela: 28
Subtitulo/data: 15
Botoes principais: 16-18
Horario da timeline: 15-16
Label da atividade: 16
Texto secundario: 14
```

### 12.4 Componentes

#### Botao De Acao Rapida

Caracteristicas:

- Alto.
- Arredondado.
- Com icone e label.
- Area de toque grande.
- Feedback visual ao toque.

Altura sugerida:

```text
64px a 76px
```

#### Item Da Timeline

Caracteristicas:

- Linha simples.
- Horario a esquerda.
- Atividade a direita.
- Icone pequeno opcional.
- Sem excesso de bordas.

#### Secao Do Dia

Caracteristicas:

- Label `Hoje`, `Ontem` ou data formatada.
- Separacao visual leve.
- Sem card aninhado.

## 13. Regras De Negocio

- O horario registrado deve ser sempre o horario local do dispositivo.
- A atividade deve aparecer imediatamente apos o toque.
- Atividades devem continuar disponiveis apos fechar e abrir o app.
- Se houver erro ao salvar, exibir mensagem simples e nao quebrar a tela.
- A timeline deve aceitar multiplas atividades do mesmo tipo no mesmo dia.

## 14. Formatacao De Datas

Para agrupamento:

- Hoje
- Ontem
- `dd/MM/yyyy` para dias anteriores

Para horario:

- Usar formato 24h: `HH:mm`

## 15. Criterios De Aceite

### Registro

- Dado que o usuario esta na tela principal, quando tocar em `Mamou`, uma atividade `Mamou` deve ser criada com o horario atual.
- Dado que o usuario esta na tela principal, quando tocar em `Dormiu`, uma atividade `Dormiu` deve ser criada com o horario atual.
- Dado que o usuario esta na tela principal, quando tocar em `Acordou`, uma atividade `Acordou` deve ser criada com o horario atual.

### Timeline

- A timeline deve exibir atividades agrupadas por dia.
- A timeline deve mostrar o dia atual como `Hoje`.
- A timeline deve ordenar atividades mais recentes primeiro.
- Cada item deve mostrar horario e label da atividade.

### Persistencia

- Ao fechar e reabrir o app, as atividades registradas devem continuar aparecendo.

### UX

- O usuario deve conseguir registrar uma atividade em ate dois toques apos abrir o app.
- A tela principal deve ser compreensivel sem tutorial.
- Os botoes principais devem ser grandes o suficiente para uso com uma mao.

## 16. Estados Da Interface

### Loading

Ao abrir o app, enquanto as atividades locais carregam:

- Mostrar um indicador discreto ou skeleton simples.
- Evitar tela complexa.

### Empty

Sem atividades:

- Mostrar mensagem curta.
- Manter os botoes de acao rapida visiveis.

### Error

Erro ao carregar ou salvar:

- Mostrar mensagem curta.
- Permitir tentar novamente, se aplicavel.

## 17. Testes Recomendados

### Testes Unitarios

- Criacao de `BabyActivity`.
- Conversao de `ActivityType` para label.
- Agrupamento por dia.
- Ordenacao por horario.

### Testes De Widget

- Renderizar estado vazio.
- Tocar em `Mamou` e verificar item na timeline.
- Tocar em `Dormiu` e verificar item na timeline.
- Tocar em `Acordou` e verificar item na timeline.

## 18. Implementacao Recomendada Para Codex

Ao implementar, seguir esta ordem:

1. Criar modelos de dominio.
2. Criar repositorio local.
3. Criar tela principal.
4. Criar botoes de acao rapida.
5. Criar timeline agrupada por dia.
6. Adicionar persistencia local.
7. Adicionar testes principais.
8. Ajustar visual conforme o design system.

## 19. Prompt Sugerido Para Codex

```text
Implemente o MVP 1 deste PRD em Flutter.

Requisitos principais:
- App local-first, sem login e sem Supabase neste MVP.
- Tela principal minimalista inspirada no Amy Food Journal.
- Registrar atividades Mamou, Dormiu e Acordou com um toque.
- Salvar localmente no dispositivo.
- Exibir timeline agrupada por dia, com Hoje, Ontem ou dd/MM/yyyy.
- Ordenar atividades da mais recente para a mais antiga.
- Usar uma arquitetura simples e organizada em features/activities.
- Criar componentes reutilizaveis para botoes de acao rapida e timeline.
- Adicionar testes unitarios para agrupamento/ordenacao e testes de widget para registro de atividades.

Mantenha o design limpo, claro, com botoes grandes, cores suaves, cantos arredondados e bastante espaco em branco.
```

## 20. Futuro MVP 2

Possiveis evolucoes apos o MVP 1:

- Cadastro de bebe.
- Edicao e exclusao de atividades.
- Supabase Auth.
- Backup/sync opcional com Supabase.
- Relatorios simples.
- Registro de fraldas.
- Registro de banho.
- Notificacoes para lembretes.
- Compartilhamento com outro cuidador.
