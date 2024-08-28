class Ball {
  PVector pos; //setup variables
  PVector vel;
  int radius = 20;
  PVector startVel;
  PVector startPos;
  PVector tempVel;
  Boolean bounce = false;

  Ball (PVector tempPos, PVector tempVel) {
    startVel = tempVel.copy(); //copy over variables
    startPos = tempPos.copy();
    vel = tempVel;
    pos = tempPos;
  }

  void move() {
    pos.add(vel); //move ball
    vel.mult(1.0001); //increase velocity
  }

  void bounceIfHits(Wall w) {
    if (w.collision && !bounce) { //check if wall collision is on
      if (w.x - radius/2 < pos.x && w.x + w.w + radius/2 > pos.x && w.y - radius/2 < pos.y && w.y + w.h + radius/2 > pos.y) { //check if ball is hitting wall     
        if (w.horizontal) { //see if wall is horizontal
          vel = new PVector(vel.x, vel.y*-1); //change ball trajectory
        } else if (!w.horizontal) { //see if wall is vertical
          vel = new PVector(vel.x*-1, vel.y); //change ball trajectory
          if (w.player > 0) { //if wall is a player paddle
            tempVel = vel.copy().rotate(PI / 8 * ((pos.y - w.y - 50) * 0.02)); //rotate ball trajectory based on height relative to paddle
            if (abs(tempVel.x/tempVel.y) > 0.1 && ball.pos.y > ball.radius + 20 && ball.pos.y < ball.radius + width - 20) vel = tempVel.copy(); //see the ball won't move too vertical, then apply trajectory change
          }
        }
        w.hit();
      }
    }
  }

  void reset() {
    vel = new PVector(2, -8).rotate(random(PI / 6 * 5)); //reset ball with new trajectory
    pos = startPos.copy();
  }

  void draw() {
    circle(pos.x, pos.y, radius); //draw ball
  }
}
