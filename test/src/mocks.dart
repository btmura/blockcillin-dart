part of test;

class MockApp extends Mock implements App {
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockAppView extends Mock implements AppView {
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockGame extends Mock implements Game {
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}