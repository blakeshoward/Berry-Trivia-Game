import processing.sound.*;

class SoundManager {
  SoundFile backgroundSound;
  SoundFile wrongSound;
  SoundFile rightSound;

  SoundManager(PApplet sketch) {
    backgroundSound = new SoundFile(sketch, "01-MedleyTheRedHairBoyandMarie'sWedding.mp3");
    backgroundSound.loop();

    wrongSound = new SoundFile(sketch, "WRONG.wav");
    rightSound = new SoundFile(sketch, "RIGHT.wav");
  }
}
