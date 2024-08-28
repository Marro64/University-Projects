/* A field of particles flowing along a 3D perlin field
 * By Marinus Bos, 2022
 */

ParticleSystem particleSystem;

void setup() {
  size(1000, 800, P3D);
  camera(0, 0, (height/1.0) / tan(PI*30.0 / 180.0), 0, 0, 0, 0, 1, 0);
  particleSystem = new ParticleSystem(new PVector(-500, -500, -500), new PVector(1000, 1000, 1000), 50);
}

void draw() {
  background(0);

  particleSystem.update();
  particleSystem.display();
}
