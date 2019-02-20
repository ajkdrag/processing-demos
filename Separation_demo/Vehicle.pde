class Vehicle {
  PVector pos, vel, acc;
  float maxVel, maxForce;
  float r;

  Vehicle(PVector pos, float maxVel, float maxForce) {
    this.pos = pos.copy();
    vel = PVector.random2D();
    vel.mult(random(1, 4));
    acc = new PVector(0, 0);
    this.maxVel = maxVel;
    this.maxForce = maxForce;
    r = 6;
  }
  void applyForce(PVector force) {
    acc.add(force);
  }

  void update() {
    vel.add(acc);
    vel.limit(maxVel);
    pos.add(vel);
    acc.mult(0);
  }

  void arrive(PVector v) {
    PVector desired = PVector.sub(v, pos);
    float d = desired.mag(); // Distance between target and position

    if (d < 100) {
      float m = map(d, 0, 100, 0, maxVel);
      desired.setMag(m);
    } else {
      desired.setMag(maxVel);
    }
    PVector steer = PVector.sub(desired, vel);
    steer.limit(maxForce);
    applyForce(steer);
  }

  //void follow(Path p) {
  //  // using s = vt formula (t = 50 here) so we set the mag of vel to 50
  //  // and update location


  //  PVector predict = vel.copy();
  //  predict.setMag(50);
  //  PVector fPos = PVector.add(predict, pos);
  //  PVector a = p.startPoint(fPos);
  //  PVector b = p.endPoint(fPos);

  //  PVector aTob = PVector.sub(b, a);

  //  aTob.normalize();
  //  PVector aTofPos = PVector.sub(fPos, a);

  //  float mag = aTofPos.dot(aTob);

  //  PVector projection = aTob.copy();
  //  projection.mult(mag);  
  //  projection.add(a);
  //  // target is ahead of the projected point by some unit (10 units here)
  //  PVector target = aTob.setMag(mag+10);
  //  target.add(a);

  //  float distance = PVector.dist(fPos, projection);
  //  if (distance > p.radius) {
  //    arrive(target);
  //  }
  //}

  void align(ArrayList<Vehicle> vehicles) {
    PVector desired = new PVector(0, 0);
    float count = 0;
    if (vehicles.size() > 1) {
      for (Vehicle v : vehicles) {
        float d = PVector.dist(pos, v.pos);
        if (d < 20) {
          desired.add(v.vel);
          count++;
        }
      }

      if (count > 0) {
        desired.div(count);
        desired.setMag(maxVel);
        PVector steer = PVector.sub(desired, vel);
        steer.limit(maxForce);
        applyForce(steer);
      }
    }
  }

  void separation(ArrayList<Vehicle> vehicles) {
    PVector desired = new PVector(0, 0);
    float count = 0;
    if (vehicles.size() > 1) {
      for (Vehicle v : vehicles) {
        if (v == this) {
          continue;
        }
        float d = PVector.dist(pos, v.pos);
        PVector sep = PVector.sub(pos, v.pos);
        if (d <= 4*r) {          
          sep.setMag(map(d, 0, 4*r, maxVel, 0));
          desired.add(sep);
          count++;
        }
      }

      if (count > 0) {
        desired.div(count);
        desired.setMag(maxVel);
        PVector steer = PVector.sub(desired, vel);
        steer.limit(maxForce);
        applyForce(steer);
      }
    }
  }

  void edges() {
    if (pos.x > width-1) {
      pos.x = 1;
    } else if (pos.x <= 0) {
      pos.x = width - 1;
    }
    if (pos.y > height -1) {
      pos.y = 1;
    } else if (pos.y <= 0) {
      pos.y = height - 1;
    }
  }

  void render() {
    fill(127);
    ellipse(pos.x, pos.y, 2*r, 2*r);
    text("FRAME : " + frameRate, 20, height-20);
    //drawVector(vel, pos.x, pos.y, 0, map(vel.mag(), 0, maxVel, 0, 10));
  }

  void drawVector(PVector v, float x, float y, float c, float len) {
    pushMatrix();
    translate(x, y);
    rotate(v.heading());
    fill(0);
    ellipse(0, 0, 4, 4);
    stroke(c);
    strokeWeight(2);
    line(0, 0, len, 0);
    popMatrix();
  }
}