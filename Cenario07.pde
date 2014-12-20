/* canÃ¡rio chamado "BigBang" na classe Modelo3D */
class Cenario07 extends Cenario {

  PApplet p5;
  Metamorfo forma0, forma1, forma2, forma3, forma4, forma5, forma6, forma7, forma8;
  Ponto ponto;
  float posicaoVariavel;
  public NuvemDePontos nuvemPontos;
  boolean verFormas =true;
//  public ArrayList <PVector> nuvemPontosUser ;
  
  Cenario07 (PApplet _p5, float angX, float angY, float angZ, int _radEsfera, String _nome) {
    super(angX, angY, angZ, _radEsfera, _nome);
    p5 = _p5;

    forma0 = new Metamorfo(0);
    forma1 = new Metamorfo(1);
    forma2 = new Metamorfo(2);
    forma3 = new Metamorfo(3);
    forma4 = new Metamorfo(4);
    forma5 = new Metamorfo(5);
    forma6 = new Metamorfo(6);
    forma7 = new Metamorfo(7);
    forma8 = new Metamorfo(8);

    ponto = new Ponto(2000);
    nuvemPontos = new NuvemDePontos(p5);
 //   nuvemPontosUser = new ArrayList <PVector>();
  }

  void drawCenario() {
    if (verNuvemPontosUser) {

      p5.pushMatrix();
      p5.pushStyle();
      p5.translate(posicaoVariavel, - p5.height*.20, 0);
      p5.rotateY(PI*.5);
      nuvemPontos.desenhaPontos(.7);//nuvemPontos.desenhaPontosLinhas(1); 
      p5.popStyle();
      p5.popMatrix();
    }

    p5.translate(-p5.width/2, -p5.height/2);
    if (verFormas) { //if (forma0 != null) {
      forma0.display();
      forma1.display();
      forma2.display();
      forma3.display();
      forma4.display();
      forma5.display();
      forma6.display();
      forma7.display();
      forma8.display();
    }
    for (int i=0; i<2000; i++) {
      ponto.displayPonto(i);
    }
  }
  public void resetCenario(){
    resetCena();
  }
  private void resetCena(){
    ponto.m = true;
    ponto.resetPos();
    nuvemPontos = new NuvemDePontos(p5);
    verFormas =true;
  }
  void ejecutaModificacoes () { //implementação de classe declarada na classe pai 'Cenario' | E chamada desde Modelo3D cada vez que tem novos dados
    //Modificações com o dado A
    posicaoVariavel  = aplicaModificacoesNoVal( valModificadoraA, -width*.18, width*.18);
  }
  public void setNuvemPontosUser( ArrayList <PVector> npu ) {
   //  print("a");
    ArrayList <PVector> nuvemPontosUser = new ArrayList <PVector>();
    if (npu != null ) {
   //   print("b");

      if ( npu.size() > 0 ) {
   //     print("c ");

     //   if (nuvemPontosUser != null ) nuvemPontosUser.clear();
        
        for (int pi=0 ; pi < npu.size()-1 ; pi++) {
          PVector p = npu.get(pi);
          //println((p.x*.7) + " " + (- p.y *.7) + " " + (p.z *.7 )+ " pi: " + pi );
          nuvemPontosUser.add( new PVector (p.x*.7, - p.y *.7, p.z *.7 ) );
        }
  //      println("d");

        nuvemPontos.setListaPontosUsuario(nuvemPontosUser);
        verNuvemPontosUser = true;
      }
    } else{
      verNuvemPontosUser = false;
    }
    
  }
  class Ponto extends Metamorfo { //cria uma nuvem de pontos

    float sP, sPini; //tamanho do ponto
    ArrayList<Ponto> pontos = new ArrayList<Ponto>();
    int tamArray, tamArrayIni; //tamnho do array de objs ponto
    boolean m;
    boolean mIni = true;
    boolean l;
    boolean lIni = false;

    //construtor externo, adiciona um obj ao array
    Ponto(int tamArrayIni) {
      m = mIni;
      tamArray = tamArrayIni;
      for (int i = 0; i < tamArray; i++)
        pontos.add(new Ponto());
    }
    public void resetPos() {
      for (int i = 0; i < tamArray; i++)
        pontos.get(i).resetLocationPonto();
    }
    public void resetLocationPonto() {
       locationIni = new PVector(random(0, p5.width), random(0, p5.height));
       location = locationIni;
       l = false;
    }
    //construtor interno, atribui propriedades ao ponto adicionado
    Ponto() {
      locationIni = new PVector(random(0, p5.width), random(0, p5.height));
      velocityIni = new PVector(random(vMin, vMax), random(vMin, vMax));
      gravityIni = new PVector(0, 0);
      //sPini = random(2, 6);
      sPini = random(.5, 2);
      location = locationIni;
      velocity = velocityIni;
      gravity = gravityIni;
      sP = sPini;
    }

    public boolean trocaM() {
      m = false;//!m;
   //   println(m);
      return m;
    }

    public boolean trocaL() {
      l = !l;
   //   println(l);
      return l;
    }

    //define o ponto especifico que ira se movimentar
    void displayPonto(int i) {
      Ponto ponto = pontos.get(i);
      if (i>0 && l) {
        float x = ponto.location.x; 
        float y = ponto.location.y;
        Ponto pontoA = pontos.get(i-1);
        float xA = pontoA.location.x; 
        float yA = pontoA.location.y;
        pontoA.conectaPontos(x, y, xA, yA);
      }

      if (m)
      {
        ponto.movimentaPonto();
      } else {        
        ponto.contraiPontos();
      }
    }

    //aplica a um ponto especifico o metodo de movimentacao antes de mostra-lo na tela
    void movimentaPonto() {
      location = mover(p5.width, p5.height);
      p5.strokeWeight(sP);
      p5.stroke(255);
      p5.point(location.x, location.y, 0);
    }

    void conectaPontos(float a, float b, float c, float d) {
      location = mover(p5.width, p5.height);
      p5.strokeWeight(1);
      p5.stroke(255, 127);
      float q = lerp(a, c, random(0, .03));
      float p = lerp(b, d, random(0, .03));
      p5.line(a, b, q, p);
      //point(q,p);
    }

    void contraiPontos() {
      location = contrai(p5.width, p5.height);
      p5.strokeWeight(sP);
      p5.stroke(255);
      p5.point(location.x, location.y, 0);
    }
  }

  class Metamorfo { //cria as metamorfoses entre pontos e formas

    String[] arquivo = {
      "coelhoBranco2Pq.svg", "gatoBranco2Pq.svg", "copasPq.svg", "espadasPq.svg", "ourosPq.svg", "pausPq.svg", "alicePq.svg", "lagartaPq.svg", "bulePq.svg"
    };
    RShape shpMorfo;
    RShape polyshpMorfo;
    RPoint[] points;
    //    float z = 40; //posicao do metamorfo no eixo espacial z
    float pol, tam; //quantidade de pontos e tamanho
    float polIni, tamIni;
    int index, indexIni; //indica a forma
    float sW = 1; //tam inicial dos pontos
    int colorStroke = 0; //cor inicial da linha entre os pontos
    int time, timeIni; //tempo de espera ate o inicio da metamorfose (em milisegundos)
    float lim = 50;
    boolean desPoligoniza;
    boolean desPoligonizaIni;

    PVector local;
    PVector location;
    PVector velocity;
    PVector gravity;
    PVector locationIni;
    PVector velocityIni;
    PVector gravityIni;
    float vMax = .9; //valores velocidade
    float vMin = -.9;
    PVector centroTela = new PVector(p5.width*.4, p5.height/2);

    Metamorfo() { //cria o metamorfo que ira ter forma final aleatoria
      indexIni = int(random(0, arquivo.length));
      polIni = random(300, 500);
      tamIni = random(280, 300);
      pol = polIni;
      tam = tamIni;
      index = indexIni;
      shpMorfo = RG.loadShape(arquivo[indexIni]);
      //shpMorfo = RG.centerIn(shpMorfo, g, tamIni);


      //println(tamIni+" :::: "+polIni);
      locationIni = new PVector(random(0, p5.width), random(0, p5.height));
      velocityIni = new PVector(random(vMin, vMax), random(vMin, vMax));
      gravityIni = new PVector(0, 0);
      location = locationIni;
      velocity = velocityIni;
      gravity = gravityIni;

      //timeIni = int(random(5000, 60000));
      time = timeIni;
    }

    Metamorfo(int indexIni) { //cria o metamorfo que ira ter forma final pre-definida
      //polIni = random(300, 500);
      polIni = random(800);
      //tamIni = random(280, 300);
      tamIni = random(800);
      desPoligonizaIni = false;

      desPoligoniza = desPoligonizaIni;
      pol = polIni;
      tam = tamIni;
      index = indexIni;
      shpMorfo = RG.loadShape(arquivo[indexIni]);
      // shpMorfo = RG.centerIn(shpMorfo, g, tamIni);


      //println(tamIni+" :::: "+polIni);
      locationIni = new PVector(random(250, p5.width-250), random(250, p5.height-250));
      velocityIni = new PVector(random(vMin, vMax), random(vMin, vMax));
      gravityIni = new PVector(0, 0);
      location = locationIni;
      velocity = velocityIni;
      gravity = gravityIni;

      //timeIni = int(random(5000, 60000));
      time = timeIni;
    }

    float poligoniza(float pointSeparation) {
      //float pointSeparation = map(constrain(mouseX, 100, width-100), 100, width-100, 1, 180);
      RG.setPolygonizer(RG.UNIFORMLENGTH);
      RG.setPolygonizerLength(pointSeparation);
      polyshpMorfo = RG.polygonize(shpMorfo);

      int timeAtual = millis();
      //println(time+"..."+timeAtual);
      if (timeAtual>time & pol>0 & !desPoligoniza) {
        //pol-=.25;
        pol-=.25;
      } else {
        desPoligoniza = true;
      }
      if (desPoligoniza) {
        colorStroke-=5;
        pol+=1.8;
        if (colorStroke<=0)colorStroke=0;
      }
      return pol;
    }

    void display() {
      poligoniza(pol);
      p5.pushMatrix();
      // location = mover(width, height);
      location = mover(p5.width, p5.height);
      p5.translate(location.x, location.y, 0);//z
      // desenha grupo poligonizado
      RG.shape(polyshpMorfo);
      points = shpMorfo.getPoints();
      p5.pushStyle();
      p5.stroke(colorStroke);
      for (int i=0; i<points.length; i++) {
        p5.strokeWeight(1);
        
        if (i>0) p5.line(points[i].x, points[i].y, points[i-1].x, points[i-1].y);
        p5.strokeWeight(sW); 
        p5.point(points[i].x, points[i].y);
      }
      p5.popStyle();
      p5.popMatrix();
      if (pol<=16)sW-=.5;
      if (sW<=0) {
        sW=1;
       // z -=20;
      }
      if (pol<=150)colorStroke+=1;
      if (colorStroke>=255)colorStroke=255;
      //println(pol);
    }

    PVector mover(float w, float h) {
      //println("vel: "+velocity.x+"/"+velocity.y);
      location.add(velocity);
      velocity.add(gravity);

      /* if (abs(location.dist(centroTela)) >= 500) {
       velocity.x = velocity.x * random(-1,1);
       velocity.y = velocity.y * random(-1,1);
       }*/

      if ((location.x > w + 150) || (location.x < -150)) {
        velocity.x = velocity.x * -1;
      }
      if (location.y > h + 150 || (location.y < -150)) {
        velocity.y = velocity.y * -1;
      }
      return location;
    }

    PVector contrai(float w, float h) {
      location.add(velocity);
      velocity.add(gravity);

      if (abs(location.dist(centroTela)) >= random(0, 50)) {
        p5.pushStyle();
        p5.strokeWeight(.1);
        p5.line(location.x, location.y, centroTela.x, centroTela.y);
        p5.popStyle();
        location.lerp(p5.width*.4, p5.height/2, 0, .8);
      }
      
      verFormas = false;
//      forma0 = forma1 = forma2 = forma3 = forma4 = null;
//      forma5 = null;forma6 = null;forma7 = null;forma8 = null;

      return location;
    }
  }
}

