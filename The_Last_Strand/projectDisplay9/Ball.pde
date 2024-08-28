/*=================
A basic ball. Pulls color from the background image
and drifts back to its initial position constantly.

Clock changelog:
 - Added ability to change size on the fly
 - Spiral and recoil have their input reworked
 - Alarm function where the ball rotates around the center of the screen
=================*/

class Ball {
  PVector initPos, currPos, velocity;
  int movementType = 0;
  float size;
  PVector field;
  color fillColor = color(#0000FF);
  boolean explode = false;
  
  
  Ball(PVector initPos, float size, PVector field, color ballColor) {
    this.initPos = initPos.copy(); //the position to which it returns
    this.currPos = initPos.copy(); //the current position
    this.size = size;
    this.fillColor = ballColor;
    this.field = field;
    
    velocity = new PVector(0, 0);
  }
  
  void move() {
    //when the alarm goes off, start spiraling around the center of the screen
    if(!explode) {
      velocity.add(gravity()); //apply gravity
    } else {
      velocity.add(0, 2);
    }
    
    velocity.div(resistance()); //apply resistance
    currPos.add(velocity); //move the ball
  }
  
  // Draw the ball with a slight glow
  void display(float seperation) {
    pushMatrix();
    translate(seperation/2, seperation/2);
    ellipseMode(CENTER);
    noStroke();
    //fillColor = getColor();
    fill(fillColor, 25);
    float glowRadius = size*2;
    //float glowSteps = 1;
    ////float glowSteps = 5;
    //for(; glowRadius >= size; glowRadius -= glowSteps) {
    //  circle(currPos.x, currPos.y, glowRadius);
    //}
    fill(fillColor, 255);
    circle(currPos.x, currPos.y, size);
    popMatrix();
  }
  
  void explode() {
    explode = true;
    velocity.add(new PVector(0, random(10, 50)).rotate(random(0, 2*PI)));
  }
  
  void unExplode() {
    explode = false;
  }
  
  //set a new home location for the balls
  void setHome(PVector newHome) {
    initPos = newHome.copy();
  }
  
  //set a new size of the ball
  void setSize(float size) {
    this.size = size;
  }
  
  // Constantly pull the ball back towards the initial position, with the pull getting stronger as the ball is further away
  PVector gravity() {
    final float gravityAmp = 0.01;
    return(initPos.copy().sub(currPos).div(1/gravityAmp));
  }
  // Constant resistance to movement
  float resistance() {
    final float resistanceAmp = 0.1;
    return(1+resistanceAmp);
  }
  
  //// Get color from the background image to be used for the ball color
  //color getColor() {
  //  return background.get((int)this.currPos.x, (int)this.currPos.y);
  //}
  
  PVector recoil(PVector gravityPoint, float gravityAmp) {
    float mag = gravityAmp/(sqrt(currPos.dist(gravityPoint)));
    float angle = currPos.copy().sub(gravityPoint).heading();
    return(PVector.fromAngle(angle).setMag(mag));
  }
  
  PVector spiral(PVector gravityPoint, float gravityAmp) {
    float rotAngle = currPos.copy().sub(gravityPoint).rotate(PI/2).heading();
    return(PVector.fromAngle(rotAngle).setMag(gravityAmp));
  }
}