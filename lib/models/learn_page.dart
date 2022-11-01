import 'learn_block.dart';

class LPage {
  final int id;
  final int articleId;
  final int order;
  final String? title;
  List<LBlock> blocks;

  LPage(this.id, this.articleId, this.order, this.blocks, {this.title});

  LPage.fromJson(Map<dynamic, dynamic> json, {int manArticleId = -1})
      : id = json["page_id"],
        articleId = json["articleId"] ?? manArticleId,
        order = json["order"],
        title = json["title"],
        blocks =
            json.containsKey("blocks") ? _blocksFromJson(json["blocks"]) : [];

  static List<LBlock> _blocksFromJson(List<Map<dynamic, dynamic>> blocks) =>
      blocks.map((b) => LBlock.fromJson(b)).toList();
}