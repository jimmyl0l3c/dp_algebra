import 'package:dp_algebra/logic/vector/vector_model.dart';
import 'package:dp_algebra/widgets/forms/button_row.dart';
import 'package:dp_algebra/widgets/input/fraction_input.dart';
import 'package:dp_algebra/widgets/input/input_utils.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';

class VectorInput extends StatefulWidget {
  final VectorModel vector;
  final String? name;
  final VoidCallback? deleteVector;

  const VectorInput({
    Key? key,
    required this.vector,
    this.name,
    this.deleteVector,
  }) : super(key: key);

  @override
  State<VectorInput> createState() => _VectorInputState();
}

class _VectorInputState extends State<VectorInput> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          children: [
            if (widget.name != null || widget.deleteVector != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.name != null) Text(widget.name!),
                    if (widget.deleteVector != null)
                      IconButton(
                        onPressed: widget.deleteVector,
                        icon: const Icon(Icons.close),
                        iconSize: 12.0,
                        splashRadius: 15.0,
                        color: Colors.redAccent,
                      ),
                  ],
                ),
              ),
            Wrap(
              direction: Axis.horizontal,
              runSpacing: 4.0,
              spacing: 2.0,
              children: [
                for (var i = 0; i < widget.vector.length(); i++)
                  InputUtils.decorateVector(
                    FractionInput(
                      maxWidth: 60,
                      onChanged: (Fraction? value) {
                        if (value == null) return;
                        widget.vector.setValue(i, value);
                      },
                      value: widget.vector[i].toDouble() != 0.0
                          ? widget.vector[i].toString()
                          : null,
                    ),
                    i,
                    widget.vector.length(),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ButtonRow(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 16.0,
                ),
                children: [
                  ButtonRowItem(
                    child: const Text('+ Prvek'),
                    onPressed: () {
                      setState(() {
                        widget.vector.addEntry();
                      });
                    },
                  ),
                  ButtonRowItem(
                    child: const Text('- Prvek'),
                    onPressed: widget.vector.length() > 1
                        ? () {
                            setState(() {
                              widget.vector
                                  .removeEntry(widget.vector.length() - 1);
                            });
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
