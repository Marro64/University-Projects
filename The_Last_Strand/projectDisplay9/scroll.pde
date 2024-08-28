class Scroll {
  int scrollPos = 0;
  SensorSmooth sensorSmooth;
  
  Scroll() {
    sensorSmooth = new SensorSmooth();
    sensorSmooth.calibrate(10, 30, 0, int(field.y)/10);
    sensorSmooth.updateMovement(millis(), -scrollPos);
  }
  
  void update() {
    sensorSmooth.update();
  }
  
  void debugDisplay(int fontSize) {
    sensorSmooth.debugDisplay(fontSize);
  }
  
  void scrolled(int value) {
    scrollPos += value;
    sensorSmooth.updateMovement(millis(), -scrollPos);
  }
}
