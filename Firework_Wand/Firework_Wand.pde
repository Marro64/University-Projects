/* A magical firework that burn up into colorful stars
 * By Marinus Bos, 2022
 */

ParticleSystem particleSystem;
Wand wand;

void setup() {
  size(1000, 800);
  
  particleSystem = new ParticleSystem(new PVector(width/2, height/2), 0, 50, 70);
  wand = new Wand(particleSystem, new PVector(width/2, height/2));
}

void draw() {
  background(0);
  wand.update();
  particleSystem.update();
  
  wand.display();
  particleSystem.display();
}

void mouseMoved() {
  PVector cursor = new PVector(mouseX, mouseY);
  wand.move(cursor.copy());
}

void mouseDragged() {
  PVector cursor = new PVector(mouseX, mouseY);
  wand.move(cursor.copy());
}

void mousePressed() {
  wand.ignite();
}
