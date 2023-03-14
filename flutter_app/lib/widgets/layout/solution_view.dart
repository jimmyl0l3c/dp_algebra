import 'package:algebra_lib/algebra_lib.dart';
import 'package:dp_algebra/models/calc/calc_result.dart';
import 'package:dp_algebra/widgets/layout/calc_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class SolutionView2 extends StatefulWidget {
  final CalcResult solution;
  final Function(SolutionOptions)? onSelected;

  const SolutionView2({Key? key, required this.solution, this.onSelected})
      : super(key: key);

  @override
  State<SolutionView2> createState() => _SolutionView2State();
}

class _SolutionView2State extends State<SolutionView2> {
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
              Wrap(
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
                ).texBreak().parts,
              ),
              if (widget.onSelected != null)
                PopupMenuButton<SolutionOptions>(
                  icon: const Icon(Icons.menu),
                  splashRadius: 20,
                  onSelected: widget.onSelected,
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: SolutionOptions.close,
                      child: Text('Zavřít'),
                    ),
                    const PopupMenuItem(
                      value: SolutionOptions.addToMatrix,
                      child: Text('Vložit výsledek do matice'),
                    ),
                    const PopupMenuItem(
                      value: SolutionOptions.remove,
                      child: Text('Smazat'),
                    ),
                  ],
                ),
              if (widget.onSelected == null) const SizedBox(), // placeholder
            ],
          ),
          if (showSteps) const SizedBox(height: 8),
          if (showSteps) CalcStepper(steps: widget.solution.steps),
        ],
      ),
    );
  }
}

enum SolutionOptions { close, remove, addToMatrix }

class SolutionView extends StatelessWidget {
  final CalcResult solution;

  const SolutionView({
    Key? key,
    required this.solution,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.calculate),
                splashRadius: 20,
              ),
              Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                runAlignment: WrapAlignment.center,
                runSpacing: 12.0,
                children: Math.tex(
                  '${solution.calculation.toTeX(flags: {
                        TexFlags.dontEnclose,
                      })}=${solution.result.toTeX()}',
                  textScaleFactor: 1.4,
                ).texBreak().parts,
              ),
              PopupMenuButton(
                icon: const Icon(Icons.menu),
                splashRadius: 20,
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    child: Text('Zavřít'),
                  ),
                  const PopupMenuItem(
                    child: Text('Vložit výsledek do matice'),
                  ),
                  const PopupMenuItem(
                    child: Text('Smazat'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          CalcStepper(steps: solution.steps),
        ],
      ),
    );
  }
}
