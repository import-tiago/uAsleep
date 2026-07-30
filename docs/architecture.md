# Arquitetura

## Visão geral

O uAsleep usa organização feature-first. As dependências apontam da interface
e de adaptadores para contratos e regras de negócio:

```text
Widgets → Cubits → domínio
                   ↑
Widgets → SettingsCubit → SettingsRepository ← adaptadores locais
```

Não há service locator, Singleton, estado global mutável ou navegação dentro
do domínio. Dependências são fornecidas por construtor.

## Inicialização e aplicação

- `main.dart` chama `bootstrap()`.
- `bootstrap.dart` cria os adaptadores locais e injeta o repositório.
- `app.dart` mantém o `SettingsCubit` acima do `MaterialApp`, permitindo troca
  imediata de locale e tema.
- `app_router.dart` centraliza as duas rotas e uma página de rota desconhecida.

## Calculadora

### Domínio

- `BatteryUsageProfile`: entradas tipadas.
- `BatteryCapacityUnit`, `CurrentUnit` e `TimeUnit`: normalização de unidades.
- `BatteryLifeCalculator`: fórmula, premissas e invariantes.
- `BatteryLifeResult`: horas, corrente média e ciclo ativo.
- `BatteryLifeFormatter`: seleção de horas, dias, meses ou anos.
- `BatteryLifeException`: falhas de domínio enumeradas.

O domínio não importa Flutter. A estimativa usa mAh, mA e horas internamente.
O número de despertares representa frequência por hora, preservando o conceito
da versão 1.x.

### Estado e apresentação

`CalculatorCubit` mantém valores textuais, unidades, erros tipados, alertas e
resultado. A UI apenas envia alterações e renderiza o estado; não executa
fórmulas. O parser aceita decimal com vírgula ou ponto e o domínio rejeita
valores inválidos de forma explícita.

Os widgets são responsivos, têm largura máxima em telas grandes, usam
componentes Material com áreas de toque padrão e não dependem exclusivamente
de cor para comunicar erros.

## Configurações

`SettingsRepository` é o contrato de domínio. `LocalSettingsRepository` usa
uma abstração de chave/valor implementada com `SharedPreferencesAsync`.

Na primeira execução após atualização, `FileLegacySettingsSource` tenta ler
`DataPersistence.txt`, converte idioma e precisão e grava um marcador. O
arquivo antigo nunca é alterado e não é necessário nas execuções seguintes.
Dados ausentes ou inválidos voltam a padrões seguros.

## Internacionalização

`gen_l10n` gera classes a partir dos ARBs em `lib/l10n`. Textos de interface,
erros e mensagens de feedback são localizados. Locale ausente segue o sistema;
idiomas não suportados usam inglês.

## Segurança e privacidade

- Sem rede, analytics, rastreamento ou credenciais.
- Sem permissões Android/iOS de produção.
- Preferências não sensíveis ficam em armazenamento comum.
- Feedback abre um cliente externo por URI e exige ação explícita.
- Arquivos de assinatura são ignorados e a configuração release é opcional.

## Testabilidade

O domínio é síncrono e determinístico. Cubits recebem serviços e repositórios
por construtor. Adaptadores de plataforma ficam nas bordas e são substituídos
por fakes em testes. O fluxo integrado usa as mesmas páginas, Cubits, rotas e
localização sem acessar serviços externos.
