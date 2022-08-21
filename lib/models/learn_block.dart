class LBlock {
  final int id;
  final String content;
  final bool isImage;
  final int pageId;
  // int size (vertical size 1-4, 1 => 1 * viewportSize/4)
  // TODO: add type (Definition, Theorem, ...)

  LBlock(this.id, this.content, this.isImage, this.pageId);
}
