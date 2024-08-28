class ParticleSystem {
  /* A controller for creating and updating a field of particles
   * By Marinus Bos, 2022
   */

  ArrayList<Particle> particles = new ArrayList();
  
  // creates a 3D cube of particles starting at [pos] with size [size] with a ball every [rate] 
  ParticleSystem(PVector pos, PVector size, float rate) {
    for (float x = pos.x; x < size.x+pos.x; x += rate) {
      for (float y = pos.y; y < size.y+pos.y; y += rate) {
        for (float z = pos.z; z < size.z+pos.z; z += rate) {
          particles.add(new Particle(new PVector(x, y, z)));
        }
      }
    }
  }

  void update() {
    for (Particle particle : particles) {
      particle.update();
    }
  }

  void display() {
    for (Particle particle : particles) {
      particle.display();
    }
  }
}
