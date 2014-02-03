// in 3D
float y_Tree = -2400; //y axis location of the tree

class Tree {
  //float length;

  Tree() {
    //length = x;
  }

  void display() {
    pushStyle();
    stroke(255);
    //tree 1
    beginShape();
    vertex(0, y_Tree-50, 150);
    vertex(0, y_Tree, 300);
    vertex(0, y_Tree+50, 150);
    endShape(CLOSE);
    line(0, y_Tree, 0, 0, y_Tree, 150);
    //tree 2
    beginShape();
    vertex(1200, y_Tree-450, 150);
    vertex(1200, y_Tree-400, 300);
    vertex(1200, y_Tree-350, 150);
    endShape(CLOSE);
    line(1200, y_Tree-400, 0, 1200, y_Tree-400, 150);
    
    y_Tree += 400;
    if(y_Tree>0)  y_Tree=-2000;
    popStyle();
  }
}

