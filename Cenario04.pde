//import peasy.*;
import toxi.geom.*;
import java.util.*;
class Cenario04 extends Cenario {
  /**--Variaveis de todo Cenario--*/
  PVector posIni;
  PApplet p5; //Objeto do tipo PApplet que vai pegar a clase pai de Processing

  /**--Variaveis proprias--*/
  Vec3D globalOffset, cameraCenter, avg; // avg - representa o vetor promedio de todos os vetores das particulas
  public float neighborhood, viscosity, speed, turbulence, cameraRate, rebirthRadius, spread, independence, dofRatio;
  public int n, rebirth;
  public boolean averageRebirth, paused;
  Vector particles;//Particulas que formam a nuvem
  Plane focalPlane;
  float[] camPosition;
  //  PeasyCam cam;

  PFrame f;
  secondApplet s;
  boolean temControl;

  Cenario04(PApplet _p5, float angX, float angY, float angZ, int _radEsfera, String _nome) {
    /**--Variaveis proprias--*/
    super(angX, angY, angZ, _radEsfera, _nome);
    p5 = _p5;
    posIni = new PVector (0, 0, -height*3);
    camPosition = new float[3];
    camPosition[0] = 0;
    camPosition[1] = 0;
    camPosition[2] = width;
    //    cam = new PeasyCam(p5, 1600);
    temControl = false;
    /**--Variaveis especiais--*/
    setParameters();
    avg = new Vec3D();
    globalOffset = new Vec3D(0, 1. / 3, 2. / 3);
    cameraCenter = new Vec3D();
    particles = new Vector();
    //Criacao das particulas
    for (int i = 0; i < n; i++)
      particles.add(new Particle());
  }
  Cenario04(PApplet _p5, float angX, float angY, float angZ, int _radEsfera, String _nome, String frame) {
    /**--Variaveis proprias--*/
    this(_p5, angX, angY, angZ, _radEsfera, _nome);
    f = new PFrame();
    temControl = true;
  }
 
  void ejecutaModificacoes () { //implementação de classe declarada na classe pai 'Cenario' | E chamada desde Modelo3D cada vez que tem novos dados
     //Modificações com o dado A
     
     //Modificações com o dado B
     speed = aplicaModificacoesNoVal( valModificadoraB, 0, 100);
     neighborhood = aplicaModificacoesNoVal( valModificadoraA, 1, 640);
//     independence = aplicaModificacoesNoVal( valModificadoraA, 0.0, 1.0);
     //Modificações com o dado C
     spread = aplicaModificacoesNoVal( valModificadoraC, 200, 50);
     viscosity = aplicaModificacoesNoVal( valModificadoraC, 0.0, 1.0);
  }
  public void setPosicaoCamara(PVector pos) {
    camPosition[0] = pos.x;
    camPosition[1] = pos.y;
    camPosition[2] = pos.z;
  }
  void drawCenario() {
//    p5.pushStyle();
 /*      if ( temControl && s.temEvento() ) {
      n = s.getN();
      dofRatio = s.getDofRatio();
      neighborhood = s.getNeighborhood();
      speed = s.getSpeed();
      viscosity = s.getViscosity();
      spread = s.getSpread();
      independence = s.getIndependence();
      rebirth = s.getRebirth();
      rebirthRadius = s.getRebirthRadius();
      turbulence = s.getTurbulence();
      cameraRate = s.getCameraRate();
      averageRebirth = s.getAverageRebirth();
      paused = s.getPaused();
    }  */ 
   
    avg = new Vec3D();
    for (int i = 0; i < particles.size (); i++) {
      Particle cur = ((Particle) particles.get(i));
      avg.addSelf(cur.position);
    }
    
    avg.scaleSelf(1. / particles.size());

    cameraCenter.scaleSelf(1 - cameraRate);
    cameraCenter.addSelf(avg.scale(cameraRate));

    p5.translate(-cameraCenter.x, -cameraCenter.y, -cameraCenter.z);
    float tempPosX = map (valModificadoraA, 0, 1, -width*3, 0);
    p5.translate(tempPosX, 0, 0);  
    //  float[] camPosition = cam.getPosition();
    //  println("camPosition: " + camPosition[0] + " " +  camPosition[1] + " " + camPosition[2]);
    focalPlane = new Plane(avg, new Vec3D(camPosition[0], camPosition[1], camPosition[2]));
  
    p5.noFill();
    p5.hint(DISABLE_DEPTH_TEST);
    
    for (int i = 0; i < particles.size (); i++) {
      Particle cur = ((Particle) particles.get(i));
      if (!paused)
        cur.update();
      cur.draw();
    }
    
    for (int i = 0; i < rebirth; i++)
      randomParticle().resetPosition();

    if (particles.size() > n)
      particles.setSize(n);
    while (particles.size () < n)
      particles.add(new Particle());

    globalOffset.addSelf(
    turbulence / neighborhood, 
    turbulence / neighborhood, 
    turbulence / neighborhood);
//    p5.popStyle();
  }
 
  
  Particle randomParticle() {
    return ((Particle) particles.get((int) random(particles.size())));
  }
  //import controlP5.*;
  public ControlP5 control;
  void setParameters() {
    n = 10000;
    dofRatio = 50;
    neighborhood = 10 ;
    speed = 24;
    viscosity = .16;
    spread = 100;
    independence = .15;
    rebirth = 0;
    rebirthRadius = 250;
    turbulence = 1.3;
    cameraRate = .1;
    averageRebirth = false;
  }
  void mudaNumero( float numIn) {
    n = int (map (numIn, 0, 1, 1000, 10000) );
  }
  void changeSpeed( float velIn) {
    speed = map (velIn, 0, 1, 0, 100);
  }
  void mudaEspalhamento( float espIn) {
    spread = map (espIn, 0, 1, 50, 200);
  }
  void mudaRebirthRadius(float redIn) {
    rebirthRadius = map (redIn, 0, 1, 1, width*3);
  }
  void mudaRebirth(float reIn) {
    rebirth = int ( map (reIn, 1, 0, 1, 100 ));
  }
  void mudaIndependence(float inIn) {
    independence = map (inIn, 0, 1, 1, 0 );
  }
  void mudaBairro(float baIn) {
    neighborhood = map (baIn, 0, 1, 1, width*2 );
  }
  void aplicaMudanca() {
    float tempPosX = map (p5.mouseX, 0, p5.width, -p5.width*2, p5.width*2);
    float y = map (p5.mouseY, 0, p5.height, 0, 1);
    //    float tZ =  posIni.z + (posIni.z*.5 * y);
    mudaNumero(y);
  }
  // ----------------------------------------------------------
  // CLASE "Particula" para usar no cenario.
  // ----------------------------------------------------------  

  Vec3D centeringForce = new Vec3D();

  class Particle {
    Vec3D position, velocity, force;
    Vec3D localOffset;
    Particle() {
      resetPosition();
      velocity = new Vec3D();
      force = new Vec3D();
      localOffset = Vec3D.randomVector();
    }
    void resetPosition() {
      position = Vec3D.randomVector();
      position.scaleSelf(random(rebirthRadius));
      if (particles.size() == 0)
        position.addSelf(avg);
      else
        position.addSelf(randomParticle().position);
    }
    void draw() {
      float distanceToFocalPlane = focalPlane.getDistanceToPoint(position);
      distanceToFocalPlane *= 1 / dofRatio;
      distanceToFocalPlane = constrain(distanceToFocalPlane, 1, 15);
      p5.strokeWeight(distanceToFocalPlane);
      p5.stroke(255, constrain(255 / (distanceToFocalPlane * distanceToFocalPlane), 1, 255));
      p5.point(position.x, position.y, position.z);
    }
    void applyFlockingForce() {
      force.addSelf(
      p5.noise(
      position.x / neighborhood + globalOffset.x + localOffset.x * independence, 
      position.y / neighborhood, 
      position.z / neighborhood)
        - .5, 
      p5.noise(
      position.x / neighborhood, 
      position.y / neighborhood + globalOffset.y  + localOffset.y * independence, 
      position.z / neighborhood)
        - .5, 
      p5.noise(
      position.x / neighborhood, 
      position.y / neighborhood, 
      position.z / neighborhood + globalOffset.z + localOffset.z * independence)
        - .5);
    }
    void applyViscosityForce() {
      force.addSelf(velocity.scale(-viscosity));
    }
    void applyCenteringForce() {
      centeringForce.set(position);
      centeringForce.subSelf(avg);
      float distanceToCenter = centeringForce.magnitude();
      centeringForce.normalize();
      centeringForce.scaleSelf(-distanceToCenter / (spread * spread));
      force.addSelf(centeringForce);
    }
    void update() {
      force.clear();
      applyFlockingForce();
      applyViscosityForce();
      applyCenteringForce();
      velocity.addSelf(force); // mass = 1
      position.addSelf(velocity.scale(speed));
    }
  }
  public class PFrame extends Frame {
    public PFrame() {

      setBounds(0, 0, 320, 240);//1200, 768);
      s = new secondApplet();
      add(s);
      s.init();
      show();
    }
  }
  public class secondApplet extends PApplet {
    int n = 10000;
    int dofRatio = 50;
    int neighborhood = 700;
    int speed = 24;
    float viscosity = .1;
    int spread = 100;
    float independence = .15;
    int rebirth = 0;
    int rebirthRadius = 250;
    float turbulence = 1.3;
    float cameraRate = .1;
    boolean averageRebirth = false;
    boolean paused = false;
    boolean event = false;

    public void setup() {
      size(320, 240);//(1200, 768, P3D);
      makeControls();
      //       noLoop();
    }

    public void draw() {

    }
    boolean temEvento() {
      if (event) {
        event = false;
        return true;
      }
      return event;
    }

    void controlEvent(ControlEvent theEvent) {
      event = true;
    }
    void makeControls() {
      control = new ControlP5(this);

      //  w = control.addControlWindow("controlWindow", 10, 10, 350, 140);
      //  w.hideCoordinates();
      //  w.setTitle("Flocking Parameters");

      int y = 0;
      control.addSlider("n", 1, 20000, n, 10, y += 10, 256, 9);//.setWindow(w);
      control.addSlider("dofRatio", 1, 200, dofRatio, 10, y += 10, 256, 9);//.setWindow(w);
      control.addSlider("neighborhood", 1, width * 2, neighborhood, 10, y += 10, 256, 9);//.setWindow(w);
      control.addSlider("speed", 0, 100, speed, 10, y += 10, 256, 9);//.setWindow(w);
      control.addSlider("viscosity", 0, 1, viscosity, 10, y += 10, 256, 9);//.setWindow(w);
      control.addSlider("spread", 50, 200, spread, 10, y += 10, 256, 9);//.setWindow(w);
      control.addSlider("independence", 0, 1, independence, 10, y += 10, 256, 9);//.setWindow(w);
      control.addSlider("rebirth", 0, 100, rebirth, 10, y += 10, 256, 9);//.setWindow(w);
      control.addSlider("rebirthRadius", 1, width, rebirthRadius, 10, y += 10, 256, 9);//.setWindow(w);
      control.addSlider("turbulence", 0, 4, turbulence, 10, y += 10, 256, 9);//.setWindow(w);
      control.addToggle("paused", false, 10, y += 11, 9, 9);//.setWindow(w);
      control.setAutoInitialization(true);
    }

    public int getN () {
      return n;
    }
    public int getDofRatio() {
      return dofRatio;
    }
    public int getNeighborhood() {
      return neighborhood;
    }
    public int getSpeed() {
      return speed;
    }
    public float getViscosity() {
      return viscosity;
    }
    public int getSpread() {
      return spread;
    }
    public float getIndependence() {
      return independence;
    }
    public int getRebirth() {
      return rebirth;
    }
    public int getRebirthRadius() {
      return  rebirthRadius;
    }
    public float getTurbulence() {
      return turbulence;
    }
    public float getCameraRate() {
      return cameraRate;
    }
    public boolean getAverageRebirth() {
      return averageRebirth;
    }
    public boolean getPaused() {
      return paused;
    }
  }
}

