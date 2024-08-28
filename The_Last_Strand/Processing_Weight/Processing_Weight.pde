//Weight sensor reading backend
//Tries to connect to an arduino, if it can't find one you can use your scrollwheel instead 
//Everything between //(================= and //=================) on the first page is important code for the backend
//The weight class stores all important final variables, you can read them from it

//(=================
import processing.serial.*;
PVector field;
int inputMode = 0;

Sensor sensor;
SerialComm serialComm;
Scroll scroll;
Weight weight;
//=================)

void setup() {
  //size(800, 450);
  fullScreen(P2D);
  
  //(=================
  field = new PVector(width, height);
  
  weight = new Weight(30, 20, 1);
  
  //Try to connect to the arduino, else fall back to scroll input
  try {
    println(Serial.list());
    println(Serial.list()[3]);
    serialComm = new SerialComm(new Serial(this, Serial.list()[3], 9600));
    sensor = new Sensor();
    inputMode = 1;
  } catch(Exception e) {
    println(e);
    inputMode = 2;
    scroll = new Scroll();
  }
  //=================)
}

void draw() {
  //(=================
  //Update inputs and movement
  if(inputMode == 1) {
    serialComm.serialRead();
    sensor.update();
    sensor.displayOverlay();
  } else if(inputMode == 2) {
    scroll.update();
    scroll.debugDisplay();
  }
  //=================)
  
  //Draw debug UI
  background(#666666);
  if(inputMode == 1) {
    sensor.displayOverlay();
  } else if(inputMode == 2) {
    scroll.debugDisplay();
  }
  weight.debugDisplay();
  fill(#FFFFFF);
  textAlign(LEFT, BOTTOM);
  text(str(frameRate), 0, field.y);
}

void keyPressed() {
  //(=================
  //Read keyboard input
  if(inputMode == 1) {
    if(key == 'r' || key == 'R') {
      sensor.sensorSmooth.reset();
    }
    if(key == 'n' || key == 'N') {
      sensor.sensorCalibration.calibrationStep();
    }
    if(key == 'c' || key == 'C') {
      sensor.sensorCalibration.toggleCalibration();
    }
  }
  if(key == 'b' || key == 'B') {
    println("Interrupted!"); //<>//
  }
  //=================)
}

void mouseWheel(MouseEvent event) {
  //(=================
  //Read scrollwheel state
  if(inputMode == 2) {
    scroll.scrolled(event.getCount());
  }
  //=================)
}
