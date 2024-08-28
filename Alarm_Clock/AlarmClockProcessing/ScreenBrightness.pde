/*=================
A class which allows adjusting of the screen brightness using two methodes:
 - draw brightness: puts a translucent black overlay over the schetch, reducing the brightness of the colors.
 - backlight brightness: uses a Windows powershell command to adjust the actual brightness of the screen.
   Only works on compatible Windows devices, and freezes the program for a split second for each change. A rate limit can be set to reduce this issue.
Depending on the argument given when initializing the class either draw, backlight or both methodes will be active. 

Backlight changing code is a Processing adaptation of Java code by Darty11 on Stackoverflow (https://stackoverflow.com/questions/15880547/how-to-change-laptop-screen-brightness-from-a-java-application)

By Marinus Bos, 2022
=================*/

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

class ScreenBrightness {
  int brightness = 127; //The screen brightness, between 0 and 255
  int drawBrightnessMin = 0, drawBrightnessMax = 0; //the range of transparancy of the darkening overlay. Default values disable it as a fallback. Values between 0 and 255 are allowed.
  PVector field = new PVector(0, 0); 
  int backlightBrightnessMin = 0, backlightBrightnessMax = 100; //the range of screen brightnesses, values between 0 and 100 are allowed
  int backlightChangeWait = 1000; //limits the rate in which the backlight can be changed 
  int lastBacklightChange = 0;
  boolean changeBackgroundBrightness; //sets if the backlight brightness will be changed
  
  //initialize to only affect background brightness
  ScreenBrightness(int startBrightness, int backlightBrightnessMin, int backlightBrightnessMax) { 
    this.backlightBrightnessMin = backlightBrightnessMin;
    this.backlightBrightnessMax = backlightBrightnessMax;
    
    changeBackgroundBrightness = true;
    
    setBrightness(startBrightness);
  }
  
  //initialize to only affect draw brightness
  ScreenBrightness(int startBrightness, int drawBrightnessMin, int drawBrightnessMax, PVector field) {
    this.drawBrightnessMin = drawBrightnessMin;
    this.drawBrightnessMax = drawBrightnessMax;
    this.field = field;
    
    changeBackgroundBrightness = false;
    
    setBrightness(startBrightness);
  }
  
  //initialize to affect both draw and background brightness
  ScreenBrightness(int startBrightness, int drawBrightnessMin, int drawBrightnessMax, PVector field, int backlightBrightnessMin, int backlightBrightnessMax) {
    this.drawBrightnessMin = drawBrightnessMin;
    this.drawBrightnessMax = drawBrightnessMax;
    this.field = field;
    this.backlightBrightnessMin = backlightBrightnessMin;
    this.backlightBrightnessMax = backlightBrightnessMax;
    
    changeBackgroundBrightness = true;
    
    setBrightness(startBrightness);
  }
  
  //call to change the brightness, performs a sanity check and then sets a variable for drawbrightness and calls the change method for background brightness
  void setBrightness(int newBrightness) {
    if(newBrightness < 256 && newBrightness > 0) { 
      this.brightness = newBrightness;
      
      if(changeBackgroundBrightness == true) { //set the background brightness if this is enabled
        setBacklightBrightness(brightness);
      }
    }
    println(brightness);
  }
  
  int getBrightness() {
    return(brightness);
  }
  
  //call at end of draw() only if class is initialized to affect draw brightness
  void drawBrightness() {
    int alpha = int(map(brightness, 0, 255, drawBrightnessMin, drawBrightnessMax));
    fill(0,0,0,255-alpha);
    rect(0,0,width,height);
  }
  
  //changes the backlight brightness, with try statement to handle any errors
  void setBacklightBrightness(int brightness) {
    if(millis() > lastBacklightChange + backlightChangeWait) {
      lastBacklightChange = millis();
      try {
        brightness = int(map(brightness, 0, 255, backlightBrightnessMin, backlightBrightnessMax));
        trySetBacklightBrightness(brightness);
      }
    
      catch(Exception E) {
        println(E);
      }
    }
  }
  
  //uses Windows PowerShell to change the background brightness. Needs to be called from a try-statement to handle any errors.
  //Processing adaptation of Java code by Darty11 on Stackoverflow (https://stackoverflow.com/questions/15880547/how-to-change-laptop-screen-brightness-from-a-java-application)
  void trySetBacklightBrightness(int brightness)
    throws IOException {
    //Creates a powerShell command that will set the brightness to the requested value (0-100), after the requested delay (in milliseconds) has passed. 
    String s = String.format("$brightness = %d;", brightness)
      + "$delay = 0;"
      + "$myMonitor = Get-WmiObject -Namespace root\\wmi -Class WmiMonitorBrightnessMethods;"
      + "$myMonitor.wmisetbrightness($delay, $brightness)";
    String command = "powershell.exe  " + s;
    // Executing the command
    Process powerShellProcess = Runtime.getRuntime().exec(command);

    powerShellProcess.getOutputStream().close();

    //Report any error messages
    String line;

    BufferedReader stderr = new BufferedReader(new InputStreamReader(
      powerShellProcess.getErrorStream()));
    line = stderr.readLine();
    if (line != null)
    {
      System.err.println("Standard Error:");
      do
      {
        System.err.println(line);
      } 
      while ((line = stderr.readLine()) != null);
    }
    stderr.close();
  }
}
