/* A point in an MSD system
 * By Marinus Bos, 2022
 */


class MSDPoint {
  
  float v = 0; // Velocity
  float d = 0; // Displacement
  float force = 0; // Force
  
  float m; // Mass
  float c; // Spring constant
  float f; // Friction constant
  
  float externalForce; // Variable to keep track of external forces
  
  MSDPoint(float m, float c, float f) {
    this.m = m;
    this.c = c;
    this.f = f;
  }
  
  void update(float previousVelocity, float nextVelocity, float previousForce, float nextForce) {
    // Force
    float torque = 1/c*d; // The tension caused by the water being away from its resting position
    float friction = f*(v-(previousVelocity+nextVelocity)/4.0); // Friction, takes more energy out of the equation the faster the system moves
    force = torque + friction; // The absolute sum off all the internal forces applied
    
    // Movement
    float F = -force + (previousForce+nextForce)/4.0 + externalForce; // The force as it affects this current point, directional with external forces applied
    v += F*1/m; // Velocity, the integral of the forces with its change slowed down by the mass
    d += (v-(previousVelocity+nextVelocity)/4.0); // The displacement of the object, integral of the velocity
    
    externalForce = 0; // External forces have been applied, so reset the variable.
  }
  
  float getDisplacement() {
    return(d);
  }
  
  void setDisplacement(float d) {
    this.d = d;
  }
  
  void addForce(float force) {
    this.externalForce += force;
  }
  
  float getVelocity() {
    return(v);
  }
}
