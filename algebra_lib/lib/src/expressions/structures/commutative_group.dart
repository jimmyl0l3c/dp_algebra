import '../../exceptions.dart';
import '../../interfaces/expression.dart';
import '../../tex_flags.dart';
import '../general/addition.dart';
import '../general/multiply.dart';
import 'boolean.dart';
import 'expression_set.dart';
import 'matrix.dart';
import 'scalar.dart';
import 'variable.dart';
import 'vector.dart';

enum CommutativeOperation {
  addition('+'),
  multiplication(r'\cdot');

  final String texSign;

  const CommutativeOperation(this.texSign);
}

class CommutativeGroup implements Expression {
  final List<Expression> values;
  final CommutativeOperation operation;

  CommutativeGroup({required this.values, required this.operation});

  CommutativeGroup.add(this.values) : operation = CommutativeOperation.addition;

  CommutativeGroup.multiply(this.values)
      : operation = CommutativeOperation.multiplication;

  @override
  Expression simplify() {
    for (var i = 0; i < values.length; i++) {
      Expression value = values[i];

      if (value is Matrix ||
          value is Vector ||
          value is Boolean ||
          value is ExpressionSet) {
        throw UndefinedOperationException();
      }

      var simplifiedValue = value.simplify();
      if (value != simplifiedValue) {
        return CommutativeGroup(
          values: List.from(values)
            ..removeAt(i)
            ..insert(i, simplifiedValue),
          operation: operation,
        );
      }
    }

    // From here all elements are CommutativeGroup, Scalar or Variable

    List<Scalar> scalars = [];
    Set<int> simplifiedVarGroups = {};
    for (var i = 0; i < values.length; i++) {
      Expression value = values[i];

      // Save scalar to add/multiply them all
      if (value is Scalar) {
        scalars.add(value);
      }

      // Unpack if the inner operation is the same as outer
      if (value is CommutativeGroup && value.operation == operation) {
        return CommutativeGroup(
          values: List.from(values)
            ..removeAt(i)
            ..addAll(value.values),
          operation: operation,
        );
      }

      if (operation == CommutativeOperation.addition &&
          value is CommutativeGroup &&
          value.operation == CommutativeOperation.multiplication) {
        var varGroup = Object.hashAllUnordered(
          value.values.whereType<Variable>(),
        );

        if (simplifiedVarGroups.contains(varGroup)) {
          continue;
        }

        simplifiedVarGroups.add(varGroup);
        for (var j = i + 1; j < values.length; j++) {
          var innerValue = values[j];
          if (innerValue is! CommutativeGroup ||
              innerValue.operation != CommutativeOperation.multiplication) {
            continue;
          }

          if (varGroup ==
              Object.hashAllUnordered(
                innerValue.values.whereType<Variable>(),
              )) {
            return CommutativeGroup(
              values: List.from(values)
                ..remove(value)
                ..remove(innerValue)
                ..add(Addition(left: value, right: innerValue)),
              operation: operation,
            );
          }
        }
      } else if (operation == CommutativeOperation.multiplication &&
          value is CommutativeGroup &&
          value.operation == CommutativeOperation.addition) {
        if (values.length == 1) {
          return value;
        } else if (values.length == (i + 1)) {
          var previousValue = values[i - 1];
          return CommutativeGroup(
            values: List.from(values)
              ..remove(value)
              ..remove(previousValue)
              ..insert(0, Multiply(left: value, right: previousValue)),
            operation: operation,
          );
        } else {
          var nextValue = values[i + 1];
          return CommutativeGroup(
            values: List.from(values)
              ..remove(value)
              ..remove(nextValue)
              ..insert(0, Multiply(left: value, right: nextValue)),
            operation: operation,
          );
        }
      }
    }

    if (scalars.length > 1) {
      if (operation == CommutativeOperation.addition) {
        Expression currentAdd = Addition(left: scalars[0], right: scalars[1]);
        for (var scalar in scalars.skip(2)) {
          currentAdd = Addition(left: currentAdd, right: scalar);
        }
        return CommutativeGroup(
          values: List.from(values)
            ..removeWhere((e) => e is Scalar)
            ..add(currentAdd),
          operation: operation,
        );
      } else if (operation == CommutativeOperation.multiplication) {
        Expression currentMultiply =
            Multiply(left: scalars[0], right: scalars[1]);
        for (var scalar in scalars.skip(2)) {
          currentMultiply = Multiply(left: currentMultiply, right: scalar);
        }
        return CommutativeGroup(
          values: List.from(values)
            ..removeWhere((e) => e is Scalar)
            ..add(currentMultiply),
          operation: operation,
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

      if (operation == CommutativeOperation.addition) {
        if (i > 0 && !tex.startsWith('-')) {
          buffer.write(operation.texSign);
        }
      } else if (operation == CommutativeOperation.multiplication && i > 0) {
        buffer.write(operation.texSign);
      }

      bool enclose = operation == CommutativeOperation.multiplication &&
          tex.startsWith('-');

      if (enclose) {
        buffer.write('(');
      }
      buffer.write(tex);
      if (enclose) {
        buffer.write(')');
      }
    }
    return buffer.toString();
  }

  @override
  bool operator ==(Object other) {
    if (other is! CommutativeGroup) return false;
    if (other.values.length != values.length) return false;

    for (var i = 0; i < values.length; i++) {
      if (values[i] != other.values[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(values);
}
