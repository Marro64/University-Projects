class Wall {
  int x; //setup variables
  int y;
  int w;
  int h;
  int player;
  boolean collision = true;
  boolean horizontal;
  int score = 0;
  int highScore = 0;

  Wall(int tempx, int tempy, int tempw, int temph, int tempPlayer, boolean temphorizontal) {
    x = tempx; //copy over setup variables
    y = tempy;
    w = tempw;
    h = temph;
    player = tempPlayer;
    horizontal = temphorizontal;
  }

  void hit() {
    if (player > 0) {
      collision = false; //disable collision for player until ball is far enough away
      score++;
    }
  }

  void draw() {
    rect(x, y, w, h); //draw wall
    if (player > 0) { //run code for player paddles
      paddle.y = (paddle.y + (int(keys[player * 2]) - int(keys[player * 2 - 1])) * 10); //move paddle based on keyboard input
      if (y < 20) y = 20; //collision detection
      if (y + h > width - 20) y = width - h - 20; 
      if (ball.pos.x > 40) collision = true; //enable collision after bounce once ball is far enough away
      if (ball.pos.x < -20) { //if ball passed player paddle
        ball.reset();
        if(score > highScore) highScore = score;
        score = 0;
      }
      textAlign(LEFT, TOP); //draw score
      text(str(score), 50, 50);
      textAlign(RIGHT, TOP);
      text(str(highScore), width - 50, 50); //draw highscore
    }
  }
}
