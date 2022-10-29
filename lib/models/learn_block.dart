class LBlock {
  final int id;
  final int pageId;

  // eg. Definition 5: Transposed matrix
  // -> {type} {number}: {title}
  final BlockType type;
  final int? number;
  final String? title;
  final String content;

  LBlock({
    required this.id,
    required this.pageId,
    this.type = BlockType.none,
    this.number,
    this.title,
    required this.content,
  });

  LBlock.fromJson(Map<dynamic, dynamic> json)
      : id = json["block_id"],
        pageId = json["pageId"],
        type = _getType(json["content"]),
        number = null,
        title = json["title"],
        content = json["content"];

  static BlockType _getType(String content) {
    // TODO: implement logic
    return BlockType.none;
  }
}

enum BlockType {
  definition,
  theorem,
  lemma,
  consequence,
  remark,
  image,
  none;
}
