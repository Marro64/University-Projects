/* TargetManager
 * Holds and updates an array of targets
 * Removes target upon collision
 * By Marinus Bos, 2022
 */

class TargetManager {
  ArrayList<Target> targets = new ArrayList();
  
  TargetManager() {
  }
  
  void display() {
    for(Target target : targets) {
      target.display();
    }
  }
  
  // Check for collision between ball and targets, removes target upon collision. Returns amount of targets hit in current cycle
  int checkCollision(Ball ball) {
    int hit = 0;
    for(int i = 0; i < targets.size(); i++) {
      boolean collided = targets.get(i).checkCollision(ball);
      if(collided) {
        targets.remove(i);
        hit++;
      }
    }
    return(hit);
  }
  
  void addTarget(Target target) {
    targets.add(target);
  }
}
