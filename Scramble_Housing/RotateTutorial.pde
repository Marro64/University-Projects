/* Tutorial for rotating pieces
 Show an icon of a right-clicking mouse to indicate that you can rotate pieces
 */
class RotateTutorial {
  PVector position;
  int timer, loopDuration = 100, mouseSize = 50;
  PImage rightMouse, noMouse;

  RotateTutorial(PVector position) {
    this.position = position;

    rightMouse = loadImage("Mouse_Right_Key_Light.png");
    noMouse = loadImage("Mouse_Simple_Key_Light.png");
  }

  //alternate between drawing the cursor of a right-clicking mouse and a mouse that isn't clicking
  void mainLoop() {
    timer++;

    imageMode(CENTER);
    if (timer < loopDuration/2) {
      image(rightMouse, position.x, position.y, mouseSize, mouseSize);
    } else {
      image(noMouse, position.x, position.y, mouseSize, mouseSize);
    }
    imageMode(CORNER);

    if (timer >= loopDuration) {
      timer = 0;
    }
  }
}
