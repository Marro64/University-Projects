/*=================
Time display using the letter and ball classes. Holds the letter objects and actualizes the time displayed by them.
Resizes letters to the field size.
Also passes alarm state to the letters.

By Marinus Bos, 2022
=================*/

class TimeDisplay {
  ArrayList<Letter> characters;
  char[] charDisplay;
  PVector stringSize;
  PVector field;
  float seperation = 1;
  PImage background;
  
  TimeDisplay(PVector field, PImage background) {
    this.field = field;
    this.background = background;
    
    characters = new ArrayList<Letter>();
    
    //generate initial letters
    for (int i = 0; i < getTimeString().length(); i++) {
      characters.add(new Letter(' ', new PVector(0, 0), 1, field, background));
    }
    
    //organise the characters on the field
    organise(field);
    //resize the background image
    background.resize(width, height);
  }
  
  void mainLoop() {
    updateTime();
    organise(field);
    for (Letter letter : characters) {
      letter.mainLoop();
    }
  }
  
  //calculate and set the location and size of the letters
  void organise(PVector field) {
    //figure out the strings's displayed size
    stringSize = new PVector(0, 0);
    for(Letter letter : characters) {
      stringSize.x += letter.charSize.x;
      if(letter.charSize.y > stringSize.y) {
        stringSize.y = letter.charSize.y;
      }
    }
    
    //resize the characters to fit in the screen, with some margins
    seperation = seperation*field.x/(stringSize.x*1.2);
    for(Letter letter : characters) {
      letter.resizeChar(seperation);
    }
    
    //find where the string needs to start to be centered
    PVector letterPos = field.copy().div(2).sub(stringSize.div(2));
    
    //move the string to the center
    float xPos = 0;
    for(Letter letter : characters) {
      letter.relocate(letterPos.copy().add(xPos, 0));
      xPos += letter.charSize.x;
    }
  }
  
  //update the time displayed
  void updateTime() {
    char[] newCharDisplay = getTimeString().toCharArray();
    
    if(newCharDisplay != charDisplay) { //only update if the time has changed
      charDisplay = newCharDisplay;
      for (int i = 0; i < charDisplay.length; i++) {
        characters.get(i).changeChar(charDisplay[i]);
      }
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
  
  //returns a string containing formatted time
  String getTimeString() {
    return String.format("%02d", hour())+":"+String.format("%02d", minute())+":"+String.format("%02d", second());
  }
}
