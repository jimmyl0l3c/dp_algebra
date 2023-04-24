import '../../exceptions.dart';
import '../../interfaces/expression.dart';
import '../../tex_flags.dart';
import '../structures/vector.dart';
import 'boolean.dart';
import 'matrix.dart';

class Polynomial implements Expression {
  final List<Expression> values;

  Polynomial({required this.values});

  @override
  Expression simplify() {
    for (var i = 0; i < values.length; i++) {
      Expression value = values[i];

      if (value is Matrix || value is Vector || value is Boolean) {
        throw UndefinedOperationException();
      }

      var simplifiedValue = value.simplify();
      if (value != simplifiedValue) {
        return Polynomial(
          values: List.from(values)
            ..removeAt(i)
            ..insert(i, simplifiedValue),
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
    if (other is! Polynomial) return false;
    if (other.values.length != values.length) return false;

    for (var i = 0; i < values.length; i++) {
      if (values[i] != other.values[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(values);
}
