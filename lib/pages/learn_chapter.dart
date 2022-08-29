import 'package:dp_algebra/models/learn_article.dart';
import 'package:flutter/material.dart';

import '../dev.dart';
import '../models/learn_chapter.dart';
import '../widgets/main_scaffold.dart';
import '../widgets/section_menu.dart';

class LearnChapter extends StatelessWidget {
  final LChapter chapter;

  const LearnChapter({
    Key? key,
    required this.chapter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: chapter.title,
      child: StreamBuilder<List<LArticle>>(
          stream: Dev.getArticleStream(chapter.id),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return const Text('Loading...');
            }

            return SectionMenu(
                sections: snapshot.data!
                    .map(
                      (article) => Section(
                        title: article.title,
                        subtitle: article.description,
                        path: '/chapter/${chapter.id}/${article.id}',
                      ),
                    )
                    .toList());
          }),
    );
  }
}
