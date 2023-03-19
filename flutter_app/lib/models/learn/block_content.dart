import 'package:dp_algebra/data/db_service.dart';
import 'package:dp_algebra/models/db/learn_literature.dart';
import 'package:get_it/get_it.dart';

class LBlockSegment {
  final LBlockSegmentType type;
  final String content;

  LBlockSegment({required this.type, required this.content});
}

class LBlockRefSegment extends LBlockSegment {
  final LBlockReferenceType refType;
  final Future<List<LLiterature>> references;

  LBlockRefSegment({required this.refType, required String content})
      : references = refType == LBlockReferenceType.literature
            ? _getReferences(content)
            : Future(() => []),
        super(type: LBlockSegmentType.reference, content: content);

  static Future<List<LLiterature>> _getReferences(String content) {
    DbService dbService = GetIt.instance.get<DbService>();
    return dbService.fetchLiterature(content.split(','));
  }
}

class LBlockContent {
  final LBlockContentType type;

  LBlockContent({required this.type});
}

class LBlockParagraphContent extends LBlockContent {
  final List<LBlockSegment> content;

  LBlockParagraphContent({required this.content})
      : super(type: LBlockContentType.paragraph);
}

class LBlockListContent extends LBlockContent {
  final List<LBlockParagraphContent> content;

  LBlockListContent({required super.type, required this.content});
}

enum LBlockSegmentType {
  text,
  inlineMath,
  displayMath,
  reference,
}

enum LBlockContentType {
  paragraph,
  list,
  enumeratedList,
}

enum LBlockReferenceType {
  literature,
  block,
}
