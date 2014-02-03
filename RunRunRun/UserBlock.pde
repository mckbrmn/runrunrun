

class UserBlock {
  //Data
  int x;
  int y;
  PImage img = loadImage("spaceship.png");
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
  void display(int x_loc) {
    //loca:1 2 3 4 5 6 7 8 the number of runway
    pushStyle();
    pushMatrix();

    if (x_loc < 75) x_loc = 75;
    if (x_loc > 1125) x_loc = 1125;
    x = x_loc;

    translate(x, y);
    //rotateX(radians(60.0));
    beginShape();
    texture(img);
    vertex(50, 50, 50, 100, 97);
    vertex(-50, 50, 50, 0, 97);
    vertex(-50, -50, 50, 0, 0);
    vertex(50, -50, 50, 100, 0);
    endShape();
    noFill();
    //stroke(0, 255, 0);
    noStroke();
    box(100);

    popMatrix();

    popStyle();
  }
}

