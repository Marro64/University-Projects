/* Fishtank by Nina Vroom and Marinus Bos
 * Made as final assignment for Algorithms for CreaTe
 * Click to add food, move mouse to generate waves in the water
 * 2022
 */

FoodContainer food;
Water water;
Flock boids;
ProceduralSand sand;

void setup() {
  size(1280, 720, P2D);
  
  food = new FoodContainer();
  water = new Water(width, height*.8, 200, height, 10, 3, 1); // Water system with length equal to screen width, mass 10, sping constant 3, dampening constant 1
  boids = new Flock();
  for(int i = 0; i < 50; i++) {
    boids.addBoid(new PVector(random(0, width), random(0, height)), new PVector(width, height));
  }
  sand = new ProceduralSand(new PVector(0, height*.8), width, height*.2, height*-.1, height*.1, #f7bb38);
}

void draw() {
  background(0);
  update();
  render();
}

void update() {
  water.update();
  food.update(water);
  boids.update(water, sand, food);
}

void render() {
  water.render();
  food.render();
  boids.render();
  sand.render();
}

void mousePressed() {
  food.mouseHandler(new PVector(mouseX, mouseY));
}

void mouseMoved() {
  if(water.checkCollision(new PVector(mouseX, mouseY))) {
    water.addForce(mouseX, 25, (mouseY-pmouseY)/250.0);
  }
}

void mouseDragged() {
  if(water.checkCollision(new PVector(mouseX, mouseY))) {
    water.addForce(mouseX, 25, (mouseY-pmouseY)/250.0);
  }
}
