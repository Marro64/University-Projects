/* Draw the background to the puzzle
 Is in a seperate class so it can be drawn without the game being active, this isn't currently used. 
 */

class Background {
  PImage image;
  PVector position, size;

  Background(PImage image, PVector position, PVector size) {
    this.image = image;
    this.position = position;
    this.size = size;
  }

  void draw() {
    imageMode(CORNER);
    image(image, position.x, position.y, size.x, size.y);
  }

  void newSize(PVector newSize) {
    size = newSize;
  }
}
