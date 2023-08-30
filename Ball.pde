class Ball {
  float x;
  float y;
  float vx;
  float vy;
  Ball(final float x, final float y, final float vx, final float vy) {
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
  }
  void display() {
    fill(255);
    ellipse(x, y, diameter, diameter);
  }
  void reset() {
    this.x = width/2;
    this.y = random(0, height);
  }
  void update() {
    this.x += this.vx;
    this.y += this.vy;
  }
}
