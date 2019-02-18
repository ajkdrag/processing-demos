// game entity references
Shape sp;

// variable for delta time
int prev;
float dt;

// window constants
static final int W_WIDTH = 640;
static final int W_HEIGHT = 420;

void setup() {
  sp = new Shape();
  size(640, 420);
  prev = millis();
}

void draw() {
  int curr = millis();
  frameRate(60);
  background(220);
  sp.render();
  // delta time in seconds
  dt = (curr - prev)/1000.0;  
  sp.update(dt);
  prev = curr;
}

void keyPressed() {
  if (key == 'a') {
    sp.left = 1;
  }

  if (key == 'd') {
    sp.right = 1;
  }

  if (key == 'w') {
    sp.jump = -1;
  }
}

void keyReleased() {
  if ( key == 'a')
    sp.left = 0;
  if ( key == 'd')
    sp.right = 0;
  if ( key == 'w')
    sp.jump = 0;
}