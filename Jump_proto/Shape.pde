class Shape {
  // shape attributes
  PVector pos ;
  PVector vel, accel;
  static final float S_WIDTH = 30;
  static final float S_HEIGHT = 40;

  // physics constants 
  static final float fl_ASSUMED_DT = 0.016;
  static final float fl_FREE_FALL_TIME = 30*fl_ASSUMED_DT;
  static final float fl_DESIRED_JUMP_HEIGHT = (W_HEIGHT - S_HEIGHT)/2;
  static final float GRAVITY = (2*fl_DESIRED_JUMP_HEIGHT/(fl_FREE_FALL_TIME*fl_FREE_FALL_TIME));
  static final float SQUARED_VERTICAL_FORCE = 2*GRAVITY*fl_DESIRED_JUMP_HEIGHT;

  // flags for movement
  int left = 0;
  int right = 0;
  int jump = 0;
  boolean inAir = false;

  Shape() {
    // defaul position
    pos = new PVector(W_WIDTH>>1, W_HEIGHT>>1);
    vel = new PVector();
  }

  // render shape
  void render() {
    pushMatrix();
    translate(pos.x, pos.y);
    rect(0, 0, S_WIDTH, S_HEIGHT);
    popMatrix();
  }

  void update(float dt) {
    // apply gravity only when in air
    if (inAir)
      applyForce(0, GRAVITY, dt);
    else
      vel.y = 0;

    // move and jump
    applySlide(dt);
    applyJump();

    // friction
    applyForce(-2.0*vel.x, -vel.y, dt);
    // gravity

    // update positions
    pos.x = pos.x + (dt)*vel.x;
    pos.y = pos.y + (dt)*vel.y;

    // if not touching ground, shape is in air
    // replace this with better implementation to account for platforms
    if (pos.y < W_HEIGHT - 41) {
      inAir = true;
    } else {
      inAir = false;
      ;
    }
    // out of bounds check
    outOfBounds();
  }

  // check boundaries
  void outOfBounds() {
    // horizontal bounds
    if (pos.x <= 0) {
      vel.x = 0;
      pos.x = 0;
    }
    if (pos.x >= W_WIDTH - S_WIDTH - 1) {
      vel.x = 0;
      pos.x = W_WIDTH - S_WIDTH - 1;
    }

    // vertical bounds
    pos.y = constrain(pos.y, 0, W_HEIGHT - S_HEIGHT - 1);
  }

  // generic function to apply force
  void applyForce(float x, float y, float dt) {
    vel.x = vel.x + x*dt;
    vel.y = vel.y + y*dt;
  }

  // apply force to horizontal component
  void applySlide(float dt) {
    vel.x = vel.x + (right - left)*1000*dt;
  }

  // apply force(jump) to vertical component only when not already in air.
  void applyJump() {
    if (!inAir)
      vel.y = vel.y + jump*sqrt(SQUARED_VERTICAL_FORCE);
  }
}