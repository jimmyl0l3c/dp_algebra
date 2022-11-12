import 'package:dp_algebra/widgets/main_scaffold.dart';
import 'package:dp_algebra/widgets/section_menu.dart';
import 'package:flutter/material.dart';

class CalcMenu extends StatelessWidget {
  const CalcMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      isSectionRoot: true,
      title: 'Kalkulačka',
      child: SectionMenu(
        sections: [
          Section(
            title: 'Operace s maticemi',
            subtitle:
                'Součet, rozdíl, součin, vlastnosti matic (hodnost, determinant)',
            path: '/calc/0',
          ),
          Section(
            title: 'Soustavy lineárních rovnic',
            path: '/calc/1',
          ),
          Section(
            title: 'Vektorové prostory',
            subtitle:
                'Lineární (ne)závislost vektorů, nalezení báze, transformace souřadnic od báze k bázi, ...',
          ),
        ],
      ),
    );
  }
}
