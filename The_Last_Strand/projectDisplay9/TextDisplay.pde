/*=================
Text display using floating balls.
Resizes letters to the field size.
Also passes alarm state to the letters.

By Marinus Bos, 2022
=================*/

class TextDisplay {
  ArrayList<Letter> characters;
  char[] charDisplay;
  PVector stringSize;
  PVector center;
  float sizeH;
  PVector field;
  float seperation = 1;
  color ballColor;
  
  TextDisplay(String initialText, PVector center, float sizeH, PVector field, color ballColor) {
    this.center = center;
    this.sizeH = sizeH;
    this.field = field;
    this.ballColor = ballColor;
    
    characters = new ArrayList<Letter>();
    
    //generate initial letters
    for (int i = 0; i < initialText.length(); i++) {
      characters.add(new Letter(' ', new PVector(0, 0), 1, field, ballColor));
    }
    
    //organise the characters on the field
    organise(center, sizeH);
    //resize the background image
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
      letter.ballColor = ballColor;
    }
  }
  
  //update the time displayed
  void changeString(String newCharDisplay) {
    charDisplay = newCharDisplay.toCharArray();
    while(charDisplay.length != characters.size()) {
      if(charDisplay.length < characters.size()) {
        characters.remove(characters.size()/2);
      }
      else if(charDisplay.length > characters.size()) {
        characters.add(int(random(characters.size())), new Letter(' ', new PVector(center.x, center.y), seperation, field, ballColor));
      }
    }
    for (int i = 0; i < charDisplay.length; i++) {
      characters.get(i).changeChar(charDisplay[i]);
    }
  }
  
  void explode() {
    for(Letter letter : characters) {
      letter.explode();
    }
  }
  
  void unExplode() {
    for(Letter letter : characters) {
      letter.unExplode();
    }
  }
}
