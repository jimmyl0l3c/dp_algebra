import 'package:algebra_lib/algebra_lib.dart';

class Expression implements TexParseable {
  Expression simplify() {
    throw UnimplementedError();
  }

  @override
  String toTeX({Set<TexFlags>? flags}) {
    throw UnimplementedError();
  }
}
