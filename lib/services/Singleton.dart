class Singleton {
  static Singleton _instance;

  factory Singleton({
    String batteryCapacityUnit = "mAh",
    String sleepCurrentUnit = "µA",
    String awakeCurrentUnit = "mA",
    String awakeTime = "s",
    String wakeupsPerHour = "5",
    String feedbackName = "",
    String feedbackEmail = "",
    String feedbackMessage = "",
    int currentLanguage = 0,
    var    language = "",
    int resultPrecision = 0,
    bool needRestart = false,
 
  }) {
    _instance ??= Singleton._internalConstructor(
        batteryCapacityUnit,
        sleepCurrentUnit,
        awakeCurrentUnit,
        awakeTime,
        wakeupsPerHour,
        feedbackName,
        feedbackEmail,
        feedbackMessage,
        language,
        resultPrecision,
        currentLanguage,
        needRestart,
        );
    return _instance;
  }

  Singleton._internalConstructor(
      this.batteryCapacityUnit,
      this.sleepCurrentUnit,
      this.awakeCurrentUnit,
      this.awakeTime,
      this.wakeupsPerHour,
        this.feedbackName,
        this.feedbackEmail,
        this.feedbackMessage,
        this.language,
        this.resultPrecision,
        this.currentLanguage,
        this.needRestart,
      );

  String batteryCapacityUnit = "mAh";
  String sleepCurrentUnit = "uA";
  String awakeCurrentUnit = "mA";
  String awakeTime = "s";
  String wakeupsPerHour = "5";
  String feedbackName = "";
  String feedbackEmail = "";
  String feedbackMessage = "";
  int currentLanguage = 0;
  int resultPrecision = 0;
  var language;
  bool needRestart;
}
