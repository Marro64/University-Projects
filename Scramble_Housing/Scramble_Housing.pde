/* Scramble housing
 By Marinus Bos
 2021
 */
Game game;
PVector field, cursor;
final int levels = 3;
int currentLevel = 0;

void setup() {
  size(1000, 620, FX2D);
  field = new PVector(width, height); //disconnect the window size from the game size
  cursor = new PVector(mouseX, mouseY); //disconnect the mouse from the in-game cursor position
  nextLevel(); //start the first level
}

void draw() {
  cursor.set(mouseX, mouseY); //update the cursor position

  if (currentLevel <= levels) {
    game.mainLoop(); //execute the game
    if (game.nextLevel) {
      nextLevel(); //start the next level when the current game says it's finished
    }
  } else { //Display a simple ending screen and stop the program.
    textSize(40);
    fill(255);
    textAlign(CENTER);
    text("The end", field.x/2, field.y/2);
    textAlign(CORNER);
    noLoop();
  }
}

//start the next level by overriding the game object
void nextLevel() {
  currentLevel++;

  //store the position and size of the holes in the image in the following structure: {x, y, w, h}
  float[][] pieceSlots = {{42, 28, 215, 146}, {395, 30, 209, 143}, {743, 27, 213, 145}, {45, 264, 212, 145}, {397, 265, 210, 142}, {744, 265, 213, 144}, {45, 455, 213, 144}, {396, 456, 209, 142}, {744, 456, 213, 145}};

  switch(currentLevel) {
  case 1:
    game = new Game(loadImage("Building.png"), 3, 3, pieceSlots, loadImage("background1 cropped.jpg"), loadImage("cool.png"), 1, false, field, cursor);
    break;
  case 2:
    game = new Game(loadImage("House.png"), 3, 3, pieceSlots, loadImage("background1 cropped.jpg"), loadImage("rad.png"), 2, true, field, cursor);
    break;
  case 3:
    game = new Game(loadImage("Houses.png"), 3, 3, pieceSlots, loadImage("background1 cropped.jpg"), loadImage("congratulations.png"), 0, true, field, cursor);
  }
}

void mousePressed() {
  if (mouseButton == LEFT) {
    game.leftMouseClick();
  }
  if (mouseButton == RIGHT) {
    game.rightMouseClick();
  }
}

void mouseReleased() {
  if (mouseButton == LEFT) {
    game.leftMouseReleased();
  }
}
