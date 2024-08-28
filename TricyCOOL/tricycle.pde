//defines the tricycle

class Tricycle {
  float tricycleX;
  float tricycleY;
  Canon canon;

  Tricycle(float initX, float initY) {
    tricycleX = initX;
    tricycleY = initY;
    canon = new Canon(0);
  }

  void display() {

    pushMatrix();
    translate(tricycleX, tricycleY);
    noFill();
    stroke(0);
    strokeWeight(3);

    //two small wheels at the back
    ellipse(22, 128, 44, 44);
    ellipse(22, 110, 44, 44);

    //big front wheel
    ellipse(170, 121, 58, 58);

    //tricycle connection lines
    stroke(0);
    strokeWeight(10);
    
    //bottom line for seat
    line(22, 128, 122, 128);
    
    //line from bottom line to the steer-to-wheel connection
    line(122, 128, 135, 95);
    line(135, 95, 150, 80);
    
    //line over wheel
    line(150, 80, 170, 80);
    
    //steer to wheel
    line(150, 80, 170, 121);
    line(150, 80, 135, 60);
    
    //steer
    line(135, 60, 120, 55);

    //canon at the back
    stroke(0);
    strokeWeight(3);
    
    //seat underside
    fill(0);
    rect(40,100,80,30);
    noStroke();
    triangle(120,99,120,130,130,99);
    
    //seat chair
    fill(100);
    rect(60,85,40,15);
    rect(60,60,10,25);
    
    //potato body
    fill(182, 158, 135);
    rect(70,25,40,60,30,30,30,30);
    stroke(0);
    strokeWeight(3);
   
    //potato-eye
    ellipse(100,40,3,3);
    
    //potato-mouth
    line(105,50,108,50);
    
    //potato-arm
    line(90,55,135,60);
    
    //potato-leg
    line(100,70,120,95);
    
    //potato foot
    fill(0,0,255);
    ellipse(120,95,20,10); 

    popMatrix();
    
    canon.display(tricycleX+22, tricycleY+98);
  }
  
  //move the tricycle based on the keyboard input
  void move(){
    tricycleX += int(keys[1])*5; //move right when 'd' is held
    tricycleX -= int(keys[0])*5; //move left when 'a' is held
    
    //prevent leaving the screen
    if(tricycleX < 0) tricycleX = 0;
    if(tricycleX > width-200) tricycleX = width-200;
  }
}
