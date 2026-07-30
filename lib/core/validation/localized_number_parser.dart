/// Parses decimal input commonly entered with either `.` or `,`.
///
/// When both separators are present, the last separator is considered decimal
/// and the other one is considered grouping. Non-finite values remain parsed
/// so the domain layer can reject them explicitly.
class LocalizedNumberParser {
  const LocalizedNumberParser();

  double? parse(String input) {
    String normalized = input.trim().replaceAll(RegExp(r'[\s\u00A0]'), '');
    if (normalized.isEmpty) {
      return null;
    }

    final int comma = normalized.lastIndexOf(',');
    final int dot = normalized.lastIndexOf('.');
    if (comma >= 0 && dot >= 0) {
      if (comma > dot) {
        normalized = normalized.replaceAll('.', '').replaceAll(',', '.');
      } else {
        normalized = normalized.replaceAll(',', '');
      }
    } else if (comma >= 0) {
      normalized = normalized.replaceAll(',', '.');
    }
    return double.tryParse(normalized);
  }
}
