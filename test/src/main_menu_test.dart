part of test;

_main_menu_tests() {
  group("main_menu", () {
    MainMenu mainMenu;

    setUp(() {
      var menu = new DivElement()
        ..id = "main-menu";

      var menuFader = new Fader(menu);

      var continueButton = new ButtonElement()
        ..id = "continue-button";

      var newGameButton = new ButtonElement()
        ..id = "new-game-button";

      mainMenu = new MainMenu(menu, menuFader, continueButton, newGameButton);
    });

    test("MainMenu.onContinueGameButtonClick", () {
      expect(mainMenu.onContinueButtonClick, isNotNull);
    });

    test("MainMenu.onNewGameButtonClick", () {
      expect(mainMenu.onNewGameButtonClick, isNotNull);
    });

    test("MainMenu.show", () {
      expect(querySelector("#main-menu"), isNull);

      mainMenu.show();
      expect(querySelector("#main-menu"), isNotNull);

      mainMenu.show();
      expect(querySelector("#main-menu"), isNotNull);
    });

    test("MainMenu.hide", () {
      mainMenu.show();
      expect(querySelector("#main-menu"), isNotNull);

      mainMenu.hide();
      // TODO(btmura): check that menu is hidden
      // expect(querySelector("#main-menu"), isNull);
    });

    tearDown(() {
      mainMenu.hide();
    });
  });
}