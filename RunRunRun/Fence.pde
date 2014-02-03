float y_Fence = -2400; //y axis location of the fence
PImage img;

class Fence {
  Fence() {
    img = loadImage("fence.png");
  }

  void display() {
    pushStyle();
    noStroke();

    //fence 1
    beginShape();
    texture(img);
    vertex(0, y_Fence-100, 0, 137, 0);
    vertex(0, y_Fence+100, 0, 0, 0);
    vertex(0, y_Fence+100, 150, 0, 100);
    vertex(0, y_Fence-100, 150, 137, 100);
    endShape();

    //fence 2
    beginShape();
    texture(img);
    vertex(1200, y_Fence-100, 0, 137, 0);
    vertex(1200, y_Fence+100, 0, 0, 0);
    vertex(1200, y_Fence+100, 150, 0, 100);
    vertex(1200, y_Fence-100, 150, 137, 100);
    endShape();

    y_Fence += 400;
    if (y_Fence>0)  y_Fence=-2000;

    popStyle();
  }
}

