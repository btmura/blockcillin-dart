part of tests;

button_bar_tests() {
  var buttonBar;

  group("button_bar", () {
    setUp(() {
      buttonBar = new ButtonBar.attached();
    });

    test("ButtonBar.height", () {
      expect(buttonBar.height, isNotNull);
    });

    test("ButtonBar.onPauseButtonClick", () {
      expect(buttonBar.onPauseButtonClick, isNotNull);
    });

    test("ButtonBar.visible", () {
      expect(buttonBar.visible, isTrue);

      buttonBar.visible = false;
      expect(buttonBar.visible, isFalse);

      buttonBar.visible = true;
      expect(buttonBar.visible, isTrue);
    });

    tearDown(() {
      buttonBar.detach();
    });
  });
}