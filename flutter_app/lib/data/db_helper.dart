import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:dp_algebra/models/db/learn_article.dart';
import 'package:dp_algebra/models/db/learn_chapter.dart';
import 'package:dp_algebra/models/db/learn_literature.dart';

class DbHelper {
  static Future<List<LChapter>?> findAllChapters() => Backendless.data
          .of('algebra_learn_chapter')
          .find(DataQueryBuilder()..sortBy = ["order ASC"])
          .then((chapters) {
        return chapters?.map((c) => LChapter.fromJson(c!)).toList();
      });

  static Future<LChapter?> findChapter(int id) => Backendless.data
          .of('algebra_learn_chapter')
          .find(DataQueryBuilder()
            ..whereClause = "chapter_id = $id"
            ..relationsDepth = 1
            ..related = ['articles'])
          .then((value) {
        if (value == null || value.first == null) return null;
        return LChapter.fromJson(value.first!);
      });

  static Future<LArticle?> findArticle(int chapterId, int articleId) =>
      Backendless.data
          .of('algebra_learn_article')
          .find(DataQueryBuilder()
            ..whereClause = "chapterId = $chapterId and article_id = $articleId"
            ..relationsDepth = 2
            ..related = ['pages', 'chapterId', 'pages.blocks'])
          .then((value) {
        if (value == null || value.first == null) return null;
        try {
          // TODO: remove this or log it properly
          //print(value);
          return LArticle.fromJson(value.first!);
        } on Error catch (err) {
          print(err);
        } on Exception catch (ex) {
          print(ex);
        }
        return null;
      });

  static Future<LLiterature?> findLiterature(String name) => Backendless.data
          .of('algebra_lit_sources')
          .find(DataQueryBuilder()..whereClause = "refName = '$name'")
          .then((value) {
        if (value == null || value.first == null) return null;
        try {
          return LLiterature.fromJson(value.first!);
        } on Error catch (err) {
          print(err);
        } on Exception catch (ex) {
          print(ex);
        }
        return null;
      });
}