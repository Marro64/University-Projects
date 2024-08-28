/*
 * Pong controller
 * by Marinus Bos
 * 
 * Collects data from pins A0, A1 and 7 and sends them to the computer in the following format:
 * A0.123
 * ^ Signifies if the signal is Digital or Analog
 * A0.123
 *  ^ Which number input of the type the data came from
 * A0.123
 *   ^ Delimiter, separates the input number from the value
 * A0.123
 *    ^^^ The new value of the input
 * A0.123
 *       ^ \r signifies the end of a packet. \n gets discarded.
 *  
 * Data is only sent if the input changes
 */

//variables to store the old values of the input, to check if they changed
int oldAnalog0, oldAnalog1;
boolean oldDigital0;

void setup() {
  Serial.begin(115000);
}

void loop() {
  int val; //store the current readings
  
  val = analogRead(A0); //read the value from the input
  if(val != oldAnalog0) { //if the value changed
    Serial.println("A0." + String(val)); //send a data  packet
  }
  oldAnalog0 = val; //store the value for next time
  
  val = analogRead(A1);
  if(val != oldAnalog1) {
    Serial.println("A1." + String(val));
  }
  oldAnalog1 = val;

  val = digitalRead(7);
  if(val != oldDigital0) {
    Serial.println("D0." + String(val));
  }
  oldDigital0 = val;
  
  delay(16); //delay so the reads happen approx. 60 times per second
}
