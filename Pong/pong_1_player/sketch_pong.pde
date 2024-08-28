//pong by Marinus Bos, 2019
//controls: 'w' = up, 's' = down, 'r' = reset ball
//features include: paddle changes the trajectory of the ball depending on where you hit it, ball going in a random direction at the start (but always away from the player) and score counter including high score.

ArrayList<Wall> walls = new ArrayList(); //setup objects
Wall paddle;
Ball ball;
boolean keys[] = new boolean[3]; //setup boolean array for pressed keys

void setup() {
  size(500, 500); //setup play area
  frameRate(60);
  fill(255);
  stroke(0);
  PFont def; //setup font 
  def = loadFont("MalgunGothicBold-48.vlw");
  textFont(def);
  Wall top = new Wall(0, 0, width, 20, 0, true); //setup walls
  Wall right = new Wall(width - 20, 20, width - 20, height - 20, 0, false);
  Wall bottom = new Wall(0, height - 20, width, height - 20, 0, true);
  paddle = new Wall(0, 20, 20, 100, 1, false);

  walls.add(top);
  walls.add(right);
  walls.add(bottom);
  walls.add(paddle);

  ball = new Ball(new PVector(250, 250), new PVector(2, -8).rotate(random(PI / 6 * 5))); //setup ball
}

void draw() {
  background(200);
  for (Wall w : walls) { //loop for each wall
    w.draw();
    ball.bounceIfHits(w);
  }
  ball.move();
  if (keys[0]) { //reset if 'r' is pressed
    ball.reset();
  }
  ball.draw();
}

void keyPressed() { //update list of keys held when a key is pressed
  if (key == 'r' || key == 'R') keys[0] = true;
  if (key == 'w' || key == 'W') keys[1] = true;
  if (key == 's' || key == 'S') keys[2] = true;
}

void keyReleased() { //update list of keys held when a key is released
  if (key == 'r' || key == 'R') keys[0] = false;
  if (key == 'w' || key == 'W') keys[1] = false;
  if (key == 's' || key == 'S') keys[2] = false;
}
