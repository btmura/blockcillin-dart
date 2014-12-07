part of test;

_main_menu_tests() {

  var menu;
  var continueGameButton;
  var newGameButton;
  var mainMenu;

  group("main_menu", () {
    setUp(() {
      menu = new DivElement()
        ..id = "main-menu";

      continueGameButton = new ButtonElement()
        ..id = "continue-game-button";

      newGameButton = new ButtonElement()
        ..id = "new-game-button";

      mainMenu = new MainMenu(menu, continueGameButton, newGameButton);
    });

    test("MainMenu.onContinueGameButtonClick", () {
      expect(mainMenu.onContinueGameButtonClick, isNotNull);
    });

    test("MainMenu.onNewGameButtonClick", () {
      expect(mainMenu.onNewGameButtonClick, isNotNull);
    });

    test("MainMenu.visible = true", () {
      expect(querySelector("#main-menu"), isNull);

      mainMenu.visible = true;
      expect(querySelector("#main-menu"), isNotNull);

      mainMenu.visible = true;
      expect(querySelector("#main-menu"), isNotNull);
    });

    test("MainMenu.visible = false", () {
      mainMenu.visible = true;
      expect(querySelector("#main-menu"), isNotNull);

      mainMenu.visible = false;
      // TODO(btmura): check that menu is hidden
      // expect(querySelector("#main-menu"), isNull);
    });

    tearDown(() {
      mainMenu.visible = false;
    });
  });
}