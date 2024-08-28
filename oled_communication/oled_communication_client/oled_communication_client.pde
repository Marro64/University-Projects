/*OLED COMMUNICATION CLIENT
 * By Marinus Bos
 * 
 * Allows you to plot pixels on an oled that's connected to an arduino which is connected to a server.
 * A data packet consists of 4 bytes in the following structure: [x] [y] [command] [endmarker]
 * The following commands are supported: 'H' for drawing a pixel, 'L' for erasing a pixel, 'C' for clearing the canvas.
 * The endmarker is a single byte set to 255 (-1). This marker has to be at the 4th byte of a packet, else the packet will be discarded.
 * Contains code from edwindertien's client example.
 * 
 */


import processing.net.*;
Client c;

int pixelState[][];
int drawColor;
int scale = 8;

void setup() {
  size(1024, 256);
  frameRate(60);
  
  //create client class that talks to server
  c = new Client(this, "127.0.0.1", 12345);
  
  pixelState = new int[128][32]; //create the drawing canvas
  
  drawToCanvas(0, 0, 2); //clear the canvas
}

//create the local visualisation
void draw() {
  background(0);
  fill(#007FFF);
  
  for(int x = 0; x < pixelState.length; x++) {
    for(int y = 0; y < pixelState[x].length; y++) {
      if(pixelState[x][y] == 1) {
        rect(x*scale, y*scale, scale, scale);
      }
    }
  }
}

//when the mouse is pressed, look at the selected pixel and draw the opposite color
void mousePressed() {
  drawColor = -1; //set the color to undefined
  prepareToDraw(mouseX, mouseY);
}

//when the mouse is dragged, draw at the new position
void mouseDragged() {
  prepareToDraw(mouseX, mouseY);
}

//prep
void prepareToDraw(int cursorX, int cursorY) {
  //map the window to the canvas
  int x = cursorX/scale;
  int y = cursorY/scale;
  
  //if the color is undefined, take the opposite of the currently selected pixel
  if(drawColor == -1) {
    drawColor = 1-pixelState[x][y];
  }
  
  if(x >= 0 && x < pixelState.length && y >= 0 && y < pixelState[x].length) { //if the pixel is on the field
    if(pixelState[x][y] != drawColor) { //see if the pixel needs to be changed
      drawToCanvas(x, y, drawColor);
    }
  }
}

void drawToCanvas(int x, int y, int mode) {
  
  //draw to the local canvas
  switch(mode) {
    case 0:
      pixelState[x][y] = 0;
      break;
    case 1:
      pixelState[x][y] = 1;
      break;
    case 2:
      for(int xf = 0; xf < pixelState.length; xf++) {
        for(int yf = 0; yf < pixelState[x].length; yf++) {
          pixelState[x][y] = 0;
        }
      }
  }
  
  //mirror the local changes to the Arduino 
  
  //set the command character for the draw more
  char charMode;
  if(mode == 2) { //clear the screen
    charMode = 'C'; 
  } else if(pixelState[x][y] == 1) { //draw a pixel
    charMode = 'H';
  } else if(pixelState[x][y] == 0) { //erase a pixel
    charMode = 'L';
  } else {
    charMode = 0x00;
  }
  
  //construct and send the command packet to the server
  String data = x + " " + y + " " + charMode + " " + -1 + " ";
  println("client send: " + data);
  c.write(data);
}
