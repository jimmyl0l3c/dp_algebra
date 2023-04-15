import 'package:get_it/get_it.dart';

import '../../data/db_service.dart';
import '../db/learn_literature.dart';
import 'type_enums.dart';

class LBlockSegment {
  final LBlockSegmentType type;
  final String content;

  LBlockSegment(this.content, {required this.type});
}

class LLitRefSegment extends LBlockSegment {
  final Future<List<LLiterature>> references;

  LLitRefSegment(String content)
      : references = _getReferences(content),
        super(content, type: LBlockSegmentType.literatureReference);

  static Future<List<LLiterature>> _getReferences(String content) {
    DbService dbService = GetIt.instance.get<DbService>();
    return dbService.fetchLiterature(content.split(','));
  }
}

class LBlockRefSegment extends LBlockSegment {
  final LBlockReferenceType refType;

  LBlockRefSegment(String content, {required this.refType})
      : super(content, type: LBlockSegmentType.reference);
}

class LBlockTabularCellSegment extends LBlockSegment {
  final List<LBlockSegment> cells;
  final int width;

  LBlockTabularCellSegment({
    required String content,
    required this.cells,
    required this.width,
  }) : super(content, type: LBlockSegmentType.tabular);
}
