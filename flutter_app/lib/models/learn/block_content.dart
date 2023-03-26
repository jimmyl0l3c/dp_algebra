import 'package:get_it/get_it.dart';

import '../../data/db_service.dart';
import '../db/learn_literature.dart';

class LBlockSegment {
  final LBlockSegmentType type;
  final String content;

  LBlockSegment({required this.type, required this.content});
}

class LLitRefSegment extends LBlockSegment {
  final Future<List<LLiterature>> references;

  LLitRefSegment({required String content})
      : references = _getReferences(content),
        super(type: LBlockSegmentType.literatureReference, content: content);

  static Future<List<LLiterature>> _getReferences(String content) {
    DbService dbService = GetIt.instance.get<DbService>();
    return dbService.fetchLiterature(content.split(','));
  }
}

class LBlockRefSegment extends LBlockSegment {
  final LBlockReferenceType refType;

  LBlockRefSegment({required this.refType, required String content})
      : super(type: LBlockSegmentType.reference, content: content);
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
  literatureReference,
}

enum LBlockContentType {
  paragraph,
  list,
  enumeratedList,
}

enum LBlockReferenceType {
  image,
  block,
}
