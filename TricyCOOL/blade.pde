//defines the razerblade, with changing colors

class Blade{
  float bladeX;
  float bladeY;
  float bladeAngle;
  float bladeXSpeed;
  float bladeYSpeed;
  boolean active;
  int colorValue;
  
  Blade(float initX, float initY, float initAngle, float initXSpeed, float initYSpeed, int initColor){
    bladeX = initX;
    bladeY = initY;
    bladeAngle = initAngle;
    bladeXSpeed = initXSpeed;
    bladeYSpeed = initYSpeed;
    colorValue = initColor;
    active = true;
  }
  
  void display(){
    if(active){
      
      pushMatrix();
      translate(bladeX, bladeY);
      rotate(bladeAngle);
      
      //rule for the blade color
      if (colorValue == 1) {
        fill(color(255,0,0));
      } else if (colorValue == 2) {
        fill(color(0,255,0));
      } else if (colorValue == 3) {
        fill(color(0,0,255)); 
      }
      stroke(0,0,0);
      
      //creates the razerblade outside
      rect(-20,-30,40,20);
      rect(-6,-10,12,40);
      
      //creates the razerblade inside
      fill(100);
      rect(-16,-26,32,12);
      popMatrix();
    }
  }
  
  void move() {
    bladeX += bladeXSpeed;
    bladeY += bladeYSpeed;
  }
}
