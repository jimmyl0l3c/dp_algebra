import 'package:big_fraction/big_fraction.dart';
import 'package:flutter/material.dart';

import '../../models/input/vector_model.dart';
import '../forms/button_row.dart';
import '../hint.dart';
import 'decorate_vector_input.dart';
import 'fraction_input.dart';

class VectorInput extends StatefulWidget {
  final VectorModel vector;
  final String? name;
  final VoidCallback? deleteVector;
  final bool randomGenerationAllowed;

  const VectorInput({
    super.key,
    required this.vector,
    this.name,
    this.deleteVector,
    this.randomGenerationAllowed = false,
  });

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
                    const Hint(
                      message:
                          'Hodnoty lze pro lepší přesnost zadávat ve zlomcích, např. 1/2',
                    )
                  ],
                ),
              ),
            Wrap(
              direction: Axis.horizontal,
              runSpacing: 4.0,
              spacing: 2.0,
              children: [
                for (var i = 0; i < widget.vector.length; i++)
                  decorateVectorInput(
                    FractionInput(
                      maxWidth: 60,
                      onChanged: (BigFraction? value) {
                        if (value == null) return;
                        widget.vector.set(i, value);
                      },
                      value: widget.vector[i].toDouble() != 0.0
                          ? widget.vector[i].toString()
                          : null,
                    ),
                    i,
                    widget.vector.length,
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
                    onPressed: () {
                      setState(() {
                        widget.vector.add();
                      });
                    },
                    child: const Text('+ Prvek'),
                  ),
                  ButtonRowItem(
                    onPressed: widget.vector.length > 1
                        ? () {
                            setState(() {
                              widget.vector.removeAt(widget.vector.length - 1);
                            });
                          }
                        : null,
                    child: const Text('- Prvek'),
                  ),
                  if (widget.randomGenerationAllowed)
                    ButtonRowItem(
                      onPressed: () {
                        setState(() {
                          widget.vector.regenerateValues();
                        });
                      },
                      tooltip: 'Náhodně vyplnit',
                      child: const Icon(
                        Icons.casino,
                        size: 17,
                      ),
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
