import processing.javafx.*; //<>//

import processing.serial.*;
import java.util.Collections;
import java.util.concurrent.TimeUnit;
import java.util.Date;
import java.io.FileWriter;
import java.io.BufferedWriter;

//for reading files
import java.io.File;  // Import the File class
import java.io.FileNotFoundException;  // Import this class to handle errors
import java.util.Scanner; // Import the Scanner class to read text files
Serial myPort;

Timer timer;
TimerStreak timerStreak;

boolean isGoingDown;
int lastGoingDown;
int lastGoingUp;
int lastTime;
int lastGoingUpTime;
int lastGoingDownTime;
int downTimes;

PImage turtle;
PImage sea;
PImage trash;
PFont numbers;
PFont regText;
PFont game;

PVector field;
int inputMode = 0;
boolean debug;

Sensor sensor;
SerialComm serialComm;
Scroll scroll;
Weight weight;
TrashManager trashManager;
FancyDisplay fancyDisplay;

//text file
static final String OUTPUT_FILE = "scores.csv";
static final String LOG_FILE = "logs.txt";



void setup() {
  //size(1080, 1920, P2D);
  fullScreen(P2D);
  field = new PVector(width, height);
  turtle = loadImage("turtle.png");
  sea = loadImage("sea.jpg");
  trash = loadImage("trash.png");
  numbers = createFont("Grotesque.ttf", 90);
  regText = createFont("Nemo.ttf", 80);
  game = createFont("8bit.ttf", 40); 
  
  timer = new Timer(LOG_FILE);
  timerStreak = new TimerStreak(OUTPUT_FILE);
  weight = new Weight(30, 20, 1);
  trashManager = new TrashManager();
  fancyDisplay = new FancyDisplay();
  
  timer.startTimer();
  
  //Try to connect to the arduino, else fall back to scroll input
  try {
    println(Serial.list()[0]);
    serialComm = new SerialComm(new Serial(this, Serial.list()[0], 9600));
    sensor = new Sensor();
    inputMode = 1;
  } catch(Exception e) {
    println(e);
    inputMode = 2;
    scroll = new Scroll();
  }
}

void draw() {
  //Update inputs and movement
  if(inputMode == 1) {
    serialComm.serialRead();
    sensor.update();
  } else if(inputMode == 2) {
    scroll.update();
  }
  timerController();
  timer.update();
  timerStreak.update();
  trashManager.update();
  fancyDisplay.update();
  
  displayBackground();
  displayStatic();
  trashManager.display();
  timer.display();
  timerStreak.display();
  fancyDisplay.display();
  
  if(debug) {
    debugDisplay();
  }
}

void timerController() {
  if(weight.health > 7 && timerStreak.running == false) {
    timerStreak.startTimer();
    timer.startTimer();
    trashManager.startMovingUp();
    fancyDisplay.unExplode();
  }
  else if(weight.health < 3 && timerStreak.running == true) {
    timerStreak.stopTimer();
    timer.countDown();
    trashManager.startMovingDown();
    fancyDisplay.explode();
  }
}

void displayBackground() {
  //display sea
  image(sea, 0, 0, width, height);
}

void displayStatic() {
  //display turtle
  pushStyle();
  imageMode(CENTER);
  image(turtle, width/2, height*0.7, 400, 400);
  popStyle();

  //image(trash, random(width), random(height), 420, 2);

  pushStyle();
  textAlign(CENTER);
  fill(0);
  textFont(regText);
  textSize(60);
  text("Pull on the ropes!", width/2, height*0.15);
  popStyle();

  //view
  pushStyle();
  textAlign(CENTER);
  fill(0);
  textFont(numbers);
  textSize(140);
  text("The Last Strand", width/2, height*0.1);
  popStyle();
}

void debugDisplay() {
  int fontSize = 25;
  
  //Draw debug UI
  if(inputMode == 1) {
    sensor.displayOverlay(fontSize);
  } else if(inputMode == 2) {
    scroll.debugDisplay(fontSize);
  }
  weight.debugDisplay();
  fill(#FFFFFF);
  textAlign(LEFT, BOTTOM);
  text(str(frameRate), 0, field.y);
}

//void mouseClicked() {
//  if (timer.running == false) {
//    timer.startTimer();
//  }
//  else if (timer.running == true) {
//    timer.stopTimer();
//  }
//}

void keyPressed() {
  //System.out.println("pressed.");
  
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
  } else {
    if (key == CODED) {
      if (keyCode == UP) {
        //timer.countUp();
        scroll.scrollPos = -20;
        scroll.scrolled(0);
      } else if (keyCode == DOWN) {
        //timer.countDown();
        scroll.scrollPos = 0;
        scroll.scrolled(0);
      }
    }
  }
  if(key == 'd' || key == 'D') {
    debug = true;
  }
  if(key == 'b' || key == 'B') {
    println("Interrupted!"); //<>//
  }
}


void mouseWheel(MouseEvent event) {
  //Read scrollwheel state
  if(inputMode == 2) {
    scroll.scrolled(event.getCount());
  }
}
