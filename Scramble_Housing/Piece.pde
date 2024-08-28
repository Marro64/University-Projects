//A piece of the puzzle
class Piece {
  PImage texture;

  float[][] pieceSlots;

  int ID, IDPos; //ID is an identifier for the piece but also the correct position for the puzzle, IDPos is the ID corresponding to the position that it's currently at

  float x = 0, y = 0, w = 0, h = 0;

  float rotation, rotationGoal = 0; //rotation is the current rotation, rotationGoal is where it's rotating towards. This is for animating the transision. 
  float rotW, rotH; //defines the width and the height of the pieces relative to its orientation. This is because the pieces are not square and you should not be able to see the difference between a square that's rotated 90 degrees and one that's right side up.
  int quartRotation = 0; //defines the current rotation in an absolute term, is used to decide if the piece is in the right orientation.

  final int selectedZoom = 10; //how much the piece is enlarged when selected 
  boolean selected;

  PVector cursor;
  PVector cursorOffset = new PVector(0, 0); //used for when the piece is dragged so it keeps its position relative to the cursor

  Piece(PImage texture, int ID, float[][] pieceSlots, PVector cursor) {
    this.texture = texture;
    this.ID = ID;
    this.IDPos = ID;
    this.pieceSlots = pieceSlots;
    this.cursor = cursor;
  }

  //Follow the cursor when selected or move towards the resting position when not selected
  void move() {

    if (!selected) { 
      //use a smooth motion when not selected
      x = transision(x, pieceSlots[IDPos][0]);
      y = transision(y, pieceSlots[IDPos][1]);
      w = transision(w, pieceSlots[IDPos][2])+1;
      h = transision(h, pieceSlots[IDPos][3])+1;
    } else {
      //snap to the position when selected so it doesn't lag behind the cursor
      x = cursor.x+cursorOffset.x - selectedZoom;
      y = cursor.y+cursorOffset.y - selectedZoom;
      w = pieceSlots[IDPos][2]+1 + 2*selectedZoom;
      h = pieceSlots[IDPos][3]+1 + 2*selectedZoom;
    }

    //animate the rotation
    rotation = transision(rotation, rotationGoal);

    //prevent the rotation from going above 2*PI or below 0, but only after the rotation animation has finished.
    if (rotation >= 2*PI) {
      rotation -= 2*PI;
      rotationGoal -= 2*PI;
    } else if (rotation < 0) {
      rotation += 2*PI;
      rotationGoal += 2*PI;
    }

    //Incrementally swap the width and height when rotating, so the rectangular pieces always fit inside their holes and you can't see if a piece is rotated upright 
    rotW = w*abs((rotation/HALF_PI)%2-1)+h*abs((rotation/HALF_PI+1)%2-1);
    rotH = h*abs((rotation/HALF_PI)%2-1)+w*abs((rotation/HALF_PI+1)%2-1);
  }

  //draw the piece, with the pivot in the center
  void draw() {
    imageMode(CENTER);
    pushMatrix();
    translate(x+w/2, y+h/2);
    rotate(rotation);
    image(texture, 0, 0, rotW, rotH);
    popMatrix();
    imageMode(CORNER);
  }

  //check for collision with the cursor
  boolean checkCollision() {
    if (!selected && cursor.x > x && cursor.y > y && cursor.x < x+w && cursor.y < y+h) {
      return(true);
    }
    return(false);
  } 

  //start following the cursor
  void getSelected() {
    selected = true;
    cursorOffset = new PVector(x - cursor.x, y - cursor.y);
  }

  //rotate by multiples of PI/2
  void rotatePiece(int dRotation) {
    quartRotation = (quartRotation+dRotation)%4; //prevent quartRotation from going above 3
    rotationGoal += dRotation*PI/2;
  }

  //set the rotation to a multiple of PI/2
  void setRotation(int quartRotation) {
    this.quartRotation = quartRotation%4; //prevent quartRotation from going above 3
    rotationGoal = quartRotation*PI/2;
  }

  //Smoothly transision between two numbers. Makes any animation look better.
  float transision(float current, float goal) {
    return(current + (goal-current)/4);
  }
}
