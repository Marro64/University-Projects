//defines the boxer objects

class Boxer {
  int x;
  int y;
  int colorValue;
  color background = color(100);
  color fill;
  boolean visible;
  
  Boxer(int x, int y, int colorValue) {
    this.x = x;
    this.y = y;
    this.colorValue = colorValue;
    visible = true;
  }
  
  void display() {
    if (visible) {
      if (colorValue == 1) {
        fill = color(255,0,0);
      } else if (colorValue == 2) {
        fill = color(0,255,0);
      } else if (colorValue == 3) {
        fill = color(0,0,255); 
      }
  
      strokeWeight(3);
      stroke(0);
      //DRAWS THE OUTLINE
      fill(fill);
      beginShape();
      vertex(x + 60, y + 10);
      vertex(x + 10, y + 10);
      vertex(x + 5, y + 65);
      vertex(x + 27, y + 65);
      vertex(x + 35 ,y + 35);
      vertex(x + 42, y + 65);
      vertex(x + 65, y + 65);
      vertex(x + 60, y + 10);
      endShape();
      
      //DRAWS THE WAISTBAND
      strokeWeight(2);
      beginShape();
      vertex(x + 9, y + 17);
      vertex(x + 61, y + 17);
      endShape();
  
      //DRAWS THE FLY (GULP)
      stroke(1);
      strokeWeight(1);
      beginShape();
      vertex(x + 35,y + 35);
      vertex(x + 35 ,y + 17);
      vertex(x + 35 ,y + 18);
      vertex(x + 36 ,y + 18);
      vertex(x + 36 ,y + 27);
      vertex(x + 35 ,y + 31);
      endShape();
    }
  }
  
  //hide the box after it's hit
  void disapear() {
    visible = false;
  }
}
