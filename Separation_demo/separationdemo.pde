Vehicle v;
ArrayList<Vehicle> vehicles;
PVector[] points = new PVector[5];

void setup() {
  size(640, 360);
  vehicles = new ArrayList<Vehicle>();
  for (int i = 0; i < 20; i++) {
    vehicles.add(new Vehicle(new PVector(random(width), random(height)), 1, 1));
  }
}

void draw() {
  background(255);
  for (Vehicle v : vehicles) {
    v.arrive(new PVector(mouseX, mouseY));
    v.align(vehicles);
    v.separation(vehicles);
    v.update();
    v.edges();
    v.render();
  }
}

void mouseDragged() {
  vehicles.add(new Vehicle(new PVector(mouseX, mouseY), 1, 1));
}