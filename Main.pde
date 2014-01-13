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

  new TrackNumber().display();

  new Tree().display();  

    for(int i = 0; i< blocks.length; i++){
    blocks[i].display(panelNumber);
  } 
  
//  new Block().display(panelNumber);

  new Bar(timer).display();
  
  userBlock.display(1);
  
  checkCrash();
  
  checkTime();
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

/*
  printMatrix();
 pushMatrix();
 //resetMatrix();
 printMatrix();
 pushStyle();
 stroke(255,0,0);
 strokeWeight(10);
 ellipse(0,0,300,300);
 popStyle();
 popMatrix();
 
 noLoop();
 */
