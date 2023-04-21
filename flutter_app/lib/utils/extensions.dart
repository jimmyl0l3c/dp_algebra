import 'package:algebra_lib/algebra_lib.dart';
import 'package:big_fraction/big_fraction.dart';

import '../models/calc/calc_operation.dart';

extension ParsingToTex on BigFraction {
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

  String capitalize() =>
      "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
}

extension HintsExtension on Expression {
  List<CalcOperation> getHints() {
    final String tex = toTeX();
    return CalcOperation.values
        .where(
          (e) => tex.contains(RegExp(e.name + r'((\\begin\{pmatrix\})|\()')),
        )
        .toList();
  }
}
