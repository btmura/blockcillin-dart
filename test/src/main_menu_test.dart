part of tests;

main_menu_tests() {
  var menu;

  group("main_menu", () {
    setUp(() {
      menu = new MainMenu();
    });

    test("MainMenu.show()", () {
      expect(querySelector("#main-menu"), isNull);

      menu.show();
      expect(querySelector("#main-menu"), isNotNull);

      menu.show();
      expect(querySelector("#main-menu"), isNotNull);
    });

    test("MainMenu.hide()", () {
      menu.show();
      expect(querySelector("#main-menu"), isNotNull);

      menu.hide();
      // TODO(btmura): check that menu is hidden
      // expect(querySelector("#main-menu"), isNull);
    });

    tearDown(() {
      menu.hide();
    });
  });
}