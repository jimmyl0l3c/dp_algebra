import 'package:dp_algebra/models/learn/block_content.dart';
import 'package:dp_algebra/utils/extensions.dart';

class BlockParser {
  static List<LBlockContent> parseBlock(String block) {
    List<LBlockContent> blockContent = [];
    LBlockContentType currentType = LBlockContentType.paragraph;

    for (var segment in block.splitWithDelim(
      RegExp(r'(\\begin{|\\end{)(enumerate|itemize)}'),
    )) {
      segment = segment.trim();
      if (segment.isEmpty) continue;

      if (segment.contains('begin{itemize')) {
        currentType = LBlockContentType.list;
        continue;
      } else if (segment.contains('begin{enumerate')) {
        currentType = LBlockContentType.enumeratedList;
        continue;
      } else if (segment.contains(RegExp(r'\\end{(enumerate|itemize)}'))) {
        currentType = LBlockContentType.paragraph;
        continue;
      }

      switch (currentType) {
        case LBlockContentType.paragraph:
          blockContent.add(
            LBlockParagraphContent(
              content: _parseTextContent(segment),
            ),
          );
          break;
        case LBlockContentType.list:
        case LBlockContentType.enumeratedList:
          blockContent.add(
            LBlockListContent(
              type: currentType,
              content: _parseListContent(segment),
            ),
          );
          break;
      }
    }

    return blockContent;
  }

  static List<LBlockParagraphContent> _parseListContent(String block) {
    List<LBlockParagraphContent> content = [];

    for (var item in block.split(r'\item')) {
      item = item.trim();

      if (item.isEmpty) continue;

      content.add(
        LBlockParagraphContent(
          content: _parseTextContent(item),
        ),
      );
    }

    return content;
  }

  static List<LBlockSegment> _parseTextContent(String block) {
    bool isMath = false;
    bool isDisplayMath = false;
    List<LBlockSegment> blockContent = [];
    for (var segment in block
        .trim()
        .splitWithDelim(RegExp(r'\${1,2}|\\(cite|ref){[a-zA-Z:\-_]+}'))) {
      if (segment.isEmpty) continue;

      if (segment.contains(r'$$')) {
        isMath = !isMath;
        isDisplayMath = !isDisplayMath;
        continue;
      } else if (segment.contains(r'$')) {
        isMath = !isMath;
        continue;
      } else if (segment.contains(RegExp(r'\\(cite|ref){[a-zA-Z:\-_]+}'))) {
        var refMatch = RegExp(r'\\(?<type>(cite|ref)){(?<ref>[a-zA-Z:\-_]+)}')
            .firstMatch(segment);

        if (refMatch != null) {
          if (refMatch.namedGroup('type') == 'cite') {
            blockContent.add(LBlockRefSegment(
              refType: LBlockReferenceType.literature,
              content: refMatch.namedGroup('ref') ?? 'unknown',
            ));
          } else if (refMatch.namedGroup('type') == 'ref') {
            blockContent.add(LBlockRefSegment(
              refType: LBlockReferenceType.block,
              content: refMatch.namedGroup('ref') ?? 'unknown',
            ));
          }
        }
        continue;
      }

      if (segment.contains(r'$')) continue;

      blockContent.add(
        LBlockSegment(
          type: isMath
              ? (isDisplayMath
                  ? LBlockSegmentType.displayMath
                  : LBlockSegmentType.inlineMath)
              : LBlockSegmentType.text,
          content: segment,
        ),
      );
    }

    return blockContent;
  }
}
