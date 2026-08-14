// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'uAsleep';

  @override
  String get calculatorTitle => 'Battery life estimator';

  @override
  String get calculatorSubtitle =>
      'Model the duty cycle of an embedded or IoT device.';

  @override
  String get settingsTooltip => 'Open settings';

  @override
  String get historyTooltip => 'Open calculation history';

  @override
  String get batterySectionTitle => 'Battery';

  @override
  String get batterySectionDescription => 'Enter the rated battery capacity.';

  @override
  String get batteryCapacityLabel => 'Battery capacity';

  @override
  String get activeSectionTitle => 'Active mode';

  @override
  String get activeSectionDescription =>
      'Current drawn while the device is awake.';

  @override
  String get activeCurrentLabel => 'Active current';

  @override
  String get sleepModeTitle => 'Use sleep mode';

  @override
  String get sleepModeSubtitle =>
      'Include the device\'s low-power time in the estimate.';

  @override
  String get sleepSectionTitle => 'Sleep mode';

  @override
  String get sleepSectionDescription => 'Current drawn between active periods.';

  @override
  String get sleepCurrentLabel => 'Sleep current';

  @override
  String get cycleSectionTitle => 'Wake cycle';

  @override
  String get cycleSectionDescription =>
      'Describe how long and how often the device wakes.';

  @override
  String get activeDurationLabel => 'Active duration';

  @override
  String get wakeupsPerHourLabel => 'Wake-ups per hour';

  @override
  String get monitoringModeTitle => 'Project consumption by period';

  @override
  String get monitoringModeSubtitle =>
      'Estimate the charge used over a chosen period.';

  @override
  String get monitoringSectionTitle => 'Monitoring period';

  @override
  String get monitoringSectionDescription =>
      'Choose how long the device operates under these conditions.';

  @override
  String get monitoringPeriodLabel => 'Period';

  @override
  String get monitoringUnitHours => 'h';

  @override
  String get monitoringUnitDays => 'days';

  @override
  String get monitoringUnitWeeks => 'weeks';

  @override
  String get calculateButton => 'Calculate';

  @override
  String get resetButton => 'Reset';

  @override
  String get estimateNotice =>
      'This is a theoretical estimate. Real battery life also depends on temperature, aging, self-discharge, regulator efficiency, and load transients.';

  @override
  String get resultTitle => 'Estimated autonomy';

  @override
  String get resultEmptyTitle => 'Ready to calculate';

  @override
  String get resultEmptyDescription =>
      'Complete the electrical profile to see the estimate.';

  @override
  String get exportButton => 'Export result';

  @override
  String get exportTooltip => 'Export result';

  @override
  String get exportUnavailable => 'The result could not be shared.';

  @override
  String get exportSubject => 'uAsleep battery estimate';

  @override
  String get exportReportTitle => 'uAsleep battery estimate';

  @override
  String get generatedAtLabel => 'Generated at';

  @override
  String get sleepModeEnabledValue => 'Enabled';

  @override
  String get sleepModeDisabledValue => 'Disabled';

  @override
  String get averageCurrentLabel => 'Average current';

  @override
  String get dutyCycleLabel => 'Active duty cycle';

  @override
  String get monitoredConsumptionLabel => 'Consumption in period';

  @override
  String get monitoredCapacityLabel => 'Battery capacity used';

  @override
  String consumptionValue(String value) {
    return '$value mAh';
  }

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
      other: '$formatted hours',
      one: '$formatted hour',
    );
    return '$_temp0';
  }

  @override
  String durationDays(num count, String formatted) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$formatted days',
      one: '$formatted day',
    );
    return '$_temp0';
  }

  @override
  String durationMonths(num count, String formatted) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$formatted months',
      one: '$formatted month',
    );
    return '$_temp0';
  }

  @override
  String durationYears(num count, String formatted) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$formatted years',
      one: '$formatted year',
    );
    return '$_temp0';
  }

  @override
  String get validationRequired => 'Enter a value.';

  @override
  String get validationInvalidNumber => 'Enter a valid number.';

  @override
  String get validationNonFinite => 'The value must be finite.';

  @override
  String get validationMustBePositive => 'Enter a value greater than zero.';

  @override
  String get validationCannotBeNegative => 'The value cannot be negative.';

  @override
  String get validationActiveDurationTooLong =>
      'Active duration cannot exceed the complete wake cycle.';

  @override
  String get validationZeroAverageCurrent =>
      'Average current must be greater than zero.';

  @override
  String get validationUnrealistic =>
      'Review these values: the resulting scale is unusual for a typical embedded device.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get historyTitle => 'Calculation history';

  @override
  String get historyEmptyTitle => 'No calculations yet';

  @override
  String get historyEmptyDescription =>
      'Your successful estimates will appear here.';

  @override
  String get historyReuseHint => 'Tap to reuse these parameters';

  @override
  String get historyClearTooltip => 'Clear history';

  @override
  String get historyClearTitle => 'Clear calculation history?';

  @override
  String get historyClearMessage =>
      'This permanently removes every saved estimate from this device.';

  @override
  String get historyClearButton => 'Clear';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get historyLoadFailure =>
      'The calculation history could not be loaded.';

  @override
  String get appearanceTitle => 'Appearance';

  @override
  String get themeLabel => 'Theme';

  @override
  String get themeSystem => 'Follow system';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get languageTitle => 'Language';

  @override
  String get languageSystem => 'System default';

  @override
  String get languageEnglish => 'English';

  @override
  String get languagePortuguese => 'Português (Brasil)';

  @override
  String get precisionTitle => 'Result precision';

  @override
  String get precisionSimple => 'Simple';

  @override
  String get precisionDetailed => 'Detailed';

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get feedbackDescription =>
      'Open your email app with a message addressed to the developer. Nothing is sent automatically.';

  @override
  String get feedbackButton => 'Write feedback';

  @override
  String get feedbackSubject => 'uAsleep feedback';

  @override
  String get feedbackBody =>
      'Hello,\n\nI would like to share the following feedback about uAsleep:\n\n';

  @override
  String get feedbackUnavailable => 'No compatible email app could be opened.';

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutDescription =>
      'Open-source battery-life estimation for embedded and IoT projects.';

  @override
  String appVersion(String version) {
    return 'Version $version';
  }

  @override
  String get softwareLicenses => 'Open-source licenses';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get privacyPolicyUnavailable =>
      'The privacy policy could not be opened.';

  @override
  String get settingsLoadFailure =>
      'Settings could not be loaded. Safe defaults are in use.';

  @override
  String get settingsSaveFailure => 'The setting could not be saved.';

  @override
  String get routeNotFoundTitle => 'Page not found';

  @override
  String get routeNotFoundDescription => 'The requested page does not exist.';

  @override
  String get backToCalculator => 'Back to calculator';

  @override
  String get loadingLabel => 'Loading';
}
