/*OLED COMMUNICATION SERVER
 * By Marinus Bos
 * 
 * Allows a remote client to plot pixels on an oled that's connected to this server via an Arduino.
 * A data packet consists of 4 bytes in the following structure: [x] [y] [command] [endmarker]
 * The following commands are supported: 'H' for drawing a pixel, 'L' for erasing a pixel, 'C' for clearing the canvas.
 * The endmarker is a single byte set to 255 (-1). This marker has to be at the 4th byte of a packet, else the packet will be discarded.
 * Contains code from edwindertien's server example.
 * 
 */


import processing.net.*;
Server s;
Client c;

import processing.serial.*; 
Serial myPort;

void setup() {
  s = new Server(this, 12345); // Start a simple server on a port
  frameRate(10);
  
  //connect to the arduino
  myPort = new Serial(this, Serial.list()[0], 115000); // open port 0 in the list at 115000 Baud
  delay(2000); //wait for the connection to be established
}

void draw() {
  // Receive data from client
  c = s.available();
  
  if (c != null) { //process potential data
    String data = c.readString();
    println("server received: " + data);
    
    
    
    //convert the data into the format that the Arduino expects
    String[] stringParts = split(data, ' ');
    byte[] bytes = new byte[stringParts.length];
    
    for (int i = 0; i < stringParts.length; i++) {
      
      try { //try to convert the string into a number
        bytes[i] = Byte.parseByte(stringParts[i]);
      }
      catch (NumberFormatException ex) {
        
        try { //try to get the first character's unicode
          bytes[i] = (byte)stringParts[i].charAt(0);
        }
        catch (Exception e) {
          bytes[i] = -1; //default to an end-of-packet marker
        }
      }
      
      print(bytes[i] + " ");
      myPort.write(bytes[i]); //send the data to the ARduino
    }
    println();
  }
}
