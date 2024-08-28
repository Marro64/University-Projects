class SensorSmooth {
  float pos = 20;
  float vel = 0;
  float acc = 0;
  
  int rawPixelPos;
  int smoothedPixelPos;
  int health;
  
  int lastUpdate = 0;
  
  float oldPos = 20;
  //float oldVel = 0;
  int oldTime = 0;
  
  int[] distanceBundle;
  int distanceBundleIndex;
  int latestTimestamp;
  float averagedDistance;
  
  int pixelsPerStep = 10;
  int size = 20;
  int lowest = -10;
  int highest = int(field.y+10);
  
  float smoothFactor = .3;
  int distanceBundleSize = 20;
  
  SensorSmooth() {
    latestTimestamp = 0;
    distanceBundle = new int[distanceBundleSize]; 
    distanceBundleIndex = 0;
  }
  
  //Display debug information
  void debugDisplay() {
    textAlign(LEFT, TOP);
    text("pos " + str(pos), 0, 0);
    text("vel " + str(vel), 0, 10);
    text("acc " + str(acc), 0, 20);
    text("averagedDistance " + str(averagedDistance), 0, 30);
    text("smoothedPixelPos " + str(smoothedPixelPos), 0, 50);
    text("rawPixelPos " + str(rawPixelPos), 0, 60);
    text("health " + str(health), 0, 80);
    
    circle(field.x/2, field.y-smoothedPixelPos, 10);
    circle(field.x/2-10, field.y-rawPixelPos , 10);
  }
  
  void update() {
    float dTime = (millis() - lastUpdate)/float(1000);
    lastUpdate = millis();
    
    if(acc > 0) {
      vel += smoothFactor;
    } else {
      vel -= smoothFactor;
    }
    
    fill(#FF0000);
    if(abs(vel) > abs((oldPos - pos)*smoothFactor*10)) {
      vel = (oldPos - pos)*smoothFactor*10;
      fill(#0000FF);
    }
    
    if(vel > 10) {
      vel = 10;
      fill(#FFFFFF);
    } else if(vel < -10) {
      vel = -10;
      fill(#FFFFFF);
    }
    
    pos += vel * dTime; 
    
    rawPixelPos = int((averagedDistance-lowest)*pixelsPerStep);
    smoothedPixelPos = int((pos-lowest)*pixelsPerStep);
    health = int((pos-lowest)/float(highest-lowest)*100);
    
    weight.pos = smoothedPixelPos;
    weight.health = health;
    weight.size = size;
  }
  
  void updateMovement(int newTime, float newPos) {
    float dTime = (newTime - oldTime)/float(1000);
    
    acc = (newPos-pos)*dTime;
    
    oldPos = newPos;
  }
  
  void newMeasurement(int timestamp, int distance) {
    if(timestamp > latestTimestamp) {
      latestTimestamp = timestamp;
      
      distanceBundle[distanceBundleIndex] = distance;
      distanceBundleIndex++;
      
      //println(distanceBundleIndex);
      if(distanceBundleIndex >= distanceBundleSize) {
        distanceBundleIndex = 0;
        averagedDistance = distanceBundleBlend(distanceBundle);
        updateMovement(latestTimestamp, averagedDistance);
      }
    }
  }
  
  float distanceBundleBlend(int[] distanceBundle) {
    distanceBundle = subset(sort(distanceBundle), int(distanceBundleSize/4), int(distanceBundleSize/4*3));
    
    float output = 0;
    for(int i = 0; i < distanceBundle.length; i++) {
      output += distanceBundle[i];
    }
    
    output = output/float(distanceBundle.length);
    
    return(output);
  }
  
  void calibrate(int pixelsPerStep, int size, int lowest, int highest) {
    this.pixelsPerStep = pixelsPerStep;
    this.size = size;
    this.lowest = lowest;
    this.highest = highest;
  }
  
  void reset() {
    latestTimestamp = 0;
    pos = averagedDistance;
    vel = 0;
    acc = 0;
  }
  
  int getPos() {
    return smoothedPixelPos;
  }
  
  int getSize() {
    return size;
  }
}
