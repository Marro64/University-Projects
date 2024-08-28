/* Water using an MSD point system
 * By Marinus Bos, 2022
 */

class Water {
  MSDChain points;

  float waterWidth;
  float waterHeight;
  float waveAmplitude;
  int screenHeight;

  final int pointCountDivider = 10;

  Water(float waterWidth, float waterHeight, float waveAmplitude, int screenHeight, float m, float c, float d) {
    this.waterWidth = waterWidth;
    this.waterHeight = waterHeight;
    this.waveAmplitude = waveAmplitude;
    this.screenHeight = screenHeight;

    points = new MSDChain((int)waterWidth/pointCountDivider+1, m, c, d);
  }

  void update() {
    points.update();
  }

  void render() {
    // Visualize MSD points as waving water
    PVector[] pointPositions = getPointPositions(); // Get ordered list of all points 
    for (int i = 0; i < pointPositions.length-1; i++) { // Iterate over every point except the last to avoid reading out of bounds

      // Get the coordinates for a line between the current and following points
      float x0 = pointPositions[i].x;
      float y0 = pointPositions[i].y;
      float x1 = pointPositions[i+1].x;
      float y1 = pointPositions[i+1].y;

      // Draw a quad that fills between the line and the bottom of the water
      noStroke();
      fill(#0040FF);
      quad(x0, y0, x1, y1, x1, screenHeight, x0, screenHeight);
      
      //// Draw the line
      //stroke(0);
      //line(x0, y0, x1, y1);
    }
  }
  
  // Apply a force to a certain point on the water, spread over a certain range of points 
  void addForce(float x, float size, float force) {
    for (float cx = x-size/2.0; cx < x+size/2.0; cx++) {
      try {
        points.addForce(pointIndexAt(cx), force/size);
      } 
      catch(Exception e) {
      }
    }
  }
  
  // Gives closest MSD point index for given x value
  int pointIndexAt(float x) {
    int index = (int)x/pointCountDivider;

    // Prevent returning invalid indexes
    if (index < 0) {
      index = 0;
    } else if (index >= points.getPointCount()) {
      index = points.getPointCount()-1;
    }

    return(index);
  }

  // Gives x pos for given MSD point index
  float pointIndexToXPos(int i) {
    return(i*waterWidth/((float)points.getPointCount()-1));
  }
  
  // Translates a displacement value into an Y position
  float displacementToYPos(float displacement) {
    return(displacement*200 + (screenHeight-waterHeight));
  }
  
  // Gives water Y position for given x position
  float getYPosAtXPos(float x) {
    return( displacementToYPos( points.getDisplacement( pointIndexAt(x) ) ) );
  }
  
  // Get a list of the positions of all the points in PVectors
  PVector[] getPointPositions() {
    float[] displacements = points.getDisplacements();
    PVector[] pointPositions = new PVector[displacements.length];

    for (int i = 0; i < displacements.length; i++) {
      pointPositions[i] = new PVector(pointIndexToXPos(i), displacementToYPos(displacements[i]));
    }

    return(pointPositions);
  }
  
  // Returns true if point collides with water
  boolean checkCollision(PVector point) {
    if (getYPosAtXPos(point.x) < point.y) {
      return(true);
    }
    return(false);
  }
}
