
class Cenario05 extends Cenario  {
  PApplet p5;
  int cuantos = 4000;
  Pelo[] lista ;
  float radio;// = 200;
  float rx = 0;
  float ry =0;

  Cenario05 (PApplet _p5, float angX, float angY, float angZ, int _radEsfera, String _nome) {
    super(angX, angY, angZ, _radEsfera, _nome);
    p5 = _p5;  
    
    radio = _radEsfera;

    lista = new Pelo[cuantos];
    for (int i = 0; i < lista.length; i++) {
      lista[i] = new Pelo();
    }
    p5.noiseDetail(3);
  }
  
  void drawCenario () {
    float rxp = (p5.mouseX-(p5.width/2)) * 0.005;
    float ryp = (p5.mouseY-(p5.height/2)) * 0.005;
    rx = rx*0.9 + rxp*0.1;
    ry = ry*0.9 + ryp*0.1;
    
    p5.stroke(255,0,0); p5.fill(0,255,20,100);
    p5.box( 40 ); 
     
    p5.translate(0, radio, 0);
    p5.rotateY(rx);
    p5.rotateX(ry);
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
    float largo = p5.random(1.10, 1.15);
    float theta = p5.asin(z/radio);
  
    Pelo() { // what's wrong with a constructor here
      z = p5.random(-radio, radio);
      phi = p5.random(TWO_PI);
      largo = p5.random(1.01, 1.06);
      theta = p5.asin(z/radio);
    }

    void dibujar() {
      z = -radio *.9f;
      z = random(-radio, z);
      theta = asin(z/radio);
    
      float off = (p5.noise(p5.millis() * 0.0005, p5.sin(phi))-0.5) * 0.3;
      float offb = (p5.noise(p5.millis() * 0.0007, p5.sin(z) * 0.01)-0.5) * 0.3;
  
      float thetaff = theta+off;
      float phff = phi+offb;
      float x = radio * p5.cos(theta) * p5.cos(phi);
      float y = radio * p5.cos(theta) * p5.sin(phi);
      float z = radio * p5.sin(theta);
  
      float xo = radio * p5.cos(thetaff) * p5.cos(phff);
      float yo = radio * p5.cos(thetaff) * p5.sin(phff);
      float zo = radio * p5.sin(thetaff);
  
      float xb = xo * largo;
      float yb = yo * largo;
      float zb = zo * largo;
      
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
