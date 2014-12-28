part of client;

class AppView {

  final MainMenu mainMenu;
  final GameView gameView;

  AppView(this.mainMenu, this.gameView);

  bool resize() {
    mainMenu.center();
    return gameView.resize();
  }

  ElementStream<MouseEvent> get onContinueGameButtonClick => mainMenu.onContinueButtonClick;

  ElementStream<MouseEvent> get onNewGameButtonClick => mainMenu.onNewGameButtonClick;

  ElementStream<MouseEvent> get onPauseButtonClick => gameView.buttonBar.onPauseButtonClick;
}