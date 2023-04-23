import '../../exceptions.dart';
import '../../interfaces/expression.dart';
import '../../tex_flags.dart';
import '../structures/scalar.dart';
import '../structures/vector.dart';
import 'boolean.dart';
import 'matrix.dart';
import 'variable.dart';

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
  String toTeX({Set<TexFlags>? flags}) {
    StringBuffer buffer = StringBuffer();
    for (var i = 0; i < values.length; i++) {
      String tex = values[i].toTeX();

      if (i > 0 && !tex.startsWith('-')) {
        buffer.write('+');
      }

      buffer.write(tex);
    }
    return buffer.toString();
  }

  @override
  bool operator ==(Object other) {
    if (other is! ParametrizedScalar) return false;
    if (other.values.length != values.length) return false;

    for (var i = 0; i < values.length; i++) {
      if (values[i] != other.values[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(values);
}
