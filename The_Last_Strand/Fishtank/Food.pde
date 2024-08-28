// Food class by Nina Vroom
// Food that the attracts the fish

class Food {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float minVelocity = 1;
  float size;
  boolean underwater; // if the particle is underwater
  
  // TODO: missing check for if it spawns underwater
  Food(PVector initPosition, float initSize) {
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 2);
    underwater = false;
    
    position = initPosition;
    size = initSize;
  }
  
  void checkWater(Water water) {
    if(position.y-velocity.y < water.getYPosAtXPos(position.x) && position.y > water.getYPosAtXPos(position.x)) { // when it hits the surface of the water send a splash, change movement
      water.addForce(position.x, size, velocity.y/100);
      underwater = true;
      acceleration = new PVector(0, 0);
    }
  }
  
  // draw the food
  void render() {
    noStroke();
    fill(150);
    circle(position.x, position.y, size);
  }
  
  
  void update(Water water) { // ground collision??
    if (underwater) {
      acceleration = velocity.copy().mult(-0.1);
      if(velocity.y < minVelocity) {
        acceleration = new PVector(0, 0);
      }
    }
    velocity.add(acceleration);
    position.add(velocity);
    checkWater(water);
  }
}
