//"Toroide"
class Cenario03 extends Cenario {
  PVector posIni;
  PApplet p5;
  
  ArrayList <Cenario03_Ser01> seres;
  float posicaoVariavel;
  
  Cenario03 (PApplet _p5, float angX, float angY, float angZ, int radEsfera, String _nome){
    super(angX, angY, angZ, radEsfera, _nome); //angulos que vāo determinar a posiçāo da cena segundo a esfera base.
    p5 = _p5;
    posIni = new PVector (0, 0, 0);
    seres = new ArrayList<Cenario03_Ser01>();
    for (int s = 0 ; s < 1 ; s++) {
      //seres.add( new Cenario03_Ser01 (p5, new PVector(random(-2*width, 2*width), random (0, height*5), random (-2*height, 2*height) ), s ) );
      seres.add( new Cenario03_Ser01 (p5, new PVector(0, 0, 0 ), s ) );
    }
  }
  
  public void drawCenario(){
    p5.pushMatrix();
    p5.pushStyle();
    p5.translate(posIni.x , posIni.y, posIni.z + posicaoVariavel );
    p5.fill(0,255,0);
    for (Cenario03_Ser01 s : seres) {
      s.desenhaSer();
    }
    p5.popStyle();
    p5.popMatrix();
  }
   void ejecutaModificacoes () { //implementação de classe declarada na classe pai 'Cenario' | E chamada desde Modelo3D cada vez que tem novos dados

     posicaoVariavel = aplicaModificacoesNoVal( valModificadoraC, -width, width);
     float val1 = aplicaModificacoesNoVal( valModificadoraC, 40.0, 120.0);
     float val2 = aplicaModificacoesNoVal( valModificadoraA, 0.0, 1.0);
     float val3 = aplicaModificacoesNoVal( valModificadoraB, 30.0, 40.0); //z:20
     for (Cenario03_Ser01 s : seres) {
        s.updateValores(val1, val2, val3);
     }
  }
}

