class Panel {
  //Data

  //CONSTRUCTOR
  Panel() {
  }

  void display() {
    background(0);
    //panel
    translate(0, 600);
    rotateX(radians(60.0));
    rect(0, -2400, 1200, 2400);
    for (int x=0; x<1200; x+=150) {
      line(x, -2400, x, 0);
    }
  }
  
  
}

