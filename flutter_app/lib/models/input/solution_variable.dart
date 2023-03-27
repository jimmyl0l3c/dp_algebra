import 'package:algebra_lib/algebra_lib.dart';
import 'package:big_fraction/big_fraction.dart';

class VariableValue {
  final BigFraction? value;
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

  Expression toExpression(int i) {
    final Map<int, BigFraction> solution = {};
    BigFraction numSolution = 0.toBigFraction();

    for (var variable in variables) {
      if (variable.variable == null) {
        numSolution += (variable.value ?? 0.toBigFraction());
      } else {
        solution.update(
          variable.variable!,
          (value) => value += (variable.value ?? 0.toBigFraction()),
          ifAbsent: () => variable.value ?? 0.toBigFraction(),
        );

        if (solution[variable.variable!] == 0.toBigFraction()) {
          solution.remove(variable.variable!);
        }
      }
    }

    List<Expression> paramScalar = [];
    if (solution.isEmpty) {
      return Scalar(value: numSolution);
    }

    if (numSolution != 0.toBigFraction()) {
      paramScalar.add(Scalar(value: numSolution));
    }
    solution.forEach((key, value) {
      if (value != 0.toBigFraction()) {
        paramScalar.add(Variable(
          n: Scalar(value: value),
          param: key,
        ));
      }
    });

    return ParametrizedScalar(values: paramScalar);
  }
}
