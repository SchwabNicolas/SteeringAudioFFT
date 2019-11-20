class RectangleParticle {

  int pWidth = 0;
  int maxWidth;
  PVector location;
  float rotation;
  color pColor;

  boolean fadeOut;
  boolean dead;

  public RectangleParticle() {
    pColor = color(255, random(0, 255), 112, 255);
    location = new PVector(random(width), random(height));
    pWidth = 0;
    maxWidth = 50;
    rotation = random(0, 360);
  }

  public void update() {
    if(!fadeOut) pWidth += 3;

    display();

    if (pWidth >= maxWidth && !fadeOut) {
      fadeOut = true;
    }

    if (fadeOut) {
      pColor = color(red(pColor), green(pColor), blue(pColor), alpha(pColor)-5);
    }

    if (fadeOut && alpha(pColor) <= 0) {
      dead = true;
    }
  }

  public void display() {
    noFill();
    stroke(pColor);
    strokeWeight(12);
    rectMode(CENTER);
    pushMatrix();
    translate(location.x, location.y);
    rotate(cos(rotation));
    rect(0, 0, pWidth, pWidth);
    popMatrix();
  }
}
