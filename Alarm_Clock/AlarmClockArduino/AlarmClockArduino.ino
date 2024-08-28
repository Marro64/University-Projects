/*
 * Interface of an alarm clock, requires the accompanying Processing sketch
 * Program made by Marinus Bos and Denzel Hagen
 * Made as final assignment for the course Programming and Physical Computing at the University of Twente
 * made in module 2 of 2021/2022
 */

// constants
static const int bdrate = 19200;         // baudrate for the Serial Monitor
static const int potThreshold = 5;      // threshold before a change in the potentiometers is detected.
static const int loopWait = 16;
// pins
static const int lightSensorPin = A0;   // pin for the voltage divider that senses the light pin
static const int hourPotPin = A1;       // pin for the potentiometer that controls the hours
static const int minPotPin = A2;        // pin for the potentiometer that controls the minutes
static const int setButtonPin = 2;    // pin for the button that enables or disables the alarm
static const int ringingOffPin = 3;    // pin for the button that turns off the alarm when it rings
static const int buzzerPin = 9;         // pin for the buzzer
static const int lightPin = 10;         // pin for the light

// timers
long ringTimer = 0;
long lastLoop = 0;

// variables
int hourPotVal = 0;
int minPotVal = 0;

// alarm set button
bool alarmOn = false;
int alarmOnInt = 0;     // integer version of alarmOn for easier comparison.

// alarmRinging settings
bool alarmRinging = false;
int alarmPWM = 0;             // variable pulse width to make sure effects are not static
bool pwmIncreasing = false;   // keeps track whether the PWM is increasing or decreasing now
long alarmTimer = 0;          // keeps track of when the PWM is changing.

void setup() {
  Serial.begin(bdrate);
  Serial.setTimeout(10);
  // setting pins
  pinMode(lightSensorPin, INPUT);
  pinMode(hourPotPin, INPUT);
  pinMode(minPotPin, INPUT);
  pinMode(setButtonPin, INPUT);
  pinMode(ringingOffPin, INPUT);
  pinMode(buzzerPin, OUTPUT);
  pinMode(lightPin, OUTPUT);
}

void loop() {
  if(millis() > lastLoop+loopWait) {
    lastLoop = millis();
    readVals();
    alarmSetButton();
    alarmDismissButton();
    readLight();
    readHour();
    readMinute();
    if (alarmRinging) {
      alarmRing();
    }
  }
}

//Receive data from Processing
void readVals() {
  if (Serial.available() > 0) {
    Serial.println("Something's available");
    String input = Serial.readString();
                   input.trim();
    if (input.equals("AA1")) {
      Serial.println("Alarm time!");
      alarmRinging = true;
    }
    else if (input.equals("AA0")) {
      Serial.println("No more alarm");
      ringingOff();
    }
  }
}

void alarmSetButton() {
  int val1 = digitalRead(setButtonPin);
  if (val1 != alarmOnInt) {
    delay(5);
    int val2 = digitalRead(setButtonPin);
    if (val1 == val2) {
      alarmOnInt = val1;
      alarmOn = !alarmOn;
      Serial.print("PA");
      Serial.println(alarmOn);
    }
    if(alarmRinging == true) {
      ringingOff();
    }
  }
}

void alarmDismissButton() {
  int val = digitalRead(ringingOffPin);
  if (val > 0) {
    ringingOff();
  }
}

void readLight() {
    int val = analogRead(lightSensorPin);
    Serial.print("PL");
    Serial.println(val);
}

void readHour() {
  int val = analogRead(hourPotPin);
  if (abs(val - hourPotVal) > potThreshold) {
    hourPotVal = val;
    Serial.print("PH");
    Serial.println(val);
  }
}

void readMinute() {
  int val = analogRead(minPotPin);
  if (abs(val - minPotVal) > potThreshold) {
    minPotVal = val;
    Serial.print("PM");
    Serial.println(val);
  }
}

// accesses both the buzzer and the alarm LED.
void alarmRing() {
  int alarmTone = 100+alarmPWM*10;
  tone(buzzerPin, alarmTone);
  analogWrite(lightPin, alarmPWM);
  if (pwmIncreasing) {
    if (alarmPWM < 255) {
      alarmPWM++;
    } else {
      pwmIncreasing = false;
    }
  } else {
    if (alarmPWM > 0) {
      alarmPWM--;
    } else {
      pwmIncreasing = true;
    }
  }
}

void ringingOff() {
  alarmRinging = false;
  alarmPWM = 0;
  noTone(buzzerPin);
  analogWrite(lightPin, 0);
  Serial.print("PE");
  Serial.println(alarmRinging);
}
