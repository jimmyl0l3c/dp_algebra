import 'package:algebra_lib/algebra_lib.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

import '../../main.dart';
import '../../models/calc/calc_category.dart';
import '../../models/calc/calc_expression_exception.dart';
import '../../models/calc/calc_result.dart';
import '../../models/calc_state/calc_equation_model.dart';
import '../../models/calc_state/calc_solutions_model.dart';
import '../../models/input/matrix_model.dart';
import '../../utils/utils.dart';
import '../../widgets/input/equation_input.dart';
import '../../widgets/layout/solution_view.dart';

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
              style: Theme.of(context).textTheme.headlineMedium!,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: ElevatedButton(
                onPressed: () async {
                  Matrix m = equationMatrix.toMatrix();

                  CalcResult.calculateAsync(
                    GaussianElimination(matrix: m),
                  )
                      .then(
                    (value) => getIt<CalcSolutionsModel>().addSolution(
                      value,
                      CalcCategory.equation,
                    ),
                  )
                      .catchError(
                    (err) {
                      if (err is CalcExpressionException) {
                        showSnackBarMessage(context, err.friendlyMessage);
                      } else {
                        throw err;
                      }
                    },
                  ).timeout(const Duration(seconds: 5));

                  // try {
                  //   getIt<CalcSolutionsModel>().addSolution(
                  //     CalcResult.calculate(GaussianElimination(
                  //       matrix: m,
                  //     )),
                  //     CalcCategory.equation,
                  //   );
                  // } on CalcExpressionException catch (e) {
                  //   showSnackBarMessage(context, e.friendlyMessage);
                  // }
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
                    List<Expression> expMatrix = m.toMatrix().rows;
                    List<Expression> vectorY = [];
                    for (var r = 0; r < m.rows; r++) {
                      vectorY.add(
                        (expMatrix[r] as Vector).items.removeAt(m.columns - 1),
                      );
                    }

                    getIt<CalcSolutionsModel>().addSolution(
                      CalcResult.calculate(SolveWithInverse(
                        matrix: Matrix(
                          rows: expMatrix,
                          rowCount: expMatrix.length,
                          columnCount: m.columns - 1,
                        ),
                        vectorY: Vector(items: vectorY),
                      )),
                      CalcCategory.equation,
                    );
                  } on CalcExpressionException catch (e) {
                    showSnackBarMessage(context, e.friendlyMessage);
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
                    List<Expression> expMatrix = m.toMatrix().rows;
                    List<Expression> vectorY = [];
                    for (var r = 0; r < m.rows; r++) {
                      vectorY.add(
                        (expMatrix[r] as Vector).items.removeAt(m.columns - 1),
                      );
                    }

                    getIt<CalcSolutionsModel>().addSolution(
                      CalcResult.calculate(SolveWithCramer(
                          matrix: Matrix(
                            rows: expMatrix,
                            rowCount: expMatrix.length,
                            columnCount: m.columns - 1,
                          ),
                          vectorY: Vector(items: vectorY))),
                      CalcCategory.equation,
                    );
                  } on CalcExpressionException catch (e) {
                    showSnackBarMessage(context, e.friendlyMessage);
                  }
                },
                child: const Text('Cramerovo pravidlo'),
              ),
            ),
            const Divider(),
            Text(
              'Výsledky',
              style: Theme.of(context).textTheme.headlineMedium!,
            ),
            const SizedBox(height: 12),
            ListView.separated(
              itemBuilder: (context, index) => SolutionView(
                key: ValueKey(solutions[index]),
                solution: solutions[index],
                onSelected: (option) {
                  if (option == SolutionOptions.remove) {
                    getIt<CalcSolutionsModel>().removeSolution(
                      CalcCategory.equation,
                      index,
                    );
                  }
                },
              ),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: solutions.length,
              reverse: true,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            ),
          ],
        ),
      ),
    );
  }
}
