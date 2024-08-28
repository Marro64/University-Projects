/* Tutorial for dragging pieces
 Show a moving and left-clicking mouse indicating to the player that they can move pieces 
 */

class DragTutorial {
  PVector start, end, path, position;
  int timer, loopDuration = 100, mouseSize = 50;
  PImage leftMouse, noMouse;

  DragTutorial(PVector start, PVector end) {
    this.start = start;
    this.end = end;

    path = end.copy().sub(start);
    position = start.copy();

    leftMouse = loadImage("Mouse_Left_Key_Light.png");
    noMouse = loadImage("Mouse_Simple_Key_Light.png");
  }


  //Smoothly animate a cursor moving between two locations, with the left button held in one direction
  void mainLoop() {
    timer++;
    if (timer > loopDuration*PI) {
      timer = 0;
    }

    float velocity = sin(timer*2/float(loopDuration));
    PVector dMove = path.copy().mult(velocity/float(loopDuration));
    position.add(dMove);

    imageMode(CENTER);
    if (velocity >= 0) {
      image(leftMouse, position.x, position.y, mouseSize, mouseSize);
    } else {
      image(noMouse, position.x, position.y, mouseSize, mouseSize);
    }
    imageMode(CORNER);
  }
}
