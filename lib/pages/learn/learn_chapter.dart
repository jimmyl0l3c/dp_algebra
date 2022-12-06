import 'package:dp_algebra/models/db/learn_article.dart';
import 'package:dp_algebra/models/db/learn_chapter.dart';
import 'package:dp_algebra/widgets/main_scaffold.dart';
import 'package:dp_algebra/widgets/section_menu.dart';
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
          if (snapshot.hasData) {
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
            title: snapshot.hasData ? snapshot.data!.title : 'Loading ...',
            child: body,
          );
        });
  }
}
