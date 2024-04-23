// ImageManager tab
class ImageManager {
  PApplet parent;
  PImage backgroundForStartScreen;
  PImage backgroundForLevelSelect;
  PImage backgroundForLevel1;
  PImage backgroundForLevel2;
  PImage backgroundForLevel3;
  PImage backgroundForWinScreen;
  //PImage boxImage;

  // Constructor
  ImageManager(PApplet parent) {
    this.parent = parent;
    loadImages();
  }

  // Load images
  void loadImages() {
    // Load background images
    backgroundForStartScreen = parent.loadImage("StartBackground.png");
    backgroundForLevelSelect = parent.loadImage("LevelSelectBackground.png");
    backgroundForLevel1 = parent.loadImage("HistoryBackground.png");
    backgroundForLevel2 = parent.loadImage("PeopleBackground.png");
    backgroundForLevel3 = parent.loadImage("BarnwellBackground.png");
    backgroundForWinScreen = parent.loadImage("FordBackground.png");
    //boxImage = parent.loadImage("boxImage.jpg");  
}

  // Display background image based on game state
  void displayBackgroundImage(StartScreenState state) {
    parent.background(0); // Clear the background
    switch (state) {
      case START_SCREEN:
        parent.image(backgroundForStartScreen, 0, 0, parent.width, parent.height);
        break;
      case LEVEL_SELECTION:
        parent.image(backgroundForLevelSelect, 0, 0, parent.width, parent.height);
        break;
      case LOADING_LEVEL:
        // Display loading screen background (if needed)
        break;
      case PLAYING_LEVEL:
        switch (selectedLevelIndex) {
          case 0:
            parent.image(backgroundForLevel1, 0, 0, parent.width, parent.height);
            break;
          case 1:
            parent.image(backgroundForLevel2, 0, 0, parent.width, parent.height);
            break;
          case 2:
            parent.image(backgroundForLevel3, 0, 0, parent.width, parent.height);
            break;
            case 3:
            parent.image(backgroundForLevel1, 0, 0, parent.width, parent.height);
            break;
        }
        break;
      case WIN_SCREEN:
        parent.image(backgroundForWinScreen, 0, 0, parent.width, parent.height);
        break;
    }
  }
}
