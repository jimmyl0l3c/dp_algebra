import 'package:dp_algebra/widgets/main_scaffold.dart';
import 'package:dp_algebra/widgets/section_menu.dart';
import 'package:flutter/material.dart';

class ExerciseMenu extends StatelessWidget {
  const ExerciseMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      isSectionRoot: true,
      title: 'Procvičování',
      child: SectionMenu(
        sections: [
          Section(
            title: 'Matice',
            subtitle: 'Součet, rozdíl, součin, determinant, inverzní matice',
            path: '/exercise/0',
          ),
          Section(
            title: 'Vektorové prostory',
            subtitle:
                'Lineární (ne)závislost vektorů, nalezení báze, transformace souřadnic od báze k bázi, ...',
            path: '/exercise/1',
          ),
          Section(
            title: 'Soustavy lineárních rovnic',
            path: '/exercise/2',
          ),
        ],
      ),
    );
  }
}
