/*
 * A little creature in a window, living a simple life.
 * Click and drag to throw him around. Don't worry, he enjoys it.
 * By Marinus Bos, 2021
 */

//PShape creatureForm;
ArrayList<Creature> creatures = new ArrayList();
PVector field, cursor, pCursor;
boolean keys[] = new boolean[3];

void setup() {
  //fullScreen(FX2D); //FX2D has better performance and precision (especially noticable in the eyes of the creature), but worse compatibility
  size(600, 600);
  field = new PVector(width, height); //seperate the windows size from the creature area size
  frameRate(60);
  
  //generate a nice selection of different creatures
  int creatureCount = 1; //set to 10 for pretty colors
  colorMode(HSB, 360, 100, 100); //hue/saturation/brightness color mode, for extra vibrant creatures
  for(int i = 0; i < creatureCount; i++) {
    creatures.add(new Creature(new PVector((i+0.5)*(field.x/(float)creatureCount), field.y), (50+(i+1)*(50/(float)creatureCount)), color(i*(360/(float)creatureCount), 100, 100))); //increment hue and size of each creature
  }
  colorMode(RGB, 255, 255, 255); //back to regular RGB color mode which the rest of the program expects
}

void draw() {
  background(192);
  
  //seperate the mouse and the cursor
  cursor = new PVector(mouseX, mouseY);
  pCursor = new PVector(pmouseX, pmouseY);
  
  //debug
  //if(keys[1]) {
  //  creatures.get(0).physics.forceRotate(-PI/64);
  //}
  //if(keys[2]) {
  //  creatures.get(0).physics.forceRotate(PI/64);
  //}
  
  for(Creature c : creatures) {
    c.draw();
  }
  
  //println("framerate:", frameRate);
}

void mousePressed() {
  for(int c = creatures.size()-1; c >= 0; c--) { //go through the list of creatures backwards so the once in the front get checked first
    if(creatures.get(c).checkCollision()) {
      break;
    }
  }
}

void mouseReleased() {
  for(Creature c : creatures) {
    c.releaseCursor();
  }
}

//debug
//void keyPressed() { //update list of keys held when a key is pressed
//  if (key == 'r' || key == 'R') keys[0] = true;
//  if (key == 'a' || key == 'A') keys[1] = true;
//  if (key == 'd' || key == 'D') keys[2] = true;
//}

//void keyReleased() { //update list of keys held when a key is released
//  if (key == 'r' || key == 'R') keys[0] = false;
//  if (key == 'a' || key == 'A') keys[1] = false;
//  if (key == 'd' || key == 'D') keys[2] = false;
//}
