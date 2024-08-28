/*=================
A simple class for Serial communication
Reads data in the following packet structure:
  PA123\r\n
  ^ P indicates that the data is intended for Processing
   ^ A indicates what variable to store the data in
    ^^^ 123 is the value being transmitted
       ^^^^ newline indicates the end of a packet

In this case the following variables are accepted:
 L = light data from the LDR, H = hours, M = minutes (Arduino Uno analog in, so values between 0 - 1023)
 E = alarm dismissed button, A = alarm toggle button (Digital inputs, so values between 0 - 1)
=================*/

class SerialComm {
  Serial serial;
  
  //Store values received from the serial communication
  int light, hour, minute;
  boolean alarmToggle, alarmDismiss;

  SerialComm(Serial serial) {
    // Opening the port
    this.serial = serial;
    serial.bufferUntil('\n');
    
    // defaults when no Arduino is attached:
    light = 255;
    hour = 17;
    minute = 30;
    alarmToggle = false;
    alarmDismiss = false;
  }
  
  void triggerAlarm() {
    serial.write("AA1\r\n");
  }

  void serialRead() {
    String input = "";
    while(serial.available() > 0) {
      try {
        // read the data until the newline n appears
        input = serial.readStringUntil('\n');
  
        if (input != null) { //if there's data to process
          input = trim(input); //trim whitespace
          
          if(input.charAt(0) == 'P') { //see if the packet is destined for Processing
            char type = input.charAt(1); //seperate the variable indicator from the packet
            int val = int(input.substring(2)); //seperate the value from the packet
            
            switch(type) { //store the value in the appropriate variable
            case 'L':
              light = val;
              println("Light: " + light);
              break;
            case 'H':
              hour = val;
              println("Hour: " + hour);
              break;
            case 'M':
              minute = val;
              println("Minute: " + minute);
              break;
            case 'E':
              alarmDismiss = true;
              println("Alarm dismissed");
              break;
            case 'A':
              alarmToggle = val > 0; //returns false if value is 0, true if value is 1
              println("Alarm toggled");
              break;
            }
          }
        }
      } 
      
      catch(Exception E) {
        println(E);
      }
    }
  }
}
