part of test;

class MockApp extends TypedMock implements App {
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockGame extends TypedMock implements Game {
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockGameView extends TypedMock implements GameView {
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockMainMenu extends TypedMock implements MainMenu {
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
