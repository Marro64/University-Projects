class Wand {
  /* Wand that burns into a fire of particles
   * By Marinus Bos, 2022
   */
  ParticleSystem particleSystem;

  PVector pos;
  PVector endOffset;
  PVector flameOffset;
  float flameOffsetMag;
  int flameAge;
  Boolean flameEnabled;

  final float shortestLength = 0.2;

  Wand(ParticleSystem particleSystem, PVector pos) {
    this.pos = pos.copy();
    this.particleSystem = particleSystem;

    endOffset = new PVector(0, -300); // offset from wand position to tip of wand
    flameOffset = endOffset.copy();
    flameAge = 0;
    flameEnabled = false;
  }

  void update() {
    if(flameEnabled) {
      flameAge += 1;
      flameOffsetMag = 1-flameAge*0.001;
      flameOffset = getFlameOffset(flameOffsetMag);
      if (flameOffsetMag > shortestLength) {
        particleSystem.move(pos.copy().add(flameOffset));
      } else {
        particleSystem.setParticleRate(0);
        flameEnabled = false;
      }
    }
  }

  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    
    // draw the stick of the wand
    stroke(#603000);
    strokeWeight(4);
    line(0, 0, endOffset.x, endOffset.y);
    
    // draw the burnable part of the wand
    stroke(#808080);
    strokeWeight(6);
    PVector flameEndOffset = getFlameOffset(shortestLength); // get the point at which the flame dies
    line(flameEndOffset.x, flameEndOffset.y, endOffset.x, endOffset.y);
    
    // draw the burned part of the wand
    if(flameAge > 0) {
      stroke(#404040);
      strokeWeight(6);
      line(flameOffset.x, flameOffset.y, endOffset.x, endOffset.y);
    }
    
    popMatrix();
  }

  void move(PVector pos) {
    this.pos = pos.copy();
  }

  void ignite() {
    flameEnabled = true;
    flameAge = 0;
    flameOffsetMag = 1;
    flameOffset = getFlameOffset(flameOffsetMag);
    particleSystem.pos = pos.copy().add(flameOffset);
    particleSystem.particleRate = 2;
    particleSystem.burst(100, 100, 100);
  }

  PVector getFlameOffset(float offsetMag) {
    return(endOffset.copy().mult(offsetMag));
  }
}
