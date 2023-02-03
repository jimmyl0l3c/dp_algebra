import 'package:fraction/fraction.dart';

class VariableValue {
  final Fraction? value;
  final int? variable;

  VariableValue({this.value, this.variable});
}

class SolutionVariable {
  final List<VariableValue> variables;

  SolutionVariable({required this.variables});

  @override
  String toString() {
    StringBuffer buffer = StringBuffer();

    for (var i = 0; i < variables.length; i++) {
      var x = variables[i];

      if (i > 0 && x.value != null && !x.value!.isNegative) buffer.write('+');

      buffer.write(x.value?.toString() ?? '');

      if (x.variable != null) {
        buffer.write('x${x.variable}');
      }
    }

    return buffer.toString();
  }
}
