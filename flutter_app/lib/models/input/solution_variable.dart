import 'package:algebra_lib/algebra_lib.dart';
import 'package:fraction/fraction.dart';
import 'package:precise_fractions/precise_fractions.dart';

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

  Expression toExpression(int i) {
    final Map<int, Fraction> solution = {};
    Fraction numSolution = 0.toFraction();

    for (var variable in variables) {
      if (variable.variable == null) {
        numSolution += (variable.value ?? 0.toFraction());
      } else {
        solution.update(
          variable.variable!,
          (value) => value += (variable.value ?? 0.toFraction()),
          ifAbsent: () => variable.value ?? 0.toFraction(),
        );

        if (solution[variable.variable!] == 0.toFraction()) {
          solution.remove(variable.variable!);
        }
      }
    }

    List<Expression> paramScalar = [];
    if (solution.isEmpty) {
      return Scalar(value: numSolution.toPreciseFrac());
    }

    if (numSolution != 0.toFraction()) {
      paramScalar.add(Scalar(value: numSolution.toPreciseFrac()));
    }
    solution.forEach((key, value) {
      if (value != 0.toFraction()) {
        paramScalar.add(Variable(
          n: Scalar(value: value.toPreciseFrac()),
          param: key,
        ));
      }
    });

    return ParametrizedScalar(values: paramScalar);
  }
}
