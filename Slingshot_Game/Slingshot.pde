/* Slingshot
 * Holds ball and allows user to pull back and shoot the ball in a direction
 * By Marinus Bos, 2022
 */

class Slingshot {
  Ball ball;
  
  boolean grabbed;
  PVector center;
  PVector cursorStart;
  PVector displacement;
  
  Slingshot(Ball ball, PVector pos) {
    this.ball = ball;
    this.center = pos;
    this.displacement = new PVector (0, 0);
  }
  
  //draw the slingshot
  void drawSlingshot() {
    final float scale = 20;
    pushMatrix();
    translate(center.x, center.y);
    scale(scale);
    
    strokeWeight(.3);
    stroke(64);
    line(-1, 0, displacement.x/(float)scale, displacement.y/(float)scale);
    line(1, 0, displacement.x/(float)scale, displacement.y/(float)scale);
    
    strokeWeight(.5);
    stroke(#B06000);
    line(0, 2, 0, 4);
    line(0, 2, -1, 0);
    line(0, 2, 1, 0);
    
    popMatrix();
  }
  
  //display line showing cursor dragged path
  void drawOverlay() {
    if(grabbed) {

      pushMatrix();
      stroke(128);
      strokeWeight(5);
      translate(cursorStart.x, cursorStart.y);
      line(0, 0, displacement.x, displacement.y);
      popMatrix();
    }
  }
  
  //update cursor position
  void updateCursor(PVector cursor) {
    displacement = cursor.copy().sub(cursorStart);
    
    final int maxDisplacement = 100; // Limit how far ball can be pulled back
    
    if(displacement.mag() > maxDisplacement) { //limit elastic band length
      displacement.setMag(maxDisplacement);
    }
    
    ball.setPos(center.copy().add(displacement));
  }
  
  //put ball in the slingshot and start following cursor 
  void grab(PVector cursor) {
    ball.grab();
    cursorStart = cursor;
    grabbed = true;
  }
  
  //release ball and stop following cursor
  void release() {
    ball.release();
    
    ball.setVel(displacement.copy().div(-2));
    this.displacement = new PVector (0, 0);
    grabbed = false;
  }
}
  
