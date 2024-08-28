/*=================
Prepares variables to be used by functions, and calls these functions when the variables have changed. 
=================*/


class Updater {
  SerialComm s;
  AlarmDisplay alarm;
  ScreenBrightness screen;
  boolean alarmHasBeenToggled = false; //makes sure each button press only toggles the alarm once

  Updater(SerialComm serial, AlarmDisplay a, ScreenBrightness scr) {
    s = serial;
    alarm = a;
    screen = scr;
  }
  
  //call relevant functions to update parts of the program based on variables
  void update() {
    updateHour();
    updateMinute();
    updateAlarm();
    updateRinging();
    checkAlarm();
    updateBrightness();
  }

  //activate the alarm at the correct time 
  void checkAlarm() {
    if (hour() == alarm.getHour() && minute() == alarm.getMinute() && alarm.isEnabled() && !alarm.isRinging() && second() == 0) {
      alarm.startRinging();
      s.triggerAlarm();
    }
  }
  
  //when the toggle alarm button has been pressed, toggle the alarm state
  void updateAlarm() {
    if(s.alarmToggle) {
      if(alarmHasBeenToggled == false) {
        if(alarm.isEnabled()) {
          alarm.toggleAlarm(false);
          alarmHasBeenToggled = true;
        } else {
          alarm.toggleAlarm(true);
          alarmHasBeenToggled = true;
        }
      }
    } else {
      alarmHasBeenToggled = false;
    }
  }
  
  //dismiss the alarm when the relevant button has been pressed
  void updateRinging() {
    if (s.alarmDismiss) {
      s.alarmDismiss = false;
      alarm.stopRinging();
    }
  }

  void updateHour() {
    int hour = int(map(s.hour, 0, 1000, 0, 23)); //map the analog in values to hours, with some margins for the upper value
    
    //ensure that the values are in the correct range
    if(hour > 23) {
      hour = 23;
    } else if(hour < 0) {
      hour = 0;
    }
    
    //if the value has been updated, call the relevant function
    if (hour != alarm.getHour()) {
      alarm.setHour(hour);
    }
  }

  void updateMinute() {
    int min = int(map(s.minute, 0, 1000, 0, 59)); //map the analog in values to minutes, with some margins for the upper value
    
    //ensure that the values are in the correct range
    if(min > 59) {
      min = 59;
    } else if(min < 0) {
      min = 0;
    }
    
    //if the value has been updated, call the relevant function
    if (min != alarm.getMinute()) {
      alarm.setMinute(min);
    }
  }

  void updateBrightness() {
    int brightness = int(map(s.light, 512, 32, 0, 255)); //map the analog in values to a byte, with large margins
    
    println("Mapped light: " + brightness); 
    
    //if the value has been updated, call the relevant function
    if (brightness != screenBrightness.getBrightness()) {
      screenBrightness.setBrightness(brightness);
    }
  }
}
