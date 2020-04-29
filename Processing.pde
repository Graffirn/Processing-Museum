PShape model;

int x = 300;
int y = 300;
int z = 130;
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

void setup() {
  size(1600, 900, P3D);
  model = loadShape("museum.obj");
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
}

public void updateGeometry() {
  fill(255, 255, 255);
  pushMatrix();
  translate(0, 22, 0);
  box(100000, 2, 100000);
  popMatrix();

  fill(30, 127, 255);
  pushMatrix();
  translate(0, 25, 0);
  shape(model);
  popMatrix();
  
  //for (int x = 0; x < blocks; x++) {
  //  for (int z = 0; z < blocks; z++) {
  //    if (world[x][z] != 0) {
  //      pushMatrix();
  //      translate(size * x, world[x][z] / 2, size * z);
  //      box(size, world[x][z], size);
  //      popMatrix();
  //    }
  //  }
  //}
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
  //rightX = sin((xAngle + PI/2)) * 5;
  //rightY = -cos((xAngle + PI/2)) * 5;
  //leftX = sin((xAngle - PI/2)) * 5;
  //leftY = -cos((xAngle - PI/2)) * 5;
  //backX = sin((xAngle - PI)) * 5;
  //backY = -cos((xAngle - PI)) * 5;
  
  //xAngle = map(-mouseX, 0, width, 0, 360);
  //yAngle = map(mouseY, 0, height, 100, -100);
  //if (yAngle > 32)
  //  yAngle = 32;
  //else if (yAngle < -32)
  //  yAngle = -32;

  //centerX = sin(xAngle * 0.05f) * 10;
  //centerY = -cos(xAngle * 0.05f) * 10;
  //centerZ = tan(yAngle * 0.05f) * 10;

  //rightX = sin((xAngle + 90) * 0.05f) * 10;
  //rightY = -cos((xAngle + 90) * 0.05f) * 10;
  //leftX = sin((xAngle - 90) * 0.05f) * 10;
  //leftY = -cos((xAngle - 90) * 0.05f) * 10;
  //backX = sin((xAngle - 180) * 0.05f) * 10;
  //backY = -cos((xAngle - 180) * 0.05f) * 10;
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
      if (x % 8 == 0 || z % 8 == 0){
          walls[x][z] = 250;
          if ((x % 8 == 4 || z % 8 == 4) || (x % 8 == 5 || z % 8 == 5))
            walls[x][z] = 0;
      }
    }
  }

  for (int x = 0; x < blocks; x++) {
    for (int z = 0; z < blocks; z++) {
        world[x][z] = walls[x][z];
    }
  }
}
