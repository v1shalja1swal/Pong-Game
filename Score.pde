class Score {
  String str;
  int xcor;
  int ycor;
  Score(String str, int xcor, int ycor) {
    this.str = str;
    this.xcor = xcor;
    this.ycor = ycor;
  }
  void display() {
    textSize(20);
    fill(255);
    text(str, xcor, ycor);
  }
}
