/* Ball
 * A ball that can be used for games
 * Includes physics and wall collision that can be disabled
 * By Marinus Bos, 2022
 */ 

class Ball {
  PVector pos;
  PVector vel;
  PVector acc;
  float size;
  color fillColor;
  PVector field; //the size of the screen
  boolean grabbed;

  Ball(PVector pos, PVector vel, float size, color fillColor, PVector field, boolean grabbed) {
    this.pos = pos;
    this.vel = vel;
    this.acc = new PVector(0, 0);
    this.size = size;
    this.fillColor = fillColor;
    this.field = field;
    this.grabbed = grabbed;
  }
  
  //display ball
  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    shape(ballShape(), 0, 0);
    popMatrix();
  }
  
  //apply physics if ball is not grabbed
  void update(float dt) {
    if (!grabbed) {
      //velocity with dt applied
      PVector frameVel = vel.copy().mult(dt);
      
      //apply forces
      if (!checkForWallCollision(frameVel)) { //discard acceleration if ball will collide
        acc.add(gravity());
        acc.add(airResistance());
        vel.add(acc.copy().mult(dt));
      }
      acc.set(0, 0); //reset acceleration after forces are applied
      
      //recalculate after forces are applied
      frameVel = vel.copy().mult(dt);

      moveWithWallCollision(frameVel);
    }
  }
  
  //returns true if ball will hit outside wall on next movement
  boolean checkForWallCollision(PVector frameVel) {
    PVector nextPos = pos.copy().add(frameVel);

    if (nextPos.x+size/2 > field.x || nextPos.y+size/2 > field.y || nextPos.x-size/2 < 0) {
      return(true);
    }
    return(false);
  }

  //move ball and bounce off the outside walls
  void moveWithWallCollision(PVector frameVel) {
    PVector nextPos = pos.copy().add(frameVel); //calculate where the next position will be if ball doesn't collide
    
    //if ball bounces off wall
    if (nextPos.x+size/2 > field.x) { //right
      nextPos.x = field.x-size/2-nextPos.x%(field.x-size/2); //calculate next position including remainder of movement after bouncing
      vel.x *= -0.95; //apply friction
    }
    if (nextPos.y+size/2 > field.y) { //bottom
      nextPos.y = field.y-size/2-nextPos.y%(field.y-size/2);
      vel.y *= -0.95;
    }
    if (nextPos.x-size/2 < 0) { //left
      nextPos.x = size/2+nextPos.x%(size/2);
      vel.x *= -0.95;
    }
    //if(nextPos.y-size/2 < 0) { //top
    //  nextPos.y = size+nextPos.y%(size/2);
    //  vel.y *= -0.95;
    //}

    pos = nextPos.copy();
  }
  
  // Returns the ball sprite
  PShape ballShape() {
    fill(fillColor);
    strokeWeight(1);
    stroke(0);
    return(createShape(ELLIPSE, 0, 0, size, size));
  }
    

  PVector gravity() {
    return(new PVector(0, 1));
  }

  PVector airResistance() {
    return(vel.copy().mult(-0.01));
  }

  PVector getPos() {
    return(pos.copy());
  }

  void setPos(PVector pos) {
    this.pos.set(pos);
  }

  void setVel(PVector vel) {
    this.vel.set(vel);
  }

  void addAcc(PVector acc) {
    this.acc.add(acc);
  }

  void grab() {
    grabbed = true;
  }

  void release() {
    grabbed = false;
  }
}
