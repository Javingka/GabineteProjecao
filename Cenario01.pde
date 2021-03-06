/* borboletas */
class Cenario01 extends Cenario {
  PVector posIni;
  PApplet p5;
  public boolean ctarget = false;//target of the logo
  ArrayList < Cenario01_Passaro > particleCollection;
  int particleNum = 800;
  float posicaoVariavel, posicaoVariavelZ;
  float posicaoPessoa;
  
  Cenario01(PApplet _p5, float angX, float angY, float angZ, int radEsfera, String _nome) {
    super(angX, angY, angZ, radEsfera, _nome); //angulos que vāo determinar a posiçāo da cena segundo a esfera base.
    p5 = _p5;
    posIni =  new PVector (0, 0, 0); //coloca o ponto 0,0,0 da animaçāo sobre a superficie da esfera

    particleCollection = new ArrayList < Cenario01_Passaro > ();

    for (int i=0; i<particleNum; i++) {
      particleCollection.add(new Cenario01_Passaro(p5, random(0, p5.width), random(0, p5.height), random (-p5.width, p5.width), 
      random(-2, 2), random(-2, 2), random(-2, 2) ));
  //    ((Cenario01_Passaro)particleCollection.get(particleCollection.size()-1)).ptarget = ctarget;
      particleCollection.get(particleCollection.size()-1).ptarget = ctarget;
    }
  }
  public void resetCenario(){
/*    posIni =  new PVector (0, 0, 0);
    particleCollection.clear();*/
    if ( particleCollection != null) {
      for (int i=0; i<particleNum; i++) {
   /*     particleCollection.add(new Cenario01_Passaro(p5, random(0, p5.width), random(0, p5.height), random (-p5.width, p5.width), 
        random(-2, 2), random(-2, 2), random(-2, 2) ));
        ((Cenario01_Passaro)particleCollection.get(particleCollection.size()-1)).ptarget = ctarget;
      */  
        particleCollection.get(i).setNovaPos( random(0, p5.width), random(0, p5.height), random (-p5.width, p5.width) );
      }
    }
  }
  public void setPos(PVector np) {
    posIni = np;
  }
  void drawCenario() {

    // p5.pushMatrix();
    p5.translate(posIni.x + posicaoVariavel , posIni.y, posIni.z );
// println("posicaoVariavel: " + posicaoVariavel );
    //  p5.pointLight(200, 200, 200, 0, 0, 0); LUZ
    //  float var = sin (frameRate * .01);
    //  p5.fill(255,255,0); p5.noStroke();
    //  p5.sphere(10);
    //  p5.fill(127 + (127 * var ), 200); 
    //  p5.sphere(50);   
    // run
    for (int i=0; i<particleCollection.size (); i++) {
//      Cenario01_Passaro myParticle = (Cenario01_Passaro) particleCollection.get(i);
        Cenario01_Passaro myParticle = particleCollection.get(i);
        float ajusteVarPas = constrain(map(valModificadoraB, 0,1,-.5,1), 0,1);
        myParticle.run(ajusteVarPas); //valModificadoraB);
    }

    //  p5.popMatrix();
    // the big switch
  }
  void cambiaTarget() {
    ctarget = !ctarget;
    for (int i=0; i<particleCollection.size (); i++) {
//      Cenario01_Passaro myParticle = (Cenario01_Passaro) particleCollection.get(i);
      Cenario01_Passaro myParticle = particleCollection.get(i);
      myParticle.mudaTarget();
    }
  }
  void ejecutaModificacoes () { //implementação de classe declarada na classe pai 'Cenario' | E chamada desde Modelo3D cada vez que tem novos dados
    //Modificações com o dado A
    posicaoVariavel  = aplicaModificacoesNoVal( valModificadoraA, -width*.2, width*.2);
    posicaoVariavelZ = aplicaModificacoesNoVal( valModificadoraC, -width*.2, width*.2);
/*    println("valModificadoraB: " + valModificadoraB);
    for (int i=0; i<particleCollection.size (); i++) {
        Cenario01_Passaro myParticle = (Cenario01_Passaro) particleCollection.get(i);
        if (valModificadoraB > .9) {
          myParticle.mudaTarget();
          myParticle.MudaFormacao(1);
        } else {
          myParticle.MudaFormacao(0);
        }
    }*/
    
    //Modificações com o dado B
 /*   if ( valModificadoraC < .01) {
      cambiaTarget();
    }*/
      
    //Modificações com o dado C
  }
}

