/*=================
Text ball animation by Marinus and Nina
3D text animation by Denzel and Jort
Ball clock program made by Marinus Bos and Denzel Hagen
Made as final assignment for the course Programming and Physical Computing at the University of Twente
made in module 2 of 2021/2022
=================*/

import processing.serial.*;

TimeDisplay timeDisplay;             // displays current time
SerialComm Arduino;                  // connects to Arduino for user input
AlarmDisplay alarm;                  // displays the alarm state 
Updater up;                          // custom class that takes care of the updates.
ScreenBrightness screenBrightness;   // adjusts screen brightness
boolean testing = false;                    // enables keyboard controls in place of Arduino, used for testing
boolean modifyDisplayBrightness = false;   // if the program should attempt to change the actual brightness of the display (not recommended) 

void setup() {
  //size(1000, 600, P3D);
  fullScreen(P3D);
  
  PVector field = new PVector(width, height);
  
  //Attempt to connect to an Arduino
  try {
    Arduino = new SerialComm(new Serial(this, Serial.list()[0], 19200));
  } 
  catch(Exception E) {
    println("Arduino not found! (" + E + ")");
  }
  
  timeDisplay = new TimeDisplay(field, loadImage("background.jpeg"));
  alarm = new AlarmDisplay();
  
  if(modifyDisplayBrightness == true) {
    screenBrightness = new ScreenBrightness(127, 64, 255, field, 0, 100); // initialize screenBrightness modifier to affect backlight brightness and draw brightness
  } else {
    screenBrightness = new ScreenBrightness(127, 64, 255, field); // initialize screenBrightness modifier to affect only draw brightness
  }
  
  up = new Updater(Arduino, alarm, screenBrightness);
}

void draw() {
  background(0);
  // update things
  if(Arduino != null) {
    Arduino.serialRead();
    up.update();
  }
  alarm.updateClock();
  // draw things
  timeDisplay.mainLoop();
  alarm.drawClock();
  screenBrightness.drawBrightness();
}

// used for testing in place of an Arduino
void keyPressed() {
  if(testing){
    switch(key) {
      case 'q': 
      // turn up the alarm hour
      Arduino.hour = (abs((alarm.getHour()+1)%24));
        break;
        
       case 'a': 
       // turn down the alarm hour
       Arduino.hour = (abs((alarm.getHour()-1)%24));
        break;
        
        case 'w': 
        // turn up the alarm minute
        Arduino.minute = (abs((alarm.getMinute()+1)%60));
        break;
        
        case 's': 
        // turn down the alarm minute
        Arduino.minute = (abs((alarm.getMinute()-1)%60));
        break;
        
        case 'W': 
        // turn up the alarm minute quickly
        Arduino.minute = (abs((alarm.getMinute()+1)%60));
        break;
        
        case 'S': 
        // turn down the alarm minute quickly
        Arduino.minute = (abs((alarm.getMinute()-1)%60));
        break;
        
        case 'e': 
        // turn off the ringing
        Arduino.alarmDismiss = true;
        break;
        
        case 'r': 
        // turn onn the ringing
        alarm.startRinging();
        Arduino.triggerAlarm();
        break;
        
        case 'd': 
        // toggle the alarm
        Arduino.alarmToggle = true;
        break;
        
        case 't':
        // turn up the screen brightness
        Arduino.light = ((screenBrightness.getBrightness()+8)%256);
        break;
        
        case 'g':
        // turn down the screen brightness
        Arduino.light = ((screenBrightness.getBrightness()-8)%256);
        break;
    }
  }
}
