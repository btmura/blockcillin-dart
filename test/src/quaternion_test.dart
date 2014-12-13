part of test;

_quaternion_tests() {
  group("quaternion", () {
    test("Quaternion(x, y, z, w)", () {
      var q = new Quaternion(1.0, 2.0, 3.0, 4.0);
      expect(q.x, equals(1.0));
      expect(q.y, equals(2.0));
      expect(q.z, equals(3.0));
      expect(q.w, equals(4.0));
    });
  });
}