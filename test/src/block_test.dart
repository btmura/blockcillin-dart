import 'package:unittest/unittest.dart';

import 'package:blockcillin/src/block.dart';

main() {
  group("Block", () {
    test("Block(color)", () {
      var block = new Block(BlockColor.red);
      expect(block.color, equals(BlockColor.red));
    });

    test("Block.withRandomColor()", () {
      var block = new Block.withRandomColor(1337);
      expect(block.color, equals(BlockColor.red));
    });

    test("operator ==", () {
      var block = new Block(BlockColor.red);
      var same = new Block(BlockColor.red);
      expect(same, equals(block));

      var different = new Block(BlockColor.blue);
      expect(different, isNot(equals(block)));
    });
  });

  group("BlockColor", () {
    test("random()", () {
      var color = BlockColor.random(3007);
      expect(color, equals(BlockColor.blue));
    });
  });
}
