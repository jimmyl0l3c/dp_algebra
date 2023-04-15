import 'block_segment.dart';
import 'type_enums.dart';

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
