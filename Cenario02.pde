//"Arvores"
class Cenario02 extends Cenario {
  PVector posIni;
  PApplet p5;
  // Perlin noise offset 
  float yoff = 0;
  float yvel = .005; //velocidade noise y
  float yacc; //aceleração noise y
  // Random seed to control randomness while drawing the tree
  int seed = 5;
  float posicaoVariavel;
  public NuvemDePontos nuvemPontos;
  float amorteceorMov = 1; //controla a movimentacao
  public ArrayList <PVector> nuvemPontosUser ;

  Cenario02(PApplet _p5, float angX, float angY, float angZ, int radEsfera, String _nome) {
    super(angX, angY, angZ, radEsfera, _nome);
    p5 = _p5;
    posIni = new PVector (0, 200, -300);//190
    nuvemPontos = new NuvemDePontos(p5);
    nuvemPontosUser = new ArrayList <PVector>();
  }
  public void resetCenario(){
    posIni = new PVector (0, 200, -300);
  }
  void drawCenario() {
    //     float z = map(mouseX, 0, width, -2000, 2000 );
    //     println("z: " + z);
    p5.translate(posIni.x, posIni.y, posIni.z ); //posIni.y
    //Se "vernuvemPon.." foi definida como true por Modelo3D, desenha a nuvem de pontos do usuario
    if (verNuvemPontosUser) {
      nuvemPontos.desenhaEspalhadosCaindo();
      //     nuvemPontos.desenhaEspalhadosCaindoAoUsuario( );
      int cont = 0;
      p5.pushMatrix();
      p5.pushStyle();
      p5.translate(posicaoVariavel, - p5.height*.2, 0);
      p5.rotateY(PI*.5);
      nuvemPontos.desenhaPontosLinhas(.5);//nuvemPontos.desenhaPontos(.2); 
      p5.popStyle();
      p5.popMatrix();
    }
    p5.fill(255);//100,255,50);
    p5.stroke(255);//(100,255,50);

    // Move alogn through noise
    //    yacc = map(mouseX, 0, width, -.001,.01);
    //    println("mouseX: "+mouseX+" yacc: "+yacc);
    yvel += yacc;
    yvel= constrain(yvel, 0.001, .01);
    yoff += yvel; 
    yacc = 0;
    /*    randomSeed(seed);
     // Start the recursive branching!
     branch(60, 0);
     */
    //     amorteceorMov = map (mouseX, 0, width, 1,10);
    for (int a= 0; a < 35; a++) {

      p5.pushStyle();
      p5.pushMatrix();
      p5.randomSeed(seed*a*1000);
      p5.translate(p5.random(-p5.width*.2, p5.width*.2), 20, 0 );

      //   p5.scale(p5.random(.3, 2),p5.random(.3, 2),0);

      // Start the recursive branching!
      branch(p5.random(60, 140), 0); //branch(60, 0);
      p5.popMatrix();
      p5.popStyle();
    }
  }
  
  void ejecutaModificacoes () { //implementação de classe declarada na classe pai 'Cenario' | E chamada desde Modelo3D cada vez que tem novos dados
    //Modificações com o dado A
    posicaoVariavel  = aplicaModificacoesNoVal( valModificadoraA, -width*.18, width*.18);
    yacc = aplicaModificacoesNoVal( valModificadoraB, -.001, .1);
  }
  public void setNuvemPontosUser( ArrayList <PVector> npu ) {
    if (npu != null ) {
       if (npu.size() > 0 ) {
        //  println("nuvemPontosUser.size(): " + npu.size());
        if (nuvemPontosUser != null ) nuvemPontosUser.clear(); nuvemPontosUser.clear();
        for (PVector p : npu) {
          nuvemPontosUser.add( new PVector (p.x *.25, - p.y *.25, p.z *.25 ) );
        }
        nuvemPontos.setListaPontosUsuario(nuvemPontosUser);
        verNuvemPontosUser = true;
      }
    } else{
      verNuvemPontosUser = false;
    }
  }
  void branch(float h, float xoff) {
    // thickness of the branch is mapped to its length
    float sw = map(h, 2, 100, 1, 5);
    p5.strokeWeight(sw);
    // Draw the branch
    p5.line(0, 0, 0, -h);
    // Move along to end
    p5.translate(0, -h);

    // Each branch will be 2/3rds the size of the previous one
    h *= 0.7f;

    // Move along through noise space
    xoff += 0.1 ;

    if (h > 4) {
      // Random number of branches
      int n = int(p5.random(0, 5));
      for (int i = 0; i < n; i++) {

        // Here the angle is controlled by perlin noise
        // This is a totally arbitrary way to do it, try others!
        float theta = map(p5.noise(xoff+i, yoff), 0, 1, -PI/3, PI/3);
        if (n%2==0) theta *= -1;

        p5.pushMatrix();      // Save the current state of transformation (i.e. where are we now)
        p5.rotate(theta);     // Rotate by theta
        branch(h, xoff);   // Ok, now call myself to branch again
        p5.popMatrix();       // Whenever we get back here, we "pop" in order to restore the previous matrix state
      }
    }
  }
  //sem uso
  void desenhaLua() {
    p5.pushStyle();
    p5.pushMatrix();
    float pl = map ( getTempoLigado()%30000, 0, 30000, -width*.3, width*.3);
    p5.translate(pl, 0, 0 );
    p5.noStroke();
    p5.fill(255);
    p5.ellipse(0,0,20,20);
    p5.popMatrix();
    p5.popStyle();
  }
}

