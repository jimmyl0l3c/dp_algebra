import 'package:algebra_lib/src/interfaces/tex_parseable.dart';

class Expression implements TexParseable {
  Expression simplify() {
    throw UnimplementedError();
  }

  @override
  String toTeX() {
    throw UnimplementedError();
  }
}
