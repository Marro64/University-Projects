class Game {
  final int rows = 3;
  final int columns = 10;
  boolean bladeActive = false;
  int currentColor;

  Blade blade;
  Boxer[][] boxers;
  Tricycle tricycle;

  Game() {
    tricycle = new Tricycle(width/2, 650);
    blade = new Blade(0, 0, 0, 0, 0, 1);
    destroyBlade(); //so the blade is in a common state
    
    boxers = new Boxer[columns][rows];
    for (int row = 0; row < rows; row++) { 
      for (int column = 0; column < columns; column++) {
        boxers[column][row] = new Boxer(column*80+5, row*80+5, int(random(1, 4)));
      }
    }
  }

  //updates all game objects
  void mainLoop() {
    
    if(bladeActive) {
      blade.move();
      blade.display();
      if(blade.bladeX > width+10 || blade.bladeX < -10 || blade.bladeY > height+10 || blade.bladeY < -10) { //check if blade has exited the screen
        destroyBlade();
      }
    }
    
    tricycle.move();
    tricycle.display();
    
    for (int row = 0; row < rows; row++) {
      for (int column = 0; column < columns; column++) {
        boxers[column][row].display();
        if(boxers[column][row].visible && bladeActive) { //seperated from next if to keep it readable
          if(boxers[column][row].x < blade.bladeX && boxers[column][row].y < blade.bladeY && boxers[column][row].x > blade.bladeX - 70 && boxers[column][row].y > blade.bladeY - 70) { //check for blade collision with boxes
            println(currentColor);
            if(boxers[column][row].colorValue == currentColor) { //if the box you hit is the same as the blade's color
              println(currentColor);
              boxers[column][row].disapear();
            }
            destroyBlade();
          }
        }
      }
    }
  }
  
  //summon the blade to the canon
  void summonBlade() {
    if(!bladeActive) {
      bladeActive = true;
      PVector direction = new PVector(0,-10).rotate(tricycle.canon.angle); 
      blade = new Blade(tricycle.canon.canonX, tricycle.canon.canonY, tricycle.canon.angle, direction.x, direction.y, currentColor); //summon blade in the same position and direction as the canon
    }
  }
  
  //make the blade inactive and choose the next color
  void destroyBlade() {
    bladeActive = false;
    currentColor = int(random(1,4)); //choose the next color
  }
}
