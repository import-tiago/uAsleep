# uAsleep

Aplicativo Flutter para estimar a autonomia teórica de baterias em sistemas
embarcados e dispositivos IoT, com ou sem modo sleep.

## Funcionalidades

- Capacidade em mAh ou Ah.
- Corrente ativa e de sleep em nA, µA, mA ou A.
- Duração ativa em µs, ms, s, min ou h.
- Frequência em despertares por hora.
- Corrente média, ciclo ativo e autonomia em escala humana.
- Validação localizada e suporte a separadores `,` e `.`.
- Inglês, português brasileiro e idioma do sistema.
- Temas claro, escuro e automático.
- Precisão simples ou detalhada.
- Preferências persistidas e migração única do arquivo usado pelo uAsleep 1.x.
- Feedback por `mailto`, sem envio silencioso ou coleta de dados.

## Capturas de tela

> Espaço reservado: capture as telas da versão 2.0 em Android e iOS e adicione
> os arquivos a `docs/images/`. As imagens antigas permanecem em
> `lib/Printscreens/` apenas como referência histórica.

## Modelo matemático

O cálculo usa mAh, mA e horas como unidades internas. Com sleep:

```text
cycleDuration = 1 hour / wakeupsPerHour
sleepDuration = cycleDuration - activeDuration

averageCurrent =
  ((activeCurrent × activeDuration) +
   (sleepCurrent × sleepDuration)) /
  cycleDuration

batteryLifeHours = batteryCapacityMah / averageCurrentMa
```

Sem sleep, a corrente ativa é considerada contínua. Essa formulação é
algebricamente equivalente à janela de uma hora usada na versão 1.x, mas agora
impede duração ativa maior que o ciclo, divisão por zero, valores negativos,
NaN e infinito.

O resultado é idealizado. Não considera autodescarga, envelhecimento,
temperatura, curva de descarga, eficiência de reguladores nem transientes.

## Ambiente

- Flutter `3.44.8` stable
- Dart `3.12.2`
- Android SDK `36`, minSdk `24`, Java/Kotlin target `17`
- iOS deployment target `13.0`

Confira a instalação:

```shell
flutter doctor -v
flutter pub get
```

## Execução

```shell
flutter run
```

## Qualidade e testes

```shell
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter test --coverage
flutter test integration_test
```

A suíte cobre domínio, conversões, validação, Cubits, persistência, migração,
widgets responsivos e um fluxo integrado. A CI repete análise, cobertura e
build Android a cada push e pull request.

Cobertura medida na migração: **88,15%** (`848/962` linhas) no código da
aplicação, excluindo somente os arquivos Dart gerados por `gen_l10n`. O LCOV
bruto, incluindo esse código regional duplicado, registra 77,73% (`984/1266`).
A fórmula, o formatador de duração, o parser numérico e todas as conversões de
unidade têm 100%; os Cubits têm 93,08% em conjunto.

## Builds

Android:

```shell
flutter build apk --debug
flutter build appbundle
```

O build release procura `android/key.properties`, que é ignorado pelo Git. Sem
esse arquivo, o artefato release é gerado sem configuração de assinatura para
publicação. Nunca versione keystores ou senhas.

iOS, em macOS com Xcode:

```shell
flutter build ios --no-codesign
```

O scaffolding iOS foi atualizado estruturalmente neste repositório, mas não
pode ser compilado no host Windows usado na migração.

## Estrutura

```text
lib/
├── app/                    # bootstrap, MaterialApp, rotas e tema
├── core/                   # parsing e adaptadores compartilhados
├── features/
│   ├── calculator/
│   │   ├── domain/         # fórmula, entidades e unidades Dart puras
│   │   └── presentation/   # Cubit, página e widgets
│   └── settings/
│       ├── data/           # shared_preferences e migração legada
│       ├── domain/         # entidade e contrato do repositório
│       └── presentation/   # Cubit e página
└── l10n/                   # ARB e código gerado pelo gen_l10n
```

As decisões estão detalhadas em [docs/architecture.md](docs/architecture.md) e
o histórico em [docs/migration.md](docs/migration.md).

## Internacionalização

Os textos ficam em `lib/l10n/*.arb`. Para adicionar um idioma:

1. Copie `app_en.arb` para `app_<locale>.arb`.
2. Traduza todas as mensagens, preservando placeholders.
3. Execute `flutter gen-l10n`.
4. Adicione a opção de seleção à tela de configurações, quando aplicável.
5. Adicione testes do locale.

`en` é o fallback seguro. `pt` é a base linguística de `pt_BR`.

## Persistência e tema

`SettingsRepository` separa o domínio do armazenamento.
`LocalSettingsRepository` usa `SharedPreferencesAsync`; `path_provider` existe
somente para ler uma vez o arquivo `DataPersistence.txt` da versão 1.x.

O design system está em `lib/app/theme/`. Altere as cores em `AppTheme` e os
tokens de layout em `AppSpacing`, mantendo contraste e testes responsivos.

## Licença

O projeto original foi publicado sob
[Creative Commons Attribution-ShareAlike 4.0](https://creativecommons.org/licenses/by-sa/4.0/).
