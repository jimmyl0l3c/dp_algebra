import 'package:algebra_lib/algebra_lib.dart';

class Vector implements Expression {
  final List<Expression> items;

  Vector({required this.items});

  @override
  Expression simplify() {
    for (var i = 0; i < items.length; i++) {
      if (items[i] is! Scalar) {
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
  String toTeX() {
    StringBuffer buffer = StringBuffer(r'\begin{pmatrix} ');

    for (var i = 0; i < items.length; i++) {
      buffer.write(items[i].toTeX());

      if (i != (items.length - 1)) buffer.write(' & ');
    }

    buffer.write(r' \end{pmatrix}');
    return buffer.toString();
  }
}
