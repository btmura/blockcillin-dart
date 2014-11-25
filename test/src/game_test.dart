import 'package:blockcillin/src/game.dart';
import 'package:unittest/unittest.dart';

main() {
  test("Game constructor", () {
    var g = new Game();
    expect("Hello, blockcillin!", g.text);
  });
}
