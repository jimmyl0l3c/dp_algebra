import '../models/learn/block_content.dart';
import '../models/learn/block_segment.dart';
import '../models/learn/type_enums.dart';
import '../utils/extensions.dart';

class BlockParser {
  static List<LBlockContent> parseBlock(String block) {
    List<LBlockContent> blockContent = [];
    LBlockContentType currentType = LBlockContentType.paragraph;

    for (var segment in block.splitWithDelim(
      RegExp(r'\\(begin|end){(enumerate|itemize)}'),
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
            blockContent.add(LBlockParagraphContent(_parseTextContent(s)));
          }
          break;
        case LBlockContentType.list:
        case LBlockContentType.enumeratedList:
          blockContent.add(
            LBlockListContent(
              _parseListContent(segment),
              type: currentType,
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

      var tabularRegex =
          RegExp(r"\\begin{tabular}{\s*m{(\d+)(\w+)}\s*l?}(.*?)\\end{tabular}");
      var tabularMatch = tabularRegex.firstMatch(item);
      if (tabularMatch != null) {
        List<LBlockSegment> tabularCells = [];

        // TODO: use the width unit (group 2)
        for (var tabularCell in tabularMatch.group(3)!.split(r"&")) {
          tabularCell = tabularCell.trim();
          if (tabularCell.endsWith(r"\\")) {
            tabularCell = tabularCell.substring(0, tabularCell.length - 2);
          }
          tabularCells.add(LBlockTabularCellSegment(
            content: tabularMatch.group(3)!,
            cells: _parseTextContent(tabularCell),
            width: int.parse(tabularMatch.group(1)!),
          ));
        }

        content.add(LBlockParagraphContent(tabularCells));
        continue;
      }

      content.add(
        LBlockParagraphContent(_parseTextContent(item)),
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
        .splitWithDelim(RegExp(r'\${1,2}|\\(cite|ref){[a-zA-Z\d:\-_,]+}'))) {
      if (segment.trim().isEmpty) continue;

      if (segment.contains(r'$$')) {
        isMath = !isMath;
        isDisplayMath = !isDisplayMath;
        continue;
      } else if (segment.contains(r'$')) {
        isMath = !isMath;
        continue;
      } else if (segment.contains(RegExp(r'\\(cite|ref){[a-zA-Z\d:\-_,]+}'))) {
        var refMatch =
            RegExp(r'\\(cite|ref){([a-zA-Z\d:\-_,]+)}').firstMatch(segment);

        // Fix previous segment if the citation is inside math segment
        if (isMath &&
            (blockContent.last.type == LBlockSegmentType.displayMath ||
                blockContent.last.type == LBlockSegmentType.inlineMath)) {
          var previous = blockContent.removeLast();
          blockContent.add(LBlockSegment(
            '${previous.content}}',
            type: previous.type,
          ));
        }

        if (refMatch != null) {
          if (refMatch.group(1) == 'cite') {
            blockContent.add(LLitRefSegment(refMatch.group(2) ?? 'unknown'));
          } else if (refMatch.group(1) == 'ref') {
            blockContent.add(LBlockRefSegment(
              refMatch.group(2) ?? 'unknown',
              refType: LBlockReferenceType.block,
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

      if (RegExp(r'\\text\{\s*\}').hasMatch(segment.trim())) {
        continue;
      }

      // If segment starts with [.,], add it to previous segment
      if (segment.startsWith(RegExp(r'[.,]')) &&
          (blockContent.last.type == LBlockSegmentType.text ||
              blockContent.last.type == LBlockSegmentType.inlineMath)) {
        var previous = blockContent.removeLast();
        blockContent.add(LBlockSegment(
          '${previous.content}${segment[0]}',
          type: previous.type,
        ));

        // Add space between two inline math blocks
        if (previous.type == LBlockSegmentType.inlineMath &&
            isMath &&
            !isDisplayMath) {
          blockContent.add(LBlockSegment(' ', type: LBlockSegmentType.text));
        }
        segment = segment.substring(1);
      }

      blockContent.add(
        LBlockSegment(
          segment,
          type: isMath
              ? (isDisplayMath
                  ? LBlockSegmentType.displayMath
                  : LBlockSegmentType.inlineMath)
              : LBlockSegmentType.text,
        ),
      );
    }

    return blockContent;
  }
}
