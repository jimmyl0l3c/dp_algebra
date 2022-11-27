import 'package:dp_algebra/matrices/matrix.dart';
import 'package:dp_algebra/widgets/button_row.dart';
import 'package:dp_algebra/widgets/fraction_input.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';

class MatrixInput extends StatefulWidget {
  final Matrix matrix;
  final String? name;
  final VoidCallback? deleteMatrix;

  const MatrixInput({
    Key? key,
    required this.matrix,
    this.name,
    this.deleteMatrix,
  }) : super(key: key);

  @override
  State<MatrixInput> createState() => _MatrixInputState();
}

class _MatrixInputState extends State<MatrixInput> {
  // TODO: add option to remove rows and columns
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          children: [
            if (widget.name != null || widget.deleteMatrix != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.name != null) Text(widget.name!),
                  if (widget.deleteMatrix != null)
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
                mainAxisSpacing: 0.0,
                clipBehavior: Clip.antiAlias,
                crossAxisSpacing: 4.0,
                children: [
                  for (var i = 0; i < widget.matrix.getRows(); i++)
                    for (var j = 0; j < widget.matrix.getColumns(); j++)
                      FractionInput(
                        onChanged: (Fraction? value) {
                          if (value == null) return;
                          widget.matrix.setValue(i, j, value);
                        },
                        value: widget.matrix[i][j].toDouble() != 0.0
                            ? widget.matrix[i][j].toString()
                            : null,
                      ),
                ],
              ),
            ),
            ButtonRow(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              children: [
                ButtonRowItem(
                  child: const Text('+ Řádek'),
                  onPressed: () {
                    setState(() {
                      widget.matrix.addRow();
                    });
                  },
                ),
                ButtonRowItem(
                  child: const Text('+ Sloupec'),
                  onPressed: () {
                    setState(() {
                      widget.matrix.addColumn();
                    });
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
