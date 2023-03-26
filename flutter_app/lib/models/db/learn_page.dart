import 'learn_block.dart';

class LPage {
  List<LBlock> blocks;

  LPage(this.blocks);

  LPage.fromJson(List<dynamic> json)
      : blocks = json.map((b) => LBlock.fromJson(b)).toList();
}
