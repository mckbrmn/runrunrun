

class UserBlock {
  //Data
  int x;
  int y;
  //CONSTRUCTOR
  UserBlock() {
  }

  UserBlock(int x, int y) {
    println("UserBlock init()");
    //loca:1 2 3 4 5 6 7 8 the number of runway

    this.x = x;
    this.y = y;
  }

  void right(){
    if(x < 1125)
    x += 150;
  }

/*
  int checkPanel(int x_loc) {
    if(0 > x_loc && x_loc < 150)
      return 75;
    if(150 > x_loc && x_loc < 300)
      return 225;
    if(300 > x_loc && x_loc < 450)
      return 375;
    return 0;
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
  */
  
  void left(){
    if(x > 75)
    x -= 150;
  }

  //METHODS
  void display(int x_loc) {
    //loca:1 2 3 4 5 6 7 8 the number of runway
    pushStyle();
    pushMatrix();

    if(x_loc > 75 && x_loc < 1125)
    x = x_loc;

    translate(x, y);
    fill(#528618);
    box(100);
    popMatrix();


    popStyle();
  }
}

