import 'package:algebra_lib/algebra_lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../main.dart';
import '../../models/calc/calc_result.dart';
import '../../models/calc_state/calc_matrix_model.dart';
import '../../models/calc_state/calc_vector_model.dart';
import '../../models/input/matrix_model.dart';
import '../../models/input/vector_model.dart';
import '../../utils/utils.dart';
import 'calc_stepper.dart';
import 'horizontally_scrollable.dart';

class SolutionView extends StatefulWidget {
  final CalcResult solution;
  final Function(SolutionOptions)? onSelected;

  const SolutionView({Key? key, required this.solution, this.onSelected})
      : super(key: key);

  @override
  State<SolutionView> createState() => _SolutionViewState();
}

class _SolutionViewState extends State<SolutionView> {
  bool showSteps = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    showSteps = !showSteps;
                  });
                },
                icon: const Icon(Icons.calculate),
                splashRadius: 20,
              ),
              Expanded(
                child: Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runAlignment: WrapAlignment.center,
                  runSpacing: 12.0,
                  children: Math.tex(
                    '${widget.solution.calculation.toTeX(flags: {
                          TexFlags.dontEnclose,
                        })}=${widget.solution.result.toTeX()}',
                    textScaleFactor: 1.4,
                  )
                      .texBreak()
                      .parts
                      .map((e) => HorizontallyScrollable(child: e))
                      .toList(),
                ),
              ),
              PopupMenuButton<SolutionOptions>(
                icon: const Icon(Icons.menu),
                splashRadius: 20,
                onSelected: (value) {
                  switch (value) {
                    case SolutionOptions.close:
                      break;
                    case SolutionOptions.remove:
                      widget.onSelected?.call(value);
                      break;
                    case SolutionOptions.addToMatrix:
                      if (widget.solution.result is Matrix) {
                        var m = getIt<CalcMatrixModel>().addMatrix(
                          matrix: MatrixModel.fromMatrix(
                              widget.solution.result as Matrix),
                        );
                        if (m == null) {
                          showSnackBarMessage(
                            context,
                            "Nelze překročit maximální počet matic, je třeba nějakou odebrat před přidáním další.",
                          );
                        }
                      }
                      break;
                    case SolutionOptions.addToVector:
                      if (widget.solution.result is Vector) {
                        var v = getIt<CalcVectorModel>().addVector(
                          vector: VectorModel.fromVector(
                              widget.solution.result as Vector),
                        );
                        if (v == null) {
                          showSnackBarMessage(
                            context,
                            "Nelze překročit maximální počet vektorů, je třeba nějaký odebrat před přidáním dalšího.",
                          );
                        }
                      }
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: SolutionOptions.close,
                    child: Text('Zavřít'),
                  ),
                  if (widget.solution.result is Matrix)
                    const PopupMenuItem(
                      value: SolutionOptions.addToMatrix,
                      child: Text('Vložit výsledek do matice'),
                    ),
                  if (widget.solution.result is Vector)
                    const PopupMenuItem(
                      value: SolutionOptions.addToVector,
                      child: Text('Vložit výsledek do vektoru'),
                    ),
                  if (widget.onSelected != null)
                    const PopupMenuItem(
                      value: SolutionOptions.remove,
                      child: Text('Smazat'),
                    ),
                ],
              ), // placeholder
            ],
          ),
          if (showSteps) const SizedBox(height: 8),
          if (showSteps) CalcStepper(steps: widget.solution.steps),
        ],
      ),
    );
  }
}

enum SolutionOptions {
  close,
  remove,
  addToMatrix,
  addToVector,
}
