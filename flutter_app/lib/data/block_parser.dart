import '../models/learn/block_content.dart';
import '../models/learn/block_segment.dart';
import '../models/learn/type_enums.dart';
import '../utils/extensions.dart';

class BlockParser {
  static const String _refRegex = r'\\(cite|ref){[a-zA-Z\d:\-_,]+}';
  static const String _tabularRegex =
      r"\\begin{tabular}{\s*m{(\d+)(\w+)}\s*l?}(.*?)\\end{tabular}";

  LBlockContentType currentType = LBlockContentType.paragraph;

  List<LBlockContent> parseBlock(String block) {
    currentType = LBlockContentType.paragraph;
    List<LBlockContent> blockContent = [];

    for (var segment in block.splitWithDelim(
      RegExp(r'\\(begin|end){(enumerate|itemize)}'),
    )) {
      segment = segment.trim();
      if (segment.isEmpty || _updateType(segment)) {
        continue;
      }

      blockContent.addAll(_parseSegment(segment));
    }

    return blockContent;
  }

  bool _updateType(String segment) {
    if (segment.contains('begin{itemize')) {
      currentType = LBlockContentType.list;
    } else if (segment.contains('begin{enumerate')) {
      currentType = LBlockContentType.enumeratedList;
    } else if (segment.contains(RegExp(r'\\end{(enumerate|itemize)}'))) {
      currentType = LBlockContentType.paragraph;
    } else {
      return false;
    }
    return true;
  }

  List<LBlockContent> _parseSegment(String segment) {
    switch (currentType) {
      case LBlockContentType.paragraph:
        return segment
            .split(r'\break')
            .map((s) => LBlockParagraphContent(_parseTextContent(s)))
            .toList();
      case LBlockContentType.list:
      case LBlockContentType.enumeratedList:
        return [
          LBlockListContent(
            _parseListContent(segment),
            type: currentType,
          )
        ];
    }
  }

  List<LBlockParagraphContent> _parseListContent(String block) {
    List<LBlockParagraphContent> content = [];

    for (var item in block.split(r'\item')) {
      item = item.trim();
      if (item.isEmpty) continue;

      var tabularMatch = RegExp(_tabularRegex).firstMatch(item);
      if (tabularMatch != null) {
        content.add(LBlockParagraphContent(_getTabularCells(tabularMatch)));
        continue;
      }

      content.add(LBlockParagraphContent(_parseTextContent(item)));
    }

    return content;
  }

  List<LBlockSegment> _getTabularCells(RegExpMatch tabularMatch) =>
      tabularMatch.group(3)!.split(r"&").map(
        (tabularCell) {
          tabularCell = tabularCell.trim();
          if (tabularCell.endsWith(r"\\")) {
            tabularCell = tabularCell.substring(0, tabularCell.length - 2);
          }

          // TODO: use the width unit (group 2)
          return LBlockTabularCellSegment(
            tabularMatch.group(3)!,
            cells: _parseTextContent(tabularCell),
            width: int.parse(tabularMatch.group(1)!),
          );
        },
      ).toList();

  List<LBlockSegment> _parseTextContent(String block) {
    bool isMath = false;
    bool isDisplayMath = false;
    List<LBlockSegment> blockContent = [];
    for (var segment in block
        .trim()
        .splitWithDelim(RegExp([r'\${1,2}', _refRegex].join('|')))) {
      if (segment.trim().isEmpty) continue;

      if (segment.contains(r'$$')) {
        isMath = !isMath;
        isDisplayMath = !isDisplayMath;
        continue;
      } else if (segment.contains(r'$')) {
        isMath = !isMath;
        continue;
      } else if (segment.contains(RegExp(_refRegex))) {
        var refMatch = RegExp(_refRegex).firstMatch(segment);

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
