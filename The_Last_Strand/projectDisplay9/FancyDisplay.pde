class FancyDisplay {
  TextDisplay display1;
  TextDisplay display2;
  boolean exploded = false;
  int explodeTime;
  boolean abandoned = false;

  FancyDisplay() {
    display1 = new TextDisplay(" ", new PVector(field.x/2, field.y*0.3), field.x/1.5, field, #0000FF);
    display2 =  new TextDisplay(" ", new PVector(field.x/2, field.y*0.35), field.x/2.5, field, #0000FF);
  }

  void update() {
    display1.changeString(timer.timeString);
    
    if (exploded) {
      if (timer.time > 0) {
        colorMode(HSB);
        display1.ballColor = color(abs((millis()/float(40))%40-20), 255, 255);
        colorMode(RGB);
      } else {
        display1.ballColor = color(#0000FF);
      }
      if (explodeTime+5000 < millis() && abandoned == false) {
        abandoned = true;
        display2.changeString(" ");
        display2.unExplode();
      }
    } else {
      abandoned = false;
    }
    
    if (!exploded) {
      display2.changeString(timerStreak.timeString);
    } else if(abandoned) {
      if (millis()/10000%3 > 1) {
        display2.changeString("Pull the rope!");
      } else {
        display2.changeString("Abandoned for " + getScoreFormat(millis() - explodeTime));
      }
    }
  }

  void display() {
    display1.mainLoop();
    display2.mainLoop();
  }

  void explode() {
    exploded = true;
    display2.explode();
    explodeTime = millis();
  }

  void unExplode() {
    exploded = false;
    display2.unExplode();
  }

  //formats the score
  String getScoreFormat(int time) {
    //int millisecs = time % 1000;
    int seconds = (int) TimeUnit.MILLISECONDS.toSeconds(time) % 60;
    int minutes = (int) TimeUnit.MILLISECONDS.toMinutes(time) % 60;
    int hours = (int) TimeUnit.MILLISECONDS.toHours(time);
    return  nf(hours, 2) + ":" + nf(minutes, 2) + ":" + nf(seconds, 2) ;
  }
}
