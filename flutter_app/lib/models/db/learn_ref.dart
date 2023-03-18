class LRef {
  final String refName;
  final int blockType;
  final int blockNumber;
  final int pageId;
  final int articleId;
  final int chapterId;

  LRef({
    required this.refName,
    required this.blockType,
    required this.blockNumber,
    required this.pageId,
    required this.articleId,
    required this.chapterId,
  });

  LRef.fromJson(Map<dynamic, dynamic> json)
      : refName = json["ref_name"],
        blockType = json["block_type"],
        blockNumber = json["block_number"],
        pageId = json["page"],
        articleId = json["article"],
        chapterId = json["chapter"];
}
