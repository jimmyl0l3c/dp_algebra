import 'package:algebra_lib/algebra_lib.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

import '../../main.dart';
import '../../models/calc/calc_category.dart';
import '../../models/calc/calc_expression_exception.dart';
import '../../models/calc/calc_result.dart';
import '../../models/calc_state/calc_matrix_model.dart';
import '../../models/calc_state/calc_solutions_model.dart';
import '../../models/input/matrix_model.dart';
import '../../models/input/matrix_operations.dart';
import '../../utils/utils.dart';
import '../../widgets/forms/button_row.dart';
import '../../widgets/forms/styled_dropdown.dart';
import '../../widgets/input/fraction_input.dart';
import '../../widgets/input/matrix_input.dart';
import '../../widgets/layout/solution_view.dart';

class CalcMatrices extends StatelessWidget with GetItMixin {
  CalcMatrices({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool canAddMatrix = watchX((CalcMatrixModel x) => x.canAddMatrix);
    List<CalcResult> solutions =
        watchX((CalcSolutionsModel x) => x.matrixSolutions);

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
                  style: Theme.of(context).textTheme.headlineMedium!,
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
              style: Theme.of(context).textTheme.headlineMedium!,
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
              style: Theme.of(context).textTheme.headlineMedium!,
            ),
            const SizedBox(height: 12),
            ListView.separated(
              itemBuilder: (context, index) => SolutionView(
                key: ValueKey(solutions[index]),
                solution: solutions[index],
                onSelected: (option) {
                  if (option == SolutionOptions.remove) {
                    getIt<CalcSolutionsModel>().removeSolution(
                      CalcCategory.matrixOperation,
                      index,
                    );
                  }
                },
              ),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: solutions.length,
              reverse: true,
              shrinkWrap: true,
            ),
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
  Fraction _scalarC = Fraction(1);

  @override
  Widget build(BuildContext context) {
    Map<String, MatrixModel> matrices =
        watchX((CalcMatrixModel x) => x.matrices);

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
                    Expression exp = Multiply(
                      left: Scalar(value: _scalarC),
                      right: matrix.value.toMatrix(),
                    );

                    getIt<CalcSolutionsModel>().addSolution(
                      CalcResult.calculate(exp),
                      CalcCategory.matrixOperation,
                    );
                  },
                ),
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
    Map<String, MatrixModel> matrices =
        watchX((CalcMatrixModel x) => x.matrices);

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
    Map<String, MatrixModel> matrices =
        watchX((CalcMatrixModel x) => x.matrices);

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
                      Expression expM = matrix.value.toMatrix();
                      Expression? exp;
                      try {
                        switch (operation) {
                          case MatrixOperation.det:
                            exp = Determinant(det: expM);
                            break;
                          case MatrixOperation.inverse:
                            exp = Inverse(exp: expM);
                            break;
                          case MatrixOperation.transpose:
                            exp = Transpose(matrix: expM);
                            break;
                          case MatrixOperation.rank:
                            exp = Rank(matrix: expM);
                            break;
                          default:
                            return;
                        }

                        getIt<CalcSolutionsModel>().addSolution(
                          CalcResult.calculate(exp),
                          CalcCategory.matrixOperation,
                        );
                      } on CalcExpressionException catch (e) {
                        showSnackBarMessage(context, e.friendlyMessage);
                      }
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
    Map<String, MatrixModel> matrices =
        watchX((CalcMatrixModel x) => x.matrices);

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
                      showSnackBarMessage(context,
                          'Zvolte matice, se kterými se má operace provést');
                      return;
                    }

                    MatrixModel? a = matrices[_binaryLeft];
                    MatrixModel? b = matrices[_binaryRight];

                    if (a == null || b == null) {
                      showSnackBarMessage(context, 'Zvolené matice neexistují');
                      return;
                    }

                    Expression expLeftM = a.toMatrix();
                    Expression expRightM = b.toMatrix();
                    Expression? exp;

                    try {
                      switch (_binaryOperation) {
                        case '+':
                          exp = Addition(left: expLeftM, right: expRightM);
                          break;
                        case '-':
                          exp = Subtraction(
                            left: expLeftM,
                            right: expRightM,
                          );
                          break;
                        case '*':
                          exp = Multiply(left: expLeftM, right: expRightM);
                          break;
                        default:
                          return;
                      }

                      getIt<CalcSolutionsModel>().addSolution(
                        CalcResult.calculate(exp),
                        CalcCategory.matrixOperation,
                      );
                    } on CalcExpressionException catch (e) {
                      showSnackBarMessage(context, e.friendlyMessage);
                    }
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
