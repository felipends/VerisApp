# PRD - Veris MVP 3: UX Patch

## 1. Contexto

O Veris ja possui o fluxo principal de registro rapido de atividades do bebe, timeline local e melhorias planejadas para edicao, exclusao, resumo diario e protecao contra taps repetidos.

O MVP 3 nao deve adicionar backend, login ou sincronizacao. Ele deve ser um patch de UX para tornar o app mais pessoal, acolhedor e facil de configurar, sem pressionar o usuario a fornecer dados pessoais.

## 2. Objetivo

Melhorar a primeira experiencia e a navegacao do app com:

- Onboarding opcional para cadastro do bebe.
- Personalizacao visual por esquema de cores.
- Drawer lateral com acesso a configuracoes.
- Tela de configuracoes para idioma, tema e informacoes do bebe.
- Tratamento cuidadoso de privacidade e baixa friccao.

## 3. Principios Do MVP 3

- Privacidade primeiro.
- Tudo deve ser opcional.
- O usuario deve conseguir usar o app sem cadastrar nenhum dado do bebe.
- O onboarding nao deve parecer uma barreira.
- A personalizacao deve ser simples e visual.
- O app deve continuar rapido para registrar atividades.

## 4. Fora Do Escopo

- Login.
- Supabase Auth.
- Sincronizacao remota.
- Backup remoto.
- Multiplos bebes.
- Compartilhamento com cuidadores.
- Notificacoes.
- Conta de usuario.
- Coleta obrigatoria de dados pessoais.

## 5. Primeiro Acesso

No primeiro acesso ao app, exibir uma tela simples de configuracao inicial.

Objetivo da tela:

- Permitir personalizar como o app se refere ao bebe.
- Permitir escolher uma cor predominante.
- Deixar claro que tudo e opcional.
- Permitir pular rapidamente.

CTA principal:

```text
Comecar
```

CTA secundario:

```text
Pular por enquanto
```

Texto sugerido:

```text
Personalize o Veris

Voce pode informar alguns dados do bebe para deixar o app mais pessoal. Tudo aqui e opcional e fica salvo apenas neste dispositivo.
```

Regras:

- Se o usuario tocar em `Pular por enquanto`, o app deve abrir a tela principal normalmente.
- Se o usuario preencher parcialmente os dados e tocar em `Comecar`, salvar apenas o que foi preenchido.
- O app nao deve bloquear o uso por falta de nome, sexo ou idade.

## 6. Cadastro Opcional Do Bebe

Campos:

- Nome do bebe.
- Sexo do bebe.
- Idade do bebe.
- Esquema de cores.

Todos os campos sao opcionais.

## 6.1 Nome

Campo:

```text
Nome do bebe
```

Placeholder:

```text
Opcional
```

Regras:

- Se o nome for preenchido, o app deve usar o nome quando se referir ao bebe.
- Se o nome nao for preenchido, o app deve usar uma referencia generica baseada no sexo, quando disponivel.
- Se sexo tambem nao for preenchido, usar uma referencia neutra.

Exemplos:

```text
Com nome: "Clara esta dormindo desde 15:55"
Sem nome, sexo feminino: "A bebe esta dormindo desde 15:55"
Sem nome, sexo masculino: "O bebe esta dormindo desde 15:55"
Sem nome e sem sexo: "O bebe esta dormindo desde 15:55"
```

Observacao:

- Para simplificar a primeira versao, usar `O bebe` como fallback neutro.
- Se o app ja estiver usando textos sem genero, preferir manter frases neutras, como `Dormindo desde 15:55`.

## 6.2 Sexo

Campo opcional.

Opcoes:

- Feminino
- Masculino
- Prefiro nao informar

Regras:

- O sexo deve ser usado apenas para ajustar textos como `o bebe` ou `a bebe`.
- Nao usar esse dado para regras medicas, relatorios ou inferencias.
- Se o usuario escolher `Prefiro nao informar`, tratar como nao preenchido.

## 6.3 Idade

Campo opcional com duas formas de preenchimento:

- Data de nascimento exata.
- Idade aproximada em meses.

UX sugerida:

- Segmented control:

```text
Data de nascimento | Idade em meses
```

Se `Data de nascimento`:

- Exibir seletor de data.
- Nao permitir data futura.

Se `Idade em meses`:

- Exibir input numerico.
- Aceitar valores de 0 a 36 no MVP.

Regras:

- Se o usuario preencher data de nascimento, o app pode calcular idade aproximada.
- Se o usuario preencher idade em meses, salvar como valor aproximado.
- Se nenhum valor for preenchido, nao exibir idade no app.
- Idade nao deve ser obrigatoria para usar o app.

## 6.4 Esquema De Cores

O usuario deve poder escolher a cor predominante dos widgets do app.

Opcoes iniciais:

- Azul bebe claro.
- Amarelo claro.
- Verde claro.
- Rosa claro.

Cada opcao deve ser exibida como um botao/swatch usando a propria cor principal do tema.

Paleta sugerida:

```text
Azul bebe claro:
  primary: #A7D8FF
  background: #F7FBFF

Amarelo claro:
  primary: #FFE8A3
  background: #FFFDF5

Verde claro:
  primary: #BCEAD5
  background: #F7FCF9

Rosa claro:
  primary: #FFC9D6
  background: #FFF8FA
```

Regras:

- A cor escolhida deve afetar botoes principais, destaques e elementos de resumo.
- A escolha deve ser persistida localmente.
- Se o usuario nao escolher, usar o tema padrao atual do app.
- O tema deve manter contraste suficiente para leitura.

## 7. Drawer Lateral

Adicionar um drawer que abre do lado esquerdo da tela.

Acesso:

- Icone de menu no canto superior esquerdo da tela principal.
- Gesto nativo de abrir drawer pode ser mantido se o Flutter oferecer por padrao.

Conteudo do drawer:

- Nome do app: `Veris`.
- Nome do bebe, se preenchido.
- Texto generico se nao houver nome:

```text
Acompanhamento do bebe
```

Itens:

- Inicio
- Configuracoes

Fora do MVP:

- Perfil de usuario.
- Login.
- Backup.
- Ajuda.
- Convite de cuidador.

## 8. Configuracoes

Criar uma tela de configuracoes acessivel pelo drawer.

Secoes:

- Bebe.
- Aparencia.
- Idioma.
- Privacidade.

## 8.1 Bebe

Permitir editar:

- Nome.
- Sexo.
- Data de nascimento ou idade em meses.

Regras:

- Todas as alteracoes devem ser persistidas localmente.
- O usuario deve poder apagar campos previamente preenchidos.
- Se apagar o nome, o app volta a usar referencia generica.

## 8.2 Aparencia

Permitir alterar o esquema de cores.

Regras:

- A alteracao deve ser aplicada imediatamente.
- A alteracao deve persistir apos fechar e abrir o app.

## 8.3 Idioma

O idioma inicial deve seguir o idioma configurado no sistema.

Opcoes iniciais:

- Sistema
- Portugues
- Ingles

Regras:

- `Sistema` deve usar o locale do dispositivo.
- Se o usuario escolher um idioma manualmente, essa escolha deve sobrescrever o idioma do sistema.
- A escolha deve ser persistida localmente.

Idiomas suportados no MVP 3:

- Portugues.
- Ingles.

Observacao:

- Se a internacionalizacao completa ainda nao existir, o MVP 3 deve preparar a estrutura minima para textos localizaveis e traduzir as telas novas.
- Nao e necessario traduzir absolutamente todos os textos antigos se isso aumentar muito o escopo, mas a arquitetura deve apontar para esse caminho.

## 8.4 Privacidade

Exibir um texto curto e tranquilizador.

Texto sugerido:

```text
Os dados do bebe sao opcionais e ficam salvos neste dispositivo. Voce pode usar o Veris sem preencher essas informacoes.
```

Nao adicionar termos longos ou juridicos no MVP.

## 9. Modelo De Dados

Nova entidade local: `BabyProfile`

Campos:

```text
id: string
name: string?
sex: BabySex?
birthDate: DateTime?
ageInMonths: int?
theme: AppThemeOption?
createdAt: DateTime
updatedAt: DateTime?
onboardingCompletedAt: DateTime?
```

Enum `BabySex`:

```text
female
male
notInformed
```

Enum `AppThemeOption`:

```text
defaultTheme
babyBlue
lightYellow
lightGreen
lightPink
```

Config local: `AppSettings`

```text
localeMode: system | pt | en
```

Regras:

- Deve existir no maximo um `BabyProfile` no MVP 3.
- Se o usuario pular onboarding, criar perfil vazio ou marcar onboarding como concluido em configuracao local.
- Dados devem ser armazenados localmente junto com as preferencias do app.

## 10. Arquitetura Recomendada

Sugestao de estrutura:

```text
features/
  onboarding/
    presentation/
      onboarding_page.dart

  baby_profile/
    data/
      baby_profile_repository.dart
      local_baby_profile_storage.dart
    domain/
      baby_profile.dart
      baby_sex.dart
      baby_reference_service.dart
    presentation/
      baby_profile_form.dart

  settings/
    data/
      app_settings_repository.dart
      local_app_settings_storage.dart
    domain/
      app_language_option.dart
      app_theme_option.dart
    presentation/
      settings_page.dart
      widgets/
        theme_selector.dart
        language_selector.dart

  navigation/
    app_drawer.dart
```

Servicos:

- `BabyReferenceService`
  - Decide se o app usa nome, `o bebe` ou `a bebe`.
- `AppThemeService`
  - Aplica tema escolhido.
- `AppLocaleService`
  - Resolve idioma entre sistema e escolha manual.

## 11. UX E Copy

Tonalidade:

- Leve.
- Respeitosa.
- Sem pressionar.
- Sem linguagem de obrigatoriedade.

Evitar:

- `Complete seu cadastro`.
- `Informe os dados para continuar`.
- `Precisamos dessas informacoes`.

Preferir:

- `Personalize se quiser`.
- `Tudo aqui e opcional`.
- `Voce pode pular e ajustar depois`.

## 12. Criterios De Aceite

### Primeiro Acesso

- Ao abrir o app pela primeira vez, o usuario deve ver a tela de onboarding.
- O usuario deve conseguir pular o onboarding.
- Ao pular, o app deve abrir a tela principal normalmente.
- O onboarding nao deve aparecer novamente apos ser concluido ou pulado.

### Cadastro Opcional

- O usuario deve conseguir salvar sem preencher nome, sexo ou idade.
- Se preencher nome, o app deve usar esse nome em textos relevantes.
- Se nao preencher nome, o app deve usar referencia generica.
- O usuario deve conseguir escolher data de nascimento ou idade em meses.
- O usuario deve conseguir deixar idade em branco.

### Tema

- O usuario deve conseguir escolher entre azul bebe claro, amarelo claro, verde claro e rosa claro.
- A cor escolhida deve ser aplicada imediatamente ou apos concluir onboarding.
- A cor escolhida deve persistir apos fechar e abrir o app.
- O usuario deve conseguir alterar o tema nas configuracoes.

### Drawer

- A tela principal deve ter acesso ao drawer pelo lado esquerdo.
- O drawer deve exibir acesso a `Inicio` e `Configuracoes`.
- Ao tocar em `Configuracoes`, deve abrir a tela de configuracoes.

### Configuracoes

- O usuario deve conseguir editar informacoes do bebe.
- O usuario deve conseguir apagar informacoes do bebe.
- O usuario deve conseguir alterar idioma.
- O idioma inicial deve ser `Sistema`.
- O usuario deve conseguir voltar da tela de configuracoes para a tela principal.

### Privacidade

- A tela de onboarding deve deixar claro que os dados sao opcionais.
- A tela de configuracoes deve conter texto curto explicando que os dados ficam salvos localmente.
- Nenhum dado do bebe deve ser obrigatorio.

## 13. Testes

### Unitarios

- `BabyReferenceService` com nome preenchido.
- `BabyReferenceService` sem nome e sexo feminino.
- `BabyReferenceService` sem nome e sexo masculino.
- `BabyReferenceService` sem nome e sem sexo.
- Resolucao de tema padrao.
- Resolucao de idioma `Sistema`.
- Validacao de data de nascimento futura.
- Validacao de idade em meses fora do intervalo.

### Widget Tests

- Primeiro acesso exibe onboarding.
- Botao `Pular por enquanto` leva para tela principal.
- Salvar nome do bebe faz o nome aparecer em textos relevantes.
- Selecionar tema altera cor dos botoes principais.
- Drawer abre pelo botao de menu.
- Drawer navega para configuracoes.
- Configuracoes permitem alterar tema.
- Configuracoes permitem editar/apagar nome do bebe.

## 14. Prompt Para Codex

```text
Implemente o MVP 3 como um patch de UX para o Veris.

Contexto:
- O app ja possui tela principal com registro rapido de atividades do bebe.
- Nao implementar login, Supabase, sync ou multiplos bebes.
- O objetivo e melhorar onboarding, personalizacao, drawer e configuracoes.

Escopo:
- Criar onboarding opcional no primeiro acesso.
- Permitir pular o onboarding.
- Permitir informar opcionalmente nome, sexo e idade do bebe.
- Para idade, permitir data de nascimento exata ou idade aproximada em meses.
- Permitir escolher esquema de cores: azul bebe claro, amarelo claro, verde claro e rosa claro.
- Persistir perfil do bebe e preferencias localmente.
- Usar nome do bebe nos textos quando preenchido.
- Se nao houver nome, usar referencia generica como "o bebe" ou "a bebe" quando aplicavel.
- Adicionar drawer lateral esquerdo com Inicio e Configuracoes.
- Criar tela de Configuracoes para editar informacoes do bebe, tema e idioma.
- Idioma inicial deve seguir o sistema; opcoes: Sistema, Portugues e Ingles.
- Adicionar texto curto de privacidade deixando claro que os dados sao opcionais e locais.

Cuidados:
- Nenhum dado do bebe deve ser obrigatorio.
- O usuario nao deve se sentir pressionado a fornecer dados.
- Manter o registro rapido de atividades como fluxo principal.
- Preservar design minimalista e baixa friccao.
```

## 15. Futuro MVP 4

Depois deste patch de UX, o proximo MVP pode voltar para:

- Supabase Auth.
- Backup remoto opcional.
- Sincronizacao local-first.
- Compartilhamento com outro cuidador.
