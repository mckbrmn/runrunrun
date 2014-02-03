

class Block {
  //Data
  int y;
  int x;
  Timer timer;
  boolean init;
  int lastSecond;
  //CONSTRUCTOR
  Block() {
  }

  Block(Timer timer) {
    randomNewLine();
    this.timer = timer;
    init = true;
  }

  void randomNewY() {
    int randomY   = int(random(7));
    switch(randomY) {
    case 1:
      y = -2400;
      break;
    case 2:
      y = -2800;
      break;
    case 3:
      y = -3200;
      break;
    case 4:
      y = -3600;
      break;
    case 5:
      y = -4000;
      break;
    case 6:
      y = -4400;
      break;
    }
  }

  void randomNewLine() {
    int line = int(random(9));
    switch(line) {
    case 1:
      x = 75;
      break;
    case 2:
      x = 225;
      break;
    case 3:
      x = 375;
      break;
    case 4:
      x = 525;
      break;
    case 5:
      x = 675;
      break;
    case 6:
      x = 825;
      break;
    case 7:
      x = 975;
      break;
    case 8:
      x = 1125;
      break;
    } 
      randomNewY();
  }

  //METHODS
  void display(int loc) {
    //loca:1 2 3 4 5 6 7 8 the number of runway
    pushStyle();
    pushMatrix();
    fill(#E81515);

    translate(x, y);
    box(100);
    popMatrix();

    if (lastSecond != timer.second()) {
      y += ((timer.minute()*60)+timer.second())+10;
    }

    //if(y_Block1>0)  y_Block1=-2400;
    if (y>0) {
      randomNewLine();
      y = -2400;
    }

    popStyle();
  }
}

