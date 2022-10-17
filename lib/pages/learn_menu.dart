import 'package:dp_algebra/data/db_helper.dart';
import 'package:dp_algebra/models/learn_chapter.dart';
import 'package:flutter/material.dart';

import '../widgets/main_scaffold.dart';
import '../widgets/section_menu.dart';

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
            if (!snapshot.hasData || snapshot.data == null) {
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
