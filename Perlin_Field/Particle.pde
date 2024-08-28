class Particle extends PerlinField {
  /* A particle following a field of acceleration data
   * By Marinus Bos, 2022
   */

  PVector pos;

  Particle(PVector pos) {
    this.pos = pos.copy();
  }

  void update() {
    PVector vel = getPerlinAt(pos).mult(5);
    pos.add(vel);
  }

  void display() {
    noStroke();
    shapeMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    circle(0, 0, 5);
    popMatrix();
  }
}
