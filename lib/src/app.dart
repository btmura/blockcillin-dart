part of client;

class App {

  bool gameStarted = false;
  bool gamePaused = false;
  Game game;

  void startGame(Game game) {
    this.gameStarted = true;
    this.gamePaused = false;
    this.game = game;
  }

  void update() {
    if (game != null) {
      game.update();
    }
  }
}
