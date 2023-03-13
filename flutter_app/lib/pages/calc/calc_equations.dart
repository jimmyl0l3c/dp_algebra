import 'package:algebra_lib/algebra_lib.dart';
import 'package:dp_algebra/main.dart';
import 'package:dp_algebra/models/calc/calc_category.dart';
import 'package:dp_algebra/models/calc/calc_expression_exception.dart';
import 'package:dp_algebra/models/calc/calc_result.dart';
import 'package:dp_algebra/models/calc_state/calc_equation_model.dart';
import 'package:dp_algebra/models/calc_state/calc_solutions_model.dart';
import 'package:dp_algebra/models/input/matrix_model.dart';
import 'package:dp_algebra/utils/utils.dart';
import 'package:dp_algebra/widgets/input/equation_input.dart';
import 'package:dp_algebra/widgets/layout/solution_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class CalcEquations extends StatelessWidget with GetItMixin {
  CalcEquations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MatrixModel equationMatrix =
        watchX((CalcEquationModel x) => x.equationMatrix);
    List<CalcResult> solutions =
        watchX((CalcSolutionsModel x) => x.equationSolutions);

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
                  MatrixModel m = equationMatrix;
                  try {
                    getIt<CalcSolutionsModel>().addSolution(
                      CalcResult.calculate(GaussianElimination(
                        matrix: m.toMatrix(),
                      )),
                      CalcCategory.equation,
                    );
                  } on CalcExpressionException catch (e) {
                    AlgebraUtils.showMessage(context, e.friendlyMessage);
                  }
                },
                child: const Text('Gaussova eliminační metoda'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: ElevatedButton(
                onPressed: () {
                  MatrixModel m = equationMatrix;
                  try {
                    Matrix expMatrix = m.toMatrix();
                    List<Expression> vectorY = [];
                    int lastCol = expMatrix.columnCount() - 1;
                    for (var r = 0; r < expMatrix.rowCount(); r++) {
                      vectorY.add(expMatrix.rows[r].removeAt(lastCol));
                    }

                    getIt<CalcSolutionsModel>().addSolution(
                      CalcResult.calculate(SolveWithInverse(
                        matrix: expMatrix,
                        vectorY: Vector(items: vectorY),
                      )),
                      CalcCategory.equation,
                    );
                  } on CalcExpressionException catch (e) {
                    AlgebraUtils.showMessage(context, e.friendlyMessage);
                  }
                },
                child: const Text('Inverzní matice'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: ElevatedButton(
                onPressed: () {
                  MatrixModel m = equationMatrix;
                  try {
                    Matrix expMatrix = m.toMatrix();
                    List<Expression> vectorY = [];
                    int lastCol = expMatrix.columnCount() - 1;
                    for (var r = 0; r < expMatrix.rowCount(); r++) {
                      vectorY.add(expMatrix.rows[r].removeAt(lastCol));
                    }

                    getIt<CalcSolutionsModel>().addSolution(
                      CalcResult.calculate(SolveWithCramer(
                          matrix: expMatrix, vectorY: Vector(items: vectorY))),
                      CalcCategory.equation,
                    );
                  } on CalcExpressionException catch (e) {
                    AlgebraUtils.showMessage(context, e.friendlyMessage);
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
}
