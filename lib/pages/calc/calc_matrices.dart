import 'package:dp_algebra/data/calc_data_controller.dart';
import 'package:dp_algebra/matrices/matrix.dart';
import 'package:dp_algebra/matrices/matrix_exceptions.dart';
import 'package:dp_algebra/matrices/matrix_operations.dart';
import 'package:dp_algebra/matrices/matrix_solution.dart';
import 'package:dp_algebra/pages/exercise/utils.dart';
import 'package:dp_algebra/widgets/button_row.dart';
import 'package:dp_algebra/widgets/fraction_input.dart';
import 'package:dp_algebra/widgets/matrix_input.dart';
import 'package:dp_algebra/widgets/matrix_solution_view.dart';
import 'package:dp_algebra/widgets/styled_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';

class CalcMatrices extends StatefulWidget {
  const CalcMatrices({Key? key}) : super(key: key);

  @override
  State<CalcMatrices> createState() => _CalcMatricesState();
}

class _CalcMatricesState extends State<CalcMatrices> {
  late Map<String, Matrix> _matrices;
  final List<String> _namePool = ['B', 'C', 'D', 'E', 'F', 'G'];

  Fraction? _scalarC = Fraction(1);

  _CalcMatricesState() {
    _matrices = {'A': Matrix(columns: 2, rows: 2)};
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: _namePool.isNotEmpty
                      ? () {
                          if (_namePool.isEmpty) return;
                          setState(() {
                            _matrices[_namePool.removeAt(0)] =
                                Matrix(columns: 2, rows: 2);
                          });
                        }
                      : null,
                  child: const Text('+'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              children: [
                for (var matrix in _matrices.entries)
                  MatrixInput(
                    matrix: matrix.value,
                    name: matrix.key,
                    deleteMatrix: () {
                      setState(() {
                        _namePool.insert(0, matrix.key);
                        _matrices.remove(matrix.key);
                      });
                    },
                  ),
              ],
            ),
            const Divider(),
            Text(
              'Operace',
              style: Theme.of(context).textTheme.headline4!,
            ),
            const SizedBox(height: 12),
            MatrixBinOperationSelection(matrices: _matrices),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 200,
                    child: Text(
                      'Násobení matice skalárem:',
                      textAlign: TextAlign.end,
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  SizedBox(
                    width: 80,
                    child: FractionInput(
                      onChanged: (Fraction? value) {
                        if (value == null) return;
                        _scalarC = value;
                      },
                      value: _scalarC.toString(),
                    ),
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
                      for (var matrix in _matrices.entries) Text(matrix.key),
                    ],
                    onPressed: (int index) {
                      Matrix? m = _matrices[_matrices.keys.elementAt(index)];
                      if (m == null) return;
                      Matrix? solution = m * _scalarC;
                      CalcDataController.addMatrixSolution(MatrixSolution(
                        leftOp: _scalarC,
                        rightOp: Matrix.from(m),
                        operation: MatrixOperation.multiply,
                        solution: solution,
                      ));
                    },
                  ),
                ],
              ),
            ),
            MatrixOperationSelection(
              operation: MatrixOperation.det,
              matrices: _matrices,
            ),
            MatrixOperationSelection(
              operation: MatrixOperation.transpose,
              matrices: _matrices,
            ),
            MatrixOperationSelection(
              operation: MatrixOperation.inverse,
              matrices: _matrices,
            ),
            const Divider(),
            Text(
              'Výsledky',
              style: Theme.of(context).textTheme.headline4!,
            ),
            const SizedBox(height: 12),
            StreamBuilder(
              stream: CalcDataController.matrixSolutionStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }

                List<Widget> results = [];
                for (var solution in snapshot.data!.reversed) {
                  results.add(
                      SolutionView(solution: solution, matrices: _matrices));
                }
                return Column(
                  children: results,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class MatrixOperationSelection extends StatelessWidget {
  final MatrixOperation operation;
  final Map<String, Matrix> matrices;

  const MatrixOperationSelection({
    Key? key,
    required this.operation,
    required this.matrices,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          SizedBox(
            width: 200,
            child: Text(
              '${operation.description}:',
              textAlign: TextAlign.end,
            ),
          ),
          const SizedBox(
            width: 8.0,
          ),
          if (!operation.binary)
            ButtonRow(
              children: [for (var matrix in matrices.entries) Text(matrix.key)],
              onPressed: (int index) {
                Matrix? m = matrices[matrices.keys.elementAt(index)];
                if (m == null) return;
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

                CalcDataController.addMatrixSolution(MatrixSolution(
                  leftOp: Matrix.from(m),
                  operation: operation,
                  solution: solution,
                ));
              },
            ),
        ],
      ),
    );
  }
}

class MatrixBinOperationSelection extends StatefulWidget {
  final Map<String, Matrix> matrices;

  const MatrixBinOperationSelection({
    Key? key,
    required this.matrices,
  }) : super(key: key);

  @override
  State<MatrixBinOperationSelection> createState() =>
      _MatrixBinOperationSelectionState();
}

class _MatrixBinOperationSelectionState
    extends State<MatrixBinOperationSelection> {
  String? _binaryLeft, _binaryRight;
  String? _binaryOperation = '+';

  @override
  Widget build(BuildContext context) {
    if (!widget.matrices.containsKey(_binaryLeft)) _binaryLeft = null;
    if (!widget.matrices.containsKey(_binaryRight)) _binaryRight = null;

    _binaryLeft ??=
        widget.matrices.isNotEmpty ? widget.matrices.keys.first : null;
    _binaryRight ??= _binaryLeft;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const SizedBox(
            width: 200,
            child: Text(
              'Binární operace:',
              textAlign: TextAlign.end,
            ),
          ),
          const SizedBox(
            width: 8.0,
          ),
          StyledDropdownButton<String>(
            value: _binaryLeft,
            items: [
              for (var matrix in widget.matrices.entries)
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
              for (var matrix in widget.matrices.entries)
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
                    Matrix? a = widget.matrices[_binaryLeft];
                    Matrix? b = widget.matrices[_binaryRight];
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
                    CalcDataController.addMatrixSolution(MatrixSolution(
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
