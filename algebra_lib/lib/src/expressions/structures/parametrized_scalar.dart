import 'package:algebra_lib/algebra_lib.dart';
import 'package:algebra_lib/src/expressions/structures/boolean.dart';
import 'package:algebra_lib/src/expressions/structures/variable.dart';

class ParametrizedScalar implements Expression {
  final List<Expression> values;

  ParametrizedScalar({required this.values});

  @override
  Expression simplify() {
    for (var i = 0; i < values.length; i++) {
      Expression value = values[i];

      if (value is Matrix || value is Vector || value is Boolean) {
        throw UndefinedOperationException();
      }

      if (value is! Scalar && value is! Variable) {
        return ParametrizedScalar(
          values: List.from(values)
            ..removeAt(i)
            ..insert(i, value.simplify()),
        );
      }
    }

    return this;
  }

  @override
  String toTeX() => values.map((e) => e.toTeX()).join(" ");
}
