import 'learn_block.dart';

class LPage {
  final int id;
  final String title;
  List<LBlock> blocks;
  final int articleId;

  LPage(this.id, this.title, this.blocks, this.articleId);
}
