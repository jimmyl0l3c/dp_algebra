import '../models/learn/block_content.dart';
import '../utils/extensions.dart';

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
          for (var s in segment.split(r'\break')) {
            blockContent.add(
              LBlockParagraphContent(
                content: _parseTextContent(s),
              ),
            );
          }
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
        .splitWithDelim(RegExp(r'\${1,2}|\\(cite|ref){[a-zA-Z:\-_,]+}'))) {
      if (segment.trim().isEmpty) continue;

      if (segment.contains(r'$$')) {
        isMath = !isMath;
        isDisplayMath = !isDisplayMath;
        continue;
      } else if (segment.contains(r'$')) {
        isMath = !isMath;
        continue;
      } else if (segment.contains(RegExp(r'\\(cite|ref){[a-zA-Z:\-_,]+}'))) {
        var refMatch =
            RegExp(r'\\(cite|ref){([a-zA-Z:\-_,]+)}').firstMatch(segment);

        // Fix previous segment if the citation is inside math segment
        if (isMath &&
            (blockContent.last.type == LBlockSegmentType.displayMath ||
                blockContent.last.type == LBlockSegmentType.inlineMath)) {
          var previous = blockContent.removeLast();
          blockContent.add(LBlockSegment(
            type: previous.type,
            content: '${previous.content}}',
          ));
        }

        if (refMatch != null) {
          if (refMatch.group(1) == 'cite') {
            blockContent.add(LLitRefSegment(
              content: refMatch.group(2) ?? 'unknown',
            ));
          } else if (refMatch.group(1) == 'ref') {
            blockContent.add(LBlockRefSegment(
              refType: LBlockReferenceType.block,
              content: refMatch.group(2) ?? 'unknown',
            ));
          }
        }
        continue;
      }

      // Fix segment if there was citation inside math segment before it
      if (isMath &&
          segment.contains('}') &&
          (!segment.contains('{') ||
              (segment.indexOf('}') < segment.indexOf('{')))) {
        segment = '\\text{$segment';
      }

      if (segment.contains(r'$')) continue;

      if (RegExp(r'\\text\{\s*\}').hasMatch(segment.trim())) continue;

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
