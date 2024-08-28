class cloud {
  float cloudR = 274;
  float cloudL = 340;
  float cloudD = 310;
  float cloudS = 375;
  float cloudRec = 300;
  float posX = 0;
  float posY;
  float speed;

  cloud(float posY, float speed) {
    this.speed = speed;
    this.posY = posY;
  }

  void display() {
    ellipseMode(CORNER);
    fill(255, 255, 255);
    stroke(255);
    ellipse(cloudR+posX, 150+posY, 50, 50);
    ellipse(cloudL+posX, 120+posY, 75, 75);
    ellipse(cloudD+posX, 130+posY, 60, 60);
    ellipse(cloudS+posX, 150+posY, 50, 50);
    rect(cloudRec+posX, 180+posY, 100, 20);
    ellipseMode(CENTER);
  }

  void move() {
    //Set the movement with speed that is subtracted from the current position
    cloudR=cloudR-speed;
    cloudL=cloudL-speed;
    cloudD=cloudD-speed;
    cloudS=cloudS-speed;
    cloudRec=cloudRec-speed;

    if (cloudR>width-530) {
    }

    if (cloudR<=-190) {
      cloudR=width;
    }
    if (cloudL>width-530) {
    }

    if (cloudL<=-190) {
      cloudL=width;
    }

    if (cloudD>width-530) {
    }

    if (cloudD<=-190) {
      cloudD=width;
    }
    if (cloudS>width-530) {
    }

    if (cloudS<=-190) {
      cloudS=width;
    }
    if (cloudRec>width-530) {
    }

    if (cloudRec<=-190) {
      cloudRec=width;
    }

    if (cloudR>=1000) {
      cloudR=+200;
    }
    if (cloudL>=1000) {
      cloudL=+120;
    }
    if (cloudD>=1000) {
      cloudD=+120;
    }
    if (cloudS>=1000) {
      cloudS=+120;
    }
    if (cloudRec>=1000) {
      cloudRec=+120;
    }
  }
}
