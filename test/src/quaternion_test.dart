part of test;

_quaternion_tests() {
  group("quaternion", () {
    test("Quaternion", () {
      var q = new Quaternion(1.0, 2.0, 3.0, 4.0);
      expect(q.x, equals(1.0), reason: "x");
      expect(q.y, equals(2.0), reason: "y");
      expect(q.z, equals(3.0), reason: "z");
      expect(q.w, equals(4.0), reason: "w");
      expect(q.storage, equals(new Float32List.fromList([1.0, 2.0, 3.0, 4.0])));
    });

    test("Quaternion.fromAxisAngle - rotate 0 around (1, 0, 0)", () {
      var q = new Quaternion.fromAxisAngle(new Vector3(1.0, 0.0, 0.0), 0.0);
      expect(q.x, equals(0.0), reason: "x");
      expect(q.y, equals(0.0), reason: "y");
      expect(q.z, equals(0.0), reason: "z");
      expect(q.w, equals(1.0), reason: "w");
    });

    test("Quaternion.fromAxisAngle - rotate PI/2 around (1, 0, 0)", () {
      var q = new Quaternion.fromAxisAngle(new Vector3(1.0, 0.0, 0.0), math.PI / 2);
      expect(q.x, inInclusiveRange(0.7071, 0.7072), reason: "x");
      expect(q.y, equals(0.0), reason: "y");
      expect(q.z, equals(0.0), reason: "z");
      expect(q.w, inInclusiveRange(0.7071, 0.7072), reason: "w");
    });

    test("Quaternion.fromAxisAngle - rotate PI around (1, 0, 0)", () {
      var q = new Quaternion.fromAxisAngle(new Vector3(1.0, 0.0, 0.0), math.PI);
      expect(q.x, equals(1.0), reason: "x");
      expect(q.y, equals(0.0), reason: "y");
      expect(q.z, equals(0.0), reason: "z");
      expect(q.w, inInclusiveRange(0.0, 0.0001), reason: "w");
    });

    test("Quaternion.fromAxisAngle - rotate PI/2 around (0, 1, 0)", () {
      var q = new Quaternion.fromAxisAngle(new Vector3(0.0, 1.0, 0.0), math.PI / 2);
      expect(q.x, equals(0.0), reason: "x");
      expect(q.y, inInclusiveRange(0.7071, 0.7072), reason: "y");
      expect(q.z, equals(0.0), reason: "z");
      expect(q.w, inInclusiveRange(0.7071, 0.7072), reason: "w");
    });

    test("Quaternion.fromAxisAngle - rotate PI around (0, 1, 0)", () {
      var q = new Quaternion.fromAxisAngle(new Vector3(0.0, 1.0, 0.0), math.PI);
      expect(q.x, equals(0.0), reason: "x");
      expect(q.y, equals(1.0), reason: "y");
      expect(q.z, equals(0.0), reason: "z");
      expect(q.w, inInclusiveRange(0.0, 0.0001), reason: "w");
    });

    test("Quaternion.fromVector", () {
      var q = new Quaternion.fromVector(new Vector3(1.0, 2.0, 3.0));
      expect(q.x, equals(1.0));
      expect(q.y, equals(2.0));
      expect(q.z, equals(3.0));
      expect(q.w, isZero);
    });

    test("Quaternion *", () {
      var q1 = new Quaternion.fromAxisAngle(new Vector3(0.0, 1.0, 0.0), math.PI / 2);
      var q2 = new Quaternion.fromAxisAngle(new Vector3(1.0, 0.0, 0.0), math.PI / 4);
      var q3 = q2 * q1;
      expect(q3.x, inInclusiveRange(0.2705, 0.2706), reason: "x");
      expect(q3.y, inInclusiveRange(0.6532, 0.6533), reason: "y");
      expect(q3.z, inInclusiveRange(0.2705, 0.2706), reason: "z");
      expect(q3.w, inInclusiveRange(0.6532, 0.6533), reason: "w");
    });

    test("Quaternion.conjugate", () {
      var q = new Quaternion(1.0, 2.0, 3.0, 4.0).conjugate();
      expect(q.x, equals(-1.0));
      expect(q.y, equals(-2.0));
      expect(q.z, equals(-3.0));
      expect(q.w, equals(4.0));
    });

    test("Quaternion.rotate", () {
      var q1 = new Quaternion.fromAxisAngle(new Vector3(0.0, 1.0, 0.0), math.PI / 2);
      var q2 = new Quaternion.fromAxisAngle(new Vector3(1.0, 0.0, 0.0), math.PI / 4);
      var q3 = q2 * q1;

      var v1 = new Vector3(1.0, 0.0, 0.0);
      var v2 = q3.rotate(v1);
      expect(v2.x, equals(0.0), reason: "x");
      expect(v2.y, inInclusiveRange(0.7071, 0.7072), reason: "y");
      expect(v2.z, inInclusiveRange(-0.7072, -0.7071), reason: "z");

      var v3 = q1.rotate(v1);
      expect(v3.x, equals(0.0), reason: "x");
      expect(v3.y, equals(0.0), reason: "y");
      expect(v3.z, inInclusiveRange(-1.0, -0.999), reason: "z");

      var v4 = q2.rotate(v3);
      expect(v4.x, equals(0.0), reason: "x");
      expect(v4.y, inInclusiveRange(0.7071, 0.7072), reason: "y");
      expect(v4.z, inInclusiveRange(-0.7072, -0.7071), reason: "z");
    });
  });
}
