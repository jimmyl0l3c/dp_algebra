import 'dart:async';

import 'package:dp_algebra/models/learn_article.dart';
import 'package:dp_algebra/models/learn_chapter.dart';
import 'package:dp_algebra/models/learn_page.dart';

/// Everything inside this file is for development purposes only
/// and should be removed before release

class Dev {
  static List<LChapter> learnData = [
    LChapter(
      0,
      'Matice',
      [
        LArticle(
          0,
          'Matice',
          [
            LPage(
              0,
              0,
              [],
            )
          ],
          0,
        ),
        LArticle(
          1,
          'Operace s maticemi',
          [
            LPage(
              0,
              1,
              [],
            )
          ],
          0,
        ),
        LArticle(
          2,
          'Determinant',
          [
            LPage(
              0,
              2,
              [],
            )
          ],
          0,
        ),
        LArticle(
          3,
          'Inverzní matice',
          [
            LPage(
              0,
              3,
              [],
            )
          ],
          0,
        ),
      ],
    ),
    LChapter(
      1,
      'Vektorové prostory',
      [
        LArticle(
          0,
          'Vektorové prostory',
          [
            LPage(
              0,
              0,
              [],
            )
          ],
          1,
        ),
        LArticle(
          1,
          'Hodnost matice',
          [
            LPage(
              0,
              0,
              [],
            )
          ],
          1,
        ),
        LArticle(
          2,
          'Báze',
          [
            LPage(
              0,
              0,
              [],
            )
          ],
          1,
        ),
      ],
    ),
    LChapter(
      2,
      'Soustavy lineárních rovnic',
      [
        LArticle(
          0,
          'Soustavy lineárních rovnic',
          [
            LPage(
              0,
              0,
              [],
            )
          ],
          2,
        ),
        LArticle(
          1,
          'Gaussova eliminační metoda',
          [
            LPage(
              0,
              0,
              [],
            )
          ],
          2,
        ),
        LArticle(
          2,
          'Cramerovo pravidlo',
          [
            LPage(
              0,
              0,
              [],
            )
          ],
          2,
        ),
      ],
    ),
  ];

  static StreamController<List<LChapter>>? _devChapterStreamController;
  static StreamController<List<LArticle>>? _devArticleStreamController;

  static Stream<List<LChapter>> getChapterStream() {
    _devChapterStreamController = StreamController<List<LChapter>>();
    _devChapterStreamController!.add(learnData);
    return _devChapterStreamController!.stream;
  }

  static void disposeChapterStream() {
    _devChapterStreamController?.close();
  }

  static Stream<List<LArticle>> getArticleStream(int chapterId) {
    _devArticleStreamController = StreamController<List<LArticle>>();
    _devArticleStreamController!.add(
        learnData.firstWhere((element) => element.id == chapterId).articles);
    return _devArticleStreamController!.stream;
  }

  static void disposeArticleStream() {
    _devArticleStreamController?.close();
  }
}
