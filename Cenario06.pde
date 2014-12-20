//"Rodape_1"
class Cenario06 extends Cenario {
  PApplet p5;
  PVector posIni;
  private int tempoMudando; //variaveis usadas para o gestÃ£o dos tempos
  private float variavelMudanca; //variavel utilizada para executas as modificaÃ§Ãµes visuais
  Random generadorRandom;
  float yoff = 0.0;        // 2nd dimension of perlin noise
  float max_eixo_X;
  float posicaoVariavel;
  public NuvemDePontos nuvemPontos;
  public ArrayList <PVector> nuvemPontosUser ;
  
  Cenario06 (PApplet _p5, float angX, float angY, float angZ, int _radEsfera, String _nome) {
    super(angX, angY, angZ, _radEsfera, _nome);
    p5 = _p5;
    posIni = new PVector(0, height, 0); // * 1
    setTempoMudando ( 50000 ); //tempo em milisegundos, 
    generadorRandom = new Random();
    max_eixo_X = p5.width*3;
    nuvemPontos = new NuvemDePontos(p5);
    nuvemPontosUser = new ArrayList <PVector>();
  }
  public void drawCenario() {
    float va = update(); //va pega o tempo de exhibição do cenario, de 0 o inicio, ate 1 o fim do tempo establecido
    p5.pushStyle();
    p5.translate(posIni.x, posIni.y, posIni.z);
    //desenhaLineasCoordenadas();
    // desenhaLineasBZ();
    if (getTempoLigado() < 33000) {
      desenhaLineasBZ();
    } else if (getTempoLigado() >= 33000 && getTempoLigado() < 50000) {
      desenhaLineasBZToCirc( 33000, 50000);
    }
    if (getTempoLigado() >= 49000) {
      desenhaGrama(49000, 60000);
    }
    p5.popStyle();
  }
  public void setNuvemPontosUser( ArrayList <PVector> npu ) {
    if (npu.size() > 1 ) {
      //   println("nuvemPontosUser.size(): " + npu.size());
      nuvemPontosUser.clear();
      for (PVector p : npu) {
        nuvemPontosUser.add( new PVector (p.x, - p.y, p.z ) );
      }
    }
    nuvemPontos.setListaPontosUsuario(nuvemPontosUser);
    verNuvemPontosUser = true;
  }
  private float update() {
    variavelMudanca = constrain ( map ( millis(), tempoDeInicio, ( tempoDeInicio + tempoMudando ), 0, 1), .0, 1.0 );
    return variavelMudanca;
  }

  /** Desenha as lineas utilizando curvas bezier */
  private void desenhaLineasBZ () {
    int cantLinhas = (int) ( 100 * variavelMudanca );
    p5.stroke(255);
    p5.strokeWeight(.5);
    p5.noFill();
    for (int i=0; i < cantLinhas; i++) {
      float max_eixo_Y = p5.width*.1;
      float max_eixo_Z = 0;// p5.width*.5;

      float temVar = (float) generadorRandom.nextGaussian();//map( variavelMudanca, 0, 1, 1, max_eixo_Y );
      float standarDeviation = max_eixo_Y * variavelMudanca;
      float posMedia = height * .1 * variavelMudanca;
      temVar = ( temVar * standarDeviation ) - posMedia;
      float temVar2 = (float) generadorRandom.nextGaussian();//map( variavelMudanca, 0, 1, 1, max_eixo_Y );
      temVar2 = ( temVar2 * standarDeviation ) - posMedia;

      /*      PVector p1 = new PVector ( random (-max_eixo_X, max_eixo_X), temVar , 0 );
       PVector p1c = new PVector ( random (-max_eixo_X, max_eixo_X), temVar2 + height, 0 );
       PVector p2 = new PVector ( random (-max_eixo_X, max_eixo_X), temVar , 0 );
       PVector p2c = new PVector ( random (-max_eixo_X, max_eixo_X), temVar2 + height, 0 );
       p5.noFill(); 
       p5.bezier( p1c.x, p1c.y, p1c.z, p1.x, p1.y, p1.z, p2.x, p2.y, p2.z, p2c.x, p2c.y, p2c.z );
       */
      PVector p1 = new PVector ( -max_eixo_X, temVar -200, 0 );
      PVector p1c = new PVector (-max_eixo_X * .5, temVar+200, 0 );//-max_eixo_X * .1
      PVector p2 = new PVector ( max_eixo_X, temVar2 -200, 0 );
      PVector p2c = new PVector ( max_eixo_X * .5, temVar2+200, 0 );//max_eixo_X * .1

      p5.bezier( p1.x, p1.y, p1.z, p1c.x, p1c.y, p1c.z, p1c.x, p1c.y, p1c.z, 0, p1.y*.3, 0 );
      p5.bezier( 0, p1.y*.3, 0, p2c.x, p2c.y, p2c.z, p2c.x, p2c.y, p2c.z, p2.x, p2.y, p2.z );
    }
  }
  private void desenhaLineasBZToCirc (float v1, float v2) {
    float variavelFecha = map(getTempoLigado(), v1, v2, .9, .001);

    int cantLinhas = (int) ( 100 * variavelFecha );
    p5.stroke(255);
    p5.strokeWeight(.5);
    p5.noFill();
    for (int i=0; i < cantLinhas; i++) {
      float max_eixo_Y = p5.width*.1;
      float max_eixo_Z = 0;// p5.width*.5;

      float temVar = (float) generadorRandom.nextGaussian();//siguente valor segundo o generador que utiliza a curva de Gauss 
      float standarDeviation = max_eixo_Y * variavelFecha;
      float posMedia = height * .1 * variavelFecha;
      temVar = ( temVar * standarDeviation ) - posMedia;
      float temVar2 = (float) generadorRandom.nextGaussian();//map( variavelMudanca, 0, 1, 1, max_eixo_Y );
      temVar2 = ( temVar2 * standarDeviation ) - posMedia;

      /*  PVector p1 = new PVector ( random (-max_eixo_X, max_eixo_X), temVar , 0 );
       PVector p1c = new PVector ( random (-max_eixo_X, max_eixo_X), temVar2 + height, 0 );
       PVector p2 = new PVector ( random (-max_eixo_X, max_eixo_X), temVar , 0 );
       PVector p2c = new PVector ( random (-max_eixo_X, max_eixo_X), temVar2 + height, 0 );
       p5.noFill();
       p5.bezier( p1c.x, p1c.y, p1c.z, p1.x, p1.y, p1.z, p2.x, p2.y, p2.z, p2c.x, p2c.y, p2c.z );
       */
      PVector p1 = new PVector ( -max_eixo_X, temVar -200, 0 );
      PVector p1c = new PVector (-max_eixo_X * .5, temVar+200, 0 );//-max_eixo_X * .1
      PVector p2 = new PVector ( max_eixo_X, temVar2 -200, 0 );
      PVector p2c = new PVector ( max_eixo_X * .5, temVar2+200, 0 );//max_eixo_X * .1

      p5.bezier( p1.x, p1.y, p1.z, p1c.x, p1c.y, p1c.z, p1c.x, p1c.y, p1c.z, 0, p1.y*.3, 0 );
      p5.bezier( 0, p1.y*.3, 0, p2c.x, p2c.y, p2c.z, p2c.x, p2c.y, p2c.z, p2.x, p2.y, p2.z );
    }
  }

  private void desenhaGrama(int v1, int v2) {
    p5.translate (0, height*.4, 0);//, map(mouseX, 0,width,0,height*.2) , 0);
    float variavelFecha = constrain (map(getTempoLigado(), v1, v2, 0, 1), 0, 1);  
    float variavelCor = constrain (map(getTempoLigado(), v1, v2, 0, 2), 0, 1);  
    float colorFill;
    float max_eixo_Y = p5.width*1.5;//*.9;
    p5.beginShape(); 
    float xoff = 0;       // Option #1: 2D Noise
    PVector ptoContAnt  = new PVector();

    p5.fill(0);
    p5.noStroke();//stroke(255);    
    p5.vertex(-max_eixo_X, max_eixo_Y* .5, 0); 
    // Iterate over horizontal pixels
    for (float x = -max_eixo_X; x <= max_eixo_X; x += 100) {
      // Calculate a y value according to noise, map to 
      float y = map(noise(xoff+x, yoff+x), 0, 1, -max_eixo_Y * .05, - max_eixo_Y); // Option #1: 2D Noise
      float xi = map(noise( x + yoff), 0, 1, -300, 300);    // Option #2: 1D Noise
      colorFill = 255 * noise(xoff+x, yoff+x) * variavelCor;
      // Set the vertex
      PVector p1 = new PVector ((x + xi), y * variavelFecha, 0); //( variavelFecha + .1 * noise(xoff, yoff) ), 0 );
      PVector p1c = new PVector ((x - xi), y * variavelFecha, 0);// * noise(xoff, yoff) , 0);//x , y * variavelFecha * noise(xoff, yoff) + 10, 0 );
      PVector p2 = new PVector ( x, (.5 * noise( (x*.1) + yoff) * max_eixo_Y ) * variavelFecha, 0 );
      PVector p2c = new PVector ( x, -20 * variavelFecha, 0 );
      p5.fill(colorFill);

      if ( x == -max_eixo_X ) {
        p5.bezierVertex(-max_eixo_X, max_eixo_Y, 0, p1c.x, p1c.y, p1c.z, p1.x, p1.y, p1.z);
      } else {
        p5.bezierVertex(ptoContAnt.x, ptoContAnt.y, ptoContAnt.z, p2c.x, p2c.y, p2c.z, p2.x, p2.y, p2.z);
        p5.bezierVertex(p2c.x, p2c.y, p2c.z, p1c.x, p1c.y, p1c.z, p1.x, p1.y, p1.z);
      }

      ptoContAnt = p1c;
      xoff += 0.01;
    }
    p5.fill(0);
    p5.bezierVertex(max_eixo_X, max_eixo_Y* .5, 0, max_eixo_X, max_eixo_Y* .5, 0, max_eixo_X, max_eixo_Y* .5, 0); //esquina direita inferior
    p5.bezierVertex(0, max_eixo_Y * .5, 0, 0, max_eixo_Y * .5, 0, -max_eixo_X, max_eixo_Y* .5, 0); //fecha o desenho

    // increment y dimension for noise
    yoff += 0.01; //0.003;
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

  void ejecutaModificacoes () { //implementação de classe declarada na classe pai 'Cenario' | E chamada desde Modelo3D cada vez que tem novos dados
    //Modificações com o dado A
    posicaoVariavel  = aplicaModificacoesNoVal( valModificadoraA, -width, width);
  }
}

