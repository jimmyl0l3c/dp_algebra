import 'dart:async';

import 'package:dp_algebra/models/learn_article.dart';
import 'package:dp_algebra/models/learn_chapter.dart';

/// Everything inside this file is for development purposes only
/// and should be removed before release

class Dev {
  static List<LChapter> learnData = [];

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
