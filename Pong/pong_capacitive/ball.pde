/* Ball class
 2019: Handles the ball drawing, movement and collision. Also contains 
 2021: Added new pause/serve 
 */

class Ball {
  PVector pos; //setup variables
  PVector vel;
  int radius = 20;
  PVector startVel;
  PVector startPos;
  PVector tempVel;
  Boolean hitPaddle = false;
  Boolean paused = true;
  int lastScoredPlayer;

  Ball (PVector tempPos, PVector tempVel, int beginPlayer) {
    startVel = tempVel.copy(); //copy over variables
    startPos = tempPos.copy();
    vel = tempVel;
    pos = tempPos;
    lastScoredPlayer = beginPlayer;
  }

  void move() {
    if (!paused) { //only move if the ball isn't paused
      pos.add(vel); //move ball
      vel.mult(1.0001); //increase velocity
    }
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

  void serve() { //unpause the ball
    paused = false;
  }

  void reset() {
    if (lastScoredPlayer == 1) vel = new PVector(-2, 8).rotate(random(PI / 6 * 5)); //reset ball with new trajectory, goes towords player that last scored.
    if (lastScoredPlayer == 2) vel = new PVector(2, -8).rotate(random(PI / 6 * 5));
    pos = startPos.copy();
    hitPaddle = false;
    
    paused = true; //wait for the ball to be served before moving
  }

  void draw() {
    circle(pos.x, pos.y, radius); //draw ball
  }
}
