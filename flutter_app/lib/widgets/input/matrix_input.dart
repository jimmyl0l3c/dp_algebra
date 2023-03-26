import 'package:dp_algebra/models/input/matrix_model.dart';
import 'package:dp_algebra/widgets/forms/button_row.dart';
import 'package:dp_algebra/widgets/input/fraction_input.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';

class MatrixInput extends StatefulWidget {
  final MatrixModel matrix;
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.name != null) Text(widget.name!),
                MenuAnchor(
                  builder: (context, controller, child) => IconButton(
                    onPressed: () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
                    iconSize: 15.0,
                    splashRadius: 18.0,
                    icon: const Icon(Icons.edit),
                  ),
                  menuChildren: [
                    if (widget.deleteMatrix != null)
                      MenuItemButton(
                        leadingIcon: const Icon(
                          Icons.delete_forever,
                          color: Colors.redAccent,
                        ),
                        onPressed: widget.deleteMatrix,
                        child: const Text(
                          'Smazat',
                          style: TextStyle(
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    SubmenuButton(
                      menuChildren: [
                        if (widget.matrix.rows > 1)
                          for (var i = 0; i < widget.matrix.rows; i++)
                            MenuItemButton(
                              onPressed: () {
                                setState(() {
                                  widget.matrix.removeRow(i);
                                });
                              },
                              child: Text('Odebrat $i.'),
                            ),
                      ],
                      child: const Text("Řádek"),
                    ),
                    SubmenuButton(
                      menuChildren: [
                        if (widget.matrix.columns > 1)
                          for (var i = 0; i < widget.matrix.columns; i++)
                            MenuItemButton(
                              onPressed: () {
                                setState(() {
                                  widget.matrix.removeColumn(i);
                                });
                              },
                              child: Text('Odebrat $i.'),
                            ),
                      ],
                      child: const Text("Sloupec"),
                    ),
                  ],
                ),
                // if (widget.deleteMatrix != null)
                //   IconButton(
                //     onPressed: widget.deleteMatrix,
                //     icon: const Icon(Icons.close),
                //     iconSize: 12.0,
                //     splashRadius: 15.0,
                //     color: Colors.redAccent,
                //   ),
              ],
            ),
            SizedBox(
              width: 60 * widget.matrix.columns.toDouble(),
              child: GridView.count(
                crossAxisCount: widget.matrix.columns,
                shrinkWrap: true,
                mainAxisSpacing: 0.0,
                clipBehavior: Clip.antiAlias,
                crossAxisSpacing: 4.0,
                children: [
                  for (var i = 0; i < widget.matrix.rows; i++)
                    for (var j = 0; j < widget.matrix.columns; j++)
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
