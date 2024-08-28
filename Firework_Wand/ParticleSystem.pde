class ParticleSystem {
  /* A controller for creating particles in a spot
   * By Marinus Bos, 2022
   */
  
  ArrayList<Particle> particles = new ArrayList();
  
  PVector pos;
  int particleRate;
  float particleVelocity;
  int particleLifespan;
  
  int timeUntilNextParticle;

  ParticleSystem(PVector pos, int particleRate, float particleVelocity, int particleLifespan) {
    this.pos = pos.copy();
    this.particleRate = particleRate;
    this.particleVelocity = particleVelocity;
    this.particleLifespan = particleLifespan;
  }

  void update() {
    if (particleRate > 0) {
      timeUntilNextParticle -= 1;
      if (timeUntilNextParticle <= 0) {
        particles.add(new Particle(pos.copy(), particleVelocity, particleLifespan));
        timeUntilNextParticle = particleRate;
      }
    }

    for (int i = 0; i < particles.size(); i++) {
      Particle particle = particles.get(i);

      if (particle.isDead()) { 
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
  
  void burst(int amount, float velMag, int lifespan) {
    for(int i = 0; i < amount; i++) {
      particles.add(new Particle(pos.copy(), velMag, lifespan));
    }
  }

  void move(PVector pos) {
    this.pos = pos.copy();
  }
}
