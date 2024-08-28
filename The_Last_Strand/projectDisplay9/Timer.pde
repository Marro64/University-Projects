class Timer {
  TextDisplay fancyDisplay;
  PFont numbers;
  int time;
  int counter; 
  int scores;
  ArrayList<Integer> leaderboard = new ArrayList<Integer>();
  ArrayList<Integer> allTimeLeaderboard = new ArrayList<Integer>();
  boolean running;
  boolean isGoingDown;
  ArrayList<Integer> eventsList = new ArrayList<Integer>();
  int highestScore = 0;
  String timeString = " ";

  Timer(String LOG_FILE) {
    //fancyDisplay = new TextDisplay(" ", new PVector(field.x/2, field.y*0.3), field.x/1.5, field);
    numbers = createFont("Grotesque.ttf", 90);
    try {
      File myObj = new File(LOG_FILE);
      Scanner myReader = new Scanner(myObj);
    } 
    catch (FileNotFoundException e) {
      System.out.println("An error occurred.");
      e.printStackTrace();
    }
    
    logEvent("Timer gets created");
  }

  void display() {
    //pushStyle();
    //textAlign(CENTER);
    //fill(0);
    //textFont(numbers);
    //text(getScoreFormat(time), width/2, height*0.3);
    //popStyle();
    
    timeString = getScoreFormat(time);
    //fancyDisplay.changeString(getScoreFormat(time));
    //fancyDisplay.mainLoop();

    pushStyle();
    textAlign(CENTER);
    fill(0);
    textFont(game);
    textSize(30);
    if(time < highestScore) {
      text("Highest time: " + getScoreFormat(highestScore), width/2, height*0.27);
    } else {
      text("New highest time!", width/2, height*0.27);
    }
    popStyle();
    
    //if(isGoingDown){
    //  pushStyle();
    //  textAlign(CENTER);
    //  fill(0);
    //  textFont(numbers);
    //  textSize(30);
    //  text("Time's Running out!", width/2, height*0.2);
    //  popStyle();
    //}
  }

  void update() {
    //the timer
    if(running) {
      time = getTime();
    }
    
    if(time <= 0 && isGoingDown == true && running == true) {
      stopTimer();
    }
    
    if(time > highestScore) {
      highestScore = time;
    }
  }

  void countUp() {
    //called when going up
    upOrDownEvent(false);
  }

  void countDown() {
    //called when going down
    upOrDownEvent(true);
  }
  
  void upOrDownEvent(boolean isDown){
    if(running){
      //only change the state if it doesn't stay the same
      if(isGoingDown != isDown){
        eventsList.add(millis());
        isGoingDown = isDown;
        if(isDown == true) {
          logEvent("Timer starts counting down at " + getScoreFormat(getTime()));
        } else {
          logEvent("Timer starts counting up at " + getScoreFormat(getTime()));
        }
      }
    }
  }

  void startTimer() {
    running = true;
    isGoingDown = false;
    eventsList.add(millis());
    logEvent("Timer gets started at " + getScoreFormat(getTime()));
  }

  void stopTimer() {
    running = false;
    logEvent("Timer gets stopped");
    time = 0;
    eventsList.clear();
  }
  
  /**
   Gets the backwards time
   **/
  int getTime() {
    int startTime = eventsList.get(0);
    return millis() - startTime - 2*getTotalReversedTime();
  }
  
  int getTotalReversedTime(){
    int total = 0;
    if(eventsList.size() == 0){
      return 0;
    }
    if(eventsList.size()%2 == 0){
      //if even --> still in reverse
      total += millis() - eventsList.get(eventsList.size() -1);
    }
    for(int i=1; i<eventsList.size(); i++){
      if (i % 2 == 0){
        total += eventsList.get(i) - eventsList.get(i-1);
      }
    }
    //System.out.println("reversed: " + total);
    return total;
  }

  //formats the score
  String getScoreFormat(int time) {
    //int millisecs = time % 1000;
    int seconds = (int) TimeUnit.MILLISECONDS.toSeconds(time) % 60;
    int minutes = (int) TimeUnit.MILLISECONDS.toMinutes(time) % 60;
    int hours = (int) TimeUnit.MILLISECONDS.toHours(time);
    return  nf(hours, 2) + ":" + nf(minutes, 2) + ":" + nf(seconds, 2) ;
  }

  void logEvent(String output) {
    //add to file
    Date date = new Date();
    System.out.println("writing \"" + date.getTime() + ": " + output + "\"");
    try {
      File file = new File(LOG_FILE);
      if (!file.exists()) {
        file.createNewFile();
        System.out.println("creating file " + time);
      }
      FileWriter fw = new FileWriter(file, true);
      BufferedWriter bw = new BufferedWriter(fw);
      PrintWriter pw = new PrintWriter(bw);
      pw.println(date.getTime() + ": " + output);
      //more code
      //more code
      pw.close();
    } 
    catch (IOException e) {
      System.out.println("Exception ");
      e.printStackTrace();
    }
    finally {
    }
  }
}
