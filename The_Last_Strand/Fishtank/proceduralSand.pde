/* Sand hills generated using perlin noise
 * By Marinus Bos, 2022
 */

class ProceduralSand {
  PVector offset;
  float drawWidth, drawHeight, minHeight, maxHeight, slope;
  color fillColor;

  float[] heights;
  float[] slopedHeights;
  float noiseOffset = 0.0;
  float noiseIncrement = 0.002;

  ProceduralSand(PVector offset, float drawWidth, float drawHeight, float minHeight, float maxHeight, color fillColor) {
    this.offset = offset.copy();
    this.drawWidth = drawWidth;
    this.drawHeight = drawHeight;
    this.minHeight = minHeight;
    this.maxHeight = maxHeight;
    
    this.fillColor = fillColor;

    //initialize the terrain
    heights = new float[(int)drawWidth+1];
    for (int i = 0; i < heights.length; i++) {
      heights[i] = nextPerlinHeight();
    }
  }
  
  //generate the height of the next point using perlin noise
  float nextPerlinHeight() {
    noiseOffset += noiseIncrement;
    return(minHeight+noise(noiseOffset)*(maxHeight-minHeight));
  }

  void render() {
    pushMatrix();
    translate(offset.x, offset.y);
    fill(fillColor);
    stroke(0);
    
    //generate shape that surrounds the bottom of the screen
    beginShape();
    vertex(-1, drawHeight);
    vertex(-1, heights[0]);
    for (int i = 0; i < heights.length; i++) {
      vertex(i, heights[i]);
    }
    vertex(drawWidth, drawHeight);
    endShape();
    
    popMatrix();
  }
  
  // Returns sand top Y pos at given x pos
  float getYPosAtXPos(float x) {
    x = x - offset.x;
    
    if(x < 0) {
      x = 0;
    } else if(x >= heights.length) {
      x = heights.length-1;
    }
    
    return(offset.y + heights[(int)x]);
  }
  
  // Get a list of the positions of all the points in PVectors
  PVector[] getPointPositions() {
    PVector[] pointPositions = new PVector[heights.length];
    
    for(int i = 0; i < heights.length; i++) {
      pointPositions[i] = new PVector(offset.x+i, offset.y+heights[i]);
    }
    
    return(pointPositions);
  }
  
  // Returns true if point collides with sand
  boolean checkCollision(PVector point) {
    point = point.copy().sub(offset);
    
    if(point.x < 0) {
      point.x = 0;
    } else if(point.x >= heights.length) {
      point.x = heights.length-1;
    }
    
    if(point.y > heights[(int)point.x]) {
      return(true);
    }
    return(false);
  }
}
