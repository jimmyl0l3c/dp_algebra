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

  LBlock.fromJson(Map<dynamic, dynamic> json, {int manPageId = -1})
      : id = json["block_id"],
        pageId = json["pageId"] ?? manPageId,
        type = _getType(json["content"]),
        number = null,
        title = json["title"],
        content = json["content"].substring(json["content"].indexOf(';') + 1);

  static BlockType _getType(String content) {
    switch (content.substring(0, content.indexOf(';'))) {
      case 'def':
        return BlockType.definition;
      case 'lemma':
        return BlockType.lemma;
      case 'theorem':
        return BlockType.theorem;
      case 'consequence':
        return BlockType.consequence;
      case 'remark':
        return BlockType.remark;
      case 'img':
        return BlockType.image;
      case 'text':
      default:
        return BlockType.none;
    }
  }
}

enum BlockType {
  definition(title: 'Definice'),
  theorem(title: 'Věta'),
  lemma(title: 'Lemma'),
  consequence(title: 'Důsledek'),
  remark(title: 'Poznámka'),
  image,
  none;

  final String? title;

  const BlockType({this.title});
}
