class Cenario06 extends Cenario {
  PApplet p5;
  PVector posIni;
  private int tempoMudando; //variaveis usadas para o gestÃ£o dos tempos
  private float variavelMudanca; //variavel utilizada para executas as modificaÃ§Ãµes visuais
  Random generadorRandom;

  Cenario06 (PApplet _p5, float angX, float angY, float angZ, int _radEsfera, String _nome) {
    super(angX, angY, angZ, _radEsfera, _nome);
    p5 = _p5;
    posIni = new PVector(0, height * 1.5, 0);
    setTempoMudando ( 30000 ); //tempo em milisegundos, 
    generadorRandom = new Random();
  }
  public void drawCenario() {
    update();
    p5.pushStyle();
    p5.translate(posIni.x, posIni.y, posIni.z);
    //desenhaLineasCoordenadas();
    desenhaLineasBZ();
//    desenhaLineas();
    p5.popStyle();
  }
  private void update() {
    variavelMudanca = constrain ( map ( millis(), tempoDeInicio, ( tempoDeInicio + tempoMudando ), 0, 1), .0, 1.0 );
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
      p5.bezier( p1c.x, p1c.y, p1c.z, p1.x, p1.y, p1.z,    p2.x, p2.y, p2.z, p2c.x, p2c.y, p2c.z );
    }
  }
  private void desenhaLineasBZToCirc () {
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
      p5.bezier( p1c.x, p1c.y, p1c.z, p1.x, p1.y, p1.z,    p2.x, p2.y, p2.z, p2c.x, p2c.y, p2c.z );
    }
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


