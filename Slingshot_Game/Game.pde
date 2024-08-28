/* Game
 * Keeps track of general game state
 * By Marinus Bos, 2022
 */ 

class Game {
  TargetManager targets;
  Ball ball;
  Slingshot slingshot;
  
  PVector field;
  
  int score;
  int lives;
  
  boolean gameStarted = false;

  Game(TargetManager targets, Ball ball, Slingshot slingshot, PVector field) {
    this.targets = targets;
    this.ball = ball;
    this.slingshot = slingshot;
    this.field = field;
  }
  
  void update() {
    // Give new set of targets and extra life is all targets are cleared
    if(targets.targets.size() == 0) {
      newTargets();
      lives += 1;
    }
  }
  
  void display() {
    displayLives();
    displayScore();
  }
  
  // Give new set of targets
  void newTargets() {
    final int setSize = 5; // Amount of targets per set
    for (int i = 0; i < setSize; i++) {
      targets.addTarget(new Target(field.copy().div(2).add(new PVector(0, 1).setMag(random(150, field.mag()/(2*sqrt(2)))).rotate(random(0, PI*2))), 50));
    }
  }
  
  void displayLives() {
    PShape ballShape = ball.ballShape();
    pushMatrix();
    translate(ball.size, ball.size);
    
    // For each life, display ball sprite and move matrix to the right
    for(int i = 0; i < lives; i++) {
      shape(ballShape, 0, 0);
      translate(ball.size*1.2, 0);
    }
    
    popMatrix();
  }
  
  void displayScore() {
    final int margins = 10;
    pushMatrix();
    translate(field.x-margins, margins);
    textSize(50);
    textAlign(RIGHT, TOP);
    stroke(255);
    text(score, 0, 0);
    popMatrix();
  }
  
  // Start game to initial state
  void startGame() {
    score = 0;
    lives = 10;
    newTargets();
    gameStarted = true;
  }
  
  // Consume a life, or stop game if lifes are gone
  void consumeLife() {
    if(lives > 0) {
      lives -= 1;
    } else {
      gameStarted = false;
    }
  }
  
  void addScore(int score) {
    this.score += score;
  }
  
  // Handle mouse press actions, unless game has ended
  void mousePress(PVector cursor) {
    game.consumeLife();
    if(gameStarted) {
      slingshot.grab(cursor);
      slingshot.updateCursor(cursor);
    }
  }
  
  // Handle mouse drag actions, unless game has ended
  void mouseDrag(PVector cursor) {
    if(gameStarted) {
      slingshot.updateCursor(cursor);
    }
  }
  
  // Handle mouse release actions, unless game has ended
  void mouseRelease() {
    if(gameStarted) {
      slingshot.release();
    }
  }
}
