// Boid class by Nina Vroom
// The fish creature that swims around

// Referenced Boid Wikipedia https://en.wikipedia.org/wiki/Boids to check rules
// Referenced Daniel Shiffman The Nature of Code to tweak steering code
class Boid {
  ParticleSystem bubbleMaker; // bubble particle system
  
  PVector bounds; // the bounds of the screen
  PVector position;
  PVector velocity;
  PVector acceleration;
  float maxVelocity;
  float maxForce;
  float falloffDist; // the 'view' range of the boids
  float desiredSeparation; // the separation value
  float size; // used for drawing
  
  Boid(PVector initPosition, PVector initBounds) {
    bubbleMaker = new ParticleSystem(initPosition.copy(), 100);
    
    bounds = initBounds.copy();
    position = initPosition.copy();
    velocity = new PVector(random(-1, 1), random(-1, 1));
    acceleration = new PVector(0, 0);
    maxVelocity = 3;
    maxForce = 0.05;
    falloffDist = 100;
    desiredSeparation = 40;
    size = 5;
  }
  
  void update(ArrayList<Boid> boids, Water water, ProceduralSand sand, FoodContainer food) {
    acceleration = heading(boids, water.getPointPositions(), sand.getPointPositions(), food.getPositions()).copy(); // calculate the new force
    consume(food); // check if any food has been hit
    velocity.add(acceleration);
    if(velocity.mag() > maxVelocity) { // don't go too fast
      velocity.setMag(maxVelocity);
    }
    position.add(velocity);
    
    // if the fish *happens* to hit an edge, loop it. Is avoided by steering code, should be overhauled to bounce instead
    if(position.x > bounds.x) {
      position.x = 0;
    }
    if(position.y > bounds.y) {
      position.y = 0;
    }
    if(position.x < 0) {
      position.x = bounds.x;
    }
    if(position.y < 0) {
      position.y = bounds.y;
    }
    
    // Move boids that are outside of the water back into the water
    if(water.checkCollision(position) == false) {
      position.y = water.getYPosAtXPos(position.x)+1;
    }
    
    // Move boids that are inside the sand to the top of the sand
    if(sand.checkCollision(position) == true) {
      position.y = sand.getYPosAtXPos(position.x)-1;
    }
    
    // move the particle system to originate at the boid position
    bubbleMaker.move(position.copy());
    bubbleMaker.update(water);
  }
  
  void consume(FoodContainer food) {
    ArrayList<Food> toRemove = new ArrayList<Food>(); // keeps track of food that's been consumed
    for(Food thisFood : food.food) {
      // distance check
      if(dist(thisFood.position.x, thisFood.position.y, position.x, position.y) <= thisFood.size/2) {
        toRemove.add(thisFood); // add to be removed
      }
    }
    for(Food thisFood : toRemove) {
      food.removeFood(thisFood); // remove the food
    }
  }
  
  PVector heading(ArrayList<Boid> boids, PVector[] waterPoints, PVector[] sandPoints, ArrayList<PVector> attractPoints) { // needs a better name, heading isn't accurate
    ArrayList avoidPoints = avoidWalls(); // find points on the walls to avoid
    
    // add points to avoid on surface of the water
    for(int i = 0; i < waterPoints.length; i++) {
      avoidPoints.add(waterPoints[i]);
    }
    
    // add points to avoid on surface of the sand
    for(int i = 0; i < sandPoints.length; i++) {
      avoidPoints.add(sandPoints[i]);
    }
    
    // determines the new acceleration force
    PVector separation = separate(boids);
    PVector alignment = align(boids);
    PVector cohesion = cohere(boids);
    PVector attraction = attract(attractPoints);
    PVector avoidance = avoid(avoidPoints);
      
    // for weighting values, altering behavior
    separation.mult(1.5);
    alignment.mult(.7);
    cohesion.mult(1.0);
    attraction.mult(1.0);
    avoidance.mult(1.5);
    
    // add everything
    PVector heading = new PVector(0, 0);
    heading.add(separation);
    heading.add(alignment);
    heading.add(cohesion);
    heading.add(attraction);
    heading.add(avoidance);
    
    return heading;
  }
  
  PVector separate(ArrayList<Boid> boids) {
    PVector steer = new PVector(0, 0);
    
    for(Boid boid : boids) {
      float distance = dist(boid.position.x, boid.position.y, position.x, position.y); // distance check
      if(distance < desiredSeparation && distance != 0) {
        steer.add(position.copy().sub(boid.position).div(distance)); // steer away from boid that's too close
      }
    }
    
    // correction for current velocity
    if(steer.mag()>0) {
      steer.setMag(maxVelocity);
      steer.sub(velocity);
      steer.limit(maxForce);
    }
    return steer;
  }
  
  PVector align(ArrayList<Boid> boids) {
    PVector steer = new PVector(0, 0);
    
    for(Boid boid : boids) {
      float distance = dist(boid.position.x, boid.position.y, position.x, position.y); // distance check
      if(distance < falloffDist && distance != 0) { // steer in the same direction as nearby boids
        steer.add(boid.velocity);
      }
    }
    
    // correction for current velocity
    if(steer.mag()>0) {
      steer.setMag(maxVelocity);
      steer.sub(velocity);
      steer.limit(maxForce);
    }
    return steer;
  }
  
  PVector cohere(ArrayList<Boid> boids) {
    PVector steer = new PVector(0, 0);
    
    for(Boid boid : boids) {
      float distance = dist(boid.position.x, boid.position.y, position.x, position.y); // distance check
      if(distance < falloffDist && distance != 0) {
        steer.add(boid.position.copy().sub(position)); // steer towards the center of mass of nearby boids
      }
    }
    
    // correction for current velocity
    if(steer.mag()>0) {
      steer.setMag(maxVelocity);
      steer.sub(velocity);
      steer.limit(maxForce);
    }
    return steer;
  }
  
  PVector avoid(ArrayList<PVector> avoidPoints) {
    PVector steer = new PVector(0, 0);
    
    for(PVector point : avoidPoints) {
      float distance = dist(point.x, point.y, position.x, position.y); // distance check
      if(distance < falloffDist && distance != 0) {
        steer.add(position.copy().sub(point).div(distance)); // steer away from points to be avoided
      }
    }
    
    steer.normalize();
    return steer;
  }
  
  PVector attract(ArrayList<PVector> attractPoints) {
    PVector steer = new PVector(0, 0);
    
    for(PVector point : attractPoints) {
      float distance = dist(point.x, point.y, position.x, position.y); // distance check
      if(distance < falloffDist && distance != 0) {
        steer.add(point.copy().sub(position).div(distance)); // steer towards attraction points
      }
    }
    
    steer.normalize();
    return steer;
  }
  
  // calculate the points to avoid on the walls if they're too close
  ArrayList<PVector> avoidWalls() {
    ArrayList<PVector> avoidPoints = new ArrayList<PVector>();
    if (position.x < falloffDist) avoidPoints.add(new PVector(-1, position.y));
    if (position.y < falloffDist) avoidPoints.add(new PVector(position.x, -1));
    if (position.x >= bounds.x-falloffDist) avoidPoints.add(new PVector(bounds.x, position.y));
    if (position.y >= bounds.y-falloffDist) avoidPoints.add(new PVector(position.x, bounds.y));
    
    return avoidPoints;
  }
  
  // draw the boid
  void render() {
    float theta = velocity.heading2D() - radians(90);
    fill(175);
    stroke(0);
    pushMatrix();
    translate(position.x,position.y);
    rotate(theta);
    beginShape();
    vertex(0, -size*2);
    vertex(-size, size*2);
    bezierVertex(0, size*5, size, size*2, size, size*2);
    vertex(size, size*2);
    vertex(0, -size*2);
    endShape();
    popMatrix();
    
    bubbleMaker.display();
  }
}
