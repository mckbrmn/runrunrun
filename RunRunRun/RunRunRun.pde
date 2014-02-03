import SimpleOpenNI.*;

// SimpleOpenNI stuff
SimpleOpenNI context;
PVector jointPos = new PVector();
PVector headPos2D = new PVector();

// To setup the maximal number of blocks
int numberOfBlocks = 6;
int speed = 5;
int lastSecond = -2;
Block[] blocks;
Timer timer = new Timer();
Integer playerId = null;
boolean gamePaused = true;

// main program
void setup() {
  size(1200, 600, P3D);
  background(0);
  frameRate(speed);
  colorMode(HSB);

  // SimpleOpenNI setup
  context = new SimpleOpenNI(this);
  context.setMirror(true);

  if(context.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!");
     exit();
     return;
  }

  // enable depthMap generation
  context.enableDepth();

  // enable skeleton generation for all joints
  context.enableUser();

  blocks = new Block[numberOfBlocks];

  for(int i = 0; i< numberOfBlocks; i++){
    println("init block "+i+1+" from "+numberOfBlocks);
    blocks[i] =  new Block();
  }
  userBlock = new UserBlock(600,-100);
  println("Speed: "+speed);
  timer.start();
}

int panelNumber = 6; //default
UserBlock userBlock;


void draw() {
  new Panel().display();

  new Tree().display();

  if (!gamePaused) {
    for(int i = 0; i< blocks.length; i++){
      blocks[i].display(panelNumber);
    }
  }

  new Bar(timer).display();

  // update the camera
  context.update();
  if (!gamePaused) {
    checkUserMovement();
    checkCrash();
    checkTime();
  } else {
    pushStyle();
    pushMatrix();
    fill(#000000);
    textSize(100);
    text("PAUSE", 400, -400);
    println(height);
    popMatrix();
    popStyle();
  }
}

void checkUserMovement() {
  PVector jointPos = new PVector();
  PVector headPos2D = new PVector();

  int[] users = context.getUsers();
  for (int i = 0; i < users.length; i++) {
    if (context.isTrackingSkeleton(users[i])) {
      // get head position
      context.getJointPositionSkeleton(users[i], SimpleOpenNI.SKEL_TORSO, jointPos);
      context.convertRealWorldToProjective(jointPos, headPos2D);

      // Make block move according to head movement
      userBlock.display((int) jointPos.x);
      //println("Head Position: "+jointPos+" converted Head Position: "+headPos2D);
    }
  }
}

void checkTime(){
  if(lastSecond != timer.second()){
    if(timer.second() % 10 == 0) {
      speed += 2;
      frameRate(speed);
      lastSecond = timer.second();
    }
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
 for(int i = 0; i<blocks.length; i++){
  if(userBlock.x == blocks[i].x)
    if(userBlock.y == blocks[i].y)
      print("CRAAAAAAAAAASH");
  }
  return true;
}


void pauseGame() {
  gamePaused = true;
}

void startGame() {
  gamePaused = false;
}

// SimpleOpenNI events

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("New user detected - userId: " + userId);
  curContext.startTrackingSkeleton(userId);
  if (gamePaused && playerId == null) {
    playerId = userId;
  }
  startGame();
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("Lost user - userId: " + userId);
  if (!gamePaused && userId == playerId) {
    playerId = null;
    pauseGame();
  }
}
