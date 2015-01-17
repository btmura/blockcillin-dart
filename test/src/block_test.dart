part of test;

_block_tests() {
  group("block", () {
    test("Block", () {
      var block = new Block(BlockColor.RED);
      expect(block.color, equals(BlockColor.RED));
    });

    test("Block.withRandomColor", () {
      var block = new Block.withRandomColor(1337);
      expect(block.color, equals(BlockColor.YELLOW));
    });

    test("Block ==", () {
      var block = new Block(BlockColor.RED);
      var same = new Block(BlockColor.RED);
      expect(same, equals(block));

      var different = new Block(BlockColor.GREEN);
      expect(different, isNot(equals(block)));
    });
  });
}
