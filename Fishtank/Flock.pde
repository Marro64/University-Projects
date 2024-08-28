// Flock class by Nina Vroom
// A collection of boids

class Flock {
  ArrayList<Boid> boids; // all the boids
  
  Flock() {
    boids = new ArrayList<Boid>();
  }
  
  void addBoid(PVector position, PVector bounds) {
    boids.add(new Boid(position, bounds));
  }
  
  void update(Water water, ProceduralSand sand, FoodContainer food) {
    for(Boid boid : boids) {
      boid.update(boids, water, sand, food);
    }
  }
  
  // draw the boids
  void render() {
    for(Boid boid : boids) {
      boid.render();
    }
  }
}
