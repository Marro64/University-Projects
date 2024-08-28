class Particle {
  /* A particle made out of a random star shape
   * By Marinus Bos, 2022 
   */

  PVector pos;
  PVector vel;
  PVector acc;
  int lifespan;
  PShape shape;
  float rotation;

  Particle(PVector pos, float velocity, int lifespan) {
    //generate the star with a hefty amount of randomness in most variables
    this.pos = pos.copy();
    vel = new PVector(1, 0).setMag(velocity*random(0.2, 2)).rotate(random(0, 2*PI));
    this.lifespan = (int)(lifespan*random(0.2, 2));
    
    acc = new PVector(0, 0);
    
    //generate the random star
    float size = random(5, 25);
    float pointiness = random(.3, .9);
    int starSpikes = (int)random(1, 7);
    colorMode(HSB);
    color fillColor = color((int)random(0, 255), 255, 255);
    noStroke();
    shape = generateStar(starSpikes, pointiness, size, fillColor);
    colorMode(RGB);

    rotation = random(0, PI);
  }

  void update() {
    lifespan -= 1; 

    acc.add(vel.mult(-0.05)); // particle gradually slows down

    vel.add(acc);
    pos.add(vel);
  }

  void display() {
    noStroke();
    shapeMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(rotation);
    shape(shape);
    popMatrix();
  }

  boolean isDead() {
    // returns true if the particle is to be destroyed
    if (lifespan > 0) {
      return(false);
    }
    return(true);
  }

  PShape generateStar(int points, float innerSize, float size, color fillColor) {
    /* Generates a PShape of a star
     * Size describes the radius, innerSize is a value between 0 and 1 (or larger) that describes how pointy the star is 
     * By Marinus Bos, 2022 
     */

    PVector center = new PVector(size*.5, size*.5);
    PVector currentPoint = new PVector(0, -size*.5);

    // avoid emptyness on left side of shape, otherwise shape wouldn't be properly centered
    // find the leftmost point of the shape and move the center to put this point at x=0 in the PShape
    float leftMostOuterPointIndex = round(points-points/(float)4);
    PVector leftMostOuterPoint = currentPoint.copy().rotate((PI*2)*(leftMostOuterPointIndex/(float)points)).add(center);
    float leftMostInnerPointIndex = round(points-points/(float)4);
    PVector leftMostInnerPoint = currentPoint.copy().mult(innerSize).rotate(-PI/(float)points+(PI*2)*(leftMostInnerPointIndex/(float)points)).add(center);
    if (leftMostInnerPoint.x < leftMostOuterPoint.x) {
      center.sub(leftMostInnerPoint.x, 0);
    } else {
      center.sub(leftMostOuterPoint.x, 0);
    }

    fill(fillColor);
    PShape s = createShape();
    if (points > 1) {
      s.beginShape();
      for (int point = 0; point < points; point++) {
        //for every spike in the star, create a vector point on the outer edge of the spike and on the inner edge of the inverse spike 
        s.vertex(currentPoint.x+center.x, currentPoint.y+center.y); // outer point
        currentPoint.rotate(PI/(float)points);
        s.vertex(currentPoint.x*innerSize+center.x, currentPoint.y*innerSize+center.y); //inner point
        currentPoint.rotate(PI/(float)points);
      }
      s.endShape(CLOSE);
    } else {
      //if there are less than 1 points default to a circle
      s = createShape(ELLIPSE, 0, 0, size*innerSize, size*innerSize);
    }
    return(s);
  }
}
