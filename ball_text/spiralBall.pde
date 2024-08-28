class SpiralBall extends Ball {
  SpiralBall(PVector initPos, float size) {
    super(initPos, size);
  }
  
  void move(boolean[] mouseButtons, PVector cursor) {
    if (mouseButtons[0] || mouseButtons[1]) {
      velocity.add(spiral(cursor));
    }
    
    super.move(mouseButtons, cursor);
  }
  
  PVector spiral(PVector cursor) {
    float rotAngle = currPos.copy().sub(cursor).rotate(PI/2).heading();
    return(PVector.fromAngle(rotAngle).setMag(2));
  }
}
