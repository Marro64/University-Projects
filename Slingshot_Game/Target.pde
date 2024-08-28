/* Target
 * Circular object to aim at
 * Handles collision detection between itself and ball
 * By Marinus Bos, 2022
 */

class Target {
  PVector pos;
  float size;

  Target(PVector pos, float size) {
    this.pos = pos.copy();
    this.size = size;
  }

  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    fill(255);
    stroke(0);
    circle(0, 0, size);
    popMatrix();
  }  
  
  // Returns true if collision with ball and bounces ball away from target
  boolean checkCollision(Ball ball) {
    PVector center1 = pos.copy();
    PVector center2 = ball.pos.copy();
    if (center1 != center2) {
      if (center2.dist(center1) < ball.size/2 + size/2) {
        //calculate bounce direction and velocity
        PVector centerDir = center2.copy().sub(center1).normalize();
        PVector nextVel = centerDir.copy().rotate(-1*(ball.vel.copy().mult(-1).heading()-centerDir.heading())).setMag(ball.vel.mag());
        
        //pushMatrix();
        //translate(ball.pos.x, ball.pos.y);
        //line(0, 0, centerDir.x*50, centerDir.y*50);
        //line(0, 0, ball.vel.x*-10, ball.vel.y*-10);
        //line(0, 0, nextVel.x*10, nextVel.y*10);
        //popMatrix();
        
        ball.setVel(nextVel.copy());
        
        return(true);
      }
    }
    return(false);
  }
}
