class Button {
  int buttonSize;
  int buttonX;
  int buttonY;
  color buttonColor;
  
  Button(int x, int y, int size, color col) {
    buttonX = x;
    buttonY = y;
    buttonSize = size;
    buttonColor = col;
  }
  
 void display() {
  fill(buttonColor);
  rectMode(CENTER);
  float borderRadius = 10; // Adjust the radius as needed
  rect(buttonX, buttonY, buttonSize, buttonSize, borderRadius); // Rounded edges
}
  
  boolean isMouseInside() {
    return mouseX > buttonX - buttonSize/2 && mouseX < buttonX + buttonSize/2 &&
           mouseY > buttonY - buttonSize/2 && mouseY < buttonY + buttonSize/2;
  }

void checkClicked() {
  if (isMouseInside()) {
    if (buttonColor == color(0, 255, 0)) { // Check if the button color is green
      println("The green button was clicked");
      return; // Exit the method if the green button is clicked
    } else {
      println("A red button was clicked");
    }
  }
}
  
  color getColor() {
    return buttonColor; // Returns the button's color
  }
}
