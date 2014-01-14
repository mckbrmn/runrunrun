import SimpleOpenNI.*;

// SimpleOpenNI stuff
SimpleOpenNI context;
PVector jointPos = new PVector();
PVector headPos2D = new PVector();
PVector prevHeadPos2D = null;

// To setup the maximal number of blocks
int numberOfBlocks = 6;
int speed = 5;
int lastSecond = -2;
Block[] blocks;
Timer timer = new Timer();

// main program
void setup() {
  size(1200, 600, P3D);
  background(0);
  frameRate(speed);
  colorMode(HSB);

  // SimpleOpenNI setup
  context = new SimpleOpenNI(this);
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
  userBlock = new UserBlock(75,-100);
  println("Speed: "+speed);
  timer.start();
}

int panelNumber = 6; //default
UserBlock userBlock;


void draw() {
  new Panel().display();

  new Tree().display();

    for(int i = 0; i< blocks.length; i++){
    blocks[i].display(panelNumber);
  }

//  new Block().display(panelNumber);

  new Bar(timer).display();

  // update the camera
  context.update();
  checkUserMovement();

  userBlock.display(1);

  checkCrash();

  checkTime();
}

void checkUserMovement() {
  int[] users = context.getUsers();
  for (int i = 0; i < users.length; i++) {
    //if (context.isTrackingSkeleton(users[i])) {
      // get head position
      context.getJointPositionSkeleton(users[i], SimpleOpenNI.SKEL_HEAD, jointPos);
      context.convertRealWorldToProjective(jointPos, headPos2D);
      println("("+headPos2D.x+","+headPos2D.y+","+headPos2D.z+")");

      // Calculate head movement and move block accordingly
      if (prevHeadPos2D != null) {
        println(prevHeadPos2D.x-headPos2D.x);
        if (prevHeadPos2D.x-headPos2D.x >= 10) {
          userBlock.right();
        } else if (prevHeadPos2D.x-headPos2D.x <= -10) {
          userBlock.left();
        }
      } else {
        prevHeadPos2D = new PVector();
      }
      prevHeadPos2D.x = headPos2D.x;
    //}
  }
}

void checkTime(){
  if(lastSecond != timer.second()){
   // println("before -- speed: "+speed);
  if(timer.second() == 0 || timer.second() == 10 || timer.second() == 20 || timer.second() == 30 || timer.second() == 40 || timer.second() == 50){
     speed += 2;
     frameRate(speed);
     lastSecond = timer.second();
  }
    //println("after -- speed: "+speed);
  }
}

void keyPressed() {
 // println("key pressed() with key: "+key);
  //switch (key) {  case '1': break; }
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


// SimpleOpenNI events

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("New user detected - userId: " + userId);
  curContext.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("Lost user - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}
