class LBlock {
  final bool showTypeTitle;
  final String typeTitle;
  final int? number;
  final String? title;
  final String content;

  LBlock.fromJson(Map<dynamic, dynamic> json)
      : showTypeTitle = json["block_type_visible"],
        typeTitle = json["block_type_title"],
        number = json.containsKey("block_number") ? json["block_number"] : null,
        title = json["block_title"],
        content = json["block_content"];

  // eg. Definition 5: Transposed matrix
  // -> {type} {number}: {title}
  String get fullTitle {
    StringBuffer buffer = StringBuffer(typeTitle);
    if (number != null) {
      buffer.write(' $number');
    }
    if (title != null && title!.isNotEmpty) {
      buffer.write(' ($title)');
    }
    return buffer.toString();
  }
}
