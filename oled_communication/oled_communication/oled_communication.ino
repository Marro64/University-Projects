/*OLED COMMUNICATION
 * By Marinus Bos, 2021
 * 
 * Allows the arduino to receive serial data to plot pixels onto an OLED screen.
 * A data packet consists of 4 bytes in the following structure: [x] [y] [command] [endmarker]
 * The following commands are supported: 'H' for drawing a pixel, 'L' for erasing a pixel, 'C' for clearing the canvas.
 * The endmarker is a single byte set to 255 (-1). This marker has to be at the 4th byte of a packet, else the packet will be discarded.
 * Contains some code from Adafruit OLED SSD1306 library examples, mostly for communicating with the OLED screen.
 * 
 */


#include <Adafruit_SSD1306.h>

#define SCREEN_WIDTH 128 // OLED display width, in pixels
#define SCREEN_HEIGHT 32 // OLED display height, in pixels

// Declaration for an SSD1306 display connected to I2C (SDA, SCL pins)
// The pins for I2C are defined by the Wire-library. 
// On an arduino UNO:       A4(SDA), A5(SCL)
// On an arduino MEGA 2560: 20(SDA), 21(SCL)
// On an arduino LEONARDO:   2(SDA),  3(SCL), ...
#define OLED_RESET     4 // Reset pin # (or -1 if sharing Arduino reset pin)
#define SCREEN_ADDRESS 0x3C ///< See datasheet for Address; 0x3D for 128x64, 0x3C for 128x32
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

int x, y, command; 
int progress;

void setup() {
  
  Serial.begin(115000);

  progress = 0; //how many bytes of a packet have been received so far
  
  // SSD1306_SWITCHCAPVCC = generate display voltage from 3.3V internally
  if(!display.begin(SSD1306_SWITCHCAPVCC, SCREEN_ADDRESS)) {
    Serial.println(F("SSD1306 allocation failed"));
    for(;;); // Don't proceed, loop forever
  }
}
  
void loop() {
  
  // see if there's incoming serial data:
  if (Serial.available() > 0) {
    // read the oldest byte in the serial buffer:
    byte incomingByte = Serial.read();
    progress++;

    if(incomingByte == 255) { //when receiving an endmarker, execute the current packet and start a new one

      if (progress == 4) { //execute the packet
        
        switch(command) {
          
          case 'H': // if it's a capital H (ASCII 72), draw a pixel
            display.drawPixel(x, y, SSD1306_WHITE);
            display.display(); // Update screen with each newly-drawn rectangle
            break;
        
          case 'L': // if it's an L (ASCII 76) erase a pixel
            display.drawPixel(x, y, SSD1306_BLACK);
            display.display(); // Update screen with each newly-drawn rectangle
            break;
            
          case 'C': // if it's a C (ASCII 67) clear the screen
            display.clearDisplay();
            display.display();
            break;
        }
      }
       
      progress = 0;
      
    } else { //if data isn't an endpacket, store it
      
      switch(progress) {
        
        case 1: //1st byte is the x coordinate
          x = incomingByte;
          break;
          
        case 2:
          y = incomingByte; //2nd byte is the y coordinate
          break;
          
        case 3: //3rd byte is the command
          command = incomingByte;
          break;
          
        default: //4th byte should've been an endmarker and prevented the code from reaching here, other progress values are also invalid
          progress = -1; //invalidate the current packet
          break;
      }
    }
  }
}
