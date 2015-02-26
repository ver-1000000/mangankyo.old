// Thanks! http://blog.p5info.com/?p=469
import processing.video.*;
import java.io.File;

Capture cap;
PGraphics pg;
File file;
File files[];
String path;
float[] POINT_U = {1, 0.5, 0}, POINT_V = {1, 0, 1};
float R3 = sqrt(3);
int EDGE_LENGTH = 120;
int CAM_W = 160, CAM_H = 120;
void setup() {
  size(displayWidth, displayHeight, P2D);
  background(90, 30, 60);
  frameRate(30);
  pg = createGraphics(CAM_W, CAM_H, P2D);
  cap = new Capture(this, CAM_W, CAM_H);
  cap.start();
  textureMode(NORMAL);
  noStroke();
}

void draw() {
  boolean initTopSideFlag = false;

  for (int y = 0; y <= height + EDGE_LENGTH; y += EDGE_LENGTH / 2 * R3) {
    drawTexture(pg);
    boolean topSideFlag = initTopSideFlag;
    int texturePointIndex = 0;
    beginShape(TRIANGLE_STRIP);
    texture(pg);
    for (int x = -EDGE_LENGTH; x <= width + EDGE_LENGTH; x += EDGE_LENGTH / 2) {
      float pointY = topSideFlag ? y : y + EDGE_LENGTH / 2 * R3;
      vertex(x, pointY, POINT_U[texturePointIndex], POINT_V[texturePointIndex]);
      topSideFlag = !topSideFlag;
      texturePointIndex++;
      if (texturePointIndex >= POINT_U.length) {
        texturePointIndex = 0;
      }
    }
    endShape(CLOSE);
    initTopSideFlag = !initTopSideFlag;
  }
}
void mousePressed() {
  path = sketchPath("");
  file = new File(path + "/img"); 
  files = file.listFiles();
  int num = files.length;
  save("img/"+ num +".png");
}
void drawTexture(PGraphics pg) {
  pg.beginDraw();
  if (cap.available()) {
    cap.read();
    pg.image(cap, 0, 0);
  }
  pg.endDraw();
}

