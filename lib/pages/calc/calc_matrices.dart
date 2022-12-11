import 'package:dp_algebra/main.dart';
import 'package:dp_algebra/matrices/matrix.dart';
import 'package:dp_algebra/matrices/matrix_exceptions.dart';
import 'package:dp_algebra/matrices/matrix_operations.dart';
import 'package:dp_algebra/matrices/matrix_solution.dart';
import 'package:dp_algebra/models/calc_state/calc_matrix_model.dart';
import 'package:dp_algebra/models/calc_state/calc_matrix_solutions_model.dart';
import 'package:dp_algebra/pages/exercise/utils.dart';
import 'package:dp_algebra/widgets/button_row.dart';
import 'package:dp_algebra/widgets/fraction_input.dart';
import 'package:dp_algebra/widgets/matrix_input.dart';
import 'package:dp_algebra/widgets/solution_view.dart';
import 'package:dp_algebra/widgets/styled_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class CalcMatrices extends StatelessWidget with GetItMixin {
  CalcMatrices({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool canAddMatrix = watchX((CalcMatrixModel x) => x.canAddMatrix);
    List<MatrixSolution> solutions =
        watchX((CalcMatrixSolutionsModel x) => x.solutions);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Matice',
                  style: Theme.of(context).textTheme.headline4!,
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed:
                      canAddMatrix ? getIt<CalcMatrixModel>().addMatrix : null,
                  child: const Text('+'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            MatrixInputWrap(),
            const Divider(),
            Text(
              'Operace',
              style: Theme.of(context).textTheme.headline4!,
            ),
            const SizedBox(height: 12),
            MatrixBinOperationSelection(),
            MatrixMultiplyByScalar(),
            MatrixOperationSelection(
              operation: MatrixOperation.det,
            ),
            MatrixOperationSelection(
              operation: MatrixOperation.rank,
            ),
            MatrixOperationSelection(
              operation: MatrixOperation.transpose,
            ),
            MatrixOperationSelection(
              operation: MatrixOperation.inverse,
            ),
            const Divider(),
            Text(
              'Výsledky',
              style: Theme.of(context).textTheme.headline4!,
            ),
            const SizedBox(height: 12),
            for (var solution in solutions.reversed)
              SolutionView(solution: solution),
          ],
        ),
      ),
    );
  }
}

class MatrixMultiplyByScalar extends StatefulWidget
    with GetItStatefulWidgetMixin {
  MatrixMultiplyByScalar({Key? key}) : super(key: key);

  @override
  State<MatrixMultiplyByScalar> createState() => _MatrixMultiplyByScalarState();
}

class _MatrixMultiplyByScalarState extends State<MatrixMultiplyByScalar>
    with GetItStateMixin {
  Fraction? _scalarC = Fraction(1);

  @override
  Widget build(BuildContext context) {
    Map<String, Matrix> matrices = watchX((CalcMatrixModel x) => x.matrices);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        runAlignment: WrapAlignment.center,
        runSpacing: 4.0,
        children: [
          const Text(
            'Násobení matice skalárem:',
            textAlign: TextAlign.end,
          ),
          // const SizedBox(
          //   width: 200,
          //   child:
          // ),
          const SizedBox(
            width: 8.0,
          ),
          FractionInput(
            maxWidth: 80,
            onChanged: (Fraction? value) {
              if (value == null) return;
              _scalarC = value;
            },
            value: _scalarC.toString(),
          ),
          const SizedBox(
            width: 8.0,
          ),
          const Icon(
            Icons.circle,
            size: 12.0,
          ),
          const SizedBox(
            width: 8.0,
          ),
          ButtonRow(
            children: [
              for (var matrix in matrices.entries)
                ButtonRowItem(
                    child: Text(matrix.key),
                    onPressed: () {
                      Matrix? m = matrix.value;
                      Matrix? solution = m * _scalarC;
                      getIt<CalcMatrixSolutionsModel>()
                          .addSolution(MatrixSolution(
                        leftOp: _scalarC,
                        rightOp: Matrix.from(m),
                        operation: MatrixOperation.multiply,
                        solution: solution,
                      ));
                    }),
            ],
          ),
        ],
      ),
    );
  }
}

class MatrixInputWrap extends StatelessWidget with GetItMixin {
  MatrixInputWrap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, Matrix> matrices = watchX((CalcMatrixModel x) => x.matrices);

    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      children: [
        for (var matrix in matrices.entries)
          MatrixInput(
            matrix: matrix.value,
            name: matrix.key,
            deleteMatrix: () {
              getIt<CalcMatrixModel>().removeMatrix(matrix.key);
            },
          ),
      ],
    );
  }
}

class MatrixOperationSelection extends StatelessWidget with GetItMixin {
  final MatrixOperation operation;

  MatrixOperationSelection({
    Key? key,
    required this.operation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, Matrix> matrices = watchX((CalcMatrixModel x) => x.matrices);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        runAlignment: WrapAlignment.center,
        runSpacing: 4.0,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              String content = '${operation.description}:';
              if (constraints.maxWidth < 300) {
                return Text(content);
              } else {
                return SizedBox(
                  width: 200,
                  child: Text(
                    content,
                    textAlign: TextAlign.end,
                  ),
                );
              }
            },
          ),
          const SizedBox(
            width: 8.0,
          ),
          if (!operation.binary)
            ButtonRow(
              children: [
                for (var matrix in matrices.entries)
                  ButtonRowItem(
                    child: Text(matrix.key),
                    onPressed: () {
                      Matrix? m = matrix.value;
                      dynamic solution;
                      try {
                        switch (operation) {
                          case MatrixOperation.add:
                          case MatrixOperation.diff:
                          case MatrixOperation.multiply:
                            return;
                          case MatrixOperation.det:
                            solution = m.determinant();
                            break;
                          case MatrixOperation.inverse:
                            solution = m.inverse();
                            break;
                          case MatrixOperation.transpose:
                            solution = m.transposed();
                            break;
                          case MatrixOperation.rank:
                            solution = m.rank();
                            break;
                        }
                      } on MatrixException catch (e) {
                        ExerciseUtils.showError(context, e.errMessage());
                        return;
                      }

                      getIt<CalcMatrixSolutionsModel>()
                          .addSolution(MatrixSolution(
                        leftOp: Matrix.from(m),
                        operation: operation,
                        solution: solution,
                      ));
                    },
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class MatrixBinOperationSelection extends StatefulWidget
    with GetItStatefulWidgetMixin {
  MatrixBinOperationSelection({
    Key? key,
  }) : super(key: key);

  @override
  State<MatrixBinOperationSelection> createState() =>
      _MatrixBinOperationSelectionState();
}

class _MatrixBinOperationSelectionState
    extends State<MatrixBinOperationSelection> with GetItStateMixin {
  String? _binaryLeft, _binaryRight;
  String? _binaryOperation = '+';

  @override
  Widget build(BuildContext context) {
    Map<String, Matrix> matrices = watchX((CalcMatrixModel x) => x.matrices);

    if (!matrices.containsKey(_binaryLeft)) _binaryLeft = null;
    if (!matrices.containsKey(_binaryRight)) _binaryRight = null;

    _binaryLeft ??= matrices.isNotEmpty ? matrices.keys.first : null;
    _binaryRight ??= _binaryLeft;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Wrap(
        direction: Axis.horizontal,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        children: [
          const Text(
            'Binární operace:',
            textAlign: TextAlign.end,
          ),
          // const SizedBox(
          //   width: 200,
          //   child:
          // ),
          const SizedBox(
            width: 8.0,
          ),
          StyledDropdownButton<String>(
            value: _binaryLeft,
            items: [
              for (var matrix in matrices.entries)
                DropdownMenuItem(
                  value: matrix.key,
                  child: Center(child: Text(matrix.key)),
                ),
            ],
            onChanged: (String? val) {
              setState(() {
                _binaryLeft = val;
              });
            },
            maxWidth: 60,
            isExpanded: true,
          ),
          const SizedBox(
            width: 8.0,
          ),
          StyledDropdownButton<String>(
            value: _binaryOperation,
            items: <String>['+', '-', '*']
                .map<DropdownMenuItem<String>>((String operation) {
              return DropdownMenuItem(
                value: operation,
                child: Center(
                  child: Text(operation),
                ),
              );
            }).toList(),
            onChanged: (String? val) {
              setState(() {
                _binaryOperation = val;
              });
            },
            maxWidth: 60,
            isExpanded: true,
          ),
          const SizedBox(
            width: 8.0,
          ),
          StyledDropdownButton<String>(
            value: _binaryRight,
            items: [
              for (var matrix in matrices.entries)
                DropdownMenuItem(
                  value: matrix.key,
                  child: Center(child: Text(matrix.key)),
                ),
            ],
            onChanged: (String? val) {
              setState(() {
                _binaryRight = val;
              });
            },
            maxWidth: 60,
            isExpanded: true,
          ),
          const SizedBox(
            width: 8.0,
          ),
          ElevatedButton(
            onPressed: (_binaryLeft == null || _binaryRight == null)
                ? null
                : () {
                    if (_binaryLeft == null || _binaryRight == null) {
                      ExerciseUtils.showError(context,
                          'Zvolte matice, se kterými se má operace provést');
                      return;
                    }
                    Matrix? a = matrices[_binaryLeft];
                    Matrix? b = matrices[_binaryRight];
                    if (a == null || b == null) {
                      ExerciseUtils.showError(
                          context, 'Zvolené matice neexistují');
                      return;
                    }
                    Matrix? solution;
                    MatrixOperation? operation;
                    try {
                      switch (_binaryOperation) {
                        case '+':
                          operation = MatrixOperation.add;
                          solution = a + b;
                          break;
                        case '-':
                          operation = MatrixOperation.diff;
                          solution = a - b;
                          break;
                        case '*':
                          operation = MatrixOperation.multiply;
                          solution = a * b;
                          break;
                        default:
                          return;
                      }
                    } on MatrixException catch (e) {
                      ExerciseUtils.showError(context, e.errMessage());
                      return;
                    }
                    Matrix leftOp = Matrix.from(a);
                    getIt<CalcMatrixSolutionsModel>()
                        .addSolution(MatrixSolution(
                      leftOp: leftOp,
                      rightOp: a == b ? leftOp : Matrix.from(b),
                      operation: operation,
                      solution: solution,
                    ));
                  },
            child: const Text('='),
          ),
          TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(const CircleBorder()),
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.white12;
                }
                if (states.contains(MaterialState.pressed)) {
                  return Colors.deepPurpleAccent[100];
                }
                if (states.contains(MaterialState.hovered) ||
                    states.contains(MaterialState.focused)) {
                  return Colors.deepPurpleAccent;
                }
                return Theme.of(context).colorScheme.primary;
              }),
            ),
            onPressed: (_binaryLeft == null && _binaryRight == null)
                ? null
                : () {
                    if (_binaryLeft == _binaryRight) return;
                    setState(() {
                      String? tmp = _binaryLeft;
                      _binaryLeft = _binaryRight;
                      _binaryRight = tmp;
                    });
                  },
            child: Icon(
              Icons.autorenew_rounded,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}
