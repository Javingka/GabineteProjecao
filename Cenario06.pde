class Cenario06 extends Cenario {
  PApplet p5;
  PVector posIni;
  private int tempoMudando; //variaveis usadas para o gestÃ£o dos tempos
  private float variavelMudanca; //variavel utilizada para executas as modificaÃ§Ãµes visuais
  Random generadorRandom;
  float yoff = 0.0;        // 2nd dimension of perlin noise

  Cenario06 (PApplet _p5, float angX, float angY, float angZ, int _radEsfera, String _nome) {
    super(angX, angY, angZ, _radEsfera, _nome);
    p5 = _p5;
    posIni = new PVector(0, height * 2, 0);
    setTempoMudando ( 30000 ); //tempo em milisegundos, 
    generadorRandom = new Random();
  }
  public void drawCenario() {
    float va = update(); //va pega o tempo de exhibição do cenario, de 0 o inicio, ate 1 o fim do tempo establecido
    p5.pushStyle();
    p5.translate(posIni.x, posIni.y, posIni.z);
    //desenhaLineasCoordenadas();
    // desenhaLineasBZ();
    if (va < .3 )
      desenhaLineasBZ();
    else if (va >= .3 && va < .4 )
      desenhaLineasBZToCirc( .3, .4);
    else 
      desenhaOndaPorPixelBz(.4, .99); // desenhaOndaPorPixel(.45, .99); //desenhaOndas(.4, .99);

    p5.popStyle();
  }
  private float update() {
    variavelMudanca = constrain ( map ( millis(), tempoDeInicio, ( tempoDeInicio + tempoMudando ), 0, 1), .0, 1.0 );
    return variavelMudanca;
  }
  private void desenhaLineas () {
    int cantLinhas = (int) ( 100 * variavelMudanca );
    p5.stroke(255);
    p5.strokeWeight(.5);

    for (int i=0; i < cantLinhas; i++) {
      float max_eixo_X = p5.width*4;
      float max_eixo_Y = p5.width*.2;
      float max_eixo_Z = 0;// p5.width*.5;

      float temVar = (float) generadorRandom.nextGaussian();//map( variavelMudanca, 0, 1, 1, max_eixo_Y );
      float standarDeviation = max_eixo_Y * variavelMudanca;
      float posMedia = height * .5 * variavelMudanca;
      temVar = ( temVar * standarDeviation ) - posMedia;
      float temVar2 = (float) generadorRandom.nextGaussian();//map( variavelMudanca, 0, 1, 1, max_eixo_Y );
      temVar2 = ( temVar2 * standarDeviation ) - posMedia;

      PVector p1 = new PVector ( random (-max_eixo_X, max_eixo_X), temVar, 0 );
      PVector p2 = new PVector ( random (-max_eixo_X, max_eixo_X), temVar2, 0 );

      p5.line( p1.x, p1.y, p1.z, p2.x, p2.y, p2.z );
    }
  }

  /** Desenha as lineas utilizando curvas bezier */
  private void desenhaLineasBZ () {
    int cantLinhas = (int) ( 100 * variavelMudanca );
    p5.stroke(255);
    p5.strokeWeight(.5);

    for (int i=0; i < cantLinhas; i++) {
      float max_eixo_X = p5.width*4;
      float max_eixo_Y = p5.width*.1;
      float max_eixo_Z = 0;// p5.width*.5;

      float temVar = (float) generadorRandom.nextGaussian();//map( variavelMudanca, 0, 1, 1, max_eixo_Y );
      float standarDeviation = max_eixo_Y * variavelMudanca;
      float posMedia = height * .1 * variavelMudanca;
      temVar = ( temVar * standarDeviation ) - posMedia;
      float temVar2 = (float) generadorRandom.nextGaussian();//map( variavelMudanca, 0, 1, 1, max_eixo_Y );
      temVar2 = ( temVar2 * standarDeviation ) - posMedia;

      PVector p1 = new PVector ( random (-max_eixo_X, max_eixo_X), temVar, 0 );
      PVector p1c = new PVector ( random (-max_eixo_X, max_eixo_X), temVar2, 0 );
      PVector p2 = new PVector ( random (-max_eixo_X, max_eixo_X), temVar, 0 );
      PVector p2c = new PVector ( random (-max_eixo_X, max_eixo_X), temVar2, 0 );
      p5.noFill();
      p5.bezier( p1c.x, p1c.y, p1c.z, p1.x, p1.y, p1.z, p2.x, p2.y, p2.z, p2c.x, p2c.y, p2c.z );
    }
  }
  private void desenhaLineasBZToCirc (float v1, float v2) {
    float variavelFecha = map(variavelMudanca, v1, v2, .9, .05);

    int cantLinhas = (int) ( 100 * variavelFecha );
    p5.stroke(255);
    p5.strokeWeight(.5);

    for (int i=0; i < cantLinhas; i++) {
      float max_eixo_X = p5.width*4;
      float max_eixo_Y = p5.width*.1;
      float max_eixo_Z = 0;// p5.width*.5;

      float temVar = (float) generadorRandom.nextGaussian();//siguente valor segundo o generador que utiliza a curva de Gauss 
      float standarDeviation = max_eixo_Y * variavelFecha;
      float posMedia = height * .1 * variavelFecha;
      temVar = ( temVar * standarDeviation ) - posMedia;
      float temVar2 = (float) generadorRandom.nextGaussian();//map( variavelMudanca, 0, 1, 1, max_eixo_Y );
      temVar2 = ( temVar2 * standarDeviation ) - posMedia;

      PVector p1 = new PVector ( random (-max_eixo_X, max_eixo_X), temVar, 0 );
      PVector p1c = new PVector ( random (-max_eixo_X, max_eixo_X), temVar2, 0 );
      PVector p2 = new PVector ( random (-max_eixo_X, max_eixo_X), temVar, 0 );
      PVector p2c = new PVector ( random (-max_eixo_X, max_eixo_X), temVar2, 0 );
      p5.noFill();
      p5.bezier( p1c.x, p1c.y, p1c.z, p1.x, p1.y, p1.z, p2.x, p2.y, p2.z, p2c.x, p2c.y, p2c.z );
    }
  }
  private void desenhaOndas(float v1, float v2) {
    float variavelFecha = constrain (map(variavelMudanca, v1, v2, 0, 1), 0, 1);  
    float max_eixo_X = p5.width*4;
    float max_eixo_Y = p5.width*.1;

    p5.stroke(255);
    p5.strokeWeight(.5);

    float variacaoY = frameCount * .08 * variavelFecha;//frameCount * .01 * variavelFecha;

    PVector p1 = new PVector (-max_eixo_X, 0, 0 );
    PVector p1c = new PVector (-max_eixo_X*.5, max_eixo_Y * sin (variacaoY), 0 );
    PVector p2 = new PVector ( max_eixo_X, 0, 0 );
    PVector p2c = new PVector ( max_eixo_X*.5, max_eixo_Y * cos (variacaoY), 0 );
    p5.noFill();
    p5.bezier( p1.x, p1.y, p1.z, p1c.x, p1c.y, p1c.z, p2c.x, p2c.y, p2c.z, p2.x, p2.y, p2.z);
  }
  
  private void desenhaOndaPorPixel(float v1, float v2) {
    float variavelFecha = constrain (map(variavelMudanca, v1, v2, 0, 1), 0, 1);  
    float max_eixo_X = p5.width*4;
    float max_eixo_Y = p5.width*.9;
    p5.beginShape(); 
    p5.fill(0);
    p5.stroke(255);
    float xoff = 0;       // Option #1: 2D Noise
    // float xoff = yoff; // Option #2: 1D Noise

    // Iterate over horizontal pixels
    for (float x = -max_eixo_X; x <= max_eixo_X ; x += 100) {
      // Calculate a y value according to noise, map to 
      float y = map(noise(xoff, yoff), 0, 1, -max_eixo_Y * .05, - max_eixo_Y); // Option #1: 2D Noise
      float xi = map(noise( (x*.1) + yoff), 0, 1, -300,300);    // Option #2: 1D Noise

      // Set the vertex
      p5.vertex( (x + xi) , y * variavelFecha * random(variavelFecha)); 
      p5.vertex(x, (.5 * noise( (x*.1) + yoff) ) * max_eixo_Y *.1 ); 
      // Increment x dimension for noise
      xoff += 0.02;
    }
    // increment y dimension for noise
    yoff += 0.001;
//    p5.vertex(p5.width, p5.height);
//    p5.vertex(0, p5.height);
    p5.endShape();
  }
   private void desenhaOndaPorPixelBz(float v1, float v2) {
    float variavelFecha = constrain (map(variavelMudanca, v1, v2, 0, 1), 0, 1);  
    float max_eixo_X = p5.width*4;
    float max_eixo_Y = p5.width*.9;
    p5.beginShape(); 
    p5.fill(0);
    p5.stroke(255);
    float xoff = 0;       // Option #1: 2D Noise
    // float xoff = yoff; // Option #2: 1D Noise
    PVector ptoAnt  = new PVector();
    PVector ptoContAnt  = new PVector();
    // Iterate over horizontal pixels
    for (float x = -max_eixo_X; x <= max_eixo_X ; x += 100) {
      // Calculate a y value according to noise, map to 
      float y = map(noise(xoff+x, yoff+x), 0, 1, -max_eixo_Y * .05, - max_eixo_Y); // Option #1: 2D Noise
      float xi = map(noise( x + yoff), 0, 1, -300,300);    // Option #2: 1D Noise

      // Set the vertex
      PVector p1 = new PVector ((x + xi) , y * ( variavelFecha + .1 * noise(xoff, yoff) ), 0 );
      PVector p1c = new PVector ((x - xi) , y * variavelFecha * noise(xoff, yoff) , 0);//x , y * variavelFecha * noise(xoff, yoff) + 10, 0 );
      PVector p2 = new PVector ( x, (.5 * noise( (x*.1) + yoff) ) * max_eixo_Y *.1 , 0 );
      PVector p2c = new PVector (x + xi, (.5 * noise( (x*.1) + yoff) ) * max_eixo_Y *.1  , 0); //0, (.5 * noise( (x*.1) + yoff) ) * -max_eixo_Y * .1  , 0 );
      p5.noFill();
      stroke(255);
      p5.bezier( p1.x, p1.y, p1.z, p1c.x, p1c.y, p1c.z, p2c.x, p2c.y, p2c.z, p2.x, p2.y, p2.z);
      if (ptoAnt != null) {
          if (x < -max_eixo_X + 100){
            
          } else {
            stroke(120);
            p5.bezier( p1.x, p1.y, p1.z, p1c.x, p1c.y, p1c.z, ptoContAnt.x, ptoContAnt.y, ptoContAnt.z, ptoAnt.x, ptoAnt.y, ptoAnt.z);
          }
      }
 //     p5.vertex( ); 
 //     p5.vertex(); 
      // Increment x dimension for noise
      ptoAnt = p2;
      ptoContAnt = p2c;
      xoff += 0.001;
    }
    // increment y dimension for noise
    yoff += 0.001;
//    p5.vertex(p5.width, p5.height);
//    p5.vertex(0, p5.height);
    p5.endShape();
  }
  private void desenhaLineasCoordenadas() {
    p5.fill(25, 255, 25);
    p5.stroke(255);
    p5.line(-width*2, 0, 0, width*2, 0, 0); //linha ao longo do eixo X
    p5.stroke(255, 0, 0); 
    p5.line(-p5.width*.5, 0, 0, p5.width*.5, 0, 0);
    p5.stroke(0, 255, 0); 
    p5.line(0, -p5.width*.5, 0, 0, p5.width*.5, 0);
    p5.stroke(0, 0, 255); 
    p5.line(0, 0, -p5.width*.5, 0, 0, p5.width*.5);
  }
  /*  @Override
   public void cenarioTurnOn() { //Metodo sobre escreto, Ã© um mÃ©todo da classe Cenario
   ligado = true;
   tempoDeInicio = p5.millis();
   }*/
  public void setTempoMudando( int tempo) {
    tempoMudando = tempo;
  }
}

