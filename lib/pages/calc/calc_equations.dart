import 'package:dp_algebra/main.dart';
import 'package:dp_algebra/matrices/equation_exceptions.dart';
import 'package:dp_algebra/matrices/equation_matrix.dart';
import 'package:dp_algebra/matrices/equation_solution.dart';
import 'package:dp_algebra/matrices/matrix_exceptions.dart';
import 'package:dp_algebra/matrices/vector.dart';
import 'package:dp_algebra/models/calc_state/calc_equation_model.dart';
import 'package:dp_algebra/models/calc_state/calc_equation_solutions_model.dart';
import 'package:dp_algebra/widgets/equation_input.dart';
import 'package:dp_algebra/widgets/solution_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class CalcEquations extends StatelessWidget with GetItMixin {
  CalcEquations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EquationMatrix equationMatrix =
        watchX((CalcEquationModel x) => x.equationMatrix);
    List<EquationSolution> solutions =
        watchX((CalcEquationSolutionsModel x) => x.solutions);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Column(
          children: [
            EquationInput(
              matrix: equationMatrix,
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
                  EquationMatrix m = equationMatrix;
                  try {
                    GeneralSolution solution = m.solveByGauss();
                    getIt<CalcEquationSolutionsModel>()
                        .addSolution(EquationSolution(
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
                  EquationMatrix m = equationMatrix;
                  try {
                    Vector solution = m.solveByInverse();
                    getIt<CalcEquationSolutionsModel>()
                        .addSolution(EquationSolution(
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
                  EquationMatrix m = equationMatrix;
                  try {
                    Vector solution = m.solveByCramer();
                    getIt<CalcEquationSolutionsModel>()
                        .addSolution(EquationSolution(
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
            for (var solution in solutions.reversed)
              SolutionView(solution: solution),
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
