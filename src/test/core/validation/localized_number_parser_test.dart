import 'package:flutter_test/flutter_test.dart';
import 'package:uasleep/core/validation/localized_number_parser.dart';

void main() {
  const LocalizedNumberParser parser = LocalizedNumberParser();

  test('parses dot and comma decimal separators', () {
    expect(parser.parse('12.5'), 12.5);
    expect(parser.parse('12,5'), 12.5);
  });

  test('parses grouped localized numbers', () {
    expect(parser.parse('1.234,5'), 1234.5);
    expect(parser.parse('1,234.5'), 1234.5);
    expect(parser.parse(' 1 234,5 '), 1234.5);
  });

  test('returns null for empty and non-numeric input', () {
    expect(parser.parse(''), isNull);
    expect(parser.parse('abc'), isNull);
  });

  test('preserves non-finite values for domain validation', () {
    expect(parser.parse('NaN')?.isNaN, isTrue);
    expect(parser.parse('Infinity'), double.infinity);
  });
}
