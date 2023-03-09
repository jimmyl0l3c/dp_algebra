import 'package:algebra_lib/algebra_lib.dart';

class Boolean implements Expression {
  final bool value;

  Boolean(this.value);

  @override
  Expression simplify() => this;

  @override
  String toTeX() => value ? "Pravda" : "Nepravda";
}
