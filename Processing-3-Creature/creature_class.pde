/* Defines most of the creature
 Including the state, AI and calls to the physics class.
 */

class Creature {
  float size;
  Physics physics;
  color bodyColor;

  int state = 2;
  PVector lookingAtPoint;
  boolean staticEyes = true;

  int blinkCounter = 0;
  int waitingTimer;
  boolean blink;
  int animationTimer;
  int rollSpeed;
  boolean preRoll;
  boolean jumping;
  int walkToPos;
  boolean moveDir;
  boolean endAnimation;

  int[] animationState = new int[1];
  float leftLegRotation, rightLegRotation, newLeftLegRotation, newRightLegRotation; 
  PVector leftPupilPos, rightPupilPos, leftPupilGoal, rightPupilGoal;

  final PVector eyeCenter = new PVector(50, 30);
  final PVector pupilPos = new PVector(9, 0);
  final PVector pupilDerpyPos = new PVector(6, 0);
  final float pupilRotationRadius = 5;

  Creature(PVector startPos, float sizeTemp, color bodyColorTemp) {
    size = sizeTemp;
    bodyColor = bodyColorTemp;
    startPos.sub(new PVector(size/2, size/2)); 
    physics = new Physics(2, startPos, size, size*0.9, 2.0, 0.8, 10.0, 0.0, 0.3);
    waitingTimer = int(random(120, 240));
    animationState[0] = 0;
    
    leftPupilPos = new PVector(6, 0);
    rightPupilPos = new PVector(6, 0);
  }

  void draw() {

    /* Random blinking
     The blinkCounter is negative when the creature is not blinking.
     It counts upwards until reaching positive numbers, which indicates it's time to blink
     When blinking it's used as a counter for how long to keep the eyes closed.
     */
    blinkCounter++;
    blink = false;
    if (blinkCounter > 0) {
      blink = true; //close the eyes
    }
    if (blinkCounter > 4) {
      blinkCounter = -int(random(50, 300)); //set the time until the next blink
    }

    /* Bordom counter
     Counts down from a randomly selected value
     When it reaches 0, the creature performs an action depending on the state it's in.
     */
    if (physics.actualVel.mag() == 0) {
      waitingTimer--;
    } else {
      waitingTimer = int(random(120, 240)); //reset the waiting timer
    }

    if (waitingTimer <= 0) {
      switch(state) {
      case 3: //ball physics
        switchToState(4); //roll upwards and change to simple physics
        break;
      case 2: //simple physics
        if (int(random(2)) == 0) { //Have a chance to wander around the screen
          switchToState(5);
        } else {
          staticEyes = false; //Return to staring at the cursor if not already staring
        }
        break;
      }
      waitingTimer = int(random(120, 240)); //reset the waiting timer
    }

    //run the relevant movement and animation routines
    switch(state) {
    case 0:
      lookingAtPoint = cursor.copy();
      break;
    case 2:
      lookingAtPoint = cursor.copy();
      break;
    case 4:
      moveUpright();
      break;
    case 5:
      walk();
      break;
    }

    //run the physics routine
    physics.move(); 

    animate();

    //draw the creature
    //shape(form(physics.pos.copy(), physics.rotation, blink, leftLegRotation, rightLegRotation, leftPupil, rightPupil), physics.pos.x, physics.pos.y);
    pushMatrix();
    translate(physics.pos.x+size/2, physics.pos.y+size/2);
    rotate(physics.rotation);
    scale(size/100);
    shape(form(), -size/(size/50), -size/(size/50)); //when using FX2D
    //shape(form(), -size/2, -size/2); //when using the default renderer
    popMatrix();
  }

  /* Switch state
   Switch to a new state and prepare the variables.
   */
  void switchToState(int newState) {
    if (newState != state) {
      state = newState;
      switch(newState) {
      case 1: //when being grabbed
        physics.changePhysics(1);
        switchAnimationState(0, 1);
        staticEyes = true;
        break;
      case 2: //when standing upright
        physics.changePhysics(2);
        switchAnimationState(0, 0);
        staticEyes = true;
        break;
      case 3: //when being thrown/needing to rotate
        physics.changePhysics(3);
        switchAnimationState(0, 1);
        staticEyes = true;
        break;
      case 4: //rotating back to face up
        animationTimer = 0;
        staticEyes = true;
        jumping = false;
        preRoll = true;

        if (physics.pos.x + size > field.x - 200) { //Decide the direction to roll
          moveDir = false;
          rollSpeed = -5;
        } else if (physics.pos.x < 200) {
          moveDir = true;
          rollSpeed = 5;
        } else if (physics.rotation > PI) {
          moveDir = true;
          rollSpeed = 5;
        } else {
          moveDir = false;
          rollSpeed = -5;
        }
        break;
      case 5: //wandering around the screen
        animationTimer = 0;
        staticEyes = false;
        jumping = false;
        endAnimation = false;
        walkToPos = int(random(size, field.x-size)); //select a random x position of the screen to wander towards

        if (walkToPos > physics.pos.x) { //Calculate the direction it has to walk to reach the goal
          moveDir = true; //move right
        } else {
          moveDir = false; //move left
        }
        break;
      }
    }
  }

  /* switch to a new animation state
   Switch a body part to a new predifined pose/animation
   Supports different body parts each with different poses and animations 
   (currently only has one body part with 2 poses and no animations... has room for expansion if needed)
   */
  void switchAnimationState(int part, int pose) {
    switch(part) {
    case 0: //legs
      switch(pose) {
      case 0:
        newLeftLegRotation = 0;
        newRightLegRotation = 0;
        break;
      case 1:
        newLeftLegRotation = PI*0.22;
        newRightLegRotation = -PI*0.22;
        break;
      }
      break;
    }
  }

  /* Animate
   For any parts that animate every frame
   Including smoothing out the transition between poses
   */
  void animate() {
    //smooth out and apply leg rotation changes
    leftLegRotation += (newLeftLegRotation-leftLegRotation)/2;
    rightLegRotation += (newRightLegRotation-rightLegRotation)/2;

    //calculate the position and smooth out the movement of the eyes 
    PVector looking;
    float lookingDir;
    PVector actualEyeCenter = eyeCenter.copy().mult(size/100); //account for the matrix transformations that happen when generating the graphic
    PVector actualPupilPos = pupilPos.copy().mult(size/100);
    
    if (!staticEyes) { //when the eyes should look at a point
      looking = new PVector(physics.pos.x+actualEyeCenter.x-actualPupilPos.x, physics.pos.y+actualEyeCenter.y+actualPupilPos.y).sub(lookingAtPoint); //calculate where the point to look at is relative to the left eye
      lookingDir = looking.heading(); //get the rotation of the point to look at relative to the left eye
      leftPupilGoal = new PVector(pupilPos.x+cos(lookingDir)*pupilRotationRadius, -sin(lookingDir)*pupilRotationRadius); //calculate where the left pupil should be located
      looking = new PVector(physics.pos.x+actualEyeCenter.x+actualPupilPos.x, physics.pos.y+actualEyeCenter.y+actualPupilPos.y).sub(lookingAtPoint); //calculate where the point to look at is relative to the right eye
      lookingDir = looking.heading(); //get the rotation of the point to look at relative to the right eye
      rightPupilGoal = new PVector(pupilPos.x-cos(lookingDir)*pupilRotationRadius, -sin(lookingDir)*pupilRotationRadius); //calculate where the right pupil should be located
    } else { //set where the eyes should be located when static, aka looking at the user
      leftPupilGoal = new PVector(pupilDerpyPos.x, pupilDerpyPos.y);
      rightPupilGoal = new PVector(pupilDerpyPos.x, pupilDerpyPos.y);
    }
    
    //smooth out the pupil movement
    leftPupilPos = leftPupilGoal.sub(leftPupilPos).div(2).add(leftPupilPos);
    rightPupilPos = rightPupilGoal.sub(rightPupilPos).div(2).add(rightPupilPos);
  }

  /* Rotate to face up and then switch to simple physics
   First rotate a bit in the opposite direction, then rotate towards facing upwards.
   Rotating is accomplished by moving over the x axis and having the physics engine calculate the rotation
   When the creature is almost facing up, jump in the air for the final bit of rotation
   When it faces completely upwards, switch to simple physics
   */
  void moveUpright() {
    animationTimer++;
    if (preRoll) { //Roll in the opposite direction for a bit, to make the animation look more natural (at least that's the idea)
      if (animationTimer < 10) {
        physics.vel.x = -rollSpeed;
      } else {
        preRoll = false;
        animationTimer = 0;
      }
    } else {
      if (jumping == false) { //Roll towards being upright
        physics.vel.x = rollSpeed;
      }
      if (jumping == false && animationTimer > 10 && ((physics.rotation < PI/8 || physics.rotation > 2*7*PI/8) || (physics.pos.x < 20 || physics.pos.x+size > field.x-20))) { //when almost upright, jump
        jumping = true;
        animationTimer = 0;
      }
      if (jumping == true && animationTimer < 3) { //accelerate upwards for a bit to make the animation more smooth
        physics.beginAcc.y = -8;
      }
      if (jumping == true && physics.rotMag < abs(physics.rotVel)) { //If the next step of rotation moves the creature fully upwards, switch to simple physics
        switchToState(2);
      }
      if (jumping == true && animationTimer > 60) { //failsafe for if the creature does not rotate upwards in time
        switchToState(3);
      }
    }
  }

  /* Walk to a spot on the screen
   Walk towards a spot on the screen by doing little hops.
   Stop walking after passing the spot
   */
  void walk() {
    animationTimer++;
    if (moveDir) {
      lookingAtPoint = new PVector(physics.pos.x + size + 50, field.y-physics.hitBoxHeight+pupilPos.y); //look right
    } else {
      lookingAtPoint = new PVector(physics.pos.x - 50, field.y-physics.hitBoxHeight+pupilPos.y); //look left
    }
    if (jumping == true && physics.pos.y >= field.y-size && animationTimer >= 60 && endAnimation == true) { //if the creature has passed the spot and the hop is finished, switch from walking to standing.
      switchToState(2);
    } else {
      if (jumping == true && physics.pos.y >= field.y-size && animationTimer >= 60) { //if the creature has landed and is ready to hop again
        jumping = false;

        if (walkToPos > physics.pos.x) { //failsafe, recalculate which direction to walk to get to the point
          moveDir = true; //walk right
        } else {
          moveDir = false; //walk left
        }
      }

      if (jumping == false) { //start the jump
        jumping = true;
        animationTimer = 0;
      }

      if (jumping == true && animationTimer < 3) { //start a hop by accelerating upwards and towords the point
        physics.beginAcc.y = -9;
        if (moveDir == false) {
          physics.beginAcc.x = -2;
        } else {
          physics.beginAcc.x = 2;
        }
      }

      if ((moveDir == true && physics.pos.x > walkToPos-size) || moveDir == false && physics.pos.x < walkToPos) { //if the creature passes the point at any point during the animation, get ready to stop walking
        endAnimation = true;
      }
    }
  }

  boolean checkCollision() { //if the cursor is clicked, check for collision with it and switch to the being grabbed state
    if (physics.pos.copy().add(size/2, size/2).dist(cursor) <= size/2) {
      switchToState(1);
      return true;
    }
    return false;
  }

  void releaseCursor() { //if the cursor is released and the creature is grabbed, switch to ball physics
    if (state == 1) {
      if(cursor.copy().sub(pCursor).mag() > 10 || physics.rotMag > PI/100) {
        switchToState(3);
      } else {
        switchToState(2);
      }
    }
  }
  
  /* Generate the look of the creature
   Using seperate functions to keep it as clean as possible while having as much flexibility for animations as possible
   */
  PShape form() {
    PShape creature = createShape(GROUP);
    
    final int legWidth = 20;
    final int legHeight = 15;
    final int legXPos = 25;
    final int legYPos = 75;

    PShape leftLeg = formLeg(legWidth, legHeight, bodyColor);
    leftLeg.translate(legXPos, legYPos);
    leftLeg.rotate(leftLegRotation);
    creature.addChild(leftLeg);

    PShape rightLeg = formLeg(legWidth, legHeight, bodyColor);
    rightLeg.translate(100-legXPos, legYPos);
    rightLeg.rotate(rightLegRotation);
    creature.addChild(rightLeg);
    
    PShape body = formBody(bodyColor);
    creature.addChild(body);
  
    final int eyeSize = 20;
    final int pupilSize = 5;
    final color eyeOpenColor = #FFFFFF;
    final color eyeClosedColor = bodyColor;
    final color pupilColor = #000000;
    
    PShape eyes = formEyes(eyeSize, leftPupilPos, rightPupilPos, pupilSize, eyeOpenColor, eyeClosedColor, pupilColor, blink);
    eyes.translate(eyeCenter.x, eyeCenter.y);
    creature.addChild(eyes);
    
    return(creature);
  }

  PShape formLeg(int legWidth, int legHeight, color legColor) { 
    pushMatrix();
    PShape leg = createShape(TRIANGLE, 0,0, -legWidth/2,legHeight, legWidth/2,legHeight);
    leg.setFill(legColor);
    translate(0,legHeight/2);
    popMatrix();
    return(leg);
  }
  
  
  PShape formBody(color bodyColor) {
    PShape body = createShape(PShape.PATH);
    body.beginShape();
    body.vertex(0.5,50.5);
    body.bezierVertex(0.5,23, 22.5,0.5, 50,0.5);
    body.bezierVertex(77.5,0.5, 99.5,23, 99.5,51);
    body.bezierVertex(99.5,78.5, 77,83, 49.5,83);
    body.bezierVertex(22,83, 0.5,78.5, 0.5,50.5);
    body.endShape();
    
    body.setFill(bodyColor);
    
    return(body); 
  }
  
  PShape formEyes(int eyeSize, PVector leftPupilPos, PVector rightPupilPos, int pupilSize, color eyeOpenColor, color eyeClosedColor, color pupilColor, boolean blink) {
    PShape eyes = new PShape(GROUP);
    
    PShape leftEyeball = createShape(ELLIPSE, -eyeSize/2, 0, eyeSize, eyeSize);
    PShape rightEyeball = createShape(ELLIPSE, eyeSize/2, 0, eyeSize, eyeSize);
    
    if(blink) {
      leftEyeball.setFill(eyeClosedColor);
      rightEyeball.setFill(eyeClosedColor);
      
      PShape eyeLid = createShape(LINE, -eyeSize, 0, eyeSize, 0);
      eyes.addChild(eyeLid);
    }
    else {
      leftEyeball.setFill(eyeOpenColor);
      rightEyeball.setFill(eyeOpenColor);
      
      PShape leftPupil = createShape(ELLIPSE, -leftPupilPos.x, leftPupilPos.y, pupilSize,pupilSize);
      PShape rightPupil = createShape(ELLIPSE, rightPupilPos.x, rightPupilPos.y, pupilSize,pupilSize);
      leftPupil.setFill(pupilColor);
      rightPupil.setFill(pupilColor); 
      eyes.addChild(leftPupil);
      eyes.addChild(rightPupil);
    }
    
    eyes.addChild(leftEyeball, 0);
    eyes.addChild(rightEyeball, 1);
    
    return(eyes);
  }
}
