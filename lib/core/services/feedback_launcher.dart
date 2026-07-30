import 'package:url_launcher/url_launcher.dart';

abstract interface class FeedbackLauncher {
  Future<bool> open({required String subject, required String body});
}

class MailtoFeedbackLauncher implements FeedbackLauncher {
  const MailtoFeedbackLauncher({
    this.recipient = 'tiagodepaulasilva@gmail.com',
  });

  final String recipient;

  @override
  Future<bool> open({required String subject, required String body}) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: recipient,
      queryParameters: <String, String>{'subject': subject, 'body': body},
    );
    try {
      return await launchUrl(uri);
    } on Object {
      return false;
    }
  }
}
