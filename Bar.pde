class Bar { //display the data bars
  //Data
  Timer timer;

  //Constructor
  Bar(Timer timer){
    this.timer = timer;
  }


    //Methods
  void display() {
    //resetMatrix();
    pushStyle();
    rotateX(radians(-60.0));
    
    text("blood", 50, -535);
    rect(100, -550, 200, 20);
    //stroke(0, 255, 0);
    pushStyle();
    for(int x=101; x<300; x++) {
      stroke(300, 150, noise(100)+x);
      line(x, -530, x, -550);
    }
    popStyle();
    
    text("Time: "+timer.hour()+":"+timer.minute()+":"+timer.second(), 850, -535);
    pushStyle();
    stroke(0);
    //text("100.0", 902, -535);
    popStyle();

    rotateX(radians(60.0));
    popStyle();
  }
}

