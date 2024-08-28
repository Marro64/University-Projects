class Ball {
  PVector initPos, currPos, velocity;
  int movementType = 0;
  float size;
  color fillColor;
  
  Ball(PVector initPos, float size) {
    this.initPos = initPos.copy(); //the position to which it returns
    this.currPos = initPos.copy(); //the current position
    this.size = size;
    this.fillColor = getColor();
    
    velocity = new PVector(0, 0);
  }
  
  void move(boolean[] mouseButtons, PVector cursor) {
    
    velocity.add(gravity()); //apply gravity
    velocity.div(resistance()); //apply resistance
    
    currPos.add(velocity); //move the ball
  }
  
  void display() {
    noStroke();
    fillColor = getColor();
    fill(fillColor, 25);
    float glowRadius = size*2;
    float glowSteps = (glowRadius-size)/10;
    for(; glowRadius >= size; glowRadius -= glowSteps) {
      circle(currPos.x, currPos.y, glowRadius);
    }
    fill(fillColor, 255);
    circle(currPos.x, currPos.y, size);
  }
  
  PVector gravity() {
    final float gravityAmp = 0.01;
    return(initPos.copy().sub(currPos).div(1/gravityAmp));
  }
  
  float resistance() {
    final float resistanceAmp = 0.1;
    return(1+resistanceAmp);
  }
  
  color getColor() {
    return img.get((int)this.currPos.x, (int)this.currPos.y);
  }
}
