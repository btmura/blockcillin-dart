part of client;

class AppView {

  final MainMenu mainMenu;
  final GameView gameView;

  AppView(this.mainMenu, this.gameView);

  bool resize() {
    return gameView.resize();
  }

  ElementStream<MouseEvent> get onContinueGameButtonClick => mainMenu.onContinueGameButtonClick;

  ElementStream<MouseEvent> get onNewGameButtonClick => mainMenu.onNewGameButtonClick;

  ElementStream<MouseEvent> get onPauseButtonClick => gameView.buttonBar.onPauseButtonClick;
}