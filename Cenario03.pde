class Cenario03 extends Cenario {
  PVector posIni;
  PApplet p5;
  
  ArrayList <Cenario03_Ser01> seres;
  
  Cenario03 (PApplet _p5, float angX, float angY, float angZ, int radEsfera, String _nome){
    super(angX, angY, angZ, radEsfera, _nome); //angulos que vāo determinar a posiçāo da cena segundo a esfera base.
    p5 = _p5;
    posIni = new PVector (0, 0, 0);
    seres = new ArrayList<Cenario03_Ser01>();
    for (int s = 0 ; s < 1 ; s++) {
      //seres.add( new Cenario03_Ser01 (p5, new PVector(random(-2*width, 2*width), random (0, height*5), random (-2*height, 2*height) ), s ) );
      seres.add( new Cenario03_Ser01 (p5, new PVector(0, 0, 0), s ) );
    }
  }
  
  public void drawCenario(){
    p5.pushMatrix();
    p5.pushStyle();
    p5.translate(posIni.x, posIni.y, posIni.z);
    p5.fill(0,255,0);
    for (Cenario03_Ser01 s : seres) {
      s.desenhaSer();
    }
    
    p5.popStyle();
    p5.popMatrix();
  }
  
}

