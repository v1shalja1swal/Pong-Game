class Paddle {
  float x;
  float y;
  float vx = 0;
  float vy = 15;
  Paddle(float x, float y) {
    this.x = x;
    this.y = y;
  }
  void display() {
    rect(this.x, this.y, paddleWidth, paddleHeight);
  }
  void movePaddleUp() {
    this.y = Math.max(0, this.y - this.vy);
  }
  void movePaddleDown() {
    this.y = Math.min(this.y + this.vy, height - paddleHeight);
  }
}
