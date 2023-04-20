import 'package:collection/collection.dart';

import 'type_enums.dart';

class LBlockSegment {
  final LBlockSegmentType type;
  final String content;

  LBlockSegment(this.content, {required this.type});

  LBlockSegment.literature(List<int> refs)
      : content = '[${refs.sorted((a, b) => a.compareTo(b)).join(", ")}]',
        type = LBlockSegmentType.literatureReference;

  LBlockSegment.blockRef(this.content)
      : type = LBlockSegmentType.blockReference;
}

class LBlockTabularCellSegment extends LBlockSegment {
  final List<LBlockSegment> cells;
  final int width;

  LBlockTabularCellSegment(
    String content, {
    required this.cells,
    required this.width,
  }) : super(content, type: LBlockSegmentType.tabular);
}
