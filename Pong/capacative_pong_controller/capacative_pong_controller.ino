/* Capacitive pong controller
 * Allows you to play pong using your hands as part of a variable capacitor 
 * Reads the values of two (almost) floating wires and sends them to Arduino
 * Also reads and sends a button to serve the ball
 * By Marinus Bos, 2022
 */

#include <CapacitiveSensor.h>

CapacitiveSensor Sense1 = CapacitiveSensor(7, 6);
CapacitiveSensor Sense2 = CapacitiveSensor(3, 2);

void setup() {
  Serial.begin(115200);
  
  Sense1.set_CS_Timeout_Millis(2000);
  Sense1.set_CS_AutocaL_Millis(0xFFFFFFFF); //do not recalibrate sensors to not disturb the automatic range in the Arduino code
  Sense2.set_CS_Timeout_Millis(2000);
  Sense2.set_CS_AutocaL_Millis(0xFFFFFFFF);
}

void loop() {
  Serial.println ("A0." + String(Sense1.capacitiveSensor(32))); //send capacitive sensor data
  Serial.println ("A1." + String(Sense2.capacitiveSensor(32)));

  Serial.println("D0." + String(digitalRead(9))); //send button data
}
