part of test;

_cell_tests() {
  group("cell", () {
    test("Cell", () {
      var block = new Block.withRandomColor();
      var cell = new Cell(block);
      expect(cell.block, equals(block));
    });

    test("Cell.withRandomBlock", () {
      var cell = new Cell.withRandomBlock(1337);
      expect(cell.block, equals(new Block(BlockColor.red)));
    });

    test("Cell.block", () {
      var cell = new Cell.withRandomBlock();
      expect(cell.block, isNotNull);

      cell.block = null;
      expect(cell.block, isNull);
    });
  });
}
