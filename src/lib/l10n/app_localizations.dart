import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
    Locale('pt', 'BR'),
  ];

  /// Product name.
  ///
  /// In en, this message translates to:
  /// **'uAsleep'**
  String get appTitle;

  /// No description provided for @calculatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Battery life estimator'**
  String get calculatorTitle;

  /// No description provided for @calculatorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Model the duty cycle of an embedded or IoT device.'**
  String get calculatorSubtitle;

  /// No description provided for @settingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get settingsTooltip;

  /// No description provided for @historyTooltip.
  ///
  /// In en, this message translates to:
  /// **'Open calculation history'**
  String get historyTooltip;

  /// No description provided for @batterySectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Battery'**
  String get batterySectionTitle;

  /// No description provided for @batterySectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the rated battery capacity.'**
  String get batterySectionDescription;

  /// No description provided for @batteryCapacityLabel.
  ///
  /// In en, this message translates to:
  /// **'Battery capacity'**
  String get batteryCapacityLabel;

  /// No description provided for @activeSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Active mode'**
  String get activeSectionTitle;

  /// No description provided for @activeSectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Current drawn while the device is awake.'**
  String get activeSectionDescription;

  /// No description provided for @activeCurrentLabel.
  ///
  /// In en, this message translates to:
  /// **'Active current'**
  String get activeCurrentLabel;

  /// No description provided for @sleepModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Use sleep mode'**
  String get sleepModeTitle;

  /// No description provided for @sleepModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Include the device\'s low-power time in the estimate.'**
  String get sleepModeSubtitle;

  /// No description provided for @sleepSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Sleep mode'**
  String get sleepSectionTitle;

  /// No description provided for @sleepSectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Current drawn between active periods.'**
  String get sleepSectionDescription;

  /// No description provided for @sleepCurrentLabel.
  ///
  /// In en, this message translates to:
  /// **'Sleep current'**
  String get sleepCurrentLabel;

  /// No description provided for @cycleSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Wake cycle'**
  String get cycleSectionTitle;

  /// No description provided for @cycleSectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Describe how long and how often the device wakes.'**
  String get cycleSectionDescription;

  /// No description provided for @activeDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Active duration'**
  String get activeDurationLabel;

  /// No description provided for @wakeupsPerHourLabel.
  ///
  /// In en, this message translates to:
  /// **'Wake-ups per hour'**
  String get wakeupsPerHourLabel;

  /// No description provided for @calculateButton.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get calculateButton;

  /// No description provided for @resetButton.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetButton;

  /// No description provided for @estimateNotice.
  ///
  /// In en, this message translates to:
  /// **'This is a theoretical estimate. Real battery life also depends on temperature, aging, self-discharge, regulator efficiency, and load transients.'**
  String get estimateNotice;

  /// No description provided for @resultTitle.
  ///
  /// In en, this message translates to:
  /// **'Estimated autonomy'**
  String get resultTitle;

  /// No description provided for @resultEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to calculate'**
  String get resultEmptyTitle;

  /// No description provided for @resultEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Complete the electrical profile to see the estimate.'**
  String get resultEmptyDescription;

  /// No description provided for @exportButton.
  ///
  /// In en, this message translates to:
  /// **'Export result'**
  String get exportButton;

  /// No description provided for @exportTooltip.
  ///
  /// In en, this message translates to:
  /// **'Export result'**
  String get exportTooltip;

  /// No description provided for @exportUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The result could not be shared.'**
  String get exportUnavailable;

  /// No description provided for @exportSubject.
  ///
  /// In en, this message translates to:
  /// **'uAsleep battery estimate'**
  String get exportSubject;

  /// No description provided for @exportReportTitle.
  ///
  /// In en, this message translates to:
  /// **'uAsleep battery estimate'**
  String get exportReportTitle;

  /// No description provided for @generatedAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Generated at'**
  String get generatedAtLabel;

  /// No description provided for @sleepModeEnabledValue.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get sleepModeEnabledValue;

  /// No description provided for @sleepModeDisabledValue.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get sleepModeDisabledValue;

  /// No description provided for @averageCurrentLabel.
  ///
  /// In en, this message translates to:
  /// **'Average current'**
  String get averageCurrentLabel;

  /// No description provided for @dutyCycleLabel.
  ///
  /// In en, this message translates to:
  /// **'Active duty cycle'**
  String get dutyCycleLabel;

  /// No description provided for @averageCurrentValue.
  ///
  /// In en, this message translates to:
  /// **'{value} mA'**
  String averageCurrentValue(String value);

  /// No description provided for @percentageValue.
  ///
  /// In en, this message translates to:
  /// **'{value}%'**
  String percentageValue(String value);

  /// No description provided for @durationHours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{formatted} hour} other{{formatted} hours}}'**
  String durationHours(num count, String formatted);

  /// No description provided for @durationDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{formatted} day} other{{formatted} days}}'**
  String durationDays(num count, String formatted);

  /// No description provided for @durationMonths.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{formatted} month} other{{formatted} months}}'**
  String durationMonths(num count, String formatted);

  /// No description provided for @durationYears.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{formatted} year} other{{formatted} years}}'**
  String durationYears(num count, String formatted);

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a value.'**
  String get validationRequired;

  /// No description provided for @validationInvalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number.'**
  String get validationInvalidNumber;

  /// No description provided for @validationNonFinite.
  ///
  /// In en, this message translates to:
  /// **'The value must be finite.'**
  String get validationNonFinite;

  /// No description provided for @validationMustBePositive.
  ///
  /// In en, this message translates to:
  /// **'Enter a value greater than zero.'**
  String get validationMustBePositive;

  /// No description provided for @validationCannotBeNegative.
  ///
  /// In en, this message translates to:
  /// **'The value cannot be negative.'**
  String get validationCannotBeNegative;

  /// No description provided for @validationActiveDurationTooLong.
  ///
  /// In en, this message translates to:
  /// **'Active duration cannot exceed the complete wake cycle.'**
  String get validationActiveDurationTooLong;

  /// No description provided for @validationZeroAverageCurrent.
  ///
  /// In en, this message translates to:
  /// **'Average current must be greater than zero.'**
  String get validationZeroAverageCurrent;

  /// No description provided for @validationUnrealistic.
  ///
  /// In en, this message translates to:
  /// **'Review these values: the resulting scale is unusual for a typical embedded device.'**
  String get validationUnrealistic;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Calculation history'**
  String get historyTitle;

  /// No description provided for @historyEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No calculations yet'**
  String get historyEmptyTitle;

  /// No description provided for @historyEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Your successful estimates will appear here.'**
  String get historyEmptyDescription;

  /// No description provided for @historyReuseHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to reuse these parameters'**
  String get historyReuseHint;

  /// No description provided for @historyClearTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear history'**
  String get historyClearTooltip;

  /// No description provided for @historyClearTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear calculation history?'**
  String get historyClearTitle;

  /// No description provided for @historyClearMessage.
  ///
  /// In en, this message translates to:
  /// **'This permanently removes every saved estimate from this device.'**
  String get historyClearMessage;

  /// No description provided for @historyClearButton.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get historyClearButton;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @historyLoadFailure.
  ///
  /// In en, this message translates to:
  /// **'The calculation history could not be loaded.'**
  String get historyLoadFailure;

  /// No description provided for @appearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceTitle;

  /// No description provided for @themeLabel.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeLabel;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languagePortuguese.
  ///
  /// In en, this message translates to:
  /// **'Português (Brasil)'**
  String get languagePortuguese;

  /// No description provided for @precisionTitle.
  ///
  /// In en, this message translates to:
  /// **'Result precision'**
  String get precisionTitle;

  /// No description provided for @precisionSimple.
  ///
  /// In en, this message translates to:
  /// **'Simple'**
  String get precisionSimple;

  /// No description provided for @precisionDetailed.
  ///
  /// In en, this message translates to:
  /// **'Detailed'**
  String get precisionDetailed;

  /// No description provided for @feedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedbackTitle;

  /// No description provided for @feedbackDescription.
  ///
  /// In en, this message translates to:
  /// **'Open your email app with a message addressed to the developer. Nothing is sent automatically.'**
  String get feedbackDescription;

  /// No description provided for @feedbackButton.
  ///
  /// In en, this message translates to:
  /// **'Write feedback'**
  String get feedbackButton;

  /// No description provided for @feedbackSubject.
  ///
  /// In en, this message translates to:
  /// **'uAsleep feedback'**
  String get feedbackSubject;

  /// No description provided for @feedbackBody.
  ///
  /// In en, this message translates to:
  /// **'Hello,\n\nI would like to share the following feedback about uAsleep:\n\n'**
  String get feedbackBody;

  /// No description provided for @feedbackUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No compatible email app could be opened.'**
  String get feedbackUnavailable;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'Open-source battery-life estimation for embedded and IoT projects.'**
  String get aboutDescription;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String appVersion(String version);

  /// No description provided for @softwareLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open-source licenses'**
  String get softwareLicenses;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicyUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The privacy policy could not be opened.'**
  String get privacyPolicyUnavailable;

  /// No description provided for @settingsLoadFailure.
  ///
  /// In en, this message translates to:
  /// **'Settings could not be loaded. Safe defaults are in use.'**
  String get settingsLoadFailure;

  /// No description provided for @settingsSaveFailure.
  ///
  /// In en, this message translates to:
  /// **'The setting could not be saved.'**
  String get settingsSaveFailure;

  /// No description provided for @routeNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get routeNotFoundTitle;

  /// No description provided for @routeNotFoundDescription.
  ///
  /// In en, this message translates to:
  /// **'The requested page does not exist.'**
  String get routeNotFoundDescription;

  /// No description provided for @backToCalculator.
  ///
  /// In en, this message translates to:
  /// **'Back to calculator'**
  String get backToCalculator;

  /// No description provided for @loadingLabel.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loadingLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
