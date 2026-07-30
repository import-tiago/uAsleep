import 'package:share_plus/share_plus.dart';

abstract interface class ResultExporter {
  Future<bool> export({required String subject, required String body});
}

class ShareResultExporter implements ResultExporter {
  const ShareResultExporter();

  @override
  Future<bool> export({required String subject, required String body}) async {
    try {
      final ShareResult result = await SharePlus.instance.share(
        ShareParams(subject: subject, title: subject, text: body),
      );
      return result.status != ShareResultStatus.unavailable;
    } on Exception {
      return false;
    }
  }
}
