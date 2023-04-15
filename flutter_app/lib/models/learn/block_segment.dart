import 'package:get_it/get_it.dart';

import '../../data/db_service.dart';
import '../db/learn_literature.dart';
import 'type_enums.dart';

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

class LBlockTabularCellSegment extends LBlockSegment {
  final List<LBlockSegment> cells;
  final int width;

  LBlockTabularCellSegment({
    required String content,
    required this.cells,
    required this.width,
  }) : super(type: LBlockSegmentType.tabular, content: content);
}
