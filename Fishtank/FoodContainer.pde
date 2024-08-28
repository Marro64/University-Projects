// FoodContainer by Nina Vroom
// Contains multiple food particles, has Gaussian distribution in size
// Click to add food

class FoodContainer {
  ArrayList<Food> food; // all the food
  float standardDeviation;
  float meanSize;
  
  FoodContainer() {
    food = new ArrayList<Food>();
    standardDeviation = 5;
    meanSize = 15;
  }
  
  // update the food particles
  void update(Water water) {
    for(Food thisFood : food) {
      thisFood.update(water);
    }
  }
  
  // draw the food particles
  void render() {
    for(Food thisFood : food) {
      thisFood.render();
    }
  }
  
  // get positions of all food, used to steer fish
  ArrayList<PVector> getPositions() {
    ArrayList<PVector> positions = new ArrayList<PVector>();
    for(Food thisFood : food) {
      positions.add(thisFood.position);
    }
    
    return positions;
  }
  
  void addFood(PVector position) {
    float s = randomGaussian();
    float size = s*standardDeviation + meanSize;
    
    food.add(new Food(position, size));
  }
  
  void removeFood(Food consumedFood) {
    food.remove(consumedFood);
  }
  
  // click to add food
  void mouseHandler(PVector mousePos) {
    addFood(mousePos);
  }
}
