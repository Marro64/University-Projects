class Weight {
  int size;
  int pos;
  int health;
  
  Weight(int size, int pos, int health) {
    this.size = size;
    this.pos = pos;
    this.health = health;
  }
  
  void debugDisplay() {
    colorMode(HSB, 255);
    fill(color(health, 255, 255));
    rect(field.x-20, field.y-pos, 20, size);
    colorMode(RGB);
  }
}
