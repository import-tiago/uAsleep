# Changelog

## 2.0.0+6

- Migração para Flutter 3.44.8, Dart 3.12.2 e sound null safety.
- Nova arquitetura feature-first com `flutter_bloc`/Cubit e injeção por
  construtor.
- Remoção de `bloc_pattern`, RxDart, Singleton e estado global mutável.
- Fórmula isolada em Dart puro, com unidades normalizadas e erros de domínio.
- Validação de campos, números não finitos, ciclos impossíveis e corrente zero.
- Material 3 responsivo, acessível e com temas claro, escuro e automático.
- Internacionalização oficial por ARB/gen_l10n em inglês e português.
- Preferências estruturadas com migração do formato 1.x.
- Feedback por `mailto`, sem permissão ou envio silencioso.
- Scaffolding Android/iOS regenerado; identificadores unificados em
  `br.uasleep`.
- Suítes unitária, de estado, widget e integração.
- CI com formatação, análise, cobertura e build Android debug.

### Mudanças incompatíveis

- Android mínimo passou de API 21 para API 24, padrão suportado pelo Flutter
  3.44.8.
- iOS mínimo passou de 8.0 para 13.0.
- A interface e o formato interno de persistência foram substituídos.
- A versão foi elevada para 2.0.0; o build number 6 supera o código 5 usado
  pela configuração Android legada.
