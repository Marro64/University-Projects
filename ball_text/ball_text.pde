TextContainer textContainer;
boolean[] mouseButtons = {false, false}; //Left mouse button, right mouse button
PImage img;
PVector safeArea;
int border = 40;

void setup() {
  size(1000, 600, FX2D);
  img = loadImage("background.jpeg");
  safeArea = new PVector(width-2*border, height-2*border);
  String inputTxt[] = loadStrings("input.txt"); //load the first line of the text file
  textContainer = new TextContainer(inputTxt, safeArea);
  
  resized();
  registerMethod("pre", this);
}

void pre() {
  if (safeArea.x != width-2*border || safeArea.y != height-2*border) {
    safeArea.x = width-2*border;
    safeArea.y = height-2*border;
    resized();
  }
}

void draw() { 
  background(0);
  textContainer.mainLoop();
  //rect(border, border, safeArea.x, safeArea.y);
}

void mousePressed() {
  if (mouseButton == LEFT) {
    mouseButtons[0] = true;
  }
  if (mouseButton == RIGHT) {
    mouseButtons[1] = true;
  }
}

void mouseReleased() {
  if (mouseButton == LEFT) {
    mouseButtons[0] = false;
  }
  if (mouseButton == RIGHT) {
    mouseButtons[1] = false;
  }
}

void mouseDragged() {
  textContainer.mouseHandler(mouseButtons, new PVector(mouseX, mouseY));
}

void mouseMoved() {
  textContainer.mouseHandler(mouseButtons, new PVector(mouseX, mouseY));
}

void resized() {
  textContainer.organiseScreen(safeArea);
  img.resize(width, height);
}
