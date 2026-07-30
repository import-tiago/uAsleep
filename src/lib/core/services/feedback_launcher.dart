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
    final Uri uri = buildMailtoUri(
      recipient: recipient,
      subject: subject,
      body: body,
    );
    try {
      return await launchUrl(uri);
    } on Object {
      return false;
    }
  }
}

Uri buildMailtoUri({
  required String recipient,
  required String subject,
  required String body,
}) {
  final String query = <String, String>{'subject': subject, 'body': body}
      .entries
      .map((MapEntry<String, String> entry) {
        return '${Uri.encodeComponent(entry.key)}='
            '${Uri.encodeComponent(entry.value)}';
      })
      .join('&');

  return Uri(scheme: 'mailto', path: recipient, query: query);
}
