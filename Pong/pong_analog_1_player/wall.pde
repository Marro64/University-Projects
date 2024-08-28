/*Wall class
  2019: Handles wall drawing and paddle movement. Also handles scoring for some reason?
  2021: Updated to use the new controller class instead of keyboard input
  */

class Wall {
  int x; //setup variables
  int y;
  int w;
  int h;
  int player;
  boolean collision = true;
  boolean horizontal;
  int score = 0;

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
    }
  }

  void draw() {
    rect(x, y, w, h); //draw wall
    if (player > 0) { //run code for player paddles
      y = (y + (int(keys[player * 2]) - int(keys[player * 2 - 1])) * 10); //move paddle based on keyboard input
      y = 20+int(controller.analog[player-1]);

      if (y < 20) y = 20; //collision detection
      else if (y + h > width - 20) y = width - h - 20; 

      if (player == 1 && ball.pos.x > 40) collision = true; //enable collision after bounce once ball is far enough away
      else if (player == 2 && ball.pos.x < width - 40) collision = true;
      if (ball.pos.x < -20) { //if ball passed p1 paddle
        if (ball.hitPaddle) { //if the ball has hit a paddle at least once, a point gets counted
          ball.lastScoredPlayer = 2;
          p2.score++;
        }
        ball.reset();
      } else if (ball.pos.x > width + 20) { //if ball passed p2 paddle
        if (ball.hitPaddle) { //if the ball has hit a paddle at least once, a point gets counted
          ball.lastScoredPlayer = 1;
          p1.score++;
        }
        ball.reset();
      }

      if (player == 1) { //draw score
        textAlign(LEFT, TOP);
        text(str(score), 50, 50);
      } else if (player == 2) {
        textAlign(RIGHT, TOP);
        text(str(score), width - 50, 50);
      }
    }
  }
}
