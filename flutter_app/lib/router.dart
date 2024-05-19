import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'data/calc_data.dart';
import 'data/db_service.dart';
import 'data/exercise_data.dart';
import 'pages/generic/alg_chapter_view.dart';
import 'pages/generic/alg_menu_view.dart';
import 'pages/generic/alg_page_view.dart';
import 'pages/generic/transition_page.dart';
import 'pages/learn/learn_article.dart';
import 'pages/learn/learn_chapter.dart';
import 'pages/learn/learn_menu.dart';
import 'pages/menu.dart';

class AlgebraRouter {
  final DbService _dbService = GetIt.instance.get<DbService>();

  late final GoRouter router;

  AlgebraRouter() {
    router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => const AlgebraTransitionPage(
            child: Menu(),
          ),
          routes: [
            GoRoute(
              path: 'chapter',
              pageBuilder: (context, state) => const AlgebraTransitionPage(
                child: LearnMenu(),
              ),
              routes: [
                GoRoute(
                  path: ':chapterId',
                  pageBuilder: (context, state) {
                    final currentChapterId =
                        int.tryParse(state.pathParameters['chapterId']!);

                    return AlgebraTransitionPage(
                      child: LearnChapter(
                        chapter: currentChapterId != null
                            ? _dbService.fetchChapter(currentChapterId)
                            : Future.value(null),
                      ),
                    );
                  },
                  routes: [
                    GoRoute(
                      path: ':articleId',
                      redirect: (context, state) =>
                          '/chapter/${state.pathParameters["chapterId"]}/${state.pathParameters["articleId"]}/1',
                    ),
                    GoRoute(
                      path: ':articleId/:pageId',
                      pageBuilder: (context, state) {
                        final currentChapterId =
                            int.tryParse(state.pathParameters['chapterId']!);
                        final currentArticleId =
                            int.tryParse(state.pathParameters['articleId']!);
                        final currentPageId =
                            int.tryParse(state.pathParameters['pageId']!);

                        final currentChapter = currentChapterId != null
                            ? _dbService.fetchChapter(currentChapterId)
                            : Future.value(null);
                        final currentArticle = currentArticleId != null
                            ? _dbService.fetchArticle(currentArticleId)
                            : Future.value(null);

                        if (currentChapterId == null) {
                          return AlgebraTransitionPage(
                            child: LearnChapter(chapter: currentChapter),
                          );
                        }

                        return AlgebraTransitionPage(
                          child: LearnArticle(
                            currentChapter: currentChapterId,
                            article: currentArticle,
                            currentPage: currentPageId ?? 1,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              path: 'exercise',
              pageBuilder: (context, state) => const AlgebraTransitionPage(
                child: AlgMenuView(
                  sectionTitle: 'Procvičování',
                  sectionPath: 'exercise',
                  chapters: exerciseChapters,
                ),
              ),
              routes: [
                GoRoute(
                  path: ':sectionChapterId',
                  pageBuilder: (context, state) {
                    final sectionChapterId =
                        int.tryParse(state.pathParameters['sectionChapterId']!);

                    if (sectionChapterId != null &&
                        sectionChapterId < exerciseChapters.length) {
                      return AlgebraTransitionPage(
                        child: AlgChapterView(
                          sectionTitle: 'Procvičování',
                          sectionPath: 'exercise',
                          chapter: exerciseChapters[sectionChapterId],
                          chapterId: sectionChapterId,
                        ),
                      );
                    }

                    return const AlgebraTransitionPage(child: Menu());
                  },
                  routes: [
                    GoRoute(
                      path: ':sectionPageId',
                      pageBuilder: (context, state) {
                        final sectionChapterId = int.tryParse(
                            state.pathParameters['sectionChapterId']!);
                        final sectionPageId = int.tryParse(
                            state.pathParameters['sectionPageId']!);

                        if (sectionChapterId != null &&
                            sectionChapterId < exerciseChapters.length &&
                            sectionPageId != null &&
                            sectionPageId <
                                exerciseChapters[sectionChapterId]
                                    .pages
                                    .length) {
                          final exerciseChapter =
                              exerciseChapters[sectionChapterId];
                          return AlgebraTransitionPage(
                            child: AlgPageView(
                              sectionTitle: 'Procvičování',
                              chapter: exerciseChapter,
                              page: exerciseChapter.pages[sectionPageId],
                            ),
                          );
                        }

                        return const AlgebraTransitionPage(child: Menu());
                      },
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              path: 'calc',
              pageBuilder: (context, state) => AlgebraTransitionPage(
                child: AlgMenuView(
                  sectionTitle: 'Kalkulačka',
                  sectionPath: 'calc',
                  chapters: calcChapters,
                ),
              ),
              routes: [
                GoRoute(
                  path: ':sectionChapterId',
                  pageBuilder: (context, state) {
                    final sectionChapterId =
                        int.tryParse(state.pathParameters['sectionChapterId']!);

                    if (sectionChapterId != null &&
                        sectionChapterId < calcChapters.length) {
                      return AlgebraTransitionPage(
                        child: AlgChapterView(
                          sectionTitle: 'Kalkulačka',
                          sectionPath: 'calc',
                          chapter: calcChapters[sectionChapterId],
                          chapterId: sectionChapterId,
                        ),
                      );
                    }

                    return const AlgebraTransitionPage(child: Menu());
                  },
                  routes: [
                    GoRoute(
                      path: ':sectionPageId',
                      pageBuilder: (context, state) {
                        final sectionChapterId = int.tryParse(
                            state.pathParameters['sectionChapterId']!);
                        final sectionPageId = int.tryParse(
                            state.pathParameters['sectionPageId']!);

                        if (sectionChapterId != null &&
                            sectionChapterId < calcChapters.length &&
                            sectionPageId != null &&
                            sectionPageId <
                                calcChapters[sectionChapterId].pages.length) {
                          final calcChapter = calcChapters[sectionChapterId];
                          return AlgebraTransitionPage(
                            child: AlgPageView(
                              sectionTitle: 'Kalkulačka',
                              chapter: calcChapter,
                              page: calcChapter.pages[sectionPageId],
                            ),
                          );
                        }

                        return const AlgebraTransitionPage(child: Menu());
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
