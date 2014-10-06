
class Cenario05 extends Cenario  {
  PApplet p5;
  PVector posIni;
  int cuantos = 8000;
  Pelo[] lista ;
  float radio;// = 200;
  float rx = 0;
  float ry =0;

  Cenario05 (PApplet _p5, float angX, float angY, float angZ, int _radEsfera, String _nome) {
    super(angX, angY, angZ, _radEsfera, _nome);
    p5 = _p5;  
    
    radio = _radEsfera;
    posIni = new PVector (0, p5.height*3, 0);

    lista = new Pelo[cuantos];
    for (int i = 0; i < lista.length; i++) {
      lista[i] = new Pelo(i);
    }
    p5.noiseDetail(3);
  }
  
  void drawCenario () {
//    float rxp = (p5.mouseX-(p5.width/2)) * 0.005;
//    float ryp = (p5.mouseY-(p5.height/2)) * 0.005;
//    rx = rx*0.9 + rxp*0.1;
//    ry = ry*0.9 + ryp*0.1;
    
    p5.translate(posIni.x, posIni.y, posIni.z);
   p5.stroke(255,0,0); p5.fill(0,255,20,100);
    p5.box( 40 ); 
     
    p5.stroke(255,0,0); p5.line(-p5.width*.5,0,0, p5.width*.5,0,0);
    p5.stroke(0,255,0); p5.line(0,-p5.width*.5,0, 0,p5.width*.5,0);
    p5.stroke(0,0,255); p5.line(0,0,-p5.width*.5, 0,0,p5.width*.5);
    p5.translate(0, radio, 0);
//    p5.rotateY(rx);
//    p5.rotateX(ry);
    p5.fill(0);
    p5.noStroke();
    p5.sphere(radio);
  
    for (int i = 0; i < lista.length; i++) {
      lista[i].dibujar();
    }
  }
  class Pelo  {
    float z = p5.random(-radio, radio);
    float phi = p5.random(TWO_PI);
    float largo = p5.random(1.15, 1.2);
    float theta = p5.asin(z/radio);
    float largoVariable;
    int id;
    int idVariacao; 

    Pelo(int _id) { // what's wrong with a constructor here
      id = _id;
      z = p5.random(-radio*.45, radio*.45);
      phi = p5.random (PI*1.45, PI*1.55);
      largo = p5.random(.9, 1); //el largo en relacion al radio de la esfera que contiene el pelo
      theta = p5.asin(z/radio);
    }

    void setLargoPeloVariable(float varPelo) {
      largoVariable = mapVar ( largo, varPelo); 
    }
    private float mapVar (float varLargo, float porcentajeCrecimento) {
      float var;
      var = varLargo + p5.abs ( varLargo * p5.map(porcentajeCrecimento, 0, 1, -.01, .01));
      return var;
    }
    void dibujar() {
//      z = -radio *.9f;
//      z = random(-radio, z);
//      theta = asin(z/radio);
    
      float off = (p5.noise(p5.millis() * 0.000006, p5.sin(phi))-0.005) * 0.3;
      float offb = (p5.noise(p5.millis() * 0.000007, p5.sin(z) * 0.0001)-0.5) * 0.3;
  
      float thetaff = theta+off;
      float phff = phi+offb;
      float x = radio * p5.cos(theta) * p5.cos(phi);
      float y = radio * p5.cos(theta) * p5.sin(phi);
      float z = radio * p5.sin(theta);
  
      float xo = radio * p5.cos(thetaff) * p5.cos(phff);
      float yo = radio * p5.cos(thetaff) * p5.sin(phff);
      float zo = radio * p5.sin(thetaff);
  
//      largoVariable = largo + largo * ( .001 * p5.cos(p5.frameCount * .1)  );// * (p5.sin(p5.millis() * .00005));
      float varTem = map (p5.frameCount * .001 % 1, 0, 1,0 , .001 );
      idVariacao = (int) p5.lerp( 0, id, varTem ); //id; 
      setLargoPeloVariable(p5.cos(idVariacao + p5.frameCount * .1));
      float xb = xo * largoVariable;
      float yb = yo * largoVariable;
      float zb = zo * largoVariable;
      
	p5.stroke(255);
	p5.point(xb, yb, zb);
      p5.strokeWeight(1);
      p5.beginShape(LINES);
      p5.stroke(0);
  //    vertex(x, y, z);
      p5.vertex(xo, yo, zo);
      p5.stroke(200, 150);
      p5.vertex(xb, yb, zb);
      p5.endShape();
    }
  }    
}
