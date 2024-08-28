/* Controller
 2021: Communicates with the arduino to receive controller input and parses the data.
 A data packet has the following structure:  
 A0.123
 ^ Signifies if the signal is Digital or Analog
 A0.123
 ^ Which number input of the type the data came from
 A0.123
 ^ Delimiter, separates the input number from the value
 A0.123
 ^^^ The new value of the input
 A0.123
 ^ \n signifies the end of a packet. \r gets discarded.
 
 2022: Added dynamic map functionality to work with a capacitive controller
 */
 

class Controller {
  Serial serial;

  int[] analog; //store analog input
  int[] analogRange; //store the maximum value of the analog input range
  boolean[] digital; //store digital input 

  Controller(Serial serial, int analogAmount, int digitalAmount) {
    this.serial = serial;
    analog = new int[analogAmount]; //initialize to the amount of analog inputs 
    analogRange = new int[analogAmount];
    digital = new boolean[digitalAmount]; //initialize to the amount of digital inputs
    
    for(int i = 0; i < analogAmount; i++) {
      analogRange[i] = 1;
    }
  }
  
  //main loop
  void receiveInput() {
    println("Frame " + frameCount + ":");
    while (serial.available() > 0) { //loop as long as there's data in the serial buffer

      String serialString = serial.readStringUntil('\n'); //read until an end of packet char, returns null if the char is not found

      if (serialString != null) { //if there's a packet to process
        serialString = serialString.substring(0, serialString.length()-1); //discard the \r

        print("input: \"" + serialString + "\"");

        try { //in case there's anything wrong with the packet, catch the exception

          char type = serialString.charAt(0); //store the type signifier

          int delimLocation = serialString.indexOf('.'); //store the location of the delimiter, aka the '.'
          int index = int(serialString.substring(1, delimLocation)); //store the index as an int

          println(", type: " + type + ", index: " + index + ", delimLocation: " + delimLocation + ", value: " + Integer.parseInt(serialString.substring(delimLocation+1, serialString.length()-1)));

          if (type == 'A') { //if the input type is analog

            analog[index] = parseInt(serialString.substring(delimLocation+1, serialString.length()-1)); //parse the value from the packet and store it in the analog input array at the index from the packet
            analog[index] = mapCapacitive(index); //map the input to the screen
            
          } else if (type == 'D') { //if the input type is digital

            int numValue = parseInt(serialString.substring(delimLocation+1, serialString.length()-1)); //parse the value from the packet and store it as an integer
            
            //convert the value to a boolean and store it in the analog input array at the index from the packet
            if (numValue == 1) {

              digital[index] = true;
              
            } else if (numValue == 0) {

              digital[index] = false;
              
            } else {
              
              throw new UnsupportedOperationException("Error parsing serial input: value of type D must be 0 or 1"); //if the value parsed can't be converted to a boolean, throw an error
              
            }
          } else {
            
            throw new UnsupportedOperationException("Error parsing serial input: input type must be A or D"); //if the input type is not recognised, throw an error
            
          }
        }
        
        //if an error occurs, print the error message and drop the packet
        catch (Exception E) {
          
          println(E);
          
        }
      } else { //if there isn't a full packet to process, interrupt the loop and wait until next frame
      
        break;
        
      }
    }
    println();
  }
  
  //map the capacitive input from a dynamically determined range
  int mapCapacitive(int index) {
  final float deadzone = 0.25; //how far away the input has to be from the range to register 
  
  if(analog[index] > analogRange[index]) { //update the maximum of the range to the highest input seen 
    analogRange[index] = analog[index];
  }
    
  return(int(map(analog[index], int(analogRange[index]*deadzone), int(analogRange[index]*(1-deadzone)), 0, height))); //map the input to the height of the field
  }
}
