// arquivo de saida
PrintWriter output; 
// tamanho da fonte
float font_size = 72f;
// cantos do caractere
int[] corner_up_left = new int[2];
int[] corner_bottom_right = new int[2];
// tamanho do caractere vga
int vga_char_width = 38;
int vga_char_height = 56;
// imagem extraida
PImage vga_char_img = createImage(vga_char_width, vga_char_height, RGB);
// caracterees a serem extraidos: '0' a '9'
char vga_char = '0';
// limiar para extracao do caractere
int threshold = 255/2;

void setup() {
  // retangulo (800/3 x 600/2)
  size(267, 300); 
  // sem suavizacao
  noSmooth();
  // config.fonte
  textSize(font_size);
  textAlign(CENTER, BASELINE);
  // calculo dos cantos
  corner_up_left[0] = int(width/2f-vga_char_width/2f); // x
  corner_up_left[1] = int(height/2f-vga_char_height/2f); // y
  corner_bottom_right[0] = int(width/2f+vga_char_width/2f); // x
  corner_bottom_right[1] = int(height/2f+vga_char_height/2f); // y

  output = createWriter("vga_chars.txt");
}

void draw() {
  // limpa a tela
  background(0);

  // desenha o caractere
  stroke(255);
  text(vga_char, width/2f, height/2f + vga_char_height/2f - 2);

  // cabecalho do caractere
  output.println("-- char: " + vga_char);
  
  // varredura da imagem
  for (int y = corner_up_left[1], j = 0; y <= corner_bottom_right[1]; y++, j++) {
    output.print("\"");
    for (int x = corner_up_left[0], i = 0; x <= corner_bottom_right[0]; x++, i++) {
      // atribui '1' se o pixel atingir o limiar
      if (brightness(get(x, y)) >= threshold) {
        output.print("1");
      } else {
        output.print("0");
      }
    }
    output.println("\",");
  }

  if (vga_char < '9') {
    // proximo caractere
    vga_char++;
  } else {
    // finaliza o programa
    output.flush();
    output.close();
    exit();
  }
}