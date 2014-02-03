class Bar { //display the data bars
  //Data
  Timer timer;
  PImage full_heart;
  int lifeCounter = 3;
  int lifeImageX = 100;

  //Constructor
  Bar(Timer timer){
    this.timer = timer;
    full_heart = loadImage("full_heart.png");
    full_heart.resize(25, 25);
  }


  //Methods
  void display() {
    pushStyle();
    rotateX(radians(-60.0));

    textSize(16);
    text("Life:", 50, -535);
    pushStyle();

    //Generate life images, #lifeCounter Images from Position lifeImageX
    for (int i=0; i<lifeCounter; i++) {
      image(full_heart, lifeImageX, -550);
      lifeImageX += 30;
    }

    //Reset lifeImageX after incrementing
    lifeImageX = 100;

    popStyle();
    String timeText = "Time: " + nf(timer.hour(), 2) + ":" +
      nf(timer.minute(), 2) + ":" + nf(timer.second(), 2);
    text(timeText, 850, -535);
    pushStyle();
    stroke(0);
    popStyle();

    rotateX(radians(60.0));
    popStyle();
  }

  boolean removeLife() {
    if (lifeCounter >= 2) {
      lifeCounter--;
      return false;
    }
    else {
      lifeCounter--;
      return true;
    }
  }

  void addLife(){
    if (lifeCounter < 3)
      lifeCounter++;
  }

  void restartLifeCounter(){
   lifeCounter = 3;
  }
}
