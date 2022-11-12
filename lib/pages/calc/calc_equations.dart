import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../data/calc_data_controller.dart';
import '../../matrices/equation_exceptions.dart';
import '../../matrices/equation_matrix.dart';
import '../../matrices/equation_solution.dart';
import '../../matrices/matrix.dart';
import '../../matrices/matrix_exceptions.dart';
import '../../widgets/equation_input.dart';
import '../../widgets/main_scaffold.dart';

class CalcEquations extends StatelessWidget {
  const CalcEquations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'Soustavy lineárních rovnic',
      child: SingleChildScrollView(
        child: Column(
          children: [
            EquationInput(
              matrix: CalcDataController.getEquationMatrix(),
            ),
            const Divider(),
            const Text('Metody řešení'),
            OutlinedButton(
              onPressed: () {
                EquationMatrix m = CalcDataController.getEquationMatrix();
                try {
                  GeneralSolution solution = m.solveByGauss();
                  CalcDataController.addEquationSolution(EquationSolution(
                    equationMatrix: EquationMatrix.from(m),
                    generalSolution: solution,
                  ));
                } on EquationsNotSolvableException {
                  showError(context, 'Soustava rovnic není řešitelná');
                }
              },
              child: const Text('Gaussova eliminační metoda'),
            ),
            OutlinedButton(
              onPressed: () {
                EquationMatrix m = CalcDataController.getEquationMatrix();
                try {
                  Matrix solution = m.solveByInverse();
                  CalcDataController.addEquationSolution(EquationSolution(
                    equationMatrix: EquationMatrix.from(m),
                    solution: solution,
                  ));
                } on MatrixInverseImpossibleException {
                  showError(context, 'Matice rovnice nemá inverzní matici');
                } on MatrixIsNotSquareException {
                  showError(context, 'Matice rovnice musí být čtvercová');
                }
              },
              child: const Text('Inverzní matice'),
            ),
            OutlinedButton(
              onPressed: () {
                EquationMatrix m = CalcDataController.getEquationMatrix();
                try {
                  Matrix solution = m.solveByCramer();
                  CalcDataController.addEquationSolution(EquationSolution(
                    equationMatrix: EquationMatrix.from(m),
                    solution: solution,
                  ));
                } on MatrixIsNotSquareException {
                  showError(context, 'Matice rovnice musí být čtvercová');
                } on EqNotSolvableByCramerException {
                  showError(context,
                      'Determinant matice rovnice nesmí být roven nula');
                }
              },
              child: const Text('Cramerovo pravidlo'),
            ),
            const Divider(),
            const Text('Výsledky:'),
            StreamBuilder(
              stream: CalcDataController.equationSolutionsStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();

                List<Widget> solutions = [];
                for (var solution in snapshot.data!.reversed) {
                  solutions.add(Math.tex(
                    solution.toTeX(),
                    textScaleFactor: 1.4,
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
