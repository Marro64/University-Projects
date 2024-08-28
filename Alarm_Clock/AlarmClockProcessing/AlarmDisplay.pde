/*=================
Displays the alarm time and animates it when the alarm goes off
Also changes color depending on if the alarm is turned on or off

By Denzel, 2022 
=================*/

class AlarmDisplay {
  PFont font;
  AlarmLetter[] clock = new AlarmLetter[5];
  int[] xPos = new int[5];
  int hour;
  int minute;
  static final float HEIGHT_FACT = 0.8;
  boolean alarmEnabled;
  boolean isRinging;

  AlarmDisplay() {
    font = loadFont("CourierNewPSMT-48.vlw");
    textFont(font);
    alarmEnabled = false;
    isRinging = false;
    for (int i = 0; i < 5; i++) {
      xPos[i] = width/3+i*width/15;
      // load alarm hours with default "00:00"
      if (i == 2) {
        clock[i] = new AlarmLetter(':', xPos[i], height*HEIGHT_FACT, i);
      } else {
        clock[i] = new AlarmLetter('0', xPos[i], height*HEIGHT_FACT, i);
      }
    }
  }

  void drawClock() {
    for (int i = 0; i < 5; i++) {
      clock[i].drawLetter();
    }
  }

  void updateClock() {
    for (int i = 0; i < 5; i++) {
      clock[i].updateLetter();
    }
  }

  void toggleAlarm(boolean on) {
    alarmEnabled = on;
    color colour = color(64);
    if (on) {
      colour = color(255);
    } 
    for (int i = 0; i < 5; i++) {
      clock[i].setColor(colour);
    }
  }

  void stopRinging() {
    isRinging = false;
    timeDisplay.alarmOff();
    for (int i = 0; i < 5; i++) {
      clock[i].stopRinging();
    }
  }
  
  void startRinging() {
    isRinging = true;
    timeDisplay.alarmOn();
    for (int i = 0; i < 5; i++) {
      clock[i].startRinging();
    }
  }

  void setHour(int newHour) {
    hour = newHour;
    // find the first and second number of the value, then place them in their corresponding spot
    char leftHour = (""+(newHour/10)).charAt(0);
    char rightHour = (""+(newHour%10)).charAt(0);
    clock[0].setLetter(leftHour);
    clock[1].setLetter(rightHour);
  }

  void setMinute(int newMin) {
    minute = newMin;
    // find the first and second number of the value, then place them in their corresponding spot
    char leftMin = (""+(newMin/10)).charAt(0);
    char rightMin = (""+(newMin%10)).charAt(0);
    clock[3].setLetter(leftMin);
    clock[4].setLetter(rightMin);
  }

  int getHour() {
    return hour;
  }

  int getMinute() {
    return minute;
  }
  
  boolean isEnabled() {
    return alarmEnabled;
  }
  
  boolean isRinging() {
    return isRinging;
  }
}
