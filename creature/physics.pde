class Physics {
  PVector pos, vel, acc, cursorOffset, oldPos, actualVel, beginAcc;
  int movementType;
  float ballSize, gravity, bounciness, airResConst, rotationFriction, maxVel, rotation, rotVel, rotMag, hitBoxHeight;
  int counter;

  Physics(int startMovementType, PVector startPos, float ballSizeTemp, float hitBoxHeightTemp, float gravityTemp, float bouncinessTemp, float maxVelTemp, float airResConstTemp, float frictionTemp) {
    movementType = startMovementType; 
    pos = startPos.copy();
    oldPos = startPos.copy();
    ballSize = ballSizeTemp;
    hitBoxHeight = hitBoxHeightTemp; //for simple physics, when height is different from width 
    gravity = gravityTemp;
    bounciness = bouncinessTemp;
    maxVel = maxVelTemp; //used by simple physics
    airResConst = airResConstTemp; //used by ball physics
    rotationFriction = frictionTemp;

    vel = new PVector(0, 0); //velocity used during movement logic
    actualVel = new PVector(0, 0); //how far the creature has moved after all logic has been applied
    acc = new PVector(0, 0);
    beginAcc = new PVector(0, 0); //this variable allows other functions to pass an acceleration that gets applied at the next round of movement calculations
    cursorOffset = new PVector(0, 0);
    rotation = 0;
    rotVel = 0;
    counter = 0;
  }

  void move() {
    oldPos = pos.copy(); //for calculating actualVel afterwards

    //call the relevant movement code
    switch(movementType) {
    default:
      break;
    case 1:
      followCursor();
      break;
    case 2:
      simplePhysics();
      break;
    case 3:
      ballPhysics();
      break;
    }

    rotation = (rotation+2*PI)%(2*PI); //keep the rotation between 0 and 2*PI
    rotMag = PI-abs((rotation%(2*PI))-PI); //how much it's rotatited from being upright

    actualVel = pos.copy().sub(oldPos); //the actual change in position, after all movement logic has been applied 

    beginAcc = new PVector(0, 0);
  }

  /* Follow the cursor
   Stick to the cursor, including an offset so stays relative to where it attached
   */
  void followCursor() {
    pos = new PVector(cursor.x+cursorOffset.x, cursor.y+cursorOffset.y);
  }

  /* Simple Physics
   The physics that are used when the standing, walking or jumping
   - Uses gravity, acceleration, velocity, position, maximum velocity
   - Has bouncing collision at the sides of the field
   - Has static collision at bottom of screen (sticks to the bottom, doesn't bounce)
   - No collision at the top of the screen
   - Doesn't support rotation, has a non-square hitbox
   - No friction
   */
  void simplePhysics() {
    //acceleration
    acc = beginAcc.copy().add(new PVector(0, gravity)); //take the starting acceleration and apply gravity

    //velocity with limit
    vel.add(acc); 
    if (vel.mag() > maxVel) {
      vel.setMag(maxVel);
    }

    //position with wall collision
    PVector tempPos = pos.copy().add(vel); //simulate the movement of the ball for collision detection
    //vertical movement
    if (tempPos.y > field.y-hitBoxHeight) { //if colliding with field bottom
      pos = new PVector(pos.x, field.y-hitBoxHeight); //stick to the bottom of the screen
    } else {
      pos = new PVector(pos.x, pos.y+vel.y); //move vertically without colliding
    }
    //horizontal movement
    if (tempPos.x < 0 || tempPos.x > field.x-ballSize) { //if colliding with field left or right
      pos = new PVector(pos.x+vel.x-tempPos.x%(field.x-ballSize), pos.y); //move the available distance left or right and then move the remainer in the opposite direction 
      vel = new PVector(vel.x*-1, vel.y); //invert horizontal velocity
    } else {
      pos = new PVector(pos.x+vel.x, pos.y); //move horizontally without colliding
    }
  }

  /* Ball physics
   The physics that are used when the creature is rolling / being tossed around
   - Uses gravity, acceleration, velocity, position, air resistance
   - Has bouncing collision at all sides of the field
   - Supports rotation, has a square hitbox
   - Friction with air and when hitting walls
   */
  void ballPhysics() {
    //acceleration
    PVector airRes = new PVector(-airResConst*sq(vel.mag()), 0).rotate(vel.heading()); //calculate air resistance
    acc = beginAcc.copy().add(new PVector(0, gravity)).add(airRes); //take the begin acceleration and apply gravity and air resistance

    // velocity
    vel.add(acc); 

    //rotation
    rotation += rotVel;

    //position and rotation velocity with wall collision
    PVector tempPos = pos.copy().add(vel); //simulate the movement of the ball for collision detection
    //vertical movement
    if (tempPos.y < 0 || tempPos.y > (field.y-ballSize)) { //if colliding with field top or bottom
      pos = new PVector(pos.x, pos.y+vel.y-tempPos.y%(field.y-ballSize)); //move the available distance up or down and then move the remainer in the opposite direction 
      vel = new PVector(vel.x*bounciness, vel.y*-1*bounciness); //invert vertical velocity and apply friction
      //roll
      if (int(rotVel*10000) == 0) { //avoid dividing by (close to) zero when creature isn't rotating
        rotVel = vel.x/(25*PI)*rotationFriction; //roll with same speed as moving over the surface
      } else { //if creature is already rotating
        rotVel = rotVel*(1+((((vel.x/(ballSize/4*PI))/rotVel)-1)*rotationFriction)); //move the rotation velocity towords the speed of moving over the surface
      }
    } else {
      pos = new PVector(pos.x, pos.y+vel.y); //move without colliding
    }
    //horizontal movement
    if (tempPos.x < 0 || tempPos.x > (field.x-ballSize)) { //if colliding with field left or right
      pos = new PVector(pos.x+vel.x-tempPos.x%(field.x-ballSize), pos.y); //move the available distance left or right and then move the remainer in the opposite direction 
      vel = new PVector(vel.x*-1*bounciness, vel.y*bounciness); //invert horizontal velocity and apply friction
      //roll
      if (int(rotVel*10000) == 0) { //avoid dividing by (close to) zero when creature isn't rotating
        rotVel = vel.y/(25*PI)*rotationFriction; //roll with same speed as moving over the surface
      } else { //if creature is already rotating
        rotVel = rotVel*(1+((((vel.y/(ballSize*PI))/rotVel)-1)*rotationFriction)); //move the rotation velocity towords the speed of moving over the surface
      }
    } else {
      pos = new PVector(pos.x+vel.x, pos.y); //move without colliding
    }
  }

  /* Change physics type
   Gets called by the switchToState function in the class creature
   Sets the movement type variable and prepares the relevant variables variables
   */
  void changePhysics(int newMovementType) {
    if (movementType != newMovementType) {
      switch(newMovementType) {
      case 1: //follow cursor
        movementType = 1;
        cursorOffset = new PVector(pos.x-cursor.x, pos.y-cursor.y);
        break;
      case 2: //simple physics
        movementType = 2;
        rotation = 0;
        break;
      case 3: //ball physics
        movementType = 3;
        vel = new PVector(cursor.x-pCursor.x, cursor.y-pCursor.y);
        break;
      }
    }
  }

  //Debug, to allow external inputs to change rotation
  //void forceRotate(float deltaRotation) {
  //  rotation += deltaRotation;
  //}
}
