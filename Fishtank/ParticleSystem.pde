/* A controller for creating particles in a spot
 * By Marinus Bos, 2022
 */

class ParticleSystem {
  ArrayList<Particle> particles = new ArrayList();
  
  PVector pos;
  int particleRate;
  
  int timeUntilNextParticle;

  ParticleSystem(PVector pos, int particleRate) {
    this.pos = pos.copy();
    this.particleRate = particleRate;
  }

  void update(Water water) {
    
    // Summon new particles at a certain rate (with some deviation)
    if (particleRate > 0) {
      timeUntilNextParticle -= 1;
      if (timeUntilNextParticle <= 0) {
        particles.add(new Particle(pos.copy()));
        timeUntilNextParticle = (int)(particleRate*random(0.5, 1.5));
      }
    }

    for (int i = 0; i < particles.size(); i++) {
      Particle particle = particles.get(i);

      if (particle.isDead(water)) { 
        // remove dead particles
        particles.remove(i);
        i -= 1; // decrease i to not skip over particle that has moved into position i
      } else {
        // update surviving particles
        particle.update();
      }
    }
  }

  void display() {
    for (Particle particle : particles) {
      particle.display();
    }
  }

  void setParticleRate(int particleRate) {
    this.particleRate = particleRate;
  }

  void move(PVector pos) {
    this.pos = pos.copy();
  }
}
