part of test;

_block_tests() {
  group("block", () {
    test("Block", () {
      var block = new Block(BlockColor.red);
      expect(block.color, equals(BlockColor.red));
    });

    test("Block.withRandomColor", () {
      var block = new Block.withRandomColor(1337);
      expect(block.color, equals(BlockColor.red));
    });

    test("Block ==", () {
      var block = new Block(BlockColor.red);
      var same = new Block(BlockColor.red);
      expect(same, equals(block));

      var different = new Block(BlockColor.blue);
      expect(different, isNot(equals(block)));
    });

    test("BlockColor.random", () {
      var color = BlockColor.random(3007);
      expect(color, equals(BlockColor.blue));
    });
  });
}
