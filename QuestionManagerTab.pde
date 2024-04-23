import java.util.ArrayList;

// Define a Question class to hold each question and its answers
class Question {
  String questionText;
  String[] answerChoices;
  int correctAnswerIndex;

  Question(String text, String[] choices, int correctIndex) {
    questionText = text;
    answerChoices = choices;
    correctAnswerIndex = correctIndex;
  }
}

// Define an enum for FSM states
enum State {
  DISPLAY_QUESTION,
  CHECK_ANSWER,
  NEXT_QUESTION
}

// Define the QuestionManager class
class QuestionManager {
  projectDraftBH main; // Reference to the main class
  projectDraftBH.State currentState;
  ArrayList<ArrayList<Question>> questionBanks; // ArrayList to hold question banks for each level
  int currentLevelIndex; // Track the current level index
  int currentQuestionIndex;
  SoundManager soundManager;
  boolean buttonsVisible;
  Button[] buttons;
  int greenButtonIndex;

  // Constructor to initialize the QuestionManager with a reference to the main class
  QuestionManager(projectDraftBH main) {
    this.main = main; // Store the reference to the main class
    currentState = State.DISPLAY_QUESTION;
    currentLevelIndex = 0; // Initialize current level index
    currentQuestionIndex = 0;
    soundManager = new SoundManager(main);
    buttonsVisible = true;
    initQuestionBanks(); // Initialize question banks
    greenButtonIndex = 0; // Initialize greenButtonIndex
  }

  // Initialize question banks for different levels
  void initQuestionBanks() {
    questionBanks = new ArrayList<ArrayList<Question>>();
    // Add question banks for each level
    for (int i = 0; i < 3; i++) { 
      questionBanks.add(new ArrayList<Question>());
    }
    populateQuestionBanks(); // Populate question banks with questions
  }

  // Method to load questions for a specific level
 void loadQuestionsForLevel(int levelIndex) {
    // Check if the level index is valid
    if (levelIndex >= 0 && levelIndex < questionBanks.size()) {
      // Set the current question bank based on the level index
      ArrayList<Question> questionBank = questionBanks.get(levelIndex);
      // Check if questions exist for the specified level
      if (!questionBank.isEmpty()) {
        // Shuffle the questions for the current level
        shuffleQuestionsForLevel(questionBank);
        currentState = State.DISPLAY_QUESTION; // Transition to DISPLAY_QUESTION state
        currentQuestionIndex = 0; // Reset currentQuestionIndex
        currentLevelIndex = levelIndex; // Update current level index
      } else {
        println("No questions found for level " + levelIndex);
      }
    } else {
      println("Invalid level index");
    }
  }

  void draw() {
  // Draw the boxes first
  for (Box box : main.boxList) {
    box.move();
    box.checkCollision(main.boxList);
    box.checkFinishLine(); // Check if the box has crossed the finish line
    box.updateFinishLineTime(); // Update the time spent at the finish line
    box.render();
  }

  // Draw the buttons and answer text over the boxes
  switch (currentState) {
    case DISPLAY_QUESTION:
      displayQuestion();
      break;
    case CHECK_ANSWER:
      checkAnswer();
      break;
    case NEXT_QUESTION:
      nextQuestion();
      break;
  }
}


void displayQuestion() {
  // Draw background image based on the current level index
  switch (currentLevelIndex) {
    case 0:
      //background(level0Image);
      break;
    case 1:
      //background(level1Image);
      break;
    case 2:
      //background(level2Image);
      break;
    default:
      // Handle additional levels if needed
      break;
  }
  
  fill(255);
  textSize(20);
  textAlign(CENTER, TOP);
  float questionY = main.height / 7; // Adjusted position for the question
  // Indent and break lines for better readability
  String questionText = questionBanks.get(currentLevelIndex).get(currentQuestionIndex).questionText;
  text(questionText, main.width / 2, questionY);

  int numChoices = Math.min(questionBanks.get(currentLevelIndex).get(currentQuestionIndex).answerChoices.length, main.buttons.length);

  for (int i = 0; i < numChoices; i++) {
    // Draw the button
    main.buttons[i].display();
    
    // Draw the answer text over the button with indentation after every space
    fill(0);
    textAlign(CENTER, CENTER);
    String[] words = questionBanks.get(currentLevelIndex).get(currentQuestionIndex).answerChoices[i].split("\\s+");
    String indentedText = "";
    for (String word : words) {
      indentedText += "   " + word + "\n";
    }
    text(indentedText.trim(), main.buttons[i].buttonX, main.buttons[i].buttonY);
  }

  // Reset button colors to default
  for (Button button : main.buttons) {
    button.buttonColor = color(255);
  }

  // Set greenButtonIndex based on the correct answer index for the current question
  greenButtonIndex = questionBanks.get(currentLevelIndex).get(currentQuestionIndex).correctAnswerIndex;

  // Change the color of the button associated with the correct answer to green
  main.buttons[greenButtonIndex].buttonColor = color(255, 255, 255);
}


 void checkAnswer() {
  if (main.buttons[greenButtonIndex].isMouseInside()) {
    // Correct answer clicked
    soundManager.rightSound.play();
    // Automatically place a box
    main.boxList.add(new Box(random(main.width), random(main.height))); 
  } else {
    // Incorrect answer clicked
    soundManager.wrongSound.play();
    // Automatically remove a box if there's at least one box in the list
    if (!main.boxList.isEmpty()) {
      main.boxList.remove(main.boxList.size() - 1);
    }
  }
  // Transition to NEXT_QUESTION state
  currentState = State.NEXT_QUESTION;
}

  void nextQuestion() {
    currentQuestionIndex++;
    if (currentQuestionIndex < questionBanks.get(currentLevelIndex).size()) {
      currentState = State.DISPLAY_QUESTION;
      buttonsVisible = true;
  }
}
  void populateQuestionBanks() {
    // Populate question banks for each level with questions
    for (int i = 0; i < questionBanks.size(); i++) {
      ArrayList<Question> currentQuestionBank = questionBanks.get(i);
      switch (i) {
        case 0:
          // Level 1 questions, people
          currentQuestionBank.add(new Question("What was Martha Berry's Childhood Nickname?",
              new String[]{"Martha-Lee", "Mattie", "Martha", "Marthie"}, 1)); // Correct answer: Mattie
          currentQuestionBank.add(new Question("Who was the head of the Industrial Arts during Martha Berry's lifetime?",
              new String[]{"Henry Ford", "M Gordon Keown", "OC Skinner", "EH Hoge"}, 2)); // Correct answer: OC Skinner
          currentQuestionBank.add(new Question("Who was Martha Berry's personal secretary?",
              new String[]{"EH Hoge", "M Gordon Keown", "OC Skinner", "Inez W. Henry"}, 3)); // Correct answer: OC Skinner
          currentQuestionBank.add(new Question("What was Martha Berry's official title?",
              new String[]{"Chaplain of Berry College", "Director of the Berry Schools", "President of Berry College", "Principal of the Berry Schools"}, 1)); // Correct answer: OC Skinner
          currentQuestionBank.add(new Question("Who was the head servant for the Berry family, and Martha Berry's lifelong confidant?",
              new String[]{"Martha Freeman", "Virginia Campbell Courts", "Gloria Shatto", "Geddins Cannon"}, 0)); // Correct answer: 1926
          currentQuestionBank.add(new Question("Who drove Martha Berry on many of her trips to Atlanta?",
              new String[]{"Geddins Cannon", "Gordon Keown", "OC Skinner", "Grady Hamrick"}, 0)); // Correct answer: 1926
          currentQuestionBank.add(new Question("Who organised the Berry Pilgrim Society -an ealy fundraising group for the Berry Schools?",
              new String[]{"Leila Laughlin Carlisle", "Martha Berry", "Emily Vanderbilt Hammond", "Kate Macy Ladd"}, 2)); 
          currentQuestionBank.add(new Question("Who has not served as President of Berry College?",
              new String[]{"William McChesney Martin Jr.", "Stephen Briggs", "Gloria Shatto", "John R. Bertrand"}, 0)); 
          currentQuestionBank.add(new Question("Which of these buildings was not named for one of their primary donor, but instead a former professor?",
              new String[]{"Krannert Center", "Hermann Hall", "Laughlin Building", "McAllister Hall"}, 3)); 
          currentQuestionBank.add(new Question("Who was the longtime manager of the Berry School's Store?",
              new String[]{"George Lister Carlisle", "Hubert Jones", "Fair C. Moon", "Grover Hermann"}, 2)); 
          currentQuestionBank.add(new Question("Green Hall is named after Berry College's first president -who served from 1926-1944?",
              new String[]{"Gerald Green", "G. Leland Green", "Elizabeth Green", "John Green"}, 1)); 
          currentQuestionBank.add(new Question("Who was Martha Berry's brother-in-law who served as the first trustee for the Berry Schools?",
              new String[]{"Leland Green", "Moses Wright", "Willliam McChesney Martin Jr.", "EH Hoge"}, 1)); 
          currentQuestionBank.add(new Question("Who was the first teacher at the Boys Industrial School?",
              new String[]{"Martha Berry", "Frances Bonnyman", "Ida McCollough", "Elizabeth Brewster"}, 3)); 
          currentQuestionBank.add(new Question("Who was the first manager of the dining hall for the Foundation School?",
              new String[]{"Gordon Keown", "Grady Hamrick", "Hubert Jones", "Clifford Hill"}, 3)); 
          currentQuestionBank.add(new Question("Who was the first superintendent at the Foundation School?",
              new String[]{"M. Gordon Keown", "Grady Hamrick", "Fred Loveday", "Clifford Hill"}, 1)); 
          currentQuestionBank.add(new Question("The Equine Center is named after which former student -who had suffered from polio?",
              new String[]{"Eugene Gunby", "Thomas Freeman", "Grady Hamrick", "Clayton Henson"}, 0)); 
          currentQuestionBank.add(new Question("Which family has a cemetary behind Possum Trot?",
              new String[]{"Ruspoli Family", "Berry Family", "Shelton Family", "Freeman Family"}, 2)); 
          currentQuestionBank.add(new Question("Who was the first graduate of the Berry Schools?",
              new String[]{"Thomas Berry", "Eugene Gunby", "Clayton Henson", "Elizabeth Brewster"}, 2)); 
          
          break;
        case 1:
          // Level 2 questions, architecture
          currentQuestionBank.add(new Question("Which dorm hall is named after Henry Ford's wife?",
              new String[]{"Mary Hall", "Clara Hall", "Lemley Hall", "Morgan Hall"}, 1)); 
          currentQuestionBank.add(new Question("Which dorm hall is named after Henry Ford's mother?",
              new String[]{"Pilgrim Hall", "Morton Hall", "Mary Hall", "Clara Hall"}, 2)); 
          currentQuestionBank.add(new Question("Who is the Memorial Library in memorial to?",
              new String[]{"Inez Wooten Henry", "Martha Berry", "Kate Macy Ladd", "Elizabeth Carpenter Macy"}, 3)); 
          currentQuestionBank.add(new Question("Which dormitory was opened in 2002 to celebrate the 100th anniversary of the Berry Schools?",
              new String[]{"Centennial Hall", "Morgan Hall", "Mary Hall", "Deerfield Hall"}, 0)); 
          currentQuestionBank.add(new Question("What was the name of the first dorm hall built for the Boys Industrial School?",
              new String[]{"The Whitewashed Schoolhouse", "Rhea Hall", "Frances Cottage", "Brewster Hall"}, 3)); // Correct answer: 1926
          currentQuestionBank.add(new Question("When was the Martha Berry Museum opened?",
              new String[]{"1931", "1950", "1972", "1995"}, 2)); 
          currentQuestionBank.add(new Question("When did Thomas Berry purchase the estate Oak Hill?",
              new String[]{"1866", "1880", "1884", "1871"}, 3)); 
          currentQuestionBank.add(new Question("What year did Martha Berry begin extensive renovations on her home Oak Hill?",
              new String[]{"1926", "1927", "1930", "1915"}, 1)); 
          currentQuestionBank.add(new Question("Who was the landscape architect hired for the 1927 renovation of the Oak Hill gardens?",
              new String[]{"William Baird", "Thomas Emery", "Robert Cridland", "Ashton Vanderslice"}, 2)); 
          currentQuestionBank.add(new Question("When was the President's House -originally built for Martha Berry's sister Bessie Wright- built?",
              new String[]{"1910", "1940", "1929", "1951"}, 1)); 
          currentQuestionBank.add(new Question("Which building -built in 1962- was meant to replace Hoge as the Administration building?",
              new String[]{"Hermann Hall", "Krannert Center", "Blackstone Hall", "Evans Hall"}, 0)); 
          currentQuestionBank.add(new Question("Moved there in 1997, the Admissions Wing of the Ford Buildings originally housed what?",
              new String[]{"The Agricultural Department", "Financial Aid", "The English Department", "The Handicrafts Department"}, 3)); 
          currentQuestionBank.add(new Question("What was the original name of Evans Hall?",
              new String[]{"The Mothers Memorial Building", "Inman Hall", "Cooper Hall", "The Jones Building"}, 0)); 
          currentQuestionBank.add(new Question("When did the Moon Building -originally the student store- become used for the Art Department?",
              new String[]{"1999", "1934", "1962", "1971"}, 3)); 
          currentQuestionBank.add(new Question("Who designed most of the early buildings for the Berry Schools?",
              new String[]{"Capt. John Gibbs Barnwell", "Clifton Russell", "Cooper and Cooper", "Carlson and Coolidge"}, 0)); 
          currentQuestionBank.add(new Question("What is the oldest, still in-use brick dorm hall on campus?",
              new String[]{"Lemley Hall", "Morton Hall", "Dana Hall", "Pilgrim Hall"}, 0)); 
          currentQuestionBank.add(new Question("What is the oldest, still in-use building on campus?",
              new String[]{"The Hoge Building", "Poland Hall", "Roosevelt Cabin", "The Ford Buildings"}, 0)); 
          currentQuestionBank.add(new Question("Which of these buildings was not built around the mid-1800's?",
              new String[]{"Possum Trot", "The Original Cabin", "Cabin in the Pines", "Roosevelt Cabin"}, 3)); 
          currentQuestionBank.add(new Question("Which dorm hall -built in 1910- has the origin of its name in a bottled water company?",
              new String[]{"Mary Hall", "Dana Hall", "Poland Hall", "Pilgrim Hall"}, 2)); 
          currentQuestionBank.add(new Question("Which building was the first brick-built building on Berry's campus?",
              new String[]{"Dana Hall", "Blackstone Hall", "Laughlin", "Lemley Hall"}, 1)); 
          
          
          break;
          
        case 2:
          // Level 3 questions, history
          currentQuestionBank.add(new Question("What year was Berry College founded?",
              new String[]{"1926", "1902", "1930", "1909"}, 0)); // Correct answer: 1926
          currentQuestionBank.add(new Question("When was the Martha Berry School for Girls opened?",
              new String[]{"1905", "1912", "1902", "1909"}, 3)); // Example question
          currentQuestionBank.add(new Question("When did former president Theodore Roosevelt visit the Berry Schools?",
              new String[]{"1905", "1920", "1910", "1909"}, 2)); // Example question
          currentQuestionBank.add(new Question("When did Berry College graduate its first class?",
              new String[]{"1932", "1902", "1926", "1930"}, 0)); // Example question
          currentQuestionBank.add(new Question("When was construction on the Ford Buildings finished?",
              new String[]{"1942", "1931", "1921", "1925"}, 1)); // Example question
          currentQuestionBank.add(new Question("How many acres did the Berry Schools own at its height?",
              new String[]{"30,000", "33,000", "80,000", "27,000"}, 1)); // Correct answer: 1926
          currentQuestionBank.add(new Question("How many acres is Berry College today?",
              new String[]{"15,000", "19,000", "31,000", "27,000"}, 3)); // Correct answer: 1926
          currentQuestionBank.add(new Question("When did Martha Berry open the Boys Industrial School?",
              new String[]{"1926", "1902", "1930", "1909"}, 1)); // Correct answer: 1926
          currentQuestionBank.add(new Question("Victory Lake was built in 1929 to commemorate the lives of 11 Berry students who died in which war?",
              new String[]{"World War II", "Spanish-American War", "World War I", "Korean War"}, 2)); 
          currentQuestionBank.add(new Question("What year did Martha Berry die?",
              new String[]{"1912", "1942", "1940", "1931"}, 1)); 
          currentQuestionBank.add(new Question("What year was Martha Berry born?",
              new String[]{"1857", "1866", "1865", "1870"}, 2)); 
          currentQuestionBank.add(new Question("What year did Martha Freeman pass away, around the age of 105?",
              new String[]{"", "1931", "1942", "1951"}, 3)); 
          currentQuestionBank.add(new Question("What year was the O'Brien Gap Road -which bisected campus- closed?",
              new String[]{"1934", "1949", "1955", "1934"}, 2)); 
          currentQuestionBank.add(new Question("When did Martha Berry open up the Mountain Farm School on the Mountain Campus?",
              new String[]{"1905", "1922", "1902", "1916"}, 3)); 
          currentQuestionBank.add(new Question("When was the Mountain Farm School reorganised into the Foundation School?",
              new String[]{"1926", "1923", "1922", "1909"}, 2)); 
          currentQuestionBank.add(new Question("What year saw the decrease of most of the Berry Schools' farming efforts?",
              new String[]{"1989", "2000", "1956", "1944"}, 3)); 
          currentQuestionBank.add(new Question("When was the Berry Academy -Berry's boarding high school on the mountain campus- closed down?",
              new String[]{"1977", "1979", "1983", "1984"}, 2)); 
          currentQuestionBank.add(new Question("When did the Winshape scholarship program have its first class of students?",
              new String[]{"1973", "1984", "1983", "1990"}, 1)); 
          currentQuestionBank.add(new Question("Which of these infrastructural changes did Henry Ford not provide the funding for?",
              new String[]{"The Reservoir", "Electricity", "A Brick Plant", "The Old Mill"}, 1)); 
          currentQuestionBank.add(new Question("When was Berry College accredited by the accredited by SACSS?",
              new String[]{"1956", "1926", "1933", "1945"}, 0)); 
          currentQuestionBank.add(new Question("Which Berry College President served from 1956 to 1979?",
              new String[]{"Moses Wright", "G. Leland Green", "Martha Berry", "John R. Bertrand"}, 3)); 
          currentQuestionBank.add(new Question("Who succeeded John Bertrand as the Sixth President of Berry College from 1979 to 1998?",
              new String[]{"Hubert Jones", "John R. Bertrand", "Gloria Shatto", "Scott Colley"}, 2)); 
          break;
        default:
          println("Invalid level");
          break;
      }
    }
  }
    // Shuffle questions for a specific level
  void shuffleQuestionsForLevel(ArrayList<Question> questions) {
    int n = questions.size();
    for (int i = 0; i < n; i++) {
      // Generate a random index between 0 and n - 1
      int randomIndex = i + (int)(Math.random() * (n - i));
      
      // Swap the elements at positions i and randomIndex
      Question temp = questions.get(i);
      questions.set(i, questions.get(randomIndex));
      questions.set(randomIndex, temp);
    }
  }

}
