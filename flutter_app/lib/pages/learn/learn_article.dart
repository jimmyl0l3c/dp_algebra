import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/db/learn_article.dart';
import '../../models/db/learn_page.dart';
import '../../widgets/layout/main_scaffold.dart';
import '../../widgets/learn/lpage_view.dart';
import '../../widgets/loading.dart';

class LearnArticle extends StatelessWidget {
  final Future<LArticle?> article;
  final int currentChapter;
  final int currentPage;

  const LearnArticle({
    Key? key,
    required this.currentChapter,
    this.currentPage = 1,
    required this.article,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    return FutureBuilder<LArticle?>(
        future: article,
        builder: (context, snapshot) {
          Widget? body;
          String title = 'Načítání...';
          Widget? forwardButton;
          Widget? backwardButton;
          Widget? floatingButton;

          if (snapshot.hasData) {
            title = snapshot.data!.title;

            List<LPage> pages = snapshot.data!.pages;
            var articleId = snapshot.data!.id;

            if (pages.length >= currentPage + 1) {
              forwardButton = FloatingActionButton(
                onPressed: () {
                  scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeIn,
                  );
                  context.go(
                    '/chapter/$currentChapter/$articleId/${currentPage + 1}',
                  );
                },
                child: const Icon(
                  Icons.arrow_forward,
                  size: 40,
                ),
              );
            }

            if (currentPage > 1) {
              backwardButton = FloatingActionButton(
                onPressed: () {
                  scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeIn,
                  );
                  context.go(
                    '/chapter/$currentChapter/$articleId/${currentPage - 1}',
                  );
                },
                child: const Icon(
                  Icons.arrow_back,
                  size: 40,
                ),
              );
            }

            if (backwardButton != null || forwardButton != null) {
              floatingButton = Stack(
                fit: StackFit.expand,
                children: [
                  if (backwardButton != null)
                    Positioned(
                      right: 100,
                      bottom: 20,
                      child: backwardButton,
                    ),
                  if (forwardButton != null)
                    Positioned(
                      right: 30,
                      bottom: 20,
                      child: forwardButton,
                    ),
                ],
              );
            }

            body = Container(
              child: pages.isEmpty
                  ? const Center(child: Text('Článek je prázdný'))
                  : LPageView(
                      page: pages[currentPage - 1],
                      scrollController: scrollController,
                    ),
            );
          } else {
            if (snapshot.connectionState == ConnectionState.waiting) {
              body = const Loading();
            } else {
              title = 'Error';
              body = const Center(child: Text('Článek nenalezen'));
            }
          }

          return MainScaffold(
            title: title,
            floatingActionButton: floatingButton,
            child: body,
          );
        });
  }
}
