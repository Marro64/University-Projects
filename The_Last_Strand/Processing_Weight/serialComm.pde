/*=================
A simple class for Serial communication
Reads data in the following packet structure:
  PA123\r\n
  ^ P indicates that the data is intended for Processing
   ^ A indicates what variable to store the data in
    ^^^ 123 is the value being transmitted
       ^^^^ newline indicates the end of a packet
=================*/

class SerialComm {
  Serial serial;
  
  //Store values received from the serial communication
  int distance;

  SerialComm(Serial serial) {
    // Opening the port
    this.serial = serial;
    serial.bufferUntil('\n');
    
    // defaults when no Arduino is attached:
    distance = 20;
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
            
            int delimPos = input.indexOf('.');
            
            int timestamp = int(input.substring(2, delimPos)); //seperate the timestamp from the packet
            int val = int(input.substring(delimPos+1)); //seperate the value from the packet
            
            switch(type) { //store the value in the appropriate variable
            case 'D':
              distance = val;
              println("Distance at " + timestamp + ": " + distance);
              sensor.newMeasurement(timestamp, distance);
              break;
            }
          }
        }
        else {
          break;
        }
      } 
      
      catch(Exception E) {
        println(E);
      }
    }
  }
}
