/*==========
Text container 
Contains and alligns the letters on the screen.
==========*/

class TextContainer {
  ArrayList<Letter> letters;
  String text = "";
  PVector cursor, field;
  boolean[] mouseButtons = {false, false};

  TextContainer(String[] inputText, PVector field) {
    this.field = field;
    
    letters = new ArrayList<Letter>();
    final float seperation = 4.5; //how far apart the balls are (also affects their size)

    //combines all text rows into one, with a line break character between lines
    for (int i = 0; i < inputText.length; i++) {
      text = text + inputText[i] + char(0xA0);
    }

    //creates the letters
    for (int i = 0; i < text.length()-1; i++) {
      letters.add(new Letter(text.charAt(i), new PVector(0, 0), seperation));
    }
  }
  
  //runs the letter's main loop
  void mainLoop() {
    for (Letter letter : letters) {
      letter.update(mouseButtons, cursor);
    }
  }
  
  
  //organises the position of all balls, including adding linebreaks where necessary to stay within the boundries. Gets called when the container's size gets changed.
  void organiseScreen(PVector updatedField) {
    this.field = updatedField;
    final char newLineChar = char(0xA0); //the character that signifies a new line
    final char emptyChar = ' '; //character to ignore when deciding the width of a text part

    PVector charPos = new PVector(border, border); //start from the border's size
    float lineHeight = 0; //keep track of the tallest character in a line, which defines how far down the next line needs to be

    for (int i = 0; i < text.length()-1; i++) {
      boolean newLine = false; //gets set to true if a new line needs to be made
      Letter currentLetter = letters.get(i);

      //see if the next word fits inside the width of the screen, using space as a delimiter. If it doesn't, call a new line.
      if (currentLetter.character == ' ') {
        float tempLineWidth = charPos.x+currentLetter.charSize.x;
        for (int j = i+1; j < text.length()-1; j++) {
          Letter tempCurrentLetter = letters.get(j);
          tempLineWidth += tempCurrentLetter.charSize.x;
          if (text.charAt(j) == ' ' || text.charAt(j) == newLineChar) {
            newLine = false;
            break;
          } else if (tempLineWidth >= field.x) {
            newLine = true;
            break;
          }
        }
      }
      
      PVector charSize = letters.get(i).charSize;
      
      //if the next character goes over the screen, call a new line
      if (charPos.x+charSize.x >= field.x + border && (text.charAt(i) != emptyChar && text.charAt(i) != newLineChar)) {
        newLine = true;
      }
      
      //if there's a new line character in the file, call a new line
      if (text.charAt(i) == newLineChar) { 
        newLine = true;
      }
      
      //respond to the call for a new line by moving the next character's position down and back to the left edge
      if (newLine) {
        charPos.x = border;
        charPos.y += lineHeight;
        lineHeight = 0;
      }

      //finally, set the character's position and increase the horizontal position for the next character. Ignore invisible characters.
      if (!newLine || (text.charAt(i) != emptyChar && text.charAt(i) != newLineChar)) { 
        currentLetter.relocate(charPos);

        charPos.x += charSize.x;
        if (lineHeight < charSize.y) {
          lineHeight = charSize.y;
        }
      }
    }
  }
  
  //update mouse variables
  void mouseHandler(boolean[] newMouseButtons, PVector newCursor) {
    cursor = newCursor;
    mouseButtons = newMouseButtons;
  }
}
