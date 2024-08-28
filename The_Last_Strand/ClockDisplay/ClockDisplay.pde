/*=================
Text ball animation by Marinus and Nina
Ball clock program made by Marinus Bos and Denzel Hagen
=================*/

import processing.serial.*;

TimeDisplay timeDisplay;             // displays current time

int timer; //for demonstration;

void setup() {
  size(1000, 600, P2D);
  //fullScreen(P2D);
  
  PVector field = new PVector(width, height);
  
  //Usage: TimeDisplay(PVector center, float sizeH, PVector field, PImage background);
  timeDisplay = new TimeDisplay(" ", field.copy().div(2), field.x/1.2, field, loadImage("background.jpeg"));
}

void draw() {
  background(0);
  timer++;
  timeDisplay.changeString(String.format("%02d", (timer/216000)) + ":" + String.format("%02d", (timer/3600)%60) + ":" + String.format("%02d", (timer/60)%60) + "." + String.format("%02d", int(timer/float(60)*99)%99));
  //timeDisplay.changeString(String.format("%01d", (timer/60)) + "." + String.format("%02d", int(timer/float(60)*99)%99)); //Showcase for changing character counts
  timeDisplay.mainLoop();
}
