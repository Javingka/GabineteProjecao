static int CONTADOR;

class Cenario01_Passaro {
  PApplet p5;
  // declare global variables
  public boolean ptarget = false;
  int id_par;
  PShape logo;

  float xpos;
  float ypos;
  float zpos;

  float _xpos;
  float _ypos;
  float _zpos;

  float xspeed;
  float yspeed;
  float zspeed;

  float x;//left wing flapping x
  float x2;//right wing flapping x
  float y;//wings flapping y
  float px, py, pz;//updated location of particle
  float easing = random(.02, .07);//easing acceleration controller
  float m_wingspeed ;//wingflapping speed
  float m_speed;
  PVector ang; //conteim os angulos que definen o vetor de velocidade, permite digiruir o elemento passaro
  float wfran;
  Vec3D velocidade; //vector de toxiclibs
  float diametroTunelPassaros;
  float dia;//diameter of the firefly
  PMatrix3D matrixPassaro; //Matrix para as coordenadas de giro do puntero de visualizacao
  Quaternion quaternionPassaro;
  PVector posRefPassaro; //Pos de referenca para girar PVector segundo a matrix
  PVector posQuaternionPassaro; //PVector com a posicao definida pelo quaternion
  // constructor
  Cenario01_Passaro(PApplet _p5, float _xpos, float _ypos, float _zpos, float _xspeed, float _yspeed, float _zspeed) {
    p5 = _p5;
    id_par = CONTADOR;
    CONTADOR++;
    p5.shapeMode(CENTER);
    velocidade = new Vec3D();
    ang = new PVector();
    //   logo = loadShape("LOGO2.svg");

    xpos = _xpos;
    ypos = _ypos;
    zpos = _zpos;

    xspeed = _xspeed;
    yspeed = _yspeed;
    zspeed = _zspeed;

    dia = 400;
    matrixPassaro = new PMatrix3D();
    quaternionPassaro = new Quaternion();
    posRefPassaro = new PVector(0, 1, 0);
    posQuaternionPassaro = new PVector();
  }

  // functionalities
  void run(float variacao) {
    update(variacao);
    display();
    bounce();
  }



  //spreading the array of particles
  void update( float variacao ) {
    //import from mouse targetted file
    //changing the target of the particle 
    if (ptarget) { //se a particula tem um objetivo 
      xpos += xspeed;
      ypos += yspeed;
      zpos += zspeed;
    } else { //Se a particula 
      xpos += xspeed;
      ypos += yspeed;
      zpos += zspeed;

      diametroTunelPassaros = height * variacao;
      //definem o diametro da figura circular dos passaros
      float targetX = sin (id_par + frameCount * .01) * diametroTunelPassaros;
      float targetY = cos (id_par + frameCount * .01) * diametroTunelPassaros;
      float targetZ = sin (id_par + frameCount * .01) * diametroTunelPassaros;

      xpos += (targetX - xpos) * easing; // pos deseada - pos atual * um amortecedor
      ypos += (targetY - ypos) * easing;
      zpos += 0;//(targetZ - zpos) * easing;
  } 

  //motion of the particle

  float speed = dist(px, py, pz, xpos, ypos, zpos); //diferenca entra posicao anterior e a atual
  velocidade = new Vec3D ( px - xpos, py - ypos, pz - zpos); 

  //  println(speed);
  m_speed = map(speed, 0, 20, 0.05, 0.1);
  m_wingspeed = map(speed, 0, 20, 3, 1);

  //wingtip motion
  float angle = frameCount/m_wingspeed;  //keep the point so it forces float mode!
  //wingtip points
  //wfran= random(2);
  x=  map(sin(angle), -1, 1, 113, 202);
  x2 = map (sin(angle), -1, 1, -111, -202);
  y=  map(sin(angle), -1, 1, 71, 125);

  //modifiers of the constructed logo
  //  ang.x = atan2(py-ypos, px-xpos);
  ang.x = 0;//atan2(velocidade.y, velocidade.z);
  ang.y= 0;//atan2(velocidade.z, velocidade.x);
  ang.z = atan2(velocidade.y, velocidade.x);

  px = xpos;
  py = ypos;
  pz = zpos;
}


void display() {

  p5.pushMatrix();
  //  float aa = map(mouseX, 0, width, 0, PI);
  //    float aaa = map(mouseY, 0, height, 0, PI);
  //  p5.rotateX(PI*1.5);//1.6);
  //  p5.rotateY(PI*.25);

  velocidade.normalize();
  //velocidade = new Vec3D(0,0,5);
  p5.translate(xpos, ypos, zpos);


  //  p5.ellipse(0,0,2,2);
  //  p5.stroke(0,255,0,100);

  //  p5.line(0,0,0, velocidade.x*9,velocidade.y*9,velocidade.z*9);

  //  p5.stroke(0,255,0);
  //  p5.line(0,0,0, 0,30,0); //linha no eiso Y

  velocidade = velocidade.toSpherical(); //x = radius y = azimuth z = theta

  float x = cos(velocidade.y)*sin(velocidade.z)*(velocidade.x);
  float y = cos(velocidade.z)*(velocidade.x);
  float z = sin(velocidade.y)*sin(velocidade.z)*(velocidade.x);

  // float ax = velocidade.headingYZ();
  // float ay = velocidade.headingXZ();// -PI*.5;
  // float az = velocidade.headingXY() - PI*.5;// -PI*.5;
  p5.rotateX ( x);
  p5.rotateY ( y);
  p5.rotateZ ( z);
  //  println("velocidade: " + velocidade);
  /*  PMatrix3D matrixPassaro = new PMatrix3D();
   PVector posicaoTempPass = new PVector();
   Quaternion passaroQuat = new Quaternion();
   
   passaroQuat.set(velocidade);
   matrixPassaro.reset();
   matrixPassaro.set(passaroQuat.getMatrix());
   p5.applyMatrix(matrixPassaro);
   */
  //  velocidade.normalize();
  //  quaternionPassaro.set(velocidade);
  //  quaternionPassaro.mult(posRefPassaro, posQuaternionPassaro); 
  //  p5.rotateX ( ang.x );
  //  p5.rotateY ( ang.y );
  //  p5.rotateZ ( ang.z );
  //  p5.applyMatrix(quaternionPassaro.getMatrix());

  /*  p5.stroke(255,0,0); p5.line(0,0,0, 20,0,0);//posQuaternionPassaro.x*10,posQuaternionPassaro.y*10,posQuaternionPassaro.z*10); //linha no eiso Y
   p5.stroke(0,0,255); p5.line(0,0,0, 0,0,20);
   p5.stroke(0,255,0); p5.line(0,0,0, 0,20,0);*/

  p5.scale(m_speed);
  //shape(logo, 0, 0, dia, dia);

  //properties of the wings
  p5.fill(255);//51, 51, 51);
  p5.noStroke();

  //wing right
  p5.beginShape();
  p5.vertex(63, -1);
  p5.vertex(162, -59);
  p5.vertex(x, y);
  p5.vertex(25, 177);
  p5.vertex(25, 75);
  p5.endShape();

  //wing left
  p5.beginShape();
  p5.vertex(-63, -1);
  p5.vertex(-162, -59);
  p5.vertex(x2, y);
  p5.vertex(-25, 177);
  p5.vertex(-25, 75);
  p5.endShape();

  p5.popMatrix();
}

public void changeTarget() {
  ptarget = !ptarget;
}

void bounce() {
  if (xpos < 5 || xpos > width-5) {
    xspeed = xspeed*-1;
  }
  if (ypos < 5 || ypos > height-5) {
    yspeed = yspeed*-1;
  }
}
}
