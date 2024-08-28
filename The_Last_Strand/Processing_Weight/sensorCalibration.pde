class SensorCalibration {
  //Calibration state variables
  boolean enabled = false;
  int displayPos = 0;
  int currStep = 0;
  boolean line = false;
  String string = "";

  //Height settings for each calibration step
  int lowestTest = int(field.y*0.95);
  int bottom1Test = int(field.y*0.9);
  int topTest = int(field.y*0.3);
  int bottom2Test = int(field.y*0.6);
  int highestTest = int(field.y*0.1);
  int completeTest = int(field.y*0.5);

  //Output containers
  float lowest, bottom1, top, bottom2, highest;
  float pixelsPerStep, size;

  SensorCalibration() {
    enabled = true;
    calibrationStep();
  }
  
  SensorCalibration(int pixelsPerStep, int size, int lowest, int highest) {
    this.pixelsPerStep = pixelsPerStep;
    this.size = size;
    this.lowest = lowest;
    this.highest = highest;
    sensor.calibrate(int(pixelsPerStep), int(size), int(lowest), int(highest));
  }

  //Display calibration overlay
  void display() {
    //Setup displayed instructions
    String tempString = string; 
    if (currStep > 0 && currStep < 6) { //For all steps containing instructions

      if (abs(weight.pos - sensor.sensorSmooth.averagedDistance) < 0.1) { //Test if the position has settled
        fill(#00FF00);
        tempString = string.concat(" and press 'n'"); //Tell user to press n to continue
      } else {
        tempString = string.concat(" and wait"); //Tell user to wait
      }
    }

    if (currStep > 0 && currStep < 7 && enabled) {
      textAlign(CENTER, CENTER);
      if (line) {
        line(0, displayPos, field.x, displayPos);
      }
      text(tempString, field.x/2, displayPos+10);
    }
  }

  //Process data to generate result
  void calculateResult() {
    pixelsPerStep = abs((bottom1Test-bottom2Test)/(bottom1-bottom2)); //Amount of screen pixels per sensor unit
    size = bottom1Test - topTest - top*pixelsPerStep; //Size of object

    println(lowest, bottom1, top, bottom2, highest, pixelsPerStep, size);
    sensor.calibrate(int(pixelsPerStep), int(size), int(lowest), int(highest));
    //8.025766 11.975318 12.999991 43.72668 51.04799 18.140955 916.1677
  }

  //Advance one step in the calibration and set the correct state
  void calibrationStep() {
    if (enabled) {
      currStep++;

      switch(currStep) {
      case 1:
        displayPos = lowestTest;
        string = "Put weight at lowest position";
        line = false;
        break;

      case 2:
        lowest = weight.pos;
        displayPos = bottom1Test;
        string = "Match bottom of weight with line";
        line = true;
        break;

      case 3:
        bottom1 = weight.pos;
        displayPos = topTest;
        string = "Match top of weight with line";
        line = true;
        break;

      case 4:
        top = weight.pos;
        displayPos = bottom2Test;
        string = "Match bottom of weight with line";
        line = true;
        break;

      case 5:
        bottom2 = weight.pos;
        displayPos = highestTest;
        string = "Put weight at highest possible position";
        line = false;
        break;

      case 6:
        highest = weight.pos;
        displayPos = completeTest;
        string = "Calibration complete";
        line = false;
        calculateResult();
        break;
        
      case 7:
        enabled = false;
        break;
      }
    }
  }

  //Toggle calibration tool on or off
  void toggleCalibration() {
    if (enabled) {
      enabled = false;
      currStep = 0;
    } else {
      enabled = true;
      currStep = 0;
      calibrationStep();
    }
  }
}
