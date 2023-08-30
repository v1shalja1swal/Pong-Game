Ball ball;
Paddle paddleLeft;
Paddle paddleRight;
Score scoreLeft;
Score scoreRight;

int leftScore = 0;
int rightScore = 0;
final int paddleWidth = 20;
final int paddleHeight = 100;
final int diameter = 25;
int caliWidth;
int caliHeight;
Line up;
Line down;
Line right;
Line left;

boolean isWelcomeScreen = true;
boolean mode = true; // true - two player, flase - single player
boolean level = true; // true - easy, false - hard

class Point {
  float x;
  float y;
  Point(float x, float y) {
    this.x = x;
    this.y = y;
  }
}
class LineParameters { //ax+by+c=0 equation of line
  float a;
  float b;
  float c;
  LineParameters(float a, float b, float c) {
    this.a = a;
    this.b = b;
    this.c = c;
  }
}

class Line {
  Point a;
  Point b;
  LineParameters p;
  Line(Point a, Point b) {
    this.a = a;
    this.b = b;
    this.p = new LineParameters(this.b.y - this.a.y, this.a.x - this.b.x, this.a.y*(this.b.x-this.a.x)+this.a.x*(this.a.y-this.b.y));
  }
  Point intersection(Line that) {
    return new Point((this.p.b*that.p.c - that.p.b*this.p.c)/(this.p.a*that.p.b-that.p.a*this.p.b), (this.p.c*that.p.a-that.p.c*this.p.a)/(this.p.a*that.p.b-that.p.a*this.p.b));
  }
}

Line[] mayIntersect(float vx, float vy) {
  if (vx >= 0 && vy >= 0) return new Line[]{right, down};
  if (vx >= 0 && vy <= 0) return new Line[]{right, up};
  if (vx <= 0 && vy >= 0) return new Line[]{left, down};
  return new Line[]{left, up};
}

boolean inBounds(final Point p) {
  return p.x >= paddleWidth && p.x <= caliWidth && p.y >= 0 && p.y <= height;
}

Point nextCollision(final Point a, final float vx, final float vy) {
  Point b = new Point(a.x + vx, a.y + vy);
  Line cur = new Line(a, b);
  Line[] may = mayIntersect(vx, vy);
  Point iOne = cur.intersection(may[0]);
  Point iTwo = cur.intersection(may[1]);
  if (inBounds(iOne)) return iOne;
  if (inBounds(iTwo)) return iTwo;
  return null;
}

void setup() {
  frameRate(80);
  size(700, 400);
  caliWidth = width - paddleWidth;
  caliHeight = height;
  up = new Line(new Point(paddleWidth, 0), new Point(caliWidth, 0));
  down = new Line(new Point(paddleWidth, caliHeight), new Point(caliWidth, caliHeight));
  right = new Line(new Point(caliWidth, 0), new Point(caliWidth, caliHeight));
  left = new Line(new Point(paddleWidth, 0), new Point(paddleWidth, caliHeight));
  ball = new Ball(width/2, height/2, 3, 3);
  paddleLeft = new Paddle(0, height/2);
  paddleRight = new Paddle(width - paddleWidth, height/2);
  scoreLeft = new Score("Score: ", 0, 15);
  scoreRight = new Score("Score: ", 525, 15);
}

void draw() {
  if (isWelcomeScreen) {
    background(0);
    textSize(30);
    fill(255);
    text("Welcome to Pong Game", width/4, height/12);
    text("Player Mode(Hit x to change)", width/30, height/4);
    if (!mode) fill(175);
    text("Single Player", width/30, height/3);
    fill(255);
    if (mode) fill(175);
    text("Two Player", width/2, height/3);
    fill(255);
    if (!mode) {
      text("Select level(Hit o to change)", width/3, height/2);
      if (level) fill(175);
      text("Easy", width/30, height/1.5);
      fill(255);
      if (!level) fill(175);
      text("Hard", width/2, height/1.5);
      fill(255);
    }
    text("Start Game", width/2, height);
    return;
  }
  background(0);
  ball.update();
  ball.display();
  paddleLeft.display();
  paddleRight.display();

  if (ball.x <= paddleLeft.x + paddleWidth && ball.vx < 0) {
    if (ball.y >= paddleLeft.y && ball.y <= paddleLeft.y + paddleHeight) { // hit
      ball.vx *= -1;
      ball.x = Math.max(ball.x, paddleWidth);
      if (!mode) ballHitLeft(ball.x, ball.y);
    } else {
      rightScore++;
      ball.reset();
      if (!mode) {
        Point next = nextCollision(new Point(ball.x, ball.y), ball.vx, ball.vy);
        paddleLeft.y = Math.max(Math.min(next.y, height-paddleHeight), 0);
      }
    }
  } else if (ball.x >= paddleRight.x && ball.vx > 0) {
    if (ball.y >= paddleRight.y && ball.y <= paddleRight.y + paddleHeight) {
      ball.vx *= -1;
      ball.x = Math.min(ball.x, width-paddleWidth);
      ballHitRight(ball.x, ball.y);
    } else {
      leftScore++;
      ball.reset();
    }
  } else if (ball.y <= 0 && ball.vy < 0) {
    ball.vy *= -1;
    ball.y = Math.max(ball.y, 0);
    if (!mode) ballHitUp(ball.x, ball.y);
  } else if (ball.y >= height && ball.vy > 0) {
    ball.vy *= -1;
    ball.y = Math.min(ball.y, height);
    if (!mode) ballHitDown(ball.x, ball.y);
  }// Showing score
  scoreLeft.display();
  scoreRight.display();
  text(leftScore, 55, 15);
  text(rightScore, 580, 15);
}

void keyPressed() {
  if (mode) {
    if (key == 'w') paddleLeft.movePaddleUp();
    else if (key == 's') paddleLeft.movePaddleDown();
  }
  if (key == 'i') paddleRight.movePaddleUp();
  else if (key == 'k') paddleRight.movePaddleDown();
  if (isWelcomeScreen && key == 'x') {
    System.out.println('x');
    mode = !mode;
  }
  if (isWelcomeScreen && key == 'o') {
    System.out.println('o');
    level = !level;
  }
  if (key == '0') {
    isWelcomeScreen = false;
  }
}

void ballHitUp(final float x, final float y) {
  System.out.println(mode);
  Point next = nextCollision(new Point(x, y), ball.vx, ball.vy);
  line(x, y, next.x, next.y); //easy:hard
  paddleLeft.y = Math.max(Math.min(next.y+10-random(level ?90:10, level?120:100), height-paddleHeight), 0);
}
void ballHitDown(final float x, final float y) {
  System.out.println(mode);
  Point next = nextCollision(new Point(x, y), ball.vx, ball.vy);
  line(x, y, next.x, next.y);
  paddleLeft.y = Math.max(Math.min(next.y+10-random(level?80:10, level?120:100), height-paddleHeight), 0);
}
void ballHitRight(final float x, final float y) {
  Point next = nextCollision(new Point(x, y), ball.vx, ball.vy);
  line(x, y, next.x, next.y);
}
void ballHitLeft(float x, float y) {
  Point next = nextCollision(new Point(x, y), ball.vx, ball.vy);
  line(x, y, next.x, next.y);
}
