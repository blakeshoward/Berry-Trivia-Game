// Main tab
enum StartScreenState {
  START_SCREEN,
  LEVEL_SELECTION,
  LOADING_LEVEL,
  PLAYING_LEVEL,
  WIN_SCREEN 
}

ArrayList<Box> boxList;
Button[] buttons = new Button[4];
SoundManager soundManager;
boolean buttonsVisible = true;
boolean greenButtonClicked = false; // Track if the green button has been clicked
int greenButtonIndex; // Track the index of the green button
QuestionManager questionManager;
StartScreenState startScreenState;
int selectedLevelIndex = -1; // Track the selected level index

// Declare finishLineY as a global variable
int finishLineY = 350; // Adjust the value as needed

// Variable to track the last box placed
Box lastPlacedBox = null;
int lastPlacedBoxTimer = 0;

// Image manager instance
ImageManager imageManager;

PImage boxImage;

void setup() {
  background(100);
  size(900, 900);
  rectMode(CENTER);

  // Initialize the image manager
  imageManager = new ImageManager(this);

  questionManager = new QuestionManager(this);
  startScreenState = StartScreenState.START_SCREEN;

  int buttonSize = width / 6;
  int buttonY = height / 4;
  int buttonSpacing = width / 5; // Evenly space the buttons
  
  soundManager = new SoundManager(this);

// Modify buttonColors array initialization here
for (int i = 0; i < buttons.length; i++) {
  int buttonX = buttonSpacing * (i + 1); // Position buttons evenly
  if (i == 0) {
    buttons[i] = new Button(buttonX, buttonY, buttonSize, color(0, 255, 0)); // Green button
  } else {
    buttons[i] = new Button(buttonX, buttonY, buttonSize, color(100)); // White buttons for level selection
  }
}

  // Set greenButtonIndex
  greenButtonIndex = 0;

  boxList = new ArrayList<Box>();
}

void draw() {
  // Display background image based on the game state
  imageManager.displayBackgroundImage(startScreenState);

  switch (startScreenState) {
    case START_SCREEN:
      drawStartScreen();
      break;
    case LEVEL_SELECTION:
      drawLevelSelection();
      break;
    case LOADING_LEVEL:
      loadLevel();
      break;
    case PLAYING_LEVEL:
      playLevel();
      break;
    case WIN_SCREEN:
      drawWinScreen();
      break;
  }
  
  // Handle mouse clicks in the win screen
  if (startScreenState == StartScreenState.WIN_SCREEN) {
    handleWinScreenClick();
  }

  for (Box box : boxList) {
    box.move();
    box.checkCollision(boxList);
    box.checkFinishLine(); // Check if the box has crossed the finish line
    box.updateFinishLineTime(); // Update the time spent at the finish line
    box.render();
  }
  
  // Check win condition
  checkWinCondition();
}

void playLevel() {
  // Draw the level
  questionManager.draw();
  
  boolean anyBoxWon = false; // Track if any box has won
  
  // Check if any box has won
  for (Box box : boxList) {
    box.move(); // Move the box downwards
    box.checkCollision(boxList); // Check for collisions with other boxes
    box.render(); // Render the box
    
    // Check if the box has won
    if (box.hasWon()) {
      anyBoxWon = true;
      break; // Exit the loop if any box has won
    }
  }
  
  // Draw finish line if no box has won yet
  if (!anyBoxWon) {
    drawFinishLine();
  } else {
    startScreenState = StartScreenState.WIN_SCREEN; // Set game state to win screen
  }
}

// Function to draw the finish line as a series of black and white checkers
void drawFinishLine() {
  int checkerWidth = 20; // Width of each checker
  int numCheckers = width / checkerWidth; // Calculate the number of checkers based on canvas width
  
  // Loop through each checker position
  for (int i = 0; i < numCheckers; i++) {
    // Alternate between drawing black and white rectangles
    if (i % 2 == 0) {
      fill(0); // Black color
    } else {
      fill(255); // White color
    }
    
    // Calculate the x-coordinate and draw the checker rectangle
    float checkerX = i * checkerWidth;
    rect(checkerX + checkerWidth / 2, finishLineY, checkerWidth, checkerWidth);
  }
}

void drawStartScreen() {
  // Draw start screen 
  textSize(20);
  textAlign(CENTER, CENTER);
  fill(255);
  text("Berry College Trivia", width/2, height/2 - 100);
  
  // Display a button to return to the start screen
  fill(0, 255, 0);
  rectMode(CENTER);
  rect(width/2, height/2 -50, 200, 50);
  fill(255);
  text("Press to Play", width/2, height/2 - 50);
}

void drawLevelSelection() {
  // Draw level select
  textSize(20);
  textAlign(CENTER, CENTER);
  fill(255);
  textSize(25);
  
  // Display level selection buttons
  String[] levelText = {"People", "Architecture", "History"}; // Text for each level button
  for (int i = 1; i < buttons.length; i++) {
    // Check if the current level button corresponds to the selected level index
    if (i == selectedLevelIndex) {
      buttons[i].buttonColor = color(100); // Set color to gray for the selected level button
    } else {
      buttons[i].buttonColor = color(255); // Set color to white for other level buttons
    }
    
    // Draw the button
    buttons[i].display();
    
    // Get the middle y-coordinate of the button
    float middleY = buttons[i].buttonY;
    // Draw text on top of the button
    fill(0); // Set text color to black
    text(levelText[i-1], buttons[i].buttonX, middleY);
  }
}

void drawWinScreen() {
  textSize(20);
  textAlign(CENTER, CENTER);
  fill(255);
  text("You won!", width/2, height/2 - 50);
  
  // Clear boxList
  boxList.clear();
  
  // Display a button to return to the start screen
  fill(0, 255, 0);
  rectMode(CENTER);
  rect(width/2, height/2 + 50, 200, 50);
  fill(255);
  text("Return to Start", width/2, height/2 + 50);
}

void loadLevel() {
  // Load questions for the selected level
  questionManager.loadQuestionsForLevel(selectedLevelIndex - 1); // Adjust index for level selection buttons
  startScreenState = StartScreenState.PLAYING_LEVEL;
}

void mousePressed() {
  switch (startScreenState) {
    case START_SCREEN:
      handleStartScreenClick();
      break;
    case LEVEL_SELECTION:
      handleLevelSelectionClick();
      break;
    case LOADING_LEVEL:
      // No mouse interaction during level loading
      break;
    case PLAYING_LEVEL:
      // Handle mouse interaction during gameplay
      if (buttonsVisible) {
        for (int i = 0; i < buttons.length; i++) {
          if (buttons[i].isMouseInside()) {
            buttons[i].checkClicked(); // Call checkClicked() 
            if (i == questionManager.greenButtonIndex) { // Check if the clicked button is the green button
              soundManager.rightSound.play();
              greenButtonClicked = true;
              buttonsVisible = false;
            } else { // Red button clicked
              soundManager.wrongSound.play();
              // Remove the code that removes a box when a wrong answer is clicked
            }
          }
        }
      } else {
        if (greenButtonClicked) {
          lastPlacedBox = new Box(mouseX, mouseY); // Record the last placed box
          lastPlacedBoxTimer = millis(); // Record the time when the last box was placed
          boxList.add(lastPlacedBox); // Place a box at mouse position
          greenButtonClicked = false;
        }
        buttonsVisible = true;
        questionManager.nextQuestion(); // Move to the next question when buttons are clicked
      }
      break;
    case WIN_SCREEN:
      handleWinScreenClick();
      break;
  }
}


void checkWinCondition() {
  // Check if the last placed box meets win condition
  if (lastPlacedBox != null) {
    boolean topAboveFinishLine = lastPlacedBox.y - lastPlacedBox.w / 2 < finishLineY;
    boolean bottomBelowFinishLine = lastPlacedBox.y + lastPlacedBox.w / 2 > finishLineY;
    if (topAboveFinishLine && bottomBelowFinishLine) {
      int currentTime = millis();
      if (currentTime - lastPlacedBoxTimer >= 5000) {
        startScreenState = StartScreenState.WIN_SCREEN;
      }
    } else {
      // Reset timer if conditions are not met
      lastPlacedBoxTimer = millis();
    }
  }
}

void handleStartScreenClick() {
  if (buttons[0].isMouseInside()) {
    // Handle the click on the start button
    startScreenState = StartScreenState.LEVEL_SELECTION;
  } else {
    // Check if the mouse is inside the green button's area
    if (mouseX > width/2 - 100 && mouseX < width/2 + 100 &&
        mouseY > height/2 - 100 && mouseY < height/2 + 100) {
      // Handle the click on the green button
      startScreenState = StartScreenState.LEVEL_SELECTION;
    }
  }
}


void handleLevelSelectionClick() {
  for (int i = 1; i < buttons.length; i++) {
    if (buttons[i].isMouseInside()) {
      // Handle the click on level selection buttons
     selectedLevelIndex = i;
      startScreenState = StartScreenState.LOADING_LEVEL;
      break;
    }
  }
}

void handleWinScreenClick() {
  if (mouseX > width/2 - 100 && mouseX < width/2 + 100 &&
      mouseY > height/2 + 25 && mouseY < height/2 + 75) {
    // Transition back to the start screen
    startScreenState = StartScreenState.START_SCREEN;
    
    // Reset game state
    boxList.clear(); // Clear the box list
    lastPlacedBox = null; // Reset last placed box
    lastPlacedBoxTimer = 0; // Reset last placed box timer
  }
}
