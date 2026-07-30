// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'uAsleep';

  @override
  String get calculatorTitle => 'Estimativa de autonomia';

  @override
  String get calculatorSubtitle =>
      'Modele o ciclo de operação de um dispositivo embarcado ou IoT.';

  @override
  String get settingsTooltip => 'Abrir configurações';

  @override
  String get batterySectionTitle => 'Bateria';

  @override
  String get batterySectionDescription =>
      'Informe a capacidade nominal da bateria.';

  @override
  String get batteryCapacityLabel => 'Capacidade da bateria';

  @override
  String get activeSectionTitle => 'Modo ativo';

  @override
  String get activeSectionDescription =>
      'Corrente consumida enquanto o dispositivo está acordado.';

  @override
  String get activeCurrentLabel => 'Corrente ativa';

  @override
  String get sleepModeTitle => 'Usar modo sleep';

  @override
  String get sleepModeSubtitle =>
      'Inclua na estimativa o período de baixo consumo.';

  @override
  String get sleepSectionTitle => 'Modo sleep';

  @override
  String get sleepSectionDescription =>
      'Corrente consumida entre os períodos ativos.';

  @override
  String get sleepCurrentLabel => 'Corrente em sleep';

  @override
  String get cycleSectionTitle => 'Ciclo de despertar';

  @override
  String get cycleSectionDescription =>
      'Defina por quanto tempo e com que frequência o dispositivo desperta.';

  @override
  String get activeDurationLabel => 'Duração ativa';

  @override
  String get wakeupsPerHourLabel => 'Despertares por hora';

  @override
  String get calculateButton => 'Calcular';

  @override
  String get resetButton => 'Limpar';

  @override
  String get estimateNotice =>
      'Esta é uma estimativa teórica. A autonomia real também depende de temperatura, envelhecimento, autodescarga, eficiência do regulador e transientes de carga.';

  @override
  String get resultTitle => 'Autonomia estimada';

  @override
  String get resultEmptyTitle => 'Pronto para calcular';

  @override
  String get resultEmptyDescription =>
      'Preencha o perfil elétrico para visualizar a estimativa.';

  @override
  String get averageCurrentLabel => 'Corrente média';

  @override
  String get dutyCycleLabel => 'Ciclo ativo';

  @override
  String averageCurrentValue(String value) {
    return '$value mA';
  }

  @override
  String percentageValue(String value) {
    return '$value%';
  }

  @override
  String durationHours(num count, String formatted) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$formatted horas',
      one: '$formatted hora',
    );
    return '$_temp0';
  }

  @override
  String durationDays(num count, String formatted) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$formatted dias',
      one: '$formatted dia',
    );
    return '$_temp0';
  }

  @override
  String durationMonths(num count, String formatted) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$formatted meses',
      one: '$formatted mês',
    );
    return '$_temp0';
  }

  @override
  String durationYears(num count, String formatted) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$formatted anos',
      one: '$formatted ano',
    );
    return '$_temp0';
  }

  @override
  String get validationRequired => 'Informe um valor.';

  @override
  String get validationInvalidNumber => 'Informe um número válido.';

  @override
  String get validationNonFinite => 'O valor deve ser finito.';

  @override
  String get validationMustBePositive => 'Informe um valor maior que zero.';

  @override
  String get validationCannotBeNegative => 'O valor não pode ser negativo.';

  @override
  String get validationActiveDurationTooLong =>
      'A duração ativa não pode superar o ciclo completo de despertar.';

  @override
  String get validationZeroAverageCurrent =>
      'A corrente média deve ser maior que zero.';

  @override
  String get validationUnrealistic =>
      'Revise os valores: a escala resultante é incomum para um dispositivo embarcado típico.';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get appearanceTitle => 'Aparência';

  @override
  String get themeLabel => 'Tema';

  @override
  String get themeSystem => 'Seguir o sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get languageTitle => 'Idioma';

  @override
  String get languageSystem => 'Padrão do sistema';

  @override
  String get languageEnglish => 'English';

  @override
  String get languagePortuguese => 'Português (Brasil)';

  @override
  String get precisionTitle => 'Precisão do resultado';

  @override
  String get precisionSimple => 'Simples';

  @override
  String get precisionDetailed => 'Detalhado';

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get feedbackDescription =>
      'Abra seu aplicativo de e-mail com uma mensagem endereçada ao desenvolvedor. Nada é enviado automaticamente.';

  @override
  String get feedbackButton => 'Enviar feedback';

  @override
  String get feedbackSubject => 'Feedback sobre o uAsleep';

  @override
  String get feedbackBody =>
      'Olá,\n\nGostaria de compartilhar o seguinte feedback sobre o uAsleep:\n\n';

  @override
  String get feedbackUnavailable =>
      'Não foi possível abrir um aplicativo de e-mail compatível.';

  @override
  String get aboutTitle => 'Sobre';

  @override
  String get aboutDescription =>
      'Estimativa de autonomia de código aberto para projetos embarcados e IoT.';

  @override
  String appVersion(String version) {
    return 'Versão $version';
  }

  @override
  String get softwareLicenses => 'Licenças de código aberto';

  @override
  String get settingsLoadFailure =>
      'Não foi possível carregar as configurações. Valores padrão seguros estão em uso.';

  @override
  String get settingsSaveFailure => 'Não foi possível salvar a configuração.';

  @override
  String get routeNotFoundTitle => 'Página não encontrada';

  @override
  String get routeNotFoundDescription => 'A página solicitada não existe.';

  @override
  String get backToCalculator => 'Voltar para a calculadora';

  @override
  String get loadingLabel => 'Carregando';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get appTitle => 'uAsleep';

  @override
  String get calculatorTitle => 'Estimativa de autonomia';

  @override
  String get calculatorSubtitle =>
      'Modele o ciclo de operação de um dispositivo embarcado ou IoT.';

  @override
  String get settingsTooltip => 'Abrir configurações';

  @override
  String get batterySectionTitle => 'Bateria';

  @override
  String get batterySectionDescription =>
      'Informe a capacidade nominal da bateria.';

  @override
  String get batteryCapacityLabel => 'Capacidade da bateria';

  @override
  String get activeSectionTitle => 'Modo ativo';

  @override
  String get activeSectionDescription =>
      'Corrente consumida enquanto o dispositivo está acordado.';

  @override
  String get activeCurrentLabel => 'Corrente ativa';

  @override
  String get sleepModeTitle => 'Usar modo sleep';

  @override
  String get sleepModeSubtitle =>
      'Inclua na estimativa o período de baixo consumo.';

  @override
  String get sleepSectionTitle => 'Modo sleep';

  @override
  String get sleepSectionDescription =>
      'Corrente consumida entre os períodos ativos.';

  @override
  String get sleepCurrentLabel => 'Corrente em sleep';

  @override
  String get cycleSectionTitle => 'Ciclo de despertar';

  @override
  String get cycleSectionDescription =>
      'Defina por quanto tempo e com que frequência o dispositivo desperta.';

  @override
  String get activeDurationLabel => 'Duração ativa';

  @override
  String get wakeupsPerHourLabel => 'Despertares por hora';

  @override
  String get calculateButton => 'Calcular';

  @override
  String get resetButton => 'Limpar';

  @override
  String get estimateNotice =>
      'Esta é uma estimativa teórica. A autonomia real também depende de temperatura, envelhecimento, autodescarga, eficiência do regulador e transientes de carga.';

  @override
  String get resultTitle => 'Autonomia estimada';

  @override
  String get resultEmptyTitle => 'Pronto para calcular';

  @override
  String get resultEmptyDescription =>
      'Preencha o perfil elétrico para visualizar a estimativa.';

  @override
  String get averageCurrentLabel => 'Corrente média';

  @override
  String get dutyCycleLabel => 'Ciclo ativo';

  @override
  String averageCurrentValue(String value) {
    return '$value mA';
  }

  @override
  String percentageValue(String value) {
    return '$value%';
  }

  @override
  String durationHours(num count, String formatted) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$formatted horas',
      one: '$formatted hora',
    );
    return '$_temp0';
  }

  @override
  String durationDays(num count, String formatted) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$formatted dias',
      one: '$formatted dia',
    );
    return '$_temp0';
  }

  @override
  String durationMonths(num count, String formatted) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$formatted meses',
      one: '$formatted mês',
    );
    return '$_temp0';
  }

  @override
  String durationYears(num count, String formatted) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$formatted anos',
      one: '$formatted ano',
    );
    return '$_temp0';
  }

  @override
  String get validationRequired => 'Informe um valor.';

  @override
  String get validationInvalidNumber => 'Informe um número válido.';

  @override
  String get validationNonFinite => 'O valor deve ser finito.';

  @override
  String get validationMustBePositive => 'Informe um valor maior que zero.';

  @override
  String get validationCannotBeNegative => 'O valor não pode ser negativo.';

  @override
  String get validationActiveDurationTooLong =>
      'A duração ativa não pode superar o ciclo completo de despertar.';

  @override
  String get validationZeroAverageCurrent =>
      'A corrente média deve ser maior que zero.';

  @override
  String get validationUnrealistic =>
      'Revise os valores: a escala resultante é incomum para um dispositivo embarcado típico.';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get appearanceTitle => 'Aparência';

  @override
  String get themeLabel => 'Tema';

  @override
  String get themeSystem => 'Seguir o sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get languageTitle => 'Idioma';

  @override
  String get languageSystem => 'Padrão do sistema';

  @override
  String get languageEnglish => 'English';

  @override
  String get languagePortuguese => 'Português (Brasil)';

  @override
  String get precisionTitle => 'Precisão do resultado';

  @override
  String get precisionSimple => 'Simples';

  @override
  String get precisionDetailed => 'Detalhado';

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get feedbackDescription =>
      'Abra seu aplicativo de e-mail com uma mensagem endereçada ao desenvolvedor. Nada é enviado automaticamente.';

  @override
  String get feedbackButton => 'Enviar feedback';

  @override
  String get feedbackSubject => 'Feedback sobre o uAsleep';

  @override
  String get feedbackBody =>
      'Olá,\n\nGostaria de compartilhar o seguinte feedback sobre o uAsleep:\n\n';

  @override
  String get feedbackUnavailable =>
      'Não foi possível abrir um aplicativo de e-mail compatível.';

  @override
  String get aboutTitle => 'Sobre';

  @override
  String get aboutDescription =>
      'Estimativa de autonomia de código aberto para projetos embarcados e IoT.';

  @override
  String appVersion(String version) {
    return 'Versão $version';
  }

  @override
  String get softwareLicenses => 'Licenças de código aberto';

  @override
  String get settingsLoadFailure =>
      'Não foi possível carregar as configurações. Valores padrão seguros estão em uso.';

  @override
  String get settingsSaveFailure => 'Não foi possível salvar a configuração.';

  @override
  String get routeNotFoundTitle => 'Página não encontrada';

  @override
  String get routeNotFoundDescription => 'A página solicitada não existe.';

  @override
  String get backToCalculator => 'Voltar para a calculadora';

  @override
  String get loadingLabel => 'Carregando';
}
