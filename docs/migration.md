# Migração 1.x → 2.0

## Referência inicial

O estado legado permanece recuperável no histórico Git, commit `1489f45`.
Antes das alterações foram auditados todos os fontes Dart, ARBs antigos,
manifests, Gradle, Xcode, assets, permissões, IDs e o lockfile.

Estado observado:

- Flutter 1.5.4-hotfix.2 e Dart 2.3.0.
- Dart `>=2.1.0 <3.0.0`, sem null safety.
- `bloc_pattern`, RxDart, Singleton e múltiplos estados globais mutáveis.
- Persistência em `DataPersistence.txt`.
- JSON de idioma com extensão `.js`.
- Android API 21/28, Gradle 4.10.2 e AGP 3.2.1.
- iOS 8.0 e bundle ID incorreto `com.example.uasleep`.
- Teste padrão de contador sem relação com o produto.

O código legado não pôde executar na toolchain atual: `flutter pub get` falhou
porque Dart 3 exige null safety. A fórmula foi caracterizada diretamente do
fonte antes da refatoração.

## Fórmula e correções

A versão 1.x calculava, em uma janela de 3.600.000 ms:

```text
activeTimePerHour = wakeupsPerHour × activeDuration
sleepTimePerHour = oneHour - activeTimePerHour
averageCurrent =
  (activeCurrent × activeTimePerHour +
   sleepCurrent × sleepTimePerHour) / oneHour
batteryLifeHours = batteryCapacityMah / averageCurrentMa
```

A versão 2.0 expressa a mesma relação por ciclo. Foram corrigidos:

- duração ativa maior que o período agora é rejeitada, em vez de produzir
  tempo de sleep negativo;
- capacidade zero/negativa, correntes negativas, frequência/duração não
  positivas, NaN, infinito e corrente média zero são rejeitados;
- resultados menores ou iguais a uma hora agora são exibidos;
- cálculo e formatação foram separados;
- unidade `ns`, listada apenas em uma condição morta no legado, não foi
  mantida porque nunca aparecia na interface; `nA` continua suportado.

Testes documentam a equivalência para um perfil manual de ciclo de 60 s.

## Dependências

Removidas:

- `bloc_pattern`
- `rxdart`
- `flutter_email_sender`
- `cupertino_icons`

Atualizadas/adicionadas:

- `flutter_bloc` e `bloc_test`
- `equatable`
- `shared_preferences`
- `url_launcher`
- `package_info_plus`
- `intl` e `flutter_localizations`
- `path_provider`, restrito à migração de dados 1.x
- `flutter_lints`, `flutter_launcher_icons` e `integration_test`

Dependências de runtime foram movidas para `dependencies`.

## Persistência

Idioma, precisão e tema agora usam `SharedPreferencesAsync` por meio de
`SettingsRepository`. Na primeira inicialização, o arquivo antigo é lido de
forma tolerante, importado e marcado como migrado. Ausência ou corrupção não
impedem o app de iniciar. O arquivo legado não é apagado.

## Android

- Scaffolding regenerado pelo Flutter 3.44.8.
- `namespace` e `applicationId`: `br.uasleep`.
- compile/target SDK 36; minSdk 24.
- Gradle 9.1.0, AGP 9.0.1 e Kotlin 2.3.20.
- Bytecode Java/Kotlin 17; toolchain local JDK 21.
- MainActivity em Kotlin com Flutter embedding atual.
- Nome e ícone preservados.
- Nenhuma permissão de produção adicionada.
- Assinatura release lê `key.properties` apenas quando presente.

O minSdk 21 foi elevado porque o Flutter 3.44.8 usa API 24 como mínimo padrão
suportado e já sinaliza versões inferiores.

## iOS

- Scaffolding Swift atual com AppDelegate/SceneDelegate.
- Bundle ID corrigido e preservado como `br.uasleep`.
- Deployment target 13.0, mínimo do template atual.
- Nome e ícone preservados.
- Nenhuma descrição de permissão desnecessária.

O projeto foi atualizado estruturalmente no Windows. Build, assinatura e
execução iOS ainda precisam ser confirmados em macOS/Xcode.

## UI, acessibilidade e localização

A interface foi refeita em Material 3 com tokens de tema e espaçamento,
largura limitada, layouts adaptativos, SafeArea, scroll, temas claro/escuro,
texto ampliado, mensagens textuais de erro e resultado anunciado como região
semântica. A navegação usa o Navigator do Flutter.

Arquivos JSON `.js` foram substituídos por ARB/gen_l10n. Inglês é fallback,
português tem base `pt` e seleção `pt_BR`; mudanças são imediatas.

## Versionamento

Foi adotado `2.0.0+6`. O major sinaliza mudanças visuais, arquiteturais,
requisitos mínimos e persistência. O build 6 supera o `versionCode` 5 forçado
no Gradle legado, evitando regressão em atualizações de loja.

## Validação executada

Resultados no host da migração:

- `dart format --output=none --set-exit-if-changed .`: passou.
- `flutter analyze`: passou sem diagnósticos.
- `flutter test --coverage`: 54/54 testes; cobertura de aplicação 88,15%
  (`848/962`) após excluir somente arquivos gerados por `gen_l10n`; LCOV bruto
  77,73% (`984/1266`).
- lógica matemática, seleção de escala e conversões: 100% de cobertura.
- Cubits: 93,08% de cobertura conjunta.
- `flutter test integration_test -d emulator-5554`: passou em AVD API 36.
- `flutter build apk --debug`: passou.
- `flutter build appbundle`: passou; AAB intencionalmente não assinado por
  ausência de credenciais locais.
- `flutter pub outdated`: todas as dependências estão nas versões mais novas
  resolvíveis; `intl 0.20.2` é fixado pelo SDK Flutter.

- Android foi analisado, testado em emulador e compilado.
- iOS não pôde ser compilado por ausência de macOS/Xcode.
- Web não faz parte das plataformas do projeto.
