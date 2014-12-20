class Arvore {
  float largoRama;
  float angulo;
  int nivelRecursivo;
  GGP GlobalPos;
  PApplet p5;
  PVector posAr;
  int indexPosicoes;
  
  public Arvore(PApplet _p5,  PVector pos) {
    p5 = _p5;
    largoRama = 200;
    GlobalPos = new GGP();
    posAr = pos;
    nuevoAr();
    indexPosicoes = 0;
  }
  
  public PVector getNextArvorePos(){
    PVector resp = GlobalPos.getSpecificPos(indexPosicoes);
    resp.add(posAr);
    indexPosicoes++;
    if (indexPosicoes >= GlobalPos.getCantPos() ) {
      indexPosicoes = 0;
    }
    return resp;
  }
  public void desenha() {
//    largoRama = map(p5.mouseX, 0,width, 0,250);
//    nuevoAr();
    p5.noFill();
    p5.pushMatrix();
    p5.stroke(255);
    
    posAr.y = map(p5.mouseX, 0,width, 0,250);
    println("posAr.y: " + posAr.y);
    p5.translate (posAr.x, posAr.y, posAr.z);
    //  newPos (width/2, height*.9, 0);
    p5.line (0, 0, 0, -largoRama);
    p5.rotate(0);
    p5.translate (0, -largoRama);
    ArrayList <PVector> al = GlobalPos.getListaPos();
    for ( PVector p : al) {
      p5.stroke(255,0,255);
      p5.strokeWeight(5);
      p5.point(p.x, p.y);
    }
    p5.popMatrix();
  }
  void nuevoAr() {
    p5.randomSeed(50);
    nivelRecursivo=0;
    GlobalPos.update();
    GlobalPos.newPos (0, -largoRama, 0, nivelRecursivo);
    rama(largoRama);
  }
  void rama (float lrama) {
    //  fill(0); text ("N: "+nivelRecursivo, 0,0); noFill();
    nivelRecursivo++;

    if (lrama > 30) {
      lrama = lrama * .66;
      p5.pushMatrix();
      float aa= p5.random(-PI*.25, PI*.25); //PI*.25;//
      p5.rotate (aa);
      p5.line (0, 0, 0, -lrama);
      p5.translate (0, -lrama);
      GlobalPos.newPos (0, -lrama, aa, nivelRecursivo);
      p5.ellipse (0, 0, 30, 30);
      rama (lrama);
      p5.popMatrix();

      p5.pushMatrix();
      p5.rotate (-aa);
      p5.line (0, 0, 0, -lrama);
      p5.translate (0, -lrama);
      GlobalPos.newPos (0, -lrama, -aa, nivelRecursivo);
      p5.ellipse (0, 0, 30, 30);
      rama (lrama);
      p5.popMatrix();
    }
    nivelRecursivo--;
  }
  class GGP {
    ArrayList <PVector> posiciones;
    ArrayList <Float> angulosIn;  
    ArrayList <PVector> posDinamicaNivel;

    GGP () {
      posiciones = new ArrayList <PVector>();
      angulosIn = new ArrayList <Float>();
      posDinamicaNivel = new ArrayList <PVector>();
    }

    public ArrayList <PVector> getListaPos( ) {
      return posiciones;
    }
    public int getCantPos(){
      return posiciones.size(); 
    }
    public PVector getSpecificPos(int index) {
      return posiciones.get(index);
    }
    void update() {
      posiciones.clear();
      angulosIn.clear();
      posDinamicaNivel.clear();
    }

    void seePos(float px, float py) {
      p5.pushMatrix();
      p5.translate (px, py);
      int t=0; 
      p5.textAlign(CENTER, CENTER);
      for (PVector p : posiciones) { 
        p5.noFill();
        p5.stroke(255, 0, 0);
        p5.ellipse (p.x, p.y, 20, 20);
        if (t == frameCount%posiciones.size() ) { 
          p5.fill (0, 0, 255); 
          p5.text (t, p.x, p.y);
        }
        t++;
      }
      p5.popMatrix();
    }

    void newPos (float nuevoX, float nuevoY, float ang, int nivelRec) {
      p5.fill(0); 
      p5.text ("N: "+nivelRec, 0, 0); 
      p5.noFill();
      float anguloUso=0;

      if (angulosIn.size() == 0) {
        angulosIn.add(nivelRec, ang);
      } else {
        float angP = angulosIn.get(nivelRec-1);
        ang+=angP;
        if (angulosIn.size()>nivelRec)
          angulosIn.remove(nivelRec); 

        angulosIn.add(nivelRec, ang);
        anguloUso=angulosIn.get(nivelRec);
      }

      float angBase = atan2(nuevoY, nuevoX);
      float hipo = sqrt(pow(nuevoX, 2) + pow(nuevoY, 2));
      float nx = hipo*cos(anguloUso+angBase);//angulo+angBase);
      float ny = hipo*sin(anguloUso+angBase);//angulo+angBase);
      PVector nuevo = new PVector (nx, ny);

      int i = nivelRec-1; 
      if (posDinamicaNivel.size() == nivelRec) {
        posDinamicaNivel.add(nuevo);
        //     println("nive: "+nivelRec+" posDinamicaNivel: "+posDinamicaNivel);
      } else {
        //    println ("i: "+i+" nive: "+nivelRec+" posDinamicaNivel: "+posDinamicaNivel);
        PVector t = posDinamicaNivel.get(i);
        PVector n = new PVector (nuevo.x+t.x, nuevo.y+t.y);
        posDinamicaNivel.remove(i+1);
        posDinamicaNivel.add(i+1, n);
      } 

      if (posiciones.size()==0) {
        posiciones.add(nuevo);
      } else {
        PVector t = posDinamicaNivel.get(i);//posiciones.size()-1);
        nuevo.add(t);
        posiciones.add(nuevo);
      }
    }
  }
}

