ArrayList<Ball> balls;           // Declare an array of ball objects.
PVector framePos = new PVector(0,0);
float ALPHA = 90.0;
boolean PAUSED = true;

void setup()
{
  size(800, 400, P2D);
  surface.setResizable(true);
  windowResizable(true);
  frameRate(60);
  colorMode(HSB);
  balls = new ArrayList<>();  // Create N new balls.
  for (int i=0; i<200; i++) {
    balls.add(new Ball());
  }
  colorMode(RGB);
  
  textFont(createFont("Consolas", 16, true));
}
 
void draw()
{
  rectMode(CORNER);
  textAlign(LEFT,TOP);
  noStroke();
  //stroke(0);
  fill(254,244,232, ALPHA);  // Pale background.
  rect(0,0,width,height);
  fill(254, 244, 232);
  rect(0,0,160,16*4);
  fill(0);
  text(String.format("FPS: %02d", (int) frameRate), 2, 2);
  text(String.format("Ball Count: %d", balls.size()), 2, 2+16);
  text(String.format("Blur Alpha: %.1f", 255-ALPHA), 2, 2+16*2);
  if (PAUSED) text(String.format("Press Key to Unpause", 255-ALPHA), 2, 2+16*3);
 
  // First draw the balls in their current position.
  colorMode(HSB);
  for (Ball ball : balls) ball.draw();
  colorMode(RGB);
 
  // Check to see if any balls have collided
  for (int sub=0; sub<8; sub++) {
    for (int i=0; i<balls.size(); i++) {
      for (int j=0; j<balls.size(); j++) {
        if (i != j) balls.get(i).bounce(balls.get(j));
      }
    }
    for (Ball ball : balls) ball.constrain();
  }
 
  // Finally move all the balls by one step.
  if (!PAUSED) for (Ball ball : balls) ball.move();
  if (keyPressed && PAUSED) PAUSED = false;
  
  fill(0);
  float x, y;
  x = framePos.x; y = framePos.y;
  getLocationOnScreen(framePos);
  float u, v;
  u = x - framePos.x;
  v = y - framePos.y;
  for (var ball : balls) {
    ball.x += u/30.0;
    ball.y += v/30.0;
  }
  
  if (mousePressed) {
    PVector dist = new PVector(0,0);
    PVector mouseXY = new PVector(mouseX,mouseY);
    for (var ball : balls) {
      dist.set(ball.x, ball.y);
      dist.sub(mouseXY);
      if (dist.mag() < ball.diameter/2.0) {
        ball.x += mouseX-pmouseX;
        ball.y += mouseY-pmouseY;
      }
    }
  }
}



void getLocationOnScreen(PVector out){
  var location = out;
  
  if(surface instanceof processing.opengl.PSurfaceJOGL) { // P2D or P3D
    com.jogamp.newt.opengl.GLWindow window = (com.jogamp.newt.opengl.GLWindow)(((PSurfaceJOGL)surface).getNative());
    com.jogamp.nativewindow.util.Point point = window.getLocationOnScreen(new com.jogamp.nativewindow.util.Point());
    location.set(point.getX(), point.getY());
  } else if(surface instanceof processing.awt.PSurfaceAWT) { // Java2D
    java.awt.Frame frame = ((processing.awt.PSurfaceAWT.SmoothCanvas) ((processing.awt.PSurfaceAWT)surface).getNative()).getFrame();
    java.awt.Point point = frame.getLocationOnScreen();
    location.set(point.x, point.y);
  }
  //else if(surface instanceof processing.javafx.PSurfaceFX) { // FX2D
  //  javafx.scene.canvas.Canvas canvas = (javafx.scene.canvas.Canvas)((processing.javafx.PSurfaceFX)surface).getNative();
  //  javafx.geometry.Point2D point = canvas.localToScreen(0,0);
  //  location.set((float) point.getX(),(float) point.getY()); 
  //}
}
