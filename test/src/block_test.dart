import 'package:blockcillin/src/block.dart';
import 'package:unittest/unittest.dart';

main() {
  test("Block.color", () {
    var b = new Block(BlockColor.RED);
    expect(b.color, equals(BlockColor.RED));
  });
}
