import 'package:dp_algebra/logic/equation_matrix/equation_exceptions.dart';
import 'package:dp_algebra/logic/equation_matrix/equation_matrix.dart';
import 'package:dp_algebra/logic/matrix/matrix_exceptions.dart';
import 'package:dp_algebra/models/calc_result.dart';
import 'package:dp_algebra/models/calc_state/calc_equation_model.dart';
import 'package:dp_algebra/models/calc_state/calc_solutions_model.dart';
import 'package:dp_algebra/utils/utils.dart';
import 'package:dp_algebra/widgets/input/equation_input.dart';
import 'package:dp_algebra/widgets/layout/solution_view_n.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class CalcEquations extends StatelessWidget with GetItMixin {
  CalcEquations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EquationMatrix equationMatrix =
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
                  EquationMatrix m = equationMatrix;
                  try {
                    // TODO: implement
                    // GeneralSolution solution = m.solveByGauss();
                    // getIt<CalcEquationSolutionsModel>()
                    //     .addSolution(EquationSolution(
                    //   equationMatrix: EquationMatrix.from(m),
                    //   generalSolution: solution,
                    // ));
                  } on EquationException catch (e) {
                    AlgebraUtils.showMessage(context, e.errMessage());
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
                    // TODO: implement
                    // VectorModel solution = m.solveByInverse();
                    // getIt<CalcEquationSolutionsModel>()
                    //     .addSolution(EquationSolution(
                    //   equationMatrix: EquationMatrix.from(m),
                    //   solution: solution,
                    // ));
                  } on MatrixException catch (e) {
                    AlgebraUtils.showMessage(context, e.errMessage());
                  } on EquationException catch (e) {
                    AlgebraUtils.showMessage(context, e.errMessage());
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
                    // TODO: implement
                    // VectorModel solution = m.solveByCramer();
                    // getIt<CalcEquationSolutionsModel>()
                    //     .addSolution(EquationSolution(
                    //   equationMatrix: EquationMatrix.from(m),
                    //   solution: solution,
                    // ));
                  } on MatrixException catch (e) {
                    AlgebraUtils.showMessage(context, e.errMessage());
                  } on EquationException catch (e) {
                    AlgebraUtils.showMessage(context, e.errMessage());
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
              SolutionView2(solution: solution),
          ],
        ),
      ),
    );
  }
}
