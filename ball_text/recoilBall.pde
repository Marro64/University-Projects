class RecoilBall extends Ball {
  RecoilBall(PVector initPos, float size) {
    super(initPos, size);
  }
  
  void move(boolean[] mouseButtons, PVector cursor) {
    if (mouseButtons[0] || mouseButtons[1]) {
      velocity.add(recoil(cursor));
    }
    
    super.move(mouseButtons, cursor);
  }
  
  PVector recoil(PVector cursor) {
    final float recoilAmp = 10;
    float mag = recoilAmp/(sqrt(currPos.dist(cursor)));
    float angle = currPos.copy().sub(cursor).heading();
    return(PVector.fromAngle(angle).setMag(mag));
  }
}
