import SimpleOpenNI.*;

// SimpleOpenNI stuff
SimpleOpenNI context;
PVector jointPos = new PVector();
PVector headPos2D = new PVector();

// To setup the maximal number of blocks
int numberOfBlocks = 6;
int speed = 5;
int lastSecond = -2;
int lastCrashedBlock;
Block[] blocks;
Timer timer = new Timer();
Bar bar;
Integer playerId = null;
PImage crashImage;
boolean gamePaused = true;
boolean gameEnd = false;
int firstCrashesCounter = 0;
PFont f;
int crashImageCounter = -1;

// main program
void setup() {
  size(1200, 600, P3D);
  background(0);
  frameRate(15);
  colorMode(HSB);

  f = createFont("Arial", 32, true);

  lastCrashedBlock = -2;

  //load the crash image
  crashImage = loadImage("crash.png");

  // SimpleOpenNI setup
  context = new SimpleOpenNI(this);
  context.setMirror(true);

  if (context.isInit() == false)
  {
    println("Can't init SimpleOpenNI, maybe the camera is not connected!");
    exit();
    return;
  }

  // enable depthMap generation
  context.enableDepth();

  // enable skeleton generation for all joints
  context.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);

  blocks = new Block[numberOfBlocks];

  for (int i = 0; i< numberOfBlocks; i++) {
    println("init block "+i+1+" from "+numberOfBlocks);
    blocks[i] =  new Block(timer);
  }
  userBlock = new UserBlock(600, -100);
  println("Speed: "+speed);
  bar = new Bar(timer);
}

int panelNumber = 6; //default
UserBlock userBlock;


void draw() {
  /*
  new Panel().display();
   
   new Tree().display();
   
   if (!gamePaused) {
   for (int i = 0; i< blocks.length; i++) {
   blocks[i].display(panelNumber);
   }
   }
   
   bar.display();
   */


  // update the camera
  context.update();
  if (gameEnd) {

    pushStyle();
    pushMatrix();
    background(0);
    fill(#000000);



    // translate(0, 0, 100);
    //rotate(10);
    //textFont(f, 32);


    //  println(height);
    popMatrix();
    popStyle();   
    textSize(32);
    text("Time: "+timer.hour()+":"+timer.minute()+":"+timer.second(), 850, -535);
    text("GAME OVER\nHIGHSCORE: " +timer.hour()+":"+timer.minute()+":"+timer.second()+"\n \n to restart the Game, \nstretch your hands.", 300, 200);  

    checkUserRestartPosition();
  }
  else if (!gamePaused) {


    new Panel().display();

    new Tree().display();


    for (int i = 0; i< blocks.length; i++) {
      blocks[i].display(panelNumber);
    }


    bar.display();

    checkUserMovement();

    if (checkCrash()) {
      //check if the player lost all his life's
      if (bar.removeLife()) {
        endGame();
      }
    }

    // Creates the crash image, if the block is not an life block or the player crashed 2 times a normal block
    if (crashImageCounter >= 0 && crashImageCounter < 10 && firstCrashesCounter < 2) {
      translate(0, 0, 100);
      image(crashImage, userBlock.x-100, userBlock.y-100, 200, 200);
      crashImageCounter++;
    }
  }
  else {

    pushStyle();
    pushMatrix();
    fill(#ffffff);



    //    textSize(100);
    //    translate(0, 0, 100);
    //rotate(10);
    //textFont(f, 32);
    //  println(height);
    popMatrix();
    popStyle();
    textSize(32);
     
    text("To start the game stay in front \n and raise your hands.\n Target is to avoid the blocks :)", 300, 400);
   
    text("RUN RUN RUN!", 400, 150, 50);  
}

  saveLastSecond();
}

void checkUserMovement() {
  PVector jointPos = new PVector();
  PVector headPos2D = new PVector();

  int[] users = context.getUsers();
  //  for (int i = 0; i < users.length; i++) {
  int i = 0;


  if (context.isTrackingSkeleton(playerId) && playerId != null) {
    // get head position
    context.getJointPositionSkeleton(playerId, SimpleOpenNI.SKEL_HEAD, jointPos);
    context.convertRealWorldToProjective(jointPos, headPos2D);

    // Make block move according to head movement
    userBlock.display((int) jointPos.x + 500);
    //      println("Head Position: "+jointPos+" converted Head Position: "+headPos2D);
  }
  //  }
}

void checkUserRestartPosition() {
  if (gameEnd && playerId != null) {

    PVector handLeftPos = new PVector();
    PVector handRightPos = new PVector();
    float distanceHands = 0;

    int[] users = context.getUsers();
    int i = 0;


    if (context.isTrackingSkeleton(playerId)) {
      // get left and right hand position
      context.getJointPositionSkeleton(playerId, SimpleOpenNI.SKEL_LEFT_HAND, handLeftPos);
      context.getJointPositionSkeleton(playerId, SimpleOpenNI.SKEL_RIGHT_HAND, handRightPos);

      distanceHands = handRightPos.x - handLeftPos.x;

      if (distanceHands > 1200) {
        endGame();
      }
    }
  }
}

void saveLastSecond() {
  if (lastSecond != timer.second()) {
    lastSecond = timer.second();
  }
}


void keyPressed() {
  switch(key) {
  case 'd':
    userBlock.right();
    break;
  case 'a':
    userBlock.left();
    break;
  }
}

boolean checkCrash() {
  if (lastSecond != timer.second()) {
    lastCrashedBlock = -3;
  }

  for (int i = 0; i<blocks.length; i++) {
    if ( userBlock.x > (blocks[i].x - 75) && userBlock.x < (blocks[i].x +75)) {
      if ( userBlock.y > (blocks[i].y - 75) && userBlock.y < (blocks[i].y +75)) {
        if (lastCrashedBlock != i) {

          lastCrashedBlock = i;
          blocks[i].randomNewY();
          if (blocks[i].lifeBlock) {
            bar.addLife();
            blocks[i].lifeBlock = false;
            return false;
          }
          else {
            crashImageCounter = 0;
            return true;
           
          }
        }
      }
    }
  } 
  return false;
}

void endGame() {
  if (gameEnd == false) {
    gameEnd = true;
    timer.stop();
  }
  else {
    gameEnd = false;
    bar.restartLifeCounter();
    timer.start();
  }
}

void pauseGame() {
  gamePaused = true;
  timer.stop();
}

void startGame() {
  gamePaused = false;
  timer.start();
}

// SimpleOpenNI events

void onNewUser( int userId)
{
  println("New user detected - userId: " + userId);
  context.startTrackingSkeleton(userId);

  if (gamePaused && playerId == null) {
    playerId = userId;
    startGame();
  }

}


void onLostUser(int userId)
{
  println("Lost user - userId: " + userId);
  if (!gamePaused && userId == playerId) {
    playerId = null;
    gameEnd = false;
    pauseGame();
  }
}
/*
// when calibration begins
 void onStartCalibration(int userId)
 {
 println("start cali");
 }
 
 // when calibaration ends - successfully or unsucessfully 
 void onEndCalibration(int userId, boolean successfull)
 {
 println("end cali with userID: "+userId);
 
 if (gamePaused && playerId != null) {
 playerId = userId;
 }
 startGame();
 }
 */
