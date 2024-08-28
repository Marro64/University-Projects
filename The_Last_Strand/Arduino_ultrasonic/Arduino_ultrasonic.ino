#include <Ultrasonic.h>

Ultrasonic ultrasonic(9, 8, 40000UL);
Ultrasonic ultrasonic2(11, 10, 40000UL);

void setup() {
  Serial.begin(9600);
}

void loop() {
  Serial.println("PD" + String(millis()) + "." + String(ultrasonic.read()));
  Serial.println("PE" + String(millis()) + "." + String(ultrasonic2.read()));
  delay(10);
}
