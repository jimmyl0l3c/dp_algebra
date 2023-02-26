import 'package:dp_algebra/data/db_helper.dart';
import 'package:dp_algebra/models/db/learn_chapter.dart';
import 'package:dp_algebra/widgets/layout/main_scaffold.dart';
import 'package:dp_algebra/widgets/layout/section_menu.dart';
import 'package:flutter/material.dart';

class LearnMenu extends StatelessWidget {
  const LearnMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      isSectionRoot: true,
      title: 'Výuka - Výběr kapitoly',
      child: FutureBuilder<List<LChapter>?>(
          future: DbHelper.findAllChapters(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text('Loading...');
            }

            return SectionMenu(
                sections: snapshot.data!
                    .map(
                      (chapter) => Section(
                        title: chapter.title,
                        subtitle: chapter.description,
                        path: '/chapter/${chapter.id}',
                      ),
                    )
                    .toList());
          }),
    );
  }
}