# Contribuindo

1. Crie uma branch curta a partir da branch principal.
2. Mantenha domínio independente de Flutter e injete dependências por
   construtor.
3. Adicione testes para toda correção matemática ou mudança observável.
4. Não versione credenciais, `key.properties`, keystores nem arquivos `.env`.
5. Antes de abrir o pull request, execute:

```shell
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter test integration_test
flutter build apk --debug
```

Descreva no pull request a motivação, o comportamento anterior, o novo
comportamento e as plataformas validadas.
