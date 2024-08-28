/* If the puzzle is solved:
 Display an image, along with a text prompting players to click to continue
 */
class WinScreen {
  PImage image;
  PVector imgPos, textPos;
  float textBackgroundWidth;
  final int textSize = 30, horTextPadding = 10;


  WinScreen(PImage image, PVector position) {
    this.image = image;
    this.imgPos = position;

    textPos = imgPos.copy().add(0, image.height/2+textSize*2); //set the text position below the image
    textSize(textSize);
    textBackgroundWidth = textWidth("click to continue") + horTextPadding; //set the width of the rectangle behind the text
  }

  //draw the win screen;
  void draw() {
    imageMode(CENTER);
    image(image, imgPos.x, imgPos.y);
    imageMode(CORNER);

    rectMode(CENTER);
    fill(0);
    rect(textPos.x, textPos.y-10, textBackgroundWidth, textSize); //display a rectangle behind the text
    rectMode(CORNER);

    textAlign(CENTER);
    textSize(30);
    fill(255);
    text("click to continue", textPos.x, textPos.y);
    textAlign(CORNER);
  }
}
