part of test;

_main_menu_tests() {
  var menu;

  group("main_menu", () {
    setUp(() {
      menu = new MainMenu();
    });

    test("MainMenu.onNewGameButtonClick", () {
      expect(menu.onNewGameButtonClick, isNotNull);
    });

    test("MainMenu.visible = true", () {
      expect(querySelector("#main-menu"), isNull);

      menu.visible = true;
      expect(querySelector("#main-menu"), isNotNull);

      menu.visible = true;
      expect(querySelector("#main-menu"), isNotNull);
    });

    test("MainMenu.visible = false", () {
      menu.visible = true;
      expect(querySelector("#main-menu"), isNotNull);

      menu.visible = false;
      // TODO(btmura): check that menu is hidden
      // expect(querySelector("#main-menu"), isNull);
    });

    tearDown(() {
      menu.visible = false;
    });
  });
}