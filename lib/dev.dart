import 'dart:async';

import 'package:dp_algebra/models/learn_article.dart';
import 'package:dp_algebra/models/learn_chapter.dart';
import 'package:dp_algebra/models/learn_page.dart';

/// Everything inside this folder is for development purposes only
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
              'unnecessary field',
              [],
              0,
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
              'unnecessary field',
              [],
              1,
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
              'unnecessary field',
              [],
              2,
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
              'unnecessary field',
              [],
              3,
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
              'unnecessary field',
              [],
              0,
            )
          ],
          1,
        ),
        LArticle(
          0,
          'Hodnost matice',
          [
            LPage(
              0,
              'unnecessary field',
              [],
              0,
            )
          ],
          0,
        ),
        LArticle(
          0,
          'Báze',
          [
            LPage(
              0,
              'unnecessary field',
              [],
              0,
            )
          ],
          0,
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
              'unnecessary field',
              [],
              0,
            )
          ],
          0,
        ),
        LArticle(
          0,
          'Gaussova eliminační metoda',
          [
            LPage(
              0,
              'unnecessary field',
              [],
              0,
            )
          ],
          0,
        ),
        LArticle(
          0,
          'Cramerovo pravidlo',
          [
            LPage(
              0,
              'unnecessary field',
              [],
              0,
            )
          ],
          0,
        ),
      ],
    ),
  ];

  static StreamController<List<LChapter>>? _devChapterStreamController;

  static Stream<List<LChapter>> getChapterStream() {
    _devChapterStreamController = StreamController<List<LChapter>>();
    _devChapterStreamController!.add(learnData);
    return _devChapterStreamController!.stream;
  }

  static void disposeStream() {
    _devChapterStreamController?.close();
  }
}
