part of test;

_vector2_tests() {
  group("vector2", () {
    test("Vector2", () {
      var v = new Vector2(1.0, 2.0);
      expect(v.x, equals(1.0));
      expect(v.y, equals(2.0));
      expect(v.floatList, equals(new Float32List.fromList([1.0, 2.0])));
    });

    test("Vector2.x", () {
      var v = new Vector2(1.0, 2.0);
      v.x = 3.0;
      expect(v.x, equals(3.0));
      expect(v.floatList, equals(new Float32List.fromList([3.0, 2.0])));
    });

    test("Vector2.y", () {
      var v = new Vector2(1.0, 2.0);
      v.y = 3.0;
      expect(v.y, equals(3.0));
      expect(v.floatList, equals(new Float32List.fromList([1.0, 3.0])));
    });

    test("Vector2 *", () {
      var v1 = new Vector2(1.0, 2.0);
      var v2 = v1 * 3.0;
      expect(v2.x, equals(3.0));
      expect(v2.y, equals(6.0));
      expect(v2.floatList, equals(new Float32List.fromList([3.0, 6.0])));
    });

    test("Vector2.toString", () {
      var v = new Vector2(1.0, 2.0);
      expect(v.toString(), equals("(1.0, 2.0)"));
    });
  });
}