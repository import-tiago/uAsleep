import 'package:flutter_test/flutter_test.dart';
import 'package:uasleep/core/services/feedback_launcher.dart';

void main() {
  test('encodes mailto spaces as percent escapes instead of plus signs', () {
    const String body =
        'Olá,\n\n'
        'Gostaria de compartilhar o seguinte feedback sobre o uAsleep:\n\n';

    final Uri uri = buildMailtoUri(
      recipient: 'developer@example.com',
      subject: 'Feedback sobre o uAsleep',
      body: body,
    );

    expect(uri.toString(), isNot(contains('+')));
    expect(uri.toString(), contains('Gostaria%20de%20compartilhar'));
    expect(uri.queryParameters['subject'], 'Feedback sobre o uAsleep');
    expect(uri.queryParameters['body'], body);
  });
}
