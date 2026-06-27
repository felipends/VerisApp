<p align="center">
  <img src="assets/images/veris_logo.png" alt="Logo do Veris" width="160" />
</p>

# Veris

Veris é um app Flutter para registrar e acompanhar a rotina de cuidados do bebê de forma simples, rápida e organizada.

O objetivo do app é ajudar pais e cuidadores a manterem um histórico claro das principais atividades do dia, como mamadas, trocas de fralda e sono. A tela inicial reúne ações rápidas, estado atual do bebê, resumo diário e uma linha do tempo com as atividades recentes.

## Funcionalidades

- Registro rápido de mamada, início do sono, fim do sono e troca de fralda.
- Proteção contra taps repetidos para evitar registros duplicados acidentais.
- Resumo diário com última mamada, fraldas do dia e sonecas finalizadas.
- Estado atual do bebê com base nos registros de sono.
- Histórico em linha do tempo agrupado por dia.
- Edição de tipo, data, horário e observação das atividades.
- Exclusão de atividades com confirmação.
- Interface simples, limpa e focada no uso diário.
- Persistência local dos registros no dispositivo.

## Tecnologias

- Flutter
- Dart
- Shared Preferences para armazenamento local

## Como executar

```bash
flutter pub get
flutter run
```

## Desenvolvimento

Para verificar o projeto antes de enviar alterações:

```bash
flutter analyze
flutter test
```
