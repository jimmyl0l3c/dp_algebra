import 'package:dp_algebra/models/db/learn_article.dart';
import 'package:dp_algebra/models/db/learn_chapter.dart';
import 'package:dp_algebra/widgets/layout/main_scaffold.dart';
import 'package:dp_algebra/widgets/layout/section_menu.dart';
import 'package:dp_algebra/widgets/loading.dart';
import 'package:flutter/material.dart';

class LearnChapter extends StatelessWidget {
  final Future<LChapter?> chapter;

  const LearnChapter({
    Key? key,
    required this.chapter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LChapter?>(
        future: chapter,
        builder: (context, snapshot) {
          Widget? body;
          String title = 'Načítání...';

          if (snapshot.hasData) {
            title = snapshot.data!.title;
            List<LArticle> articles = snapshot.data!.articles;
            body = SectionMenu(
                sections: articles
                    .map(
                      (article) => Section(
                        title: article.title,
                        subtitle: article.description,
                        path: '/chapter/${snapshot.data!.id}/${article.id}',
                      ),
                    )
                    .toList());
          } else {
            if (snapshot.connectionState == ConnectionState.waiting) {
              body = const Loading();
            } else {
              title = 'Error';
              body = const Center(child: Text('Kapitola nenalezena'));
            }
          }

          return MainScaffold(
            title: title,
            child: body,
          );
        });
  }
}
