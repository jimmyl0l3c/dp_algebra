import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../data/db_service.dart';
import '../../models/db/learn_chapter.dart';
import '../../widgets/layout/main_scaffold.dart';
import '../../widgets/layout/section_menu.dart';
import '../../widgets/loading.dart';

class LearnMenu extends StatelessWidget {
  const LearnMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DbService dbService = GetIt.instance.get<DbService>();

    return MainScaffold(
      isSectionRoot: true,
      title: 'Výuka - Výběr kapitoly',
      child: FutureBuilder<List<LChapter>?>(
          future: dbService.fetchChapters(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              if (snapshot.connectionState != ConnectionState.waiting) {
                return const Center(child: Text('Chyba při načítání kapitol'));
              }
              return const Loading();
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
