import 'package:algebra_lib/algebra_lib.dart';

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
  String toTeX() {
    StringBuffer buffer = StringBuffer();
    for (var i = 0; i < values.length; i++) {
      String tex = values[i].toTeX();

      if (i > 0 && !tex.startsWith('-')) {
        buffer.write('+');
      }

      buffer.write(tex);
    }
    values.map((e) => e.toTeX()).join(" ");
    return buffer.toString();
  }
}
