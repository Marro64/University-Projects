class TimerStreak {
  TextDisplay fancyDisplay;
  PFont numbers;
  int time;
  int counter; 
  int startTime = 0;
  int scores;
  ArrayList<Integer> leaderboard = new ArrayList<Integer>();
  ArrayList<Integer> allTimeLeaderboard = new ArrayList<Integer>();
  boolean running;
  String timeString = " ";

  TimerStreak(String OUTPUT_FILE) {
    //fancyDisplay = new TextDisplay(" ", new PVector(field.x/2, field.y*0.35), field.x/2.5, field);
    numbers = createFont("Grotesque.ttf", 90);
    try {
      File myObj = new File(OUTPUT_FILE);
      Scanner myReader = new Scanner(myObj);
      while (myReader.hasNextLine()) {
        String data = myReader.nextLine();
        String[] parts = data.split(",");
        allTimeLeaderboard.add(Integer.parseInt(parts[0]));
      }
    } 
    catch (FileNotFoundException e) {
      System.out.println("An error occurred.");
      e.printStackTrace();
    }        
    Collections.sort(allTimeLeaderboard);
    Collections.reverse(allTimeLeaderboard);
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

    String allTimeHighscores = "Longest streaks:" + "\n";
    ArrayList<Integer> combinedScores = new ArrayList<Integer>();
    combinedScores.addAll(allTimeLeaderboard);
    combinedScores.addAll(leaderboard);
    Collections.sort(combinedScores);
    Collections.reverse(combinedScores);
    for (int i = 0; i<allTimeLeaderboard.size() && i<5; i++) {
      allTimeHighscores += getScoreFormat(combinedScores.get(i)) + "\n";
    }
    
    //String highscores = "Today's Highscores" + "\n";
    //for (int i = 0; i<leaderboard.size() && i<5; i++) {
    //  highscores += getScoreFormat(leaderboard.get(i)) + "\n";
    //}

    pushStyle();
    textAlign(LEFT);
    fill(0);
    textFont(game);
    textSize(30);
    //text(highscores, width*0.05, height*0.6);
    text(allTimeHighscores, width*0.05, height*0.4);
    popStyle();
  }

  void update() {
    //the timer
    if (running) {
      getTime();
    } else {
      time = 0;
    }
  }

  void countUp() {
    isGoingDown = false;
    lastGoingUp = millis()-startTime;
    lastGoingUpTime = time;
    downTimes += lastGoingDown-lastGoingUp;
  }

  void countDown() {
    isGoingDown = true;
    lastGoingDown = millis()-startTime;
    System.out.println("downnn.");
    lastGoingDownTime = time;
    pushStyle();
    textAlign(CENTER);
    fill(0);
    textFont(numbers);
    textSize(30);
    text("Time's Running out!", width/2, height*0.2);
    popStyle();
  }

  void startTimer() {
    running = true;
    startTime = millis();
    lastGoingUp = 0;
  }

  void stopTimer() {
    running = false;
    addToLeaderBoard(time);
    time = 0;
    lastGoingUp = startTime;
    lastGoingDown = 0;
  }
  /**
   Gets the backwards time
   **/
  int getTime() {
    int current = millis()-startTime;
    //time = current;
    if (isGoingDown) {
      time = current-(2*(current - lastGoingDown));
    } else {
      time = current-(2*(lastGoingUp-lastGoingDown));
    }
    return time;
  }

  //formats the score
  String getScoreFormat(int time) {
    //int millisecs = time % 1000;
    int seconds = (int) TimeUnit.MILLISECONDS.toSeconds(time) % 60;
    int minutes = (int) TimeUnit.MILLISECONDS.toMinutes(time) % 60;
    int hours = (int) TimeUnit.MILLISECONDS.toHours(time);
    return  nf(hours, 2) + ":" + nf(minutes, 2) + ":" + nf(seconds, 2) ;
  }

  void addToLeaderBoard(int time) {
    leaderboard.add(time);
    Collections.sort(leaderboard);
    Collections.reverse(leaderboard);

    //add to file
    Date date = new Date();
    System.out.println("writing " + time);
    try {
      File file = new File(OUTPUT_FILE);
      if (!file.exists()) {
        file.createNewFile();
        System.out.println("creating file " + time);
      }
      FileWriter fw = new FileWriter(file, true);
      BufferedWriter bw = new BufferedWriter(fw);
      PrintWriter pw = new PrintWriter(bw);
      pw.println(time+ ", " + date.getTime());
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
