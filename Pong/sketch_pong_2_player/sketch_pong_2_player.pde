/* Two player pong with analogue controls powered by Arduino
 By Marinus Bos, 2021
 
 Two pots control the paddle, and a button serve the ball.
 
 Please don't judge the code outside of the Controller class too harsh, I made most of it when I was still learning and now have to work around the jank to add the new code.
 
 Underneath is the old header:
 */

//two player pong by Marinus Bos, 2019
//features include: paddle changes the trajectory of the ball depending on where you hit it and score counter for two players
//the ball starts in the direction of the last player that earned a point, and has a random trajectory.
//if the ball goes off the screen before it hits a peddle, it won't count as a point and the ball will reset and go towords the same player.

import processing.serial.*;
Serial arduino;  // The serial port
Controller controller;

ArrayList<Wall> walls = new ArrayList(); //setup objects
Ball ball;
Wall p1;
Wall p2;
boolean keys[] = new boolean[5]; //setup boolean array for pressed keys

void setup() {
  size(800, 800); //setup play area
  frameRate(60);
  fill(255);
  stroke(0);
  PFont def; //setup font 
  def = loadFont("MalgunGothicBold-48.vlw");
  textFont(def);
  Wall top = new Wall(0, 0, width, 20, 0, true); //setup walls
  Wall bottom = new Wall(0, height - 20, width, height - 20, 0, true);
  p1 = new Wall(0, 200, 20, 100, 1, false);
  p2 = new Wall(width - 20, 200, 20, 100, 2, false);

  walls.add(top);
  walls.add(bottom);
  walls.add(p1);
  walls.add(p2);

  ball = new Ball(new PVector(width/2, height/2), new PVector(2, -8).rotate(random(PI / 6 * 5)), 1 + int(random(1))); //setup ball
  
  controller = new Controller(new Serial(this, Serial.list()[0], 115000), 2, 1);
}

void draw() {
  background(200);

  controller.receiveInput();

  for (Wall w : walls) { //loop for each wall
    w.draw();
    ball.bounceIfHits(w);
  }

  ball.move();

  if (keys[0]) { //reset if 'r' is pressed
    ball.reset();
  }

  if (controller.digital[0]) {
    ball.serve();
  }

  ball.draw();
}

void keyPressed() { //update list of keys held when a key is pressed
  if (key == 'r' || key == 'R') keys[0] = true;
  if (key == 'w' || key == 'W') keys[1] = true;
  if (key == 's' || key == 'S') keys[2] = true;
  if (key == 'i' || key == 'I') keys[3] = true;
  if (key == 'k' || key == 'K') keys[4] = true;
}

void keyReleased() { //update list of keys held when a key is released
  if (key == 'r' || key == 'R') keys[0] = false;
  if (key == 'w' || key == 'W') keys[1] = false;
  if (key == 's' || key == 'S') keys[2] = false;
  if (key == 'i' || key == 'I') keys[3] = false;
  if (key == 'k' || key == 'K') keys[4] = false;
}
