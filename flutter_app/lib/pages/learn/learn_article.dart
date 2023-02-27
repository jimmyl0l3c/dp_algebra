import 'package:dp_algebra/models/db/learn_article.dart';
import 'package:dp_algebra/models/db/learn_page.dart';
import 'package:dp_algebra/widgets/layout/main_scaffold.dart';
import 'package:dp_algebra/widgets/loading.dart';
import 'package:dp_algebra/widgets/lpage_view.dart';
import 'package:flutter/material.dart';

class LearnArticle extends StatefulWidget {
  final Future<LArticle?> article;
  final int? currentPage;

  const LearnArticle({
    Key? key,
    required this.article,
    this.currentPage,
  }) : super(key: key);

  @override
  State<LearnArticle> createState() => _LearnArticleState();
}

class _LearnArticleState extends State<LearnArticle> {
  int currentPage = 0;

  @override
  void initState() {
    currentPage = widget.currentPage ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LArticle?>(
        future: widget.article,
        builder: (context, snapshot) {
          Widget? body;
          String title = 'Načítání...';
          Widget? forwardButton;
          Widget? backwardButton;
          Widget? floatingButton;

          if (snapshot.hasData) {
            title = snapshot.data!.title;

            List<LPage> pages = snapshot.data!.pages;

            if (pages.length > currentPage + 1) {
              forwardButton = FloatingActionButton(
                onPressed: () {
                  setState(() {
                    currentPage++;
                  });
                },
                child: const Icon(
                  Icons.arrow_forward,
                  size: 40,
                ),
              );
            }

            if (currentPage > 0) {
              backwardButton = FloatingActionButton(
                onPressed: () {
                  setState(() {
                    currentPage--;
                  });
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
                  : LPageView(page: pages[currentPage]),
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
