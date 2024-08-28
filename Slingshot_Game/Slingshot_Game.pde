/* Ball game
 * Use a slingshot to shoot a ball at targets and get points
 * For each set of targets hit an extra life is rewarded
 * By Marinus Bos, 2022
 */

Ball ball;
Slingshot slingshot;
TargetManager targets;
Game game;

long lastFrame;

void setup() {
  size(800, 800);
  
  PVector field = new PVector(width, height);
  
  ball = new Ball(field.copy().div(2), new PVector(1, 0).setMag(100).rotate(random(0, 2*PI)), 20, #FFFFFF, new PVector(width, height), true);
  slingshot = new Slingshot(ball, field.copy().div(2));
  targets = new TargetManager();
  game = new Game(targets, ball, slingshot, field.copy());
  
  game.startGame();
}

void draw() {
  background(192);
  
  // Get the current frame time
  long currentFrame = System.nanoTime();
  float dt = 60*(float)(currentFrame-lastFrame)/(float)(1000000000);
  lastFrame = currentFrame;
  
  // Run main loops
  final int precision = 10; // Precision multiplier for main game loop
  
  for(int i = 0; i < precision; i++) {
    ball.update(dt/(float)precision);
    int hit = targets.checkCollision(ball);
    game.addScore(hit);
    game.update();
  }
  
  // Draw objects
  ball.display();
  slingshot.drawSlingshot();
  targets.display();
  slingshot.drawOverlay();
  game.display();
}

void mousePressed() {
  game.mousePress(new PVector(mouseX, mouseY));
}

void mouseDragged() {
  game.mouseDrag(new PVector(mouseX, mouseY));
}

void mouseReleased() {
  game.mouseRelease();
}
