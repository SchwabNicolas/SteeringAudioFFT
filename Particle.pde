class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;

  PVector target;

  float r;
  float maxforce;
  float maxspeed;
  
  boolean dead;

  color vColor;

  Particle() {
    int random = (int)random(-150, 150);

    r = (int)random(10, 30);
    maxspeed = 12;
    maxforce = 0.6;
    vColor = color(255, 255, 255, random(25, 255)); // #00FF90 -> #FFFF90
    acceleration = new PVector(-10, 0);
    velocity = new PVector(0, 0);
    location = new PVector(width+r, height/2+random);
    target = new PVector(0, height/2+random);
  }

  void update() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    location.add(velocity);
    acceleration.mult(0);

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
    noStroke();

    fill(vColor);
    ellipse(location.x, location.y, r, r);
  }

  public void arrive() {
    if (location.x <= 0) {
      dead = true;
    }
  }
}
