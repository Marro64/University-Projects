//the canon on the tricycle, because every tricycle has a canon

class Canon{
  float canonX;
  float canonY;
  float angle;
  int colorValue;
  color canonColor;
  
  Canon(float initAngle){
    canonColor = color(255,0,0);
    angle = initAngle;
  }
  
  void display(float initX, float initY){
    angle = calcCanonAngle(new PVector(initX,initY), cursor);
    canonX = initX;
    canonY = initY;
    
    pushMatrix();
    translate(initX, initY);
    rotate(angle);
    if (game.currentColor == 1) {
        fill(color(255,0,0));
      } else if (game.currentColor == 2) {
        fill(color(0,255,0));
      } else if (game.currentColor == 3) {
        fill(color(0,0,255)); 
      }
    noStroke();
    rect(-22,-86,44,86);
    stroke(0,0,0);
    strokeWeight(3);
    ellipse(0,-86,44,22);
    strokeWeight(3);
    arc(0,0,44,40,0,PI);
    line(-22,-86,-22,0);
    line(22,-86,22,0);
    
    
    popMatrix();
  }
  
  //calculate the angle the canon has to face to 
  float calcCanonAngle(PVector pos, PVector cursor) {
    Float direction = pos.copy().sub(cursor).rotate(-PI/2).heading(); //get the rotation of the point to look at relative to the left eye
    return(direction); 
  }
}
