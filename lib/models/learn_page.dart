import 'package:dp_algebra/models/learn_block.dart';

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
        blocks = json.containsKey("blocks")
            ? _blocksFromJson(json["blocks"], json["page_id"])
            : [];

  static List<LBlock> _blocksFromJson(List<dynamic> blocks, int pageId) =>
      blocks.map((b) => LBlock.fromJson(b, manPageId: pageId)).toList();
}
