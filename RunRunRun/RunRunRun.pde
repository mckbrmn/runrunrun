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
boolean adviseMode = false;
boolean adviseTimerActive = false;
int firstCrashesCounter = 0;
PFont f;
int crashImageCounter = -1;
Timer adviseTimer;

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

  if(!context.isInit())
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!");
     exit();
     return;
  }

  // enable depthMap generation
  context.enableDepth();

  // enable skeleton generation for all joints
  context.enableUser();
  //context.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);

  blocks = new Block[numberOfBlocks];

  for(int i = 0; i< numberOfBlocks; i++){
    println("init block "+i+1+" from "+numberOfBlocks);
    blocks[i] =  new Block(timer);
  }
  userBlock = new UserBlock(600,-100);
  println("Speed: "+speed);
  bar = new Bar(timer);
}

int panelNumber = 6; //default
UserBlock userBlock;


void draw() {
  // update the camera
  context.update();
  if (gameEnd) {
    pushStyle();
    pushMatrix();
    background(0);
    fill(#000000);
    popMatrix();
    popStyle();

    textSize(32);
    String timeTxt = nf(timer.hour(), 2) + ":" + nf(timer.minute(), 2) + ":" + nf(timer.second(), 2);
    text("Time: "+timeTxt, 850, -535);
    text("GAME OVER\nHIGHSCORE: " +timeTxt+"\n \n To restart the Game, \nstretch out your hands.", 300, 200);
    checkUserRestartPosition();
  } else if (adviseMode){
    if (adviseTimerActive) {
      adviseTimer = new Timer();
      adviseTimer.start();
    }
    adviseTimerActive = false;

    pushStyle();
    fill(#ffffff);
    translate(0,0,100);

    rect(400,100, 400,300);
    fill(0);
    textSize(20);
    text("Do not crash into the\nblue blocks \ntry to avoid them! :)\n Game resumes in: "+(5-adviseTimer.second()),450,150);
    popStyle();

    if (adviseTimer.second() == 5) adviseMode = false;
  } else if (!gamePaused) {
    checkUserMovement();

    new Panel().display();

    new Fence().display();


    for (int i = 0; i< blocks.length; i++) {
      blocks[i].display(panelNumber);
    }


    bar.display();

    checkUserMovement();

    if (checkCrash()) {
      if(firstCrashesCounter < 2){
        adviseMode = true;
        adviseTimerActive = true;
        firstCrashesCounter++;
      }else{
        //check if the player lost all his life's
        if (bar.removeLife()) {
          endGame();
        }
      }
    }

    // Creates the crash image, if the block is not an life block or the player crashed 2 times a normal block
    if (crashImageCounter >= 0 && crashImageCounter < 10) {
      translate(0, 0, 100);
      image(crashImage, userBlock.x-100, userBlock.y-100, 200, 200);
      crashImageCounter++;
    }
  } else {

    pushStyle();
    pushMatrix();
    fill(#ffffff);
    background(0, 127);
    popMatrix();
    popStyle();
    textSize(32);

    text("To start the game stand in front of the screen\n and raise your hands.\nYour objective is to avoid the blocks :)", 300, 400);

    text("RUN RUN RUN!", 400, 150, 50);
  }
  saveLastSecond();
}

void checkUserMovement() {
  PVector jointPos = new PVector();
  PVector headPos2D = new PVector();

  if (playerId != null && context.isTrackingSkeleton(playerId)) {
    // get torso position
    context.getJointPositionSkeleton(playerId, SimpleOpenNI.SKEL_TORSO, jointPos);
    context.convertRealWorldToProjective(jointPos, headPos2D);

    // Make block move according to head movement
    userBlock.display((int) jointPos.x + 500);
    //println("Head Position: "+jointPos+" converted Head Position: "+headPos2D);
  }
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
  } else {
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
void onNewUser(int userId) {
  onNewUser(context, userId);
}

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("New user detected - userId: " + userId);
  curContext.startTrackingSkeleton(userId);
  if (gamePaused || playerId == null) {
    playerId = userId;
    startGame();
  }
}

void onLostUser(int userId) {
  onLostUser(context, userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("Lost user - userId: " + userId);
  if (!gamePaused && userId == playerId) {
    playerId = null;
    pauseGame();
  }

}
