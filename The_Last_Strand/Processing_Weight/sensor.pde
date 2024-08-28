class Sensor {
  SensorSmooth sensorSmooth;
  SensorCalibration sensorCalibration;
  
  Sensor() {
    sensorSmooth = new SensorSmooth();
    sensorCalibration = new SensorCalibration(int(18.140955), int(916.1677), int(8.025766), int(51.04799));
    //Stored values: 8.025766 11.975318 12.999991 43.72668 51.04799 18.140955 916.1677
  }
  
  void update() {
    sensorSmooth.update();
  }
  
  void displayOverlay() {
    sensorCalibration.display();
    sensorSmooth.debugDisplay();
  }
  
  void newMeasurement(int timestamp, int distance) {
    sensorSmooth.newMeasurement(timestamp, distance);
  }
  
  void calibrate(int pixelsPerStep, int size, int lowest, int highest) {
    sensorSmooth.calibrate(int(pixelsPerStep), int(size), int(lowest), int(highest));
  }
}
