PShape model;
PFont Font1;

boolean isVisiting = false;

int x = 300;
int y = 300;
int z = 130;
int H = 900;
int W = 1600;
float speed = 1;

float xAngle;
float yAngle;
float centerX;
float centerY;
float centerZ;
float rightX = 0;
float leftX = 0;
float rightY = 0;
float leftY = 0;

boolean[] isPressing;
boolean leftMouse, rightMouse;
boolean ctrl, shift;

boolean canMoveForward = true;
boolean canMoveLeft = true;
boolean canMoveRight = true;
boolean canMoveBackwards = true;
boolean isWalking = false;

int size = 64;
int blocks = 25;
int[][] walls;
int[][] world;
int titleSize = 30;
int paddingTop = 450 - titleSize*blocks/2, paddingLeft = paddingTop;
int wallHeight = 250;

void setup() {
  size(1600, 900, P3D);
  model = loadShape("museum.obj");
  Font1 = createFont("Arial Bold", 26);
  stroke(60, 127, 200);
  strokeWeight(1);
  strokeJoin(ROUND);
  smooth();

  frameRate(60);
  isPressing = new boolean[256];
  walls = new int[blocks][blocks];
  world = new int[blocks][blocks];

  genMap();
}

void draw() {
  if (isVisiting){
    background(0, 0, 0);
    ambientLight(150, 150, 150);
    lightFalloff(0.25, 0.001, 0.0);
    //spotLight(127, 127, 127, x - centerX, z, y - centerY, centerX, 0, centerY, PI/1, 1);
    //spotLight(190, 190, 190, x - centerX, z, y - centerY, centerX, 0, centerY, PI/6, 2);
    pointLight(
      100, 100, 100, 
      x, z, y
    );
    
    updateCam();
    updateControls();
    updateGeometry();
  
    useCam();
  } else {
    int i = (mouseX-paddingLeft)/titleSize, j =  (mouseY-paddingTop)/titleSize;
    if (i >= 0 && mouseX > paddingLeft && i < blocks && j >= 0 && j < blocks && mouseY > paddingTop){
      if (leftMouse){
        world[i][j] = 1;
      } else if (rightMouse){
        world[i][j] = 0;
      }
    }
    background(255);
    int btnX = W / 2 - titleSize + paddingLeft + 70;
    int btnY = H / 2 - titleSize * 2;
    rect(btnX, btnY ,titleSize * 4, titleSize * 2);
    fill(48, 63, 159);
    textAlign(CENTER, CENTER);
    textFont(Font1);
    text("START", btnX + titleSize*2, btnY + titleSize - 3);
    if (overRect(btnX, btnY ,titleSize * 4, titleSize * 2) && leftMouse) {
      isVisiting = true;
    }
    for(int x = 0; x < blocks; ++x){
      for(int z = 0; z < blocks; ++z){
        if (world[x][z] == 1){
          fill(48, 63, 159);
        } else if (world[x][z] == 0){
          fill(232, 234, 246);
        }
        rect(x * titleSize + paddingLeft, z * titleSize + paddingTop, titleSize, titleSize);
      }
    }
  }
}

public void updateGeometry() {
  fill(255, 255, 255);
  pushMatrix();
  translate(0, 22, 0);
  box(100000, 2, 100000);
  popMatrix();

  drawMap();
  //drawObjects();
}

public void updateCam() {
  xAngle = map(-mouseX, 0, width, 0, 2*PI);
  yAngle = map(mouseY, 0, height, PI/2, -PI/2);
  if (yAngle > PI/6)
    yAngle = PI/6;
  else if (yAngle < -PI/6)
    yAngle = -PI/6;

  centerX = sin(xAngle) * 10;
  centerY = -cos(xAngle) * 10;
  centerZ = tan(yAngle) * 10;
}


public void useCam() {
  float fov = 1f;

  float cameraZ = (height/2.0) / tan(fov/2.0);
  frustum(-10, 0, 0, 10, 10, 10000);
  perspective(fov, float(width)/float(height), cameraZ/1000, cameraZ*10000);
  camera(x, z, y, x + centerX, centerZ + z, y + centerY, 0, -1, 0);
}

public void keyPressed() {
  if (key == 'w')
    isPressing['w'] = true;
  if (key == 's')
    isPressing['s'] = true;
  if (key == 'a')
    isPressing['a'] = true;
  if (key == 'd')
    isPressing['d'] = true;
}

public void keyReleased() {
  if (key == 'w')
    isPressing['w'] = false;
  if (key == 's')
    isPressing['s'] = false;
  if (key == 'a')
    isPressing['a'] = false;
  if (key == 'd')
    isPressing['d'] = false;
}

public void mousePressed() {
  if (mouseButton == LEFT)
    leftMouse = true;
  if (mouseButton == RIGHT)
    rightMouse = true;
}

public void mouseReleased() {
  if (mouseButton == LEFT)
    leftMouse = false;
  if (mouseButton == RIGHT)
    rightMouse = false;
  
}


void mouseWheel(MouseEvent event) {
  //float e = event.getCount();
  //zoom += 10f * e;
}

public void updateControls() {
  float walkSpeed=1.0f;

  isWalking = false;

  //if (keys['a'] && canGoLeft) {
  //  x += leftX * speed * walkSpeed;
  //  y += leftY * speed * walkSpeed;
  //  walking = true;
  //}
  //if (keys['d'] && canGoRight) {
  //  x += rightX * speed * walkSpeed;
  //  y += rightY * speed * walkSpeed;
  //  walking = true;
  //}
  if (isPressing['w'] && canMoveForward) {
    x += centerX * speed * walkSpeed;
    y += centerY * speed * walkSpeed;
    isWalking = true;
  }  
  if (isPressing['s'] && canMoveBackwards) {
    x -= centerX * speed * walkSpeed;
    y -= centerY * speed * walkSpeed;
    isWalking = true;
  } 
}

void genMap(){

  for (int x = 0; x < blocks; x++) {
    for (int z = 0; z < blocks; z++) {
      if (walls[x][z] > 0){
        world[x][z] = 1;
      } else {
        world[x][z] = 0;
      }
    }
  }
}

void drawMap(){
  for (int x = 0; x < blocks; x++) {
    for (int z = 0; z < blocks; z++) {
      if (world[x][z] == 1) {
        pushMatrix();
        translate(size * x, wallHeight/2, size * z);
        box(size, wallHeight, size);
        popMatrix();
      }
    }
  }
}

void drawObjects(){
  fill(30, 127, 255);
  pushMatrix();
  translate(0, 25, 0);
  shape(model);
  popMatrix();
}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}
