PShape model;

float acixf = PI/2;
float aciyf = PI/2;

float zoom = 550;

float fx;
float fy;

void setup() {
  size(1600, 900, P3D);
  model = loadShape("museum.obj");
}

void draw() {
  background(0);
  ambientLight(150, 150, 150);

  lightFalloff(0.25, 0.001, 0.0);
  //box(8000, 8000, 8000);
  pointLight(200, 200, 200, 
    zoom * cos(acixf) * sin(aciyf), 
    zoom * cos(aciyf), 
    zoom * sin(acixf) * sin(aciyf));

  camera(zoom * cos(acixf) * sin(aciyf), 
    zoom * cos(aciyf), 
    zoom * sin(acixf) * sin(aciyf), 
    0, 0, 0, 
    0, 1, 0);

  fill(75);
  box(900, 2, 900);

  //fill(#FF3B3B);
  //box(2000, 3, 3);
  //box(3, 2000, 3);
  //box(3, 3, 2000);

  shape(model);

  translate(500, 0, 300);
  rotateX(PI);


  if (mousePressed == true) {
    float
    dx = mouseX - fx;
    float dy = mouseY - fy;

    acixf += (dx / width);
    aciyf += (dy / height);
  }

  fx = mouseX;
  fy = mouseY;
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  zoom += 10f * e;
}
