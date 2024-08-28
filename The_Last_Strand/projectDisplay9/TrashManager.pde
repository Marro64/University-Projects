class TrashManager {
  ArrayList<Trash> staticTrashes = new ArrayList<Trash>();
  ArrayList<Trash> movingTrashes = new ArrayList<Trash>();
  ArrayList<Trash> temporaryTrashes = new ArrayList<Trash>();
  PImage[] bitmaps;
  int trashDir = -1;
  int trashTimer;
  int trashIndex;

  TrashManager() {
    String path = sketchPath() + "/trashes";
    String[] filenames = listFileNames(path);
    bitmaps = new PImage[filenames.length];
    for (int i = 0; i < filenames.length; i++) {
      println(filenames[i]);
      bitmaps[i] = loadImage("trashes/" + filenames[i]);
    }
    
    for(int i = 0; i < 10; i++) {
      int bitmapID = int(random(0, bitmaps.length));
      movingTrashes.add(new Trash(bitmaps[bitmapID], new PVector(random(0, width), random(field.y*.7, field.y*.75)), 0, true));
    }
    for(int i = 0; i < 10; i++) {
      int bitmapID = int(random(0, bitmaps.length));
      movingTrashes.add(new Trash(bitmaps[bitmapID], new PVector(random(0, width), random(field.y*.75, field.y*.8)), 0, true));
    }
    for(int i = 0; i < 10; i++) {
      int bitmapID = int(random(0, bitmaps.length));
      movingTrashes.add(new Trash(bitmaps[bitmapID], new PVector(random(0, width), random(field.y*.8, field.y*.85)), 0, true));
    }
    for(int i = 0; i < 10; i++) {
      int bitmapID = int(random(0, bitmaps.length));
      movingTrashes.add(new Trash(bitmaps[bitmapID], new PVector(random(0, width), random(field.y*.85, field.y*.9)), 0, true));
    }
    //for(int i = 0; i < 20; i++) {
    //  int bitmapID = int(random(0, bitmaps.length));
    //  staticTrashes.add(new Trash(bitmaps[bitmapID], new PVector(random(0, width), random(field.y*.8, field.y)), 0, true));
    //}
    for(int i = 0; i < 20; i++) {
      staticTrashes.add(new Trash(bitmaps, new PVector(i*width/20, random(field.y*.9, field.y)), 0, true));
    }

  }

  void display() {
    imageMode(CENTER);
    for (Trash trash : temporaryTrashes) {
      trash.display();
    }
    for (Trash trash : movingTrashes) {
      trash.display();
    }
    for (Trash trash : staticTrashes) {
      trash.display();
    }

    imageMode(CORNER);
  }
  
  void update() {
    trashTimer++;
    if(trashDir < 0) {      
      if(trashTimer >= 240 && movingTrashes.get(trashIndex).moveDir == 0) {
        if(trashIndex < movingTrashes.size()-1) {
          movingTrashes.get(trashIndex).startMovingUp();
          trashIndex++;
        } else {
          createTempTrashUp();
        }
        trashTimer = 0;
      }
    } else if(trashDir > 0) {
       if(trashTimer >= 240) {
        if(trashIndex > 0 && movingTrashes.get(trashIndex-1).moveDir == 0) {
          trashIndex--;
          movingTrashes.get(trashIndex).startMovingDown();
        } else {
          createTempTrashDown();
        }
        trashTimer = 0;
      }
    }
    
    for (Trash trash : movingTrashes) {
      trash.update();
    }
    for (Trash trash : staticTrashes) {
      trash.update();
    }
    for (Trash trash : temporaryTrashes) {
      trash.update();
    }
    for (int i = 0; i < temporaryTrashes.size(); i++) {
       if(temporaryTrashes.get(i).pos.y > height+500 || temporaryTrashes.get(i).pos.y < -500) {
        temporaryTrashes.remove(i);
      }
    }

  }
  
  void createTempTrashUp() {
    temporaryTrashes.add(new Trash(bitmaps, new PVector(random(0, width), height+300), 0, true));
    temporaryTrashes.get(temporaryTrashes.size()-1).noLimit = true;
    temporaryTrashes.get(temporaryTrashes.size()-1).startMovingUp();
  }
  
  void createTempTrashDown() {
    temporaryTrashes.add(new Trash(bitmaps, new PVector(random(0, width), -300), 0, true));
    temporaryTrashes.get(temporaryTrashes.size()-1).noLimit = true;
    temporaryTrashes.get(temporaryTrashes.size()-1).startMovingDown();
  }
  
  void startMovingUp() {
    trashDir = -1;
    trashTimer = 0;
  }
  
  void startMovingDown() {
    trashDir = 1;
    trashTimer = 0;
  }


  String[] listFileNames(String dir) {
    File file = new File(dir);
    if (file.isDirectory()) {
      String names[] = file.list();
      return names;
    } else {
      return null;
    }
  }
}
