// Punktiert is a particle engine based and thought as an extension of Karsten Schmidt's toxiclibs.physics code. 
// This library is developed through and for an architectural context. Based on my teaching experiences over the past couple years. (c) 2012 Daniel Köhler, daniel@lab-eds.org

//here: global attractor force connected to mouse position

import punktiert.math.Vec;
import punktiert.physics.*;

class Cenario02 extends Cenario {
  PVector posIni; //posiçāo que representa o ponto 0,0,0 do cenario, considerando que a posiçāo incial 0,0,0 é na superficie da esfera
  PApplet p5; //Objeto do tipo PApplet que vai pegar a clase pai de Processing
  
  VPhysics physics; // world object
  BAttraction attr; // attractor
 
  // number of particles in the scene
  int amount = 300;
  float noiseCount;
  
  public Cenario02( PApplet _p5, float angX, float angY, float angZ, int radEsfera, String _nome){
    super(angX, angY, angZ, radEsfera, _nome); //angulos que vāo determinar a posiçāo da cena segundo a esfera base.
    p5 = _p5;
    p5.noStroke();
  
    posIni = new PVector (0, height/2, 0);
  //set up physics
    physics = new VPhysics();
    physics.setfriction(.4f);
  
    // new AttractionForce: (Vec pos, radius, strength)
    attr = new BAttraction(new Vec(width * .5f, height * .5f, height * .5f), 400, .1f);
    physics.addBehavior(attr);
  
    for (int i = 0; i < amount; i++) {
      // val for arbitrary radius
      float rad = random(2, 20);
      // vector for position
      Vec pos = new Vec(random(-width/2, width/2), random(-height/2, height/2 ), random(-height/2, height/2));
      // create particle (Vec pos, mass, radius)
      VParticle particle = new VParticle(pos, 4, rad);
      // add Collision Behavior
      particle.addBehavior(new BCollision());
      // add particle to world
      physics.addParticle(particle);
    }
  }
  
  public void drawCenario() {
    p5.pushMatrix();
    p5.pushStyle();
    p5.translate(posIni.x, posIni.y, posIni.z);
    p5.ambientLight(200, 200, 200);
    p5.noFill();
    p5.stroke(200, 0, 0);
    
    attr.setStrength(map(mouseX, 0, width, 0, 1));
    attr.setAttractor(new Vec(mouseX - width/2, mouseY - height/2));
    
    physics.update();
   // set pos to mousePosition
    p5.ellipse(attr.getAttractor().x, attr.getAttractor().y, attr.getRadius(), attr.getRadius());
  
    p5.noStroke();
    p5.fill(0, 255);
    float timer = TWO_PI;//frameCount*.1;
    float var = noise(noiseCount);
    noiseCount +=.01;
    float cont = 0;
    for (VParticle p : physics.particles) {
      //ellipse(p.x, p.y, p.getRadius() * 2, p.getRadius() * 2);
      p5.pushMatrix();
      p5.translate(p.x, p.y, p.z );
      p5.noFill();
      p5.strokeWeight(2);
      p5.stroke(255);
      p5.rectMode(CENTER);
        p5.rotateZ( noiseCount + cont);
        
        //ellipse(0,0, p.getRadius()+ var*20, p.getRadius()+ var*20) ;
        p5.rotateY(noiseCount + cont);
       // ellipse(0,0, p.getRadius()+ var*20, p.getRadius()+ var*20) ;
   //    rect(0,0, p.getRadius()+ var*20, p.getRadius()+ var*20) ;
        p5.rotateX(noiseCount + cont);
        //ellipse(0,0, p.getRadius()+ var*20, p.getRadius()+ var*20) ;
  //      rect(0,0, p.getRadius()+ var*20, p.getRadius()+ var*20) ;
      p5.rect(0,0, p.getRadius()+ 5, p.getRadius()) ;
      
      cont+=.1;
      //sphere(p.getRadius());
      p5.popMatrix();
    }
    p5.popStyle();
    p5.popMatrix();
 }
  
}
