class Trash {
  PImage bitmap;
  PImage[] bitmaps;
  PVector pos;
  PVector homePos;
  int moveDir = 0;
  boolean visible;
  float rotation;
  boolean noLimit = false;

  Trash(PImage[] bitmaps) {
    bitmap = randomBitmap(bitmaps);
    pos = new PVector(0, 0);
    homePos = new PVector(0, 0);
    moveDir = 0;
    visible = false;
    rotation = random(0, 2*PI);
  }

  Trash(PImage[] bitmaps, PVector pos, int moveDir, boolean visible) {
    bitmap = randomBitmap(bitmaps);
    this.pos = pos;
    this.homePos = pos.copy();
    this.moveDir = moveDir;
    this.visible = visible;
    rotation = random(0, 2*PI);
  }

  Trash(PImage bitmap) {
    this.bitmap = bitmap;
    pos = new PVector(0, 0);
    homePos = new PVector(0, 0);
    moveDir = 0;
    visible = false;
    rotation = random(0, 2*PI);
  }

  Trash(PImage bitmap, PVector pos, int moveDir, boolean visible) {
    this.bitmap = bitmap;
    this.pos = pos;
    this.homePos = pos.copy();
    this.moveDir = moveDir;
    this.visible = visible;
    rotation = random(0, 2*PI);
  }

  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(rotation);
    if (visible) {
      image(bitmap, 0, 0);
    }
    popMatrix();
  }

  void update() {
    pos.y += moveDir;

    if (!noLimit) {
      if (pos.y < -400 && moveDir < 0) {
        moveDir = 0;
      } else if (pos.y > homePos.y && moveDir > 0) {
        pos.y = homePos.y;
        moveDir = 0;
      }
    }
  }

  void startMovingUp() {
    moveDir = -5;
  }

  void startMovingDown() {
    moveDir = 5;
  }

  PImage randomBitmap(PImage[] bitmaps) {
    return(bitmaps[int(random(0, bitmaps.length))]);
  }
}
