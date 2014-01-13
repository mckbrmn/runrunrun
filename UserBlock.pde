

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


  void left(){
    if(x > 75)
    x -= 150; 
  }
  
  //METHODS
  void display(int loc) {
    //loca:1 2 3 4 5 6 7 8 the number of runway
    pushStyle();

    pushMatrix();
    translate(x, y);
    fill(#528618);
    box(100);
    popMatrix();
    
    
    popStyle();
  }
}

