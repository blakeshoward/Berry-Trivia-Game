class Box {
  float x; // x coordinate of the box
  float y; // y coordinate of the box
  float w; // width of the box
  color boxColor; // Color of the box
  float speed; // speed of the box
  float finishLineY = 350;
  boolean atFinishLine = false; // Track if the box is at the finish line
  boolean timerStarted = false; // Track if the timer has started
  int finishLineTimer = 0; // Timer for how long the box has been at the finish line
  int lastUpdateTime; // Track the last time the finish line timer was updated
  boolean hasWon = false; // Track if the box has won

  // Constructor for initializing box properties
  Box(float x, float y) {
    this.x = x;
    this.y = 0;
    w = 75; // Default width
    boxColor = color(random(255), random(255), random(255)); // Generate random color
    speed = 5; // Default speed
    lastUpdateTime = millis(); // Initialize lastUpdateTime
  }

  // Render the box
  void render() {
    fill(boxColor); // Set fill color to the random color
    rectMode(CENTER);
    rect(x, y, w, w);
  }

  // Move the box downwards
  void move() {
    if (!atBottom()) {
      y += speed; // move the box downwards by adding to y-coordinate
    }
  }

  // Check if the box has reached the bottom of the screen
  boolean atBottom() {
    return y + w / 2 >= height;
  }

// Check for collisions with other boxes
void checkCollision(ArrayList<Box> boxes) {
    for (Box otherBox : boxes) {
        if (otherBox != this && intersects(otherBox)) {
            boolean thisAboveOther = this.y < otherBox.y;
            boolean thisBelowOther = this.y > otherBox.y;

            if (thisAboveOther) {
                this.speed = 0; // Stop moving if collision detected
                this.y = otherBox.y - this.w; // Move this box just above the colliding box
            } else if (thisBelowOther) {
                this.speed = 0; // Stop moving if collision detected
                this.y = otherBox.y + otherBox.w; // Move this box just below the colliding box
            }
        }
    }
}




  // Check if this box intersects with another box
  boolean intersects(Box other) {
    return (x - w / 2 < other.x + other.w / 2 &&
            x + w / 2 > other.x - other.w / 2 &&
            y - w / 2 < other.y + other.w / 2 &&
            y + w / 2 > other.y - other.w / 2);
  }

  // Check if the box has crossed the finish line
  boolean crossedFinishLine() {
    return y + w / 2 >= finishLineY;
  }

  // Update the finish line timer
  void updateFinishLineTime() {
    if (atFinishLine && timerStarted) {
      int currentTime = millis(); // Get the current time in millis
      finishLineTimer += currentTime - lastUpdateTime; // Calculate the time difference since the last update
      lastUpdateTime = currentTime; // Update the last update time
    }
  }

  // Check if the box has won
  boolean hasWon() {
    return hasWon;
  }

// Check if the box has been at the finish line for 5 seconds and set hasWon flag
void checkFinishLine() {
  if (crossedFinishLine()) {
    if (!atFinishLine) {
      atFinishLine = true; // Set the box to be at the finish line
      lastUpdateTime = millis(); // Initialize lastUpdateTime
      timerStarted = true; // Start the timer
    }
    if (timerStarted) {
      int currentTime = millis(); // Get the current time in millis
      finishLineTimer = currentTime - lastUpdateTime; // Calculate the time difference since the box entered the finish line area
      if (finishLineTimer >= 5000) { // If the box has been at the finish line for 5 seconds
        hasWon = true; 
      }
    }
  } else {
    atFinishLine = false; // Reset atFinishLine if the box is not at the finish line
    timerStarted = false; // Reset timerStarted if the box is not at the finish line
    finishLineTimer = 0; // Reset the timer
  }
}
}
