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
PFont f;
int crashImageCounter = -1;

// main program
void setup() {
  size(1200, 600, P3D);
  background(0);
  frameRate(15);
  colorMode(HSB);

  f = createFont("Arial", 56, true);

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
  new Panel().display();

  new Fence().display();

  if (!gamePaused) {
    for(int i = 0; i< blocks.length; i++){
      blocks[i].display(panelNumber);
    }
  }

  bar.display();

  // update the camera
  context.update();
  if (gameEnd){
    pushStyle();
    pushMatrix();
    fill(#000000);
    textSize(100);
    translate(0, 0, 100);
    textFont(f, 78);
    text("Sorry you have lost all your lives.", 200, -400, 0);
    popMatrix();
    popStyle();
  } else if (!gamePaused) {

    checkUserMovement();

    if (checkCrash()) {
      translate(0, 0, 100);
      image(crashImage, userBlock.x-100, userBlock.y-100, 200, 200);
      // check if the player lost all their lives
      if(bar.removeLife()) {
        endGame();
      }
    }
  } else {
    pushStyle();
    pushMatrix();
    fill(#ffffff);
    textFont(f, 56);
    popMatrix();
    popStyle();
    text("To start the game stay in front \n and raise your hands. Target is to avoid the blocks:)", 20, 20);
  }

  saveLastSecond();
}

void checkUserMovement() {
  PVector jointPos = new PVector();
  PVector headPos2D = new PVector();

  int[] users = context.getUsers();
  for (int i = 0; i < users.length; i++) {
    if (context.isTrackingSkeleton(users[i])) {
      // get torso position
      context.getJointPositionSkeleton(users[i], SimpleOpenNI.SKEL_TORSO, jointPos);
      context.convertRealWorldToProjective(jointPos, headPos2D);

      // Make block move according to head movement
      userBlock.display((int) jointPos.x + 500);
      //println("Head Position: "+jointPos+" converted Head Position: "+headPos2D);
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
    if ( userBlock.x > (blocks[i].x - 50) && userBlock.x < (blocks[i].x +50)) {
      if ( userBlock.y > (blocks[i].y - 50) && userBlock.y < (blocks[i].y +50)) {
        if (lastCrashedBlock != i) {
          crashImageCounter = 0;
          lastCrashedBlock = i;
          return true;
        }
      }
    }
  }
  return false;
}

void endGame() {
  gameEnd = true;
  timer.stop();
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
  if (gamePaused && playerId == null) {
    playerId = userId;
  }
  startGame();
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
