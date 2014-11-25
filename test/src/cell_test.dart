import 'package:blockcillin/src/block.dart';
import 'package:blockcillin/src/cell.dart';
import 'package:unittest/unittest.dart';

main() {
  test("Cell.withBlock", () {
    var block = new Block(BlockColor.RED);
    var cell = new Cell.withBlock(block);
    expect(cell.block, equals(block));

    cell.block = null;
    expect(cell.block, isNull);
  });
}
