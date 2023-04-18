import 'package:get_it/get_it.dart';

import '../../data/db_service.dart';
import '../db/learn_literature.dart';
import 'block_segment.dart';
import 'type_enums.dart';

class LBlockContent {
  final LBlockContentType type;

  LBlockContent({required this.type});
}

class LBlockParagraphContent extends LBlockContent {
  final List<LBlockSegment> content;

  LBlockParagraphContent(this.content)
      : super(type: LBlockContentType.paragraph);
}

class LBlockListContent extends LBlockContent {
  final List<LBlockParagraphContent> content;

  LBlockListContent(this.content, {required super.type});
}

class LBlockLiteratureContent extends LBlockContent {
  final Future<List<LLiterature>> literature;

  LBlockLiteratureContent(List<String> refs)
      : literature = _getReferences(refs),
        super(type: LBlockContentType.literature);

  static Future<List<LLiterature>> _getReferences(List<String> refs) {
    DbService dbService = GetIt.instance.get<DbService>();
    return dbService.fetchLiterature(refs);
  }
}
