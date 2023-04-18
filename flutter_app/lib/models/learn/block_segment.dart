import 'type_enums.dart';

class LBlockSegment {
  final LBlockSegmentType type;
  final String content;

  LBlockSegment(this.content, {required this.type});
}

class LLitRefSegment extends LBlockSegment {
  LLitRefSegment(List<int> refs)
      : super(
          '[${refs.join(", ")}]',
          type: LBlockSegmentType.literatureReference,
        );
}

class LBlockRefSegment extends LBlockSegment {
  final LBlockReferenceType refType;

  LBlockRefSegment(String content, {required this.refType})
      : super(content, type: LBlockSegmentType.reference);
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
