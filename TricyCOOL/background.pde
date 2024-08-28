cloud cloud;

// creates the background with moving clouds, the road, sky and geen field
class Backdrop {
  cloud[] cloud = new cloud[3];
  int groundX = 0;
  int roadX = 0;

  Backdrop() {

    //Initialize the clouds
    for (int i = 0; i < cloud.length; i++) {
      cloud[i] = new cloud(random(0, 100), random(0.1, 0.6));
    }
  }
  void display() {
    //Create the main background
    background(0, 191, 255);
    background(0, 191, 255);
    fill(255, 255, 0);
    stroke(255, 255, 0);
    fill(52, 235, 94);
    stroke(52, 235, 94);
    rect(groundX, 625, 800, 200);

    //Display the cloud
    for (int i = 0; i < cloud.length; i++) {
      cloud[i].display();
      cloud[i].move();
    }
  }
}
