class LRef {
  final String refName;
  final int blockType;
  final int blockNumber;
  final int pageId;
  final int articleId;
  final int chapterId;

  LRef(
    this.refName,
    this.blockType,
    this.blockNumber,
    this.pageId,
    this.articleId,
    this.chapterId,
  );

  LRef.fromJson(Map<dynamic, dynamic> json)
      : refName = json["ref_label"],
        blockType = json["block_type"],
        blockNumber = json["block_number"],
        pageId = json["page_order"] + 1,
        articleId = json["article"],
        chapterId = json["chapter"];
}
