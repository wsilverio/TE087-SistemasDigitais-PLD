float font_size = 72f;

int qwidth = 267;
int qheight = 300;

int[] corner_up_left = new int[2];
int[] corner_bottom_right = new int[2];

int vga_char_width = 38;
int vga_char_height = 56;

void setup() {
  size(800, 600);

  noSmooth();
  textSize(font_size);
  textAlign(CENTER, BASELINE);

  fill(255);

  corner_up_left[0] = int(qwidth/2f-vga_char_width/2f); // x
  corner_up_left[1] = int(qheight/2f-vga_char_height/2f); // y
  corner_bottom_right[0] = int(qwidth/2f+vga_char_width/2f); // x
  corner_bottom_right[1] = int(qheight/2f+vga_char_height/2f); // y
}
void draw() {
  background(0);

  text("00", 0*qwidth+qwidth/2f, qheight/2f + vga_char_height/2f - 2);
  text("10", 1*qwidth+qwidth/2f, qheight/2f + vga_char_height/2f - 2);
  text("29", 2*qwidth+qwidth/2f, qheight/2f + vga_char_height/2f - 2);

  text("38", 0*qwidth+qwidth/2f, qheight+qheight/2f + vga_char_height/2f - 2);
  text("47", 1*qwidth+qwidth/2f, qheight+qheight/2f + vga_char_height/2f - 2);
  text("56", 2*qwidth+qwidth/2f, qheight+qheight/2f + vga_char_height/2f - 2);

  stroke(255, 0, 0);
  line(0, height/2f, width, height/2f);
  line(width/3f, 0, width/3f, height);
  line(2*width/3f, 0, 2*width/3f, height);


  stroke(0, 255, 0);
  for (int j = 0; j < 2; j++) {
    for (int i = 0; i < 3; i++) {
      line(0, 120+j*height/2, width, 120+j*height/2);
      //line(0, 120+57+300*j, width, 120+57+300*j);

      line(90+i*width/3f, 0, 90+i*width/3f, height);
      //line(130, 0, 130, height);
      line(130+8+i*width/3f, 0, 130+8+i*width/3f, height);
    }
  }
}