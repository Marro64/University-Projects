/* A chain of MSD points
 * Passes the relevant values to the points to make a system 
 * By Marinus Bos, 2022
 */

class MSDChain {
  MSDPoint[] MSDPoints;

  MSDChain(int amount, float m, float c, float f) {
    MSDPoints = new MSDPoint[amount];

    for (int i = 0; i < amount; i++) {
      MSDPoints[i] = new MSDPoint(m, c, f);
    }
  }

  void update() {
    // Alternate between updating left to right and right to left, to keep symmetry
    if (frameCount%2 == 0) {
      for (int i = 0; i < MSDPoints.length; i++) {
        updatePoint(i);
      }
    } else {
      for (int i = MSDPoints.length-1; i >= 0; i--) {
        updatePoint(i);
      }
    }
  }
  
  // Update each of the points
  void updatePoint(int i) {
    float previousVelocity = 0; // Default to 0, in case the point is at an edge
    float nextVelocity = 0;
    float previousForce = 0; 
    float nextForce = 0;
    if (i > 0) { // If the point isn't at an edge, take the values from adjecent points
      previousVelocity = MSDPoints[i-1].v; 
      previousForce = MSDPoints[i-1].force;
    }
    if (i < MSDPoints.length-1) {
      nextVelocity = MSDPoints[i+1].v;
      nextForce = MSDPoints[i+1].force;
    }
    MSDPoints[i].update(previousVelocity, nextVelocity, previousForce, nextForce);
  }

  // Outputs list of displacement values
  float[] getDisplacements() {
    float[] displacements = new float[MSDPoints.length];
    for (int i = 0; i < MSDPoints.length; i++) {
      displacements[i] = MSDPoints[i].d;
    }
    return(displacements);
  }
  
  // Get individual displacement value
  float getDisplacement(int i) {
    return(MSDPoints[i].d);
  }
  
  // Get amount of points
  int getPointCount() {
    return(MSDPoints.length);
  }
  
  // Apply a force to a point
  void addForce(int x, float force) {
    MSDPoints[x].d += force;
  }
}
