/*=================
Text display using floating balls.
Resizes letters to the field size.
Also passes alarm state to the letters.

By Marinus Bos, 2022
=================*/

class TimeDisplay {
  ArrayList<Letter> characters;
  char[] charDisplay;
  PVector stringSize;
  PVector center;
  float sizeH;
  PVector field;
  float seperation = 1;
  PImage background;
  
  TimeDisplay(String initialText, PVector center, float sizeH, PVector field, PImage background) {
    this.center = center;
    this.sizeH = sizeH;
    this.field = field;
    this.background = background;
    
    characters = new ArrayList<Letter>();
    
    //generate initial letters
    for (int i = 0; i < initialText.length(); i++) {
      characters.add(new Letter(' ', new PVector(0, 0), 1, field, background));
    }
    
    //organise the characters on the field
    organise(center, sizeH);
    //resize the background image
    background.resize(width, height);
  }
  
  void mainLoop() {
    organise(center, sizeH);
    
    for (Letter letter : characters) {
      letter.mainLoop();
    }
  }
  
  //calculate and set the location and size of the letters
  void organise(PVector center, float sizeH) {
    //figure out the strings's displayed size
    stringSize = new PVector(0, 0);
    for(Letter letter : characters) {
      stringSize.x += letter.charSize.x;
      if(letter.charSize.y > stringSize.y) {
        stringSize.y = letter.charSize.y;
      }
    }
    
    //resize the characters to fit in the given size
    seperation = seperation*sizeH/stringSize.x;
    for(Letter letter : characters) {
      letter.resizeChar(seperation);
    }
    
    //find where the string needs to start to be centered
    PVector letterPos = center.copy().sub(stringSize.div(2));
    
    //move the string to the center
    float xPos = 0;
    for(Letter letter : characters) {
      letter.relocate(letterPos.copy().add(xPos, 0));
      xPos += letter.charSize.x;
    }
  }
  
  //update the time displayed
  void changeString(String newCharDisplay) {
    charDisplay = newCharDisplay.toCharArray();
    while(charDisplay.length != characters.size()) {
      if(charDisplay.length < characters.size()) {
        characters.remove(0);
      }
      else if(charDisplay.length > characters.size()) {
        characters.add(0, new Letter(' ', new PVector(0, center.y), seperation, field, background));
      }
    }
    for (int i = 0; i < charDisplay.length; i++) {
      characters.get(i).changeChar(charDisplay[i]);
    }
  }
  
  void alarmOn() {
    for(Letter letter : characters) {
      letter.alarmOn();
    }
  }
  
  void alarmOff() {
    for(Letter letter : characters) {
      letter.alarmOff();
    }
  }
}
