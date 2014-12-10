part of test;

_vector3_tests() {
  group("vector3", () {
    test("Vector3.operator -(o)", () {
      var a = new Vector3(5.0, 3.0, -2.0);
      var b = new Vector3(2.0, -6.0, 1.5);
      expect(a - b, equals(new Vector3(3.0, 9.0, -3.5)));
    });

    test("Vector3.cross(o)", () {
      var a = new Vector3(5.0, 3.0, -2.0);
      var b = new Vector3(2.0, -6.0, 1.5);
      expect(a.cross(b), equals(new Vector3(-7.5, -11.5, -36.0)));
    });
  });
}