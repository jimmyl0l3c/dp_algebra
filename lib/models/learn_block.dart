class LBlock {
  final int id;
  final int pageId;

  // eg. Definition 5: Transposed matrix
  // -> {type} {number}: {title}
  final BlockType type;
  final int? number;
  final String? title;
  final String content;

  final BlockSize? size; // TODO: remove BockSize? (or make it non-nullable)
  final bool isImage;

  LBlock({
    required this.id,
    required this.pageId,
    this.type = BlockType.none,
    this.number,
    this.title,
    required this.content,
    this.size,
    this.isImage = false,
  });
}

enum BlockType {
  definition,
  theorem,
  lemma,
  consequence,
  remark,
  none;
}

enum BlockSize {
  fullPage(4),
  long(3),
  normal(2),
  short(1);

  final int value;

  const BlockSize(this.value);
}
