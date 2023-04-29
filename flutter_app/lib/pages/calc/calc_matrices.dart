import 'package:algebra_lib/algebra_lib.dart';
import 'package:big_fraction/big_fraction.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

import '../../data/predefined_refs.dart';
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
import '../../widgets/learn/block_ref_button.dart';

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
            for (var unaryOp in UnaryMatrixOperation.values)
              MatrixOperationSelection(operation: unaryOp),
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
              physics: const NeverScrollableScrollPhysics(),
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
  BigFraction _scalarC = BigFraction.one();

  @override
  Widget build(BuildContext context) {
    Map<String, MatrixModel> matrices =
        watchX((CalcMatrixModel x) => x.matrices);

    const String multiplyMatrixByScalar = 'Násobení matice skalárem:';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        runAlignment: WrapAlignment.center,
        runSpacing: 4.0,
        children: [
          BlockRefButton(
            refName: PredefinedRef.multiplyMatrixByScalar.refName,
            placeholder: multiplyMatrixByScalar,
            text: multiplyMatrixByScalar,
            tooltip: 'Zjistit více',
          ),
          const SizedBox(
            width: 8.0,
          ),
          FractionInput(
            maxWidth: 80,
            onChanged: (BigFraction? value) {
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
                      left: Scalar(_scalarC),
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
    bool canAddMatrix = watchX((CalcMatrixModel x) => x.canAddMatrix);

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
            duplicateMatrix: canAddMatrix
                ? () {
                    getIt<CalcMatrixModel>().addMatrix(
                      matrix: MatrixModel.from(matrix.value),
                    );
                  }
                : null,
            randomGenerationAllowed: true,
          ),
      ],
    );
  }
}

class MatrixOperationSelection extends StatelessWidget with GetItMixin {
  final UnaryMatrixOperation operation;

  MatrixOperationSelection({
    Key? key,
    required this.operation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, MatrixModel> matrices =
        watchX((CalcMatrixModel x) => x.matrices);

    String refName = '';
    switch (operation) {
      case UnaryMatrixOperation.det:
        refName = PredefinedRef.determinant.refName;
        break;
      case UnaryMatrixOperation.inverse:
        refName = PredefinedRef.inverseMatrix.refName;
        break;
      case UnaryMatrixOperation.transpose:
        refName = PredefinedRef.transposedMatrix.refName;
        break;
      case UnaryMatrixOperation.rank:
        refName = PredefinedRef.matrixRank.refName;
        break;
      case UnaryMatrixOperation.triangular:
        refName = PredefinedRef.matrixTypes.refName;
        break;
      case UnaryMatrixOperation.reduce:
        refName = PredefinedRef.reducedMatrix.refName;
        break;
    }
    String operationDescription = '${operation.description}:';

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
              if (constraints.maxWidth < 300) {
                return BlockRefButton(
                  refName: refName,
                  placeholder: operationDescription,
                  text: operationDescription,
                  tooltip: 'Zjistit více',
                );
              } else {
                return SizedBox(
                  width: 200,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: BlockRefButton(
                      refName: refName,
                      placeholder: operationDescription,
                      text: operationDescription,
                      tooltip: 'Zjistit více',
                    ),
                  ),
                );
              }
            },
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
                    Expression expM = matrix.value.toMatrix();
                    Expression? exp;
                    try {
                      switch (operation) {
                        case UnaryMatrixOperation.det:
                          exp = Determinant(det: expM);
                          break;
                        case UnaryMatrixOperation.inverse:
                          exp = Inverse(exp: expM);
                          break;
                        case UnaryMatrixOperation.transpose:
                          exp = Transpose(matrix: expM);
                          break;
                        case UnaryMatrixOperation.rank:
                          exp = Rank(matrix: expM);
                          break;
                        case UnaryMatrixOperation.triangular:
                          exp = Triangular(matrix: expM);
                          break;
                        case UnaryMatrixOperation.reduce:
                          exp = Reduce(exp: expM);
                          break;
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
  BinaryMatrixOperation _binaryOperation = BinaryMatrixOperation.add;

  @override
  Widget build(BuildContext context) {
    Map<String, MatrixModel> matrices =
        watchX((CalcMatrixModel x) => x.matrices);

    if (!matrices.containsKey(_binaryLeft)) _binaryLeft = null;
    if (!matrices.containsKey(_binaryRight)) _binaryRight = null;

    _binaryLeft ??= matrices.isNotEmpty ? matrices.keys.first : null;
    _binaryRight ??= _binaryLeft;

    const String binaryOperation = 'Binární operace:';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Wrap(
        direction: Axis.horizontal,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        children: [
          BlockRefButton(
            refName: PredefinedRef.matrixAddition.refName,
            placeholder: binaryOperation,
            text: binaryOperation,
            tooltip: 'Zjistit více',
          ),
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
          StyledDropdownButton<BinaryMatrixOperation>(
            value: _binaryOperation,
            items: BinaryMatrixOperation.values
                .map<DropdownMenuItem<BinaryMatrixOperation>>(
                    (BinaryMatrixOperation operation) {
              return DropdownMenuItem(
                value: operation,
                child: Center(
                  child: Text(operation.symbol),
                ),
              );
            }).toList(),
            onChanged: (BinaryMatrixOperation? val) {
              setState(() {
                _binaryOperation = val ?? BinaryMatrixOperation.add;
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
                        case BinaryMatrixOperation.add:
                          exp = Addition(left: expLeftM, right: expRightM);
                          break;
                        case BinaryMatrixOperation.diff:
                          exp = Subtraction(
                            left: expLeftM,
                            right: expRightM,
                          );
                          break;
                        case BinaryMatrixOperation.multiply:
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
          Tooltip(
            message: 'Vyměnit matice',
            child: TextButton(
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
          ),
        ],
      ),
    );
  }
}
