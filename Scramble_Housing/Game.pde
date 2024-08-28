/* The main container of the game
 can be replaced to load a new level
 */
class Game {
  Piece[] pieces;
  Background background;
  DragTutorial dragTutorial;
  RotateTutorial rotateTutorial;
  WinScreen winScreen;

  int pieceCount;
  int selected = -1; //Which piece is being dragged, -1 means none
  int tutorial; //Which tutorial is active
  int fadeTimer; //Stores how much the screen is darkened, when >= 100 the screen is black

  boolean allowRotation, win = false, fadeOut = false, nextLevel = false;

  PVector field, cursor;

  float[][] pieceSlots; //Stores the position and width of the grid of pieces.

  final int fadeDuration = 50; //how many frames the fadein/out takes
  final int loadingTime = 50; //how long the screen stays black before fading into the puzzle

  Game(PImage img, int columns, int rows, float[][] pieceSlots, PImage backgroundImage, PImage winScreenImage, int tutorial, boolean allowRotation, PVector field, PVector cursor) {
    this.tutorial = tutorial; //contains the little mouse icon that shows you what to do
    this.allowRotation = allowRotation; //if the current level has rotating pieces
    this.pieceSlots = pieceSlots; //the location and size of each of the slots for the pieces
    this.field = field;
    this.cursor = cursor;

    pieceCount = columns*rows;
    pieces = new Piece[pieceCount];

    //split the puzzle image up into 9 equal pieces
    int partWidth = img.width/columns;
    int partHeight = img.height/rows;
    for (int ID = 0; ID < pieceCount; ID++) {
      pieces[ID] = new Piece(img.get((ID%columns)*partWidth, (ID/rows)*partHeight, partWidth, partHeight), ID, pieceSlots, cursor);
    }

    shufflePieces(pieces);

    if (tutorial == 1) { //enable the tutorial for dragging the pieces
      final int dragTutorialPiece1 = 0; //the pieces that the tutorial prompts you to drag between
      final int dragTutorialPiece2 = 4;
      dragTutorial = new DragTutorial(new PVector(pieceSlots[dragTutorialPiece1][0]+pieceSlots[dragTutorialPiece1][2]/2, pieceSlots[dragTutorialPiece1][1]+pieceSlots[dragTutorialPiece1][3]/2), new PVector(pieceSlots[dragTutorialPiece2][0]+pieceSlots[dragTutorialPiece2][2]/2, pieceSlots[dragTutorialPiece2][1]+pieceSlots[dragTutorialPiece2][3]/2)); //create the dragging tutorial between the center of two pieces
    } else if (tutorial == 2) { //enable the tutoial for rotation
      final int rotateTutorialPiece = 4;
      rotateTutorial = new RotateTutorial(new PVector(pieceSlots[rotateTutorialPiece][0]+pieceSlots[rotateTutorialPiece][2]/2, pieceSlots[rotateTutorialPiece][1]+pieceSlots[rotateTutorialPiece][3]/2)); //create the rotation tutorial with the right click icon in the center of the piece
    }

    background = new Background(backgroundImage, new PVector(0, 0), new PVector(backgroundImage.width, backgroundImage.height)); //set the static background
    winScreen = new WinScreen(winScreenImage, field.copy().div(2));

    fadeTimer = fadeDuration + loadingTime; //setup the fadein with a loading time where the screen is completely blank to allow the pieces to move into position
  }

  //the main loop of the game
  void mainLoop() {

    background.draw();
    drawHoles();

    //Call the main loop of all the pieces
    for (int ID = 0; ID < pieces.length; ID++) {
      pieces[ID].move();
    }

    //draw the currently selected piece last, so it's always on top
    for (int ID = 0; ID < pieces.length; ID++) {
      if (ID != selected) {
        pieces[ID].draw();
      }
    }
    if (selected != -1) {
      pieces[selected].draw();
    }

    if (tutorial == 1) {
      dragTutorial.mainLoop();
    } else if (tutorial == 2) {
      rotateTutorial.mainLoop();
    }

    //check if the player has won by setting a boolean to true and changing it to false if any piece is incorrect
    win = true;
    for (int ID = 0; ID < pieces.length; ID++) {
      if (ID != pieces[ID].IDPos || pieces[ID].quartRotation != 0) {
        win = false;
        break;
      }
    }

    //if the puzzle is solved draw the win screen
    if (win) {
      winScreen.draw();
    }

    fade();
  }

  //for the fadein at the beginning of the level and fadeout at the end
  void fade() {
    int fade; //the actual fade amount
    if (fadeTimer > fadeDuration) {
      fade = fadeDuration; //if the fade timer is more than 100%, set it to 100%
    } else {
      fade = fadeTimer;
    }

    if (fadeOut && fade < fadeDuration) {
      fadeTimer++; //if the fade out is active and hasn't finished
    } else if (!fadeOut && fade > 0) {
      fadeTimer--; //if the fadein is active and hasn't finished
    } else if (fadeOut && fade >= fadeDuration) {
      nextLevel = true; //if the fadeout has finished
    }

    //draw the fade
    fill(#000000, fade*(255/float(fadeDuration)));
    rect(0, 0, field.x, field.y);
  }

  //try to select a piece unless the game is won, in that case activate the fadeout to transision to the next level
  void leftMouseClick() {
    if (!win) {
      for (Piece piece : pieces) {
        if (piece.checkCollision()) {
          piece.getSelected();
          selected = piece.ID;
          break;
        }
      }
    } else {
      fadeOut = true;
    }
  }

  /* When the left mouse button is pressed:
   if any piece is selected, check if the cursor is over another piece and swap the selected piece with the one underneath the cursor
   Deselect the piece so it takes its new place or returns to its old position
   Disable the dragging tutorial if it is active
   */
  void leftMouseReleased() {
    if (selected != -1) {
      for (Piece piece : pieces) {
        if (piece.checkCollision()) {
          swapPiece(piece, pieces[selected]);
          if (tutorial == 1) {
            tutorial = 0;
          }
          break;
        }
      }
      //unselect piece
      pieces[selected].selected = false;
      selected = -1;
    }
  }

  /* When the right mouse button is pressed:
   if the game is in a state where it allows rotation, if the cursor is over a piece rotate that piece
   Disable the rotation tutorial if it is active
   */
  void rightMouseClick() {
    if (!win && allowRotation) {
      for (Piece piece : pieces) {
        if (piece.checkCollision()) {
          piece.rotatePiece(1);
          if (tutorial == 2) {
            tutorial = 0;
          }
          break;
        }
      }
    }
  }

  /* Shuffle all the pieces
   For each piece, swap it with a random other piece
   If rotation is enabled, give each piece a random rotation
   Check how many pieces are in the solved position (not rotation), if this is too many shuffle again
   */
  void shufflePieces(Piece[] pieces) {
    int solvedAmount = pieceCount;
    while (solvedAmount > 2) { //loop if too many pieces are in the right place
      for (Piece piece : pieces) {
        swapPiece(piece, pieces[int(random(0, pieceCount))]);
      }

      //count how many pieces are correct
      solvedAmount = 0;
      for (Piece piece : pieces) {
        if (piece.ID == piece.IDPos) {
          solvedAmount++;
        }
      }
    }


    //rotate all pieces
    if (allowRotation) {
      for (Piece piece : pieces) {
        piece.setRotation(int(random(0, 4)));
      }
    }
  }

  //swap the grid position of two pieces
  void swapPiece(Piece piece1, Piece piece2) {
    int moveTo = piece1.IDPos;
    piece1.IDPos = piece2.IDPos;
    piece2.IDPos = moveTo;
  }

  /* Draw something over the resting position of the pieces
   Used to be its own class with the idea of it having some cool particles, but time constraints forced it into a simple method...
   */
  void drawHoles() {
    fill(0);
    for (int num = 0; num < pieceSlots.length; num++) {
      rect(pieceSlots[num][0], pieceSlots[num][1], pieceSlots[num][2], pieceSlots[num][3]);
    }
  }
}
