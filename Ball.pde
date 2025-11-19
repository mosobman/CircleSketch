
// Implemented to use verlet integration

float dt() { return 0.999; } ; // /60.0;

class Ball
{
  float x, y;                   // Ball position.
  float diameter;               // Ball diameter.
  color colour;                 // Ball colour.
  float dx, dy;                  // Previous position
 
  // Constructor - this is called whenever a new ball is created.
  Ball()
  {
    // Initialise the state of the ball with some random values.
    diameter = random(10, 40);
    x = random(diameter, width-diameter);
    y = random(diameter, height-diameter);
    colour = color(random(100, 155), random(170, 255), random(130, 180));
    dx = x + random(-2, 2);
    dy = y + random(-2, 2);
  }
 
  void draw()
  {
    noStroke();
    fill(colour);
    circle(x, y, diameter);
  }
 
  void move()
  {
    float ox = x;
    float oy = y;
    x = ox+(ox-dx)*dt();
    y = oy+(oy-dy+dt())*dt();
    dx = ox;
    dy = oy;
  }
 
  boolean hasCollidedWith(Ball anotherBall)
  {
    return (dist(x, y, anotherBall.x, anotherBall.y) <= (diameter+anotherBall.diameter)/2.0);
  }
  
  void constrain() {
    if (x <= diameter/2) {
      x = diameter/2;
    }
    if (y <= diameter/2) {
      y = diameter/2;
    }
    if (x >= width-diameter/2) {
      x = width-diameter/2;
    }
    if (y >= height-diameter/2) {
      y = height-diameter/2;
    }
  }
 
  void bounce(Ball b) {
    float dx2 = b.x - x;
    float dy2 = b.y - y;
    float dist2 = dx2 * dx2 + dy2 * dy2;
    float rSum = diameter/2.0 + b.diameter/2.0;
    if (dist2 < rSum * rSum) {
      float dist = (float)Math.sqrt(dist2);
      if (dist < 1e-6f) dist = 1e-6f;
      float overlap = rSum - dist;
      float nx2 = dx2 / dist;
      float ny2 = dy2 / dist;
      float mA = diameter/2.0, mB = b.diameter/2.0;
      float total = mA + mB;
      float moveA = (mB / total) * overlap;
      float moveB = (mA / total) * overlap;
      x -= nx2 * moveA;
      y -= ny2 * moveA;
      b.x += nx2 * moveB;
      b.y += ny2 * moveB;
    }
  }
}
