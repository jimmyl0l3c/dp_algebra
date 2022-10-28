import 'package:dp_algebra/widgets/fraction_input.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';

import '../matrices/matrix.dart';

class MatrixInput extends StatefulWidget {
  final Matrix matrix;
  final String name;
  final VoidCallback deleteMatrix;

  const MatrixInput({
    Key? key,
    required this.matrix,
    required this.name,
    required this.deleteMatrix,
  }) : super(key: key);

  @override
  State<MatrixInput> createState() => _MatrixInputState();
}

class _MatrixInputState extends State<MatrixInput> {
  // TODO: add option to remove rows and columns
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.name),
              IconButton(
                onPressed: widget.deleteMatrix,
                icon: const Icon(Icons.close),
                iconSize: 12.0,
                splashRadius: 15.0,
                color: Colors.redAccent,
              ),
            ],
          ),
          SizedBox(
            width: 60 * widget.matrix.getColumns().toDouble(),
            child: GridView.count(
              crossAxisCount: widget.matrix.getColumns(),
              shrinkWrap: true,
              mainAxisSpacing: 4.0,
              clipBehavior: Clip.antiAlias,
              crossAxisSpacing: 4.0,
              children: [
                for (var i = 0; i < widget.matrix.getRows(); i++)
                  for (var j = 0; j < widget.matrix.getColumns(); j++)
                    FractionInput(
                      onChanged: (String value) {
                        if (value.isEmpty) {
                          widget.matrix.setValue(i, j, 0.toFraction());
                        } else if (value.contains('.')) {
                          double? dValue = double.tryParse(value);
                          if (dValue == null) return;
                          widget.matrix.setValue(i, j, dValue.toFraction());
                        } else {
                          if (value.startsWith('/')) value = '0$value';
                          if (!value.isFraction) return;
                          widget.matrix.setValue(i, j, value.toFraction());
                        }
                      },
                      value: widget.matrix[i][j].toDouble() != 0.0
                          ? widget.matrix[i][j].toString()
                          : null,
                    ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    widget.matrix.addRow();
                  });
                },
                child: const Text('+ Řádek'),
              ),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    widget.matrix.addColumn();
                  });
                },
                child: const Text('+ Sloupec'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
