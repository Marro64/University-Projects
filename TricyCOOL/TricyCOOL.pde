// Created by Team Blue 2
// Marinus, Valentijn, Nihat, Susanne
// Tricycle razorblade boxer shooting game

PVector field, cursor;
boolean keys[] = new boolean[3];
Game game;
Backdrop backdrop;

void setup() {
  size(800, 800);
  field = new PVector(width, height); //seperate play area size from screen size
  cursor = new PVector(mouseX, mouseY); //seperate cursor from mouse
  frameRate(60);
  
  game = new Game();
  backdrop = new Backdrop(); //backdrop that's independant of the background
}

void draw() {
  backdrop.display(); 
  cursor = new PVector(mouseX, mouseY); //seperate cursor from mouse
  
  if(keys[2]) { //reset if 'r' is pressed
    game = new Game();
  }
  
  game.mainLoop();
}

void keyPressed() { //update list of keys held when a key is pressed
  if (key == 'a' || key == 'A') keys[0] = true;
  if (key == 'd' || key == 'D') keys[1] = true;
  if (key == 'r' || key == 'R') keys[2] = true;
}

void keyReleased() { //update list of keys held when a key is released
  if (key == 'a' || key == 'A') keys[0] = false;
  if (key == 'd' || key == 'D') keys[1] = false;
  if (key == 'r' || key == 'R') keys[2] = false;
}

void mousePressed() {
  game.summonBlade();
}
