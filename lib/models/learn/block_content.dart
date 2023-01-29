class LBlockSegment {
  final LBlockSegmentType type;
  final String content;

  LBlockSegment({required this.type, required this.content});
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
}

enum LBlockContentType {
  paragraph,
  list,
  enumeratedList,
}
