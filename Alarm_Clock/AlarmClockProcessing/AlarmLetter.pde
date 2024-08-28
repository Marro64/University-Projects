/*=================
Individual letter of the alarm display

by Denzel and Jort
=================*/


class AlarmLetter {
  static final int DEF_SIZE = 60;
  static final int RING_SIZE = 200;

  char myLetter;
  float xPos, yPos, zPos;
  float xOrigin, yOrigin;
  float angleX, angleY, angleZ;
  color letterColor;
  boolean ringing;
  float rotaX, rotaY, rotaZ; // rotation in the various dimensions
  int num;                     // keeps track which number in the word this number is
  int textSize;

  AlarmLetter (char letter, float xPos, float yPos, int num) {
    myLetter = letter;
    this.xPos = xPos;
    this.yPos = yPos;
    xOrigin = xPos;
    yOrigin = yPos;
    zPos = 0;
    angleX = 0; //random (2 * PI);
    angleY = 0;
    angleZ = 0;
    ringing = false;
    letterColor = color(255);
    textSize = DEF_SIZE;
    this.num = num;
  }

  void drawLetter() {
    pushMatrix();
    translate(xPos, yPos, zPos);
    fill(letterColor);
    rotateX(angleX);
    rotateY(angleY);
    rotateZ(angleZ);
    textSize(textSize);
    text(myLetter, 0, 0);
    popMatrix();
  }

  // this method updates the letter
  void updateLetter() {
    if (ringing) {
      
      angleX = angleX + rotaX;
      angleY = angleY + rotaY;
      angleZ = angleZ + rotaZ;
    }
  }
  
  // this code is ran to put the letters back into their place.
  void stopRinging() {
    ringing = false;
    rotaX = 0;
    rotaY = 0;
    rotaZ = 0;
    angleX = 0;
    angleY = 0;
    angleZ = 0;
    xPos = xOrigin;
    yPos = yOrigin;
    zPos = 0;
    textSize = DEF_SIZE;
    //letterColor = color(0, 0, 0);
  }

  // this method makes a letter spazz out when the alarm goes off.
  void startRinging() {
    ringing = true;
    xPos = (num*width/5)+RING_SIZE/2;
    yPos = width/3;
    rotaX = random(-0.25, 0.25);
    rotaY = random(-0.25, 0.25);
    rotaZ = random(-0.25, 0.25);
    textSize = RING_SIZE;
  }
  
  void setColor(color letterColour) {
    letterColor = letterColour;
  }
  
  void setLetter(char number) {
    myLetter = number;
  }
}
