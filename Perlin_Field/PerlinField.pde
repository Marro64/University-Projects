class PerlinField {
  /* Returns 3 streams of perlin noise at a specific 3D position
   * By Marinus Bos, 2022
   */
   
  final float rateOfChange = 0.003;
  final int xOffset = 0;
  final int yOffset = 1000;
  final int zOffset = 2000;
  
  PVector getPerlinAt(PVector pos) {
    return(new PVector(
      noise(pos.x*rateOfChange+xOffset, pos.y*rateOfChange+xOffset, pos.z*rateOfChange+xOffset)*2-1, 
      noise(pos.x*rateOfChange+yOffset, pos.y*rateOfChange+yOffset, pos.z*rateOfChange+yOffset)*2-1, 
      noise(pos.x*rateOfChange+zOffset, pos.y*rateOfChange+zOffset, pos.z*rateOfChange+zOffset)*2-1)
    );
  }
}
