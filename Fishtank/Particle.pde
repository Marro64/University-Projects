/* A bubble particle
 * By Marinus Bos, 2022 
 */

class Particle {
  PVector pos;
  PVector vel;
  PVector acc;
  int lifespan;
  PShape shape;
  
  final float defaultStartVelocity = 1;
  final float defaultLifespan = 500;
  final float defaultSize = 5;

  Particle(PVector pos) {
    // Generate the bubble's (initial) state
    this.pos = pos.copy();
    
    vel = new PVector(0, -1).setMag(defaultStartVelocity*random(0.2, 2)).rotate(random(-PI/4.0, PI/4.0));
    acc = new PVector(0, -.01);
    lifespan = (int)(defaultLifespan*random(0.2, 2));
    
    float size = defaultSize * random(0.2, 2);
    
    colorMode(HSB);
    noFill();
    stroke(200 + random(-10, 10), 100 + random(-10, 0), 25 + random(-5, 5));
    strokeWeight(1);
    shape = createShape(ELLIPSE, 0, 0, size, size);
    colorMode(RGB);
  }

  void update() {
    lifespan -= 1; 
    
    // Limit velocity by turning off acceleration
    if(vel.mag() > 10) {
      acc.setMag(0);
    }

    vel.add(acc);
    pos.add(vel);
  }

  void display() {
    noStroke();
    shapeMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    shape(shape);
    popMatrix();
  }
  
  // returns true if the particle is to be destroyed, because it's expired or because it's out of the water
  boolean isDead(Water water) {
    if (lifespan > 0 && water.checkCollision(pos.copy()) == true) {
      return(false);
    }
    return(true);
  }
}
