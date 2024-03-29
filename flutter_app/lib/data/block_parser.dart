import 'dart:collection';

import 'package:collection/collection.dart';

import '../models/learn/block_content.dart';
import '../models/learn/block_segment.dart';
import '../models/learn/type_enums.dart';
import '../utils/extensions.dart';

class BlockParser {
  static const String _refRegex = r'\\(cite|ref){([a-zA-Z\d:\-_,]+)}';
  static const String _tabularRegex =
      r'\\begin{tabular}{\s*m{(\d+)(\w+)}\s*l?}(.*?)\\end{tabular}';

  LBlockContentType _currentType = LBlockContentType.paragraph;
  LinkedHashSet<String> usedLiterature = LinkedHashSet();

  List<LBlockContent> parseBlock(String block, {bool isLastBlock = false}) {
    _currentType = LBlockContentType.paragraph;
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

    if (isLastBlock && usedLiterature.isNotEmpty) {
      blockContent.add(LBlockLiteratureContent(usedLiterature.toList()));
    }
    return blockContent;
  }

  bool _updateType(String segment) {
    if (segment.contains('begin{itemize')) {
      _currentType = LBlockContentType.list;
    } else if (segment.contains('begin{enumerate')) {
      _currentType = LBlockContentType.enumeratedList;
    } else if (segment.contains(RegExp(r'\\end{(enumerate|itemize)}'))) {
      _currentType = LBlockContentType.paragraph;
    } else {
      return false;
    }
    return true;
  }

  List<LBlockContent> _parseSegment(String segment) {
    switch (_currentType) {
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
            type: _currentType,
          )
        ];
      case LBlockContentType.literature:
        // Should never happen
        return [];
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
      tabularMatch.group(3)!.split(r'&').map(
        (tabularCell) {
          tabularCell = tabularCell.trim();
          if (tabularCell.endsWith(r'\\')) {
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
      }

      var refMatch = RegExp(_refRegex).firstMatch(segment);
      if (refMatch != null) {
        // Fix previous segment if the citation is inside math segment
        if (isMath) _fixPreviousMathSegment(blockContent);
        blockContent.add(_parseRef(refMatch)!);
        continue;
      }

      // Fix segment if there was citation inside math segment before it
      if (isMath &&
          segment.contains('}') &&
          (!segment.contains('{') ||
              (segment.indexOf('}') < segment.indexOf('{')))) {
        segment = '\\text{$segment';
      }

      if (segment.contains(r'$') ||
          RegExp(r'\\text\{\s*\}').hasMatch(segment.trim())) {
        continue;
      }

      // If segment starts with [.,], add it to previous segment
      segment = _appendPunctuationToPreviousSegment(
        blockContent,
        segment,
        isMath && !isDisplayMath,
      );

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

  LBlockSegment? _parseRef(RegExpMatch refMatch) {
    if (refMatch.group(1) == 'cite') {
      var litRefs = refMatch.group(2)!.split(',');
      usedLiterature.addAll(litRefs);

      List<int> refIndexes = [];
      usedLiterature.forEachIndexed((index, element) {
        if (litRefs.contains(element)) {
          refIndexes.add(index + 1);
        }
      });

      return LBlockSegment.literature(refIndexes);
    } else if (refMatch.group(1) == 'ref') {
      return LBlockSegment.blockRef(refMatch.group(2) ?? 'unknown');
    }
    return null;
  }

  String _appendPunctuationToPreviousSegment(
    List<LBlockSegment> blockContent,
    String segment,
    bool isInlineMath,
  ) {
    if (segment.startsWith(RegExp(r'[.,]')) &&
        (blockContent.last.type == LBlockSegmentType.text ||
            blockContent.last.type == LBlockSegmentType.inlineMath)) {
      var previous = blockContent.removeLast();
      blockContent.add(LBlockSegment(
        '${previous.content}${segment[0]}',
        type: previous.type,
      ));

      return segment.substring(1);
    }

    // Add space between two inline math blocks
    if (blockContent.isNotEmpty &&
        blockContent.last.type == LBlockSegmentType.inlineMath &&
        isInlineMath) {
      blockContent.add(LBlockSegment(' ', type: LBlockSegmentType.text));
    }

    return segment;
  }

  void _fixPreviousMathSegment(List<LBlockSegment> blockContent) {
    if ((blockContent.last.type == LBlockSegmentType.displayMath ||
        blockContent.last.type == LBlockSegmentType.inlineMath)) {
      var previous = blockContent.removeLast();
      blockContent.add(LBlockSegment(
        '${previous.content}}',
        type: previous.type,
      ));
    }
  }
}
