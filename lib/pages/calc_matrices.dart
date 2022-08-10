import 'package:dp_algebra/widgets/matrix_input.dart';
import 'package:flutter/material.dart';

import '../matrices/matrix.dart';

class CalcMatrices extends StatefulWidget {
  const CalcMatrices({Key? key}) : super(key: key);

  @override
  State<CalcMatrices> createState() => _CalcMatricesState();
}

class _CalcMatricesState extends State<CalcMatrices> {
  late Map<String, Matrix> _matrices;
  List<String> _namePool = ['B', 'C', 'D', 'E', 'F', 'G'];

  _CalcMatricesState() {
    _matrices = {'A': Matrix(columns: 2, rows: 2)};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulačka - Operace s maticemi'),
      ),
      body: Wrap(
        direction: Axis.horizontal,
        children: [
          for (var matrix in _matrices.entries)
            MatrixInput(
              matrix: matrix.value,
              name: matrix.key,
            ),
          OutlinedButton(
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
          Text('${_matrices['A']![0][0]} ${_matrices['A']![0][1]};'),
          Text('${_matrices['A']![1][0]} ${_matrices['A']![1][1]}'),
        ],
      ),
    );
  }
}
