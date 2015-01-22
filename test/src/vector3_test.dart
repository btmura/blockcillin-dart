part of test;

_vector3_tests() {
  group("vector3", () {
    test("Vector3", () {
      var v = new Vector3(1.0, 2.0, 3.0);
      expect(v.x, equals(1.0));
      expect(v.y, equals(2.0));
      expect(v.z, equals(3.0));
      expect(v.floatList, equals(new Float32List.fromList([1.0, 2.0, 3.0])));
    });

    test("Vector3.length", () {
      var v = new Vector3(1.0, 2.0, 3.0);
      expect(v.length, equals(math.sqrt(14)));
    });

    test("Vector3 +", () {
      var a = new Vector3(5.0, 3.0, -2.0);
      var b = new Vector3(2.0, -6.0, 1.5);
      expect(a + b, equals(new Vector3(7.0, -3.0, -0.5)));
    });

    test("Vector3 -", () {
      var a = new Vector3(5.0, 3.0, -2.0);
      var b = new Vector3(2.0, -6.0, 1.5);
      expect(a - b, equals(new Vector3(3.0, 9.0, -3.5)));
    });

    test("Vector3 *", () {
      var a = new Vector3(1.0, 2.0, 3.0);
      expect(a * 3.0, equals(new Vector3(3.0, 6.0, 9.0)));
    });

    test("Vector3 == - equal vectors", () {
      var a = new Vector3(3.0, 4.0, 5.0);
      var b = new Vector3(3.0, 4.0, 5.0);
      expect(a == b, isTrue);
    });

    test("Vector3 == - unequal vectors", () {
      var a = new Vector3(1.0, 2.0, 3.0);
      var b = new Vector3(3.0, 4.0, 5.0);
      expect(a == b, isFalse);
    });

    test("Vector3.cross", () {
      var a = new Vector3(5.0, 3.0, -2.0);
      var b = new Vector3(2.0, -6.0, 1.5);
      expect(a.cross(b), equals(new Vector3(-7.5, -11.5, -36.0)));
    });

    test("Vector3.normalize", () {
      var v = new Vector3(2.0, 2.0, 2.0).normalize();
      expect(v.x, inInclusiveRange(0.5773, 0.5774), reason: "x");
      expect(v.y, inInclusiveRange(0.5773, 0.5774), reason: "y");
      expect(v.z, inInclusiveRange(0.5773, 0.5774), reason: "z");
    });
  });
}