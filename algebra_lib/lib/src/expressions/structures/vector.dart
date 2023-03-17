import 'package:algebra_lib/algebra_lib.dart';

class Vector implements Expression {
  final List<Expression> items;

  Vector({required this.items});

  Vector.from(Vector other) : items = List.from(other.items);

  int length() => items.length;

  Expression operator [](int i) => items[i];

  void operator []=(int i, Expression e) => items[i] = e;

  @override
  Expression simplify() {
    for (var i = 0; i < items.length; i++) {
      if (items[i] is! Scalar &&
          items[i] is! ParametrizedScalar &&
          items[i] is! Variable) {
        return Vector(
          items: List.from(items)
            ..removeAt(i)
            ..insert(i, items[i].simplify()),
        );
      }
    }
    return this;
  }

  @override
  String toTeX({Set<TexFlags>? flags}) {
    StringBuffer buffer = StringBuffer(r'\begin{pmatrix} ');

    for (var i = 0; i < items.length; i++) {
      buffer.write(items[i].toTeX());

      if (i != (items.length - 1)) buffer.write(' & ');
    }

    buffer.write(r' \end{pmatrix}');
    return buffer.toString();
  }

  @override
  String toString() {
    StringBuffer buffer = StringBuffer('(');

    for (var i = 0; i < items.length; i++) {
      buffer.write(items[i]);

      if (i != (items.length - 1)) buffer.write(', ');
    }

    buffer.write(')');
    return buffer.toString();
  }

  @override
  bool operator ==(Object other) {
    if (other is! Vector) return false;

    for (var i = 0; i < length(); i++) {
      if (this[i] != other[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(items);
}
