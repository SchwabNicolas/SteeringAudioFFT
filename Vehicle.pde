class Vehicle {
  PVector location;
  PVector velocity;
  PVector acceleration;

  PVector target;

  float r;
  float maxforce;
  float maxspeed;

  int frequency;
  color vColor;

  Vehicle(float x, float y) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    location = new PVector(x, y);
    r = 7.5;
    maxspeed = 12;
    maxforce = 0.6;
    vColor = color(frequency, 255, 144, 255);
  }

  Vehicle(int frequence) {
    this.frequency = frequence;
    r = 7.5;
    maxspeed = 12;
    maxforce = 0.6;
    vColor = color(frequence, 255, 144, 255); // #00FF90 -> #FFFF90
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    location = new PVector(frequence * r, height-r);
    target = new PVector(frequence * r, height - r - scaledSum[frequence]);
  }

  void update() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    location.add(velocity);
    acceleration.mult(0);

    updateTarget();
    seek();
    arrive();
    display();
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  void seek() {
    PVector desired = PVector.sub(target, location);
    desired.normalize();
    desired.mult(maxspeed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);
    applyForce(steer);
  }

  void display() {
    stroke(255);

    fill(vColor);
    stroke(vColor);
    strokeWeight(2);
    ellipse(location.x, location.y, r, r);
    line(location.x, location.y, target.x, target.y);
  }

  void updateTarget() {
    target = new PVector(frequency * r, height - r - scaledSum[frequency]);
  }

  public void arrive() {
    PVector desired = PVector.sub(target, location);

    float d = desired.mag();
    desired.normalize();
    if (d < 100) {
      float m = map(d, 0, 100, 0, maxspeed);
      desired.mult(m);
    } else {
      desired.mult(maxspeed);
    }
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);
    applyForce(steer);
  }
}
