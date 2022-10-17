import 'package:dp_algebra/models/learn_article.dart';
import 'package:flutter/material.dart';

import '../models/learn_chapter.dart';
import '../widgets/main_scaffold.dart';
import '../widgets/section_menu.dart';

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
          if (snapshot.hasData && snapshot.data != null) {
            List<LArticle> articles = snapshot.data!.articles
              ..sort((a, b) => a.order.compareTo(b.order));
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
            body = const Text('Loading...');
          }

          return MainScaffold(
            title: snapshot.hasData && snapshot.data != null
                ? snapshot.data!.title
                : 'Loading ...',
            child: body,
          );
        });
  }
}
