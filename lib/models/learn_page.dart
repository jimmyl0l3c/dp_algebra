import 'learn_block.dart';

class LPage {
  final int id;
  final int articleId;
  final String? title;
  List<LBlock> blocks;

  LPage(this.id, this.articleId, this.blocks, {this.title});
}
