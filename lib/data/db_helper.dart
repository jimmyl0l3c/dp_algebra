import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:dp_algebra/models/learn_chapter.dart';

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
            ..whereClause = "id = $id"
            ..relationsDepth = 1
            ..related = ['articles'])
          .then((value) {
        if (value == null || value.first == null) return null;
        return LChapter.fromJson(value.first!);
      });
}
