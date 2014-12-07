part of test;

_main_menu_tests() {

  var menu;
  var newGameButton;
  var mainMenu;

  group("main_menu", () {
    setUp(() {
      menu = new DivElement()
        ..id = "main-menu";
      newGameButton = new ButtonElement()
        ..id = "new-game-button";
      mainMenu = new MainMenu(menu, newGameButton);
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