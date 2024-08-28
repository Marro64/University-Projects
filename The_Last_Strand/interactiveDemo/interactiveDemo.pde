float pos = 0;
float vel = 0;
float acc = 0;
int up = 0;

int timer = 0;

int sizex = 80;
int sizey = 160;
void setup() {
  fullScreen(FX2D);
}

void draw() {
  colorMode(HSB);
  background(millis()/float(100)%255, 100, 200);
  
  if(pos > 0) {
    timer++;
  } else {
    timer = 0;
  }
  
  //if(up == 0) {
    acc = -.3;
  //} else if(up == 1) {
    //acc = .5;
  //}
  
  vel += acc;
  if(vel >= 10) {
    vel = 10;
  } else if(vel <= -15) {
    vel = -15;
  }
  
  pos += vel;
  if(pos >= height-sizey-100) {
    pos = height-sizey-100;
    vel = 0;
  } else if(pos <= 0) {
    pos = 0;
    vel = 0;
  }
  
  stroke(128);
  strokeWeight(4);
  line(width/2, 0, width/2, height-pos);
  
  stroke(0);
  fill(255);
  strokeWeight(2);
  rect(width/2-sizex/2, height-pos-sizey, sizex, sizey); 
  
  fill(32);
  textSize(64);
  textAlign(LEFT, CENTER);
  text(String.format("%02d", (timer/216000)) + ":" + String.format("%02d", (timer/3600)%60) + ":" + String.format("%02d", (timer/60)%60) + "." + String.format("%02d", int(timer/float(60)*99)%99) , 10, height/2);
  textAlign(RIGHT, CENTER);
  text("Press the spacebar!", width, height/2); 
  textAlign(CENTER, TOP);
  text("Interactive Demo", width/2, 10);
}

void keyPressed() {
  if(key == ' ' && up == 0) {
    up = 1;
    vel += 5;
  }
}

void keyReleased() {
  if(key == ' ') {
    up = 0;
  }
}
