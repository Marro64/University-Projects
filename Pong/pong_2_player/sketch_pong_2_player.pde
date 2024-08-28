//two player pong by Marinus Bos, 2019
//controls p1: 'w' = up, 's' = down
//controls p2: 'i' = up, 'k' = down
//'r' = reset ball
//features include: paddle changes the trajectory of the ball depending on where you hit it and score counter for two players
//the ball starts in the direction of the last player that earned a point, and has a random trajectory.
//if the ball goes off the screen before it hits a peddle, it won't count as a point and the ball will reset and go towords the same player.

ArrayList<Wall> walls = new ArrayList(); //setup objects
Ball ball;
Wall p1;
Wall p2;
boolean keys[] = new boolean[5]; //setup boolean array for pressed keys

void setup() {
  size(500, 500); //setup play area
  frameRate(60);
  fill(255);
  stroke(0);
  PFont def; //setup font 
  def = loadFont("MalgunGothicBold-48.vlw");
  textFont(def);
  Wall top = new Wall(0, 0, width, 20, 0, true); //setup walls
  Wall bottom = new Wall(0, height - 20, width, height - 20, 0, true);
  p1 = new Wall(0, 200, 20, 100, 1, false);
  p2 = new Wall(width - 20, 200, 20, 100, 2, false);

  walls.add(top);
  walls.add(bottom);
  walls.add(p1);
  walls.add(p2);

  ball = new Ball(new PVector(250, 250), new PVector(2, -8).rotate(random(PI / 6 * 5)), 1 + int(random(1))); //setup ball
}

void draw() {
  background(200);
  for (Wall w : walls) { //loop for each wall
    w.draw();
    ball.bounceIfHits(w);
  }
  ball.move();
  if (keys[0]) { //reset if 'r' is pressed
    ball.reset();
  }
  ball.draw();
}

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

class Ball {
  PVector pos; //setup variables
  PVector vel;
  int radius = 20;
  PVector startVel;
  PVector startPos;
  PVector tempVel;
  Boolean hitPaddle = false;
  int lastScoredPlayer;

  Ball (PVector tempPos, PVector tempVel, int beginPlayer) {
    startVel = tempVel.copy(); //copy over variables
    startPos = tempPos.copy();
    vel = tempVel;
    pos = tempPos;
    lastScoredPlayer = beginPlayer;
  }

  void move() {
    pos.add(vel); //move ball
    vel.mult(1.0001); //increase velocity
  }

  void bounceIfHits(Wall w) {
    if (w.collision && w.x - radius/2 < pos.x && w.x + w.w + radius/2 > pos.x && w.y - radius/2 < pos.y && w.y + w.h + radius/2 > pos.y) { //check if wall collision is on andball is hitting a wall     
      if (w.horizontal) { //see if wall is horizontal
        vel = new PVector(vel.x, vel.y*-1); //change ball trajectory
      } else if (!w.horizontal) { //see if wall is vertical
        vel = new PVector(vel.x*-1, vel.y); //change ball trajectory
        if (w.player == 1) { //if wall is player 1
          tempVel = vel.copy().rotate(PI / 8 * ((pos.y - w.y - 50) * 0.02)); //rotate ball trajectory based on height relative to paddle
          if (abs(tempVel.x/tempVel.y) > 0.1 && ball.pos.y > ball.radius + 20 && ball.pos.y < ball.radius + width - 20) vel = tempVel.copy(); //see the ball won't move too vertical or be too close to another wall, then apply trajectory change
          hitPaddle = true;
        } else if (w.player == 2) { //if wall is player 2
          tempVel = vel.copy().rotate(-(PI / 8 * ((pos.y - w.y - 50) * 0.02))); //rotate ball trajectory based on height relative to paddle
          if (abs(tempVel.x/tempVel.y) > 0.1 && ball.pos.y > ball.radius + 20 && ball.pos.y < ball.radius + width - 20) vel = tempVel.copy(); //see the ball won't move too vertical or be too close to another wall, then apply trajectory change
          hitPaddle = true;
        }
      }
      w.hit();
    }
  }

  void reset() {
    if (lastScoredPlayer == 1) vel = new PVector(-2, 8).rotate(random(PI / 6 * 5)); //reset ball with new trajectory, goes towords player that last scored.
    if (lastScoredPlayer == 2) vel = new PVector(2, -8).rotate(random(PI / 6 * 5));
    pos = startPos.copy();
    hitPaddle = false;
  }

  void draw() {
    circle(pos.x, pos.y, radius); //draw ball
  }
}

void keyPressed() { //update list of keys held when a key is pressed
  if (key == 'r' || key == 'R') keys[0] = true;
  if (key == 'w' || key == 'W') keys[1] = true;
  if (key == 's' || key == 'S') keys[2] = true;
  if (key == 'i' || key == 'I') keys[3] = true;
  if (key == 'k' || key == 'K') keys[4] = true;
}

void keyReleased() { //update list of keys held when a key is released
  if (key == 'r' || key == 'R') keys[0] = false;
  if (key == 'w' || key == 'W') keys[1] = false;
  if (key == 's' || key == 'S') keys[2] = false;
  if (key == 'i' || key == 'I') keys[3] = false;
  if (key == 'k' || key == 'K') keys[4] = false;
}
