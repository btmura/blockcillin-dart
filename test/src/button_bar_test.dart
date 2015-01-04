part of test;

_button_bar_tests() {
  group("button_bar", () {
    ButtonBar buttonBar;

    setUp(() {
      var buttonBarElement = new DivElement();
      var pauseButton = new ButtonElement();
      var fader = new Fader(buttonBarElement);
      buttonBar = new ButtonBar(buttonBarElement, pauseButton, fader);
    });

    test("ButtonBar.height", () {
      expect(buttonBar.height, isNotNull);
    });

    test("ButtonBar.onPauseButtonClick", () {
      expect(buttonBar.onPauseButtonClick, isNotNull);
    });
  });
}