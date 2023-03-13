import 'package:algebra_lib/algebra_lib.dart';

class ExpressionSet implements Expression {
  final Set<Expression> items;

  ExpressionSet({required this.items});

  int length() => items.length;

  @override
  Expression simplify() {
    for (var item in items) {
      Expression simplified = item.simplify();
      if (simplified != item) {
        return ExpressionSet(
          items: Set.from(items)
            ..remove(item)
            ..add(simplified),
        );
      }
    }

    return this;
  }

  @override
  String toTeX({Set<TexFlags>? flags}) {
    StringBuffer buffer = StringBuffer(r'\{');

    List<String> itemsTeX = items.map((e) => e.toTeX()).toList();
    buffer.write(itemsTeX.join(", "));

    buffer.write(r'\}');
    return buffer.toString();
  }

  @override
  bool operator ==(Object other) {
    if (other is! ExpressionSet) return false;
    if (other.length() != length()) return false;

    for (var item in items) {
      if (!other.items.contains(item)) return false;
    }

    return true;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => items.hashCode;
}
