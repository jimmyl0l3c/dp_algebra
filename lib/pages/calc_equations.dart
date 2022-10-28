import 'package:dp_algebra/data/calc_data_controller.dart';
import 'package:dp_algebra/widgets/equation_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../widgets/main_scaffold.dart';

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
            const OutlinedButton(
              onPressed: null,
              child: Text('Gaussova eliminační metoda'),
            ),
            const OutlinedButton(
              onPressed: null,
              child: Text('Inverzní matice'),
            ),
            const OutlinedButton(
              onPressed: null,
              child: Text('Cramerovo pravidlo'),
            ),
            const Divider(),
            const Text('Výsledky:'),
            StreamBuilder(
              stream: CalcDataController.equationSolutionsStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();

                List<Widget> solutions = [];
                for (var solution in snapshot.data!) {
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
}
