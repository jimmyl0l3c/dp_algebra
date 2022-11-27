import 'package:dp_algebra/data/calc_data_controller.dart';
import 'package:dp_algebra/matrices/equation_exceptions.dart';
import 'package:dp_algebra/matrices/equation_matrix.dart';
import 'package:dp_algebra/matrices/equation_solution.dart';
import 'package:dp_algebra/matrices/matrix_exceptions.dart';
import 'package:dp_algebra/matrices/vector.dart';
import 'package:dp_algebra/widgets/equation_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class CalcEquations extends StatelessWidget {
  const CalcEquations({Key? key}) : super(key: key);

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
            EquationInput(
              matrix: CalcDataController.getEquationMatrix(),
            ),
            const Divider(),
            Text(
              'Metody řešení',
              style: Theme.of(context).textTheme.headline4!,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: ElevatedButton(
                onPressed: () {
                  EquationMatrix m = CalcDataController.getEquationMatrix();
                  try {
                    GeneralSolution solution = m.solveByGauss();
                    CalcDataController.addEquationSolution(EquationSolution(
                      equationMatrix: EquationMatrix.from(m),
                      generalSolution: solution,
                    ));
                  } on EquationException catch (e) {
                    showError(context, e.errMessage());
                  }
                },
                child: const Text('Gaussova eliminační metoda'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: ElevatedButton(
                onPressed: () {
                  EquationMatrix m = CalcDataController.getEquationMatrix();
                  try {
                    Vector solution = m.solveByInverse();
                    CalcDataController.addEquationSolution(EquationSolution(
                      equationMatrix: EquationMatrix.from(m),
                      solution: solution,
                    ));
                  } on MatrixException catch (e) {
                    showError(context, e.errMessage());
                  } on EquationException catch (e) {
                    showError(context, e.errMessage());
                  }
                },
                child: const Text('Inverzní matice'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: ElevatedButton(
                onPressed: () {
                  EquationMatrix m = CalcDataController.getEquationMatrix();
                  try {
                    Vector solution = m.solveByCramer();
                    CalcDataController.addEquationSolution(EquationSolution(
                      equationMatrix: EquationMatrix.from(m),
                      solution: solution,
                    ));
                  } on MatrixException catch (e) {
                    showError(context, e.errMessage());
                  } on EquationException catch (e) {
                    showError(context, e.errMessage());
                  }
                },
                child: const Text('Cramerovo pravidlo'),
              ),
            ),
            const Divider(),
            Text(
              'Výsledky',
              style: Theme.of(context).textTheme.headline4!,
            ),
            const SizedBox(height: 12),
            StreamBuilder(
              stream: CalcDataController.equationSolutionsStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();

                List<Widget> solutions = [];
                for (var solution in snapshot.data!.reversed) {
                  solutions.add(Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Math.tex(
                      solution.toTeX(),
                      textScaleFactor: 1.4,
                    ),
                  ));
                }

                return Column(children: solutions);
              },
            )
          ],
        ),
      ),
    );
  }

  void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
