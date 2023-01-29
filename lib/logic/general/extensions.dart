import 'package:fraction/fraction.dart';

extension ParsingToTex on Fraction {
  String toTeX() {
    if (isWhole) {
      return toString();
    } else {
      return '\\frac{$numerator}{$denominator}';
    }
  }
}

extension RegExpExtension on RegExp {
  List<String> allMatchesWithSep(String input, [int start = 0]) {
    var result = <String>[];
    for (var match in allMatches(input, start)) {
      result.add(input.substring(start, match.start));
      result.add(match[0] ?? '');
      start = match.end;
    }
    result.add(input.substring(start));
    return result;
  }
}

extension StringExtension on String {
  List<String> splitWithDelim(RegExp pattern) =>
      pattern.allMatchesWithSep(this);
}
