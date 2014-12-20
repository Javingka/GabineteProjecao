/** Final */
class Cenario05 extends Cenario {
  PApplet p5;
  PVector posIni, posA, posB, posTrans;
  float w, h;
  float rx = 0;
  float ry =0;
  Arvore arvore;
  ArrayList<PontoMovil> pontosP;
  float yoff = 0;
  int contadorvoltas;
  int cantPassaros;
  
  Cenario05 (PApplet _p5, float angX, float angY, float angZ, int _radEsfera, String _nome) {
    super(angX, angY, angZ, _radEsfera, _nome);
    p5 = _p5;  

    posIni = new PVector (0, 0, -300);
    float scaledim = .5;
    w = width * scaledim;
    h = height * scaledim;
    posA = new PVector(-w/2, 0, 0);
    posB = new PVector(w+w/2, 0, 0);
    posTrans = new PVector(posA.x, posA.y, posA.z);

    //  arvore = new Arvore( p5, new PVector(0,0,0));
    contadorvoltas=0;
    cantPassaros = 25;
    pontosP = new ArrayList<PontoMovil>();
    for (int pp=0; pp < cantPassaros; pp++) {
      pontosP.add( new PontoMovil ( random(-posB.x, posA.x), 0, 0, pp ) );  // ) );
    }
  }
  void resetCenario() {
    posTrans = new PVector(posA.x, posA.y, posA.z);
    contadorvoltas=0;
    pontosP.clear();
    for (int pp=0; pp < cantPassaros; pp++) {
      pontosP.add( new PontoMovil ( random(-posB.x, posA.x - 300), 0, 0, pp ) );  // pp * 4) );
    }
  }
  void drawCenario () {
    p5.pushMatrix();
    p5.pushStyle();
    p5.sphereDetail(2);
    p5.rectMode(CENTER);

    p5.translate(posIni.x, posIni.y, posIni.z);

/*    p5.noFill();
    p5.stroke(255, 0, 0);
    //    p5.fill(255,0,0);
    p5.rect(0, 0, w, h);
    //    p5.fill(0,255,0);
    p5.rect(w, 0, w, h);*/

    p5.scale( 1 + (cos (frameCount * .008))* -.05 ); //da um ir e venir
    //   arvore.desenha();
    float xoff =0;
    int c = 0;
    float wi=w/10; //radio para o circulo
    float wa = TWO_PI / cantPassaros; //angulo
    for ( PontoMovil pm : pontosP) {
      float v = noise(xoff+c, yoff);
      PVector sp = new PVector();
      if (contadorvoltas < 1) {
        PVector intensiadForcas = new PVector(3,1,1); //separa, alinha, coesao
        sp = PVector.add(pm.posicao, new PVector(1*v, 0, 0));//20*v  
        pm.aplicaForca(pm.seek( sp ) );
        pm.rolar(pontosP, intensiadForcas);
      } else { //ficam num pontp
        PVector intensiadForcas = new PVector(1,1,1); //1.5,1,1
        sp = new PVector (posB.x*.8 + (wi * cos(wa*c)), posB.y*.8 + (wi * sin(wa*c)),0);//new PVector( posB.x*.8, posB.y*v, posB.z) ;//20*v
        pm.aplicaForca(pm.seek( sp ) );
        pm.rolar(pontosP, "comCor", intensiadForcas);
      }

      c++;
      xoff += 0.05;
    }
    yoff += 0.05;

    //    p5.fill(20,255,150);
    //    p5.ellipse(posTrans.x, posTrans.y, 5,5);
    p5.popMatrix(); 
    p5.popStyle();

    if (posTrans.x >= posB.x) {
      posTrans.x = posA.x;
      contadorvoltas++;
//      println("contadorvoltas: " + contadorvoltas);
    }
    posTrans.add(new PVector(2.5, 0, 0));
  }

  class PontoMovil {
    public PVector posicao;
    PVector velocidade;
    PVector aceleracao;
    float radio;
    float maxForca;    // máxima steering force
    float maxVel;    // velocidade máxima
    float separacaoDesejada = 150.0f;
    float distanciaVizinha = 150;
    int baseTempo;
    float velAsa;
    int id;

    PontoMovil (float x, float y, float z, int _id) {
      aceleracao = new PVector(0, 0, 0);
      velocidade = new PVector(p5.random(-1, 1), p5.random(-1, 1), p5.random(-1, 1));
      posicao = new PVector(x, y, z);
      radio = 3.0;
      maxVel = 2;
      maxForca = 0.05;//05;
      id  = _id;
    }

    public void rolar (ArrayList<PontoMovil> outrosPontos, PVector intensiadForcas) { //el comportamento de cada ponto depende dos outros
      nuvem(outrosPontos, intensiadForcas);
      atualiza();
      //    fronteiras();
      desenho();
      baseTempo= millis();
    }
    public void rolar (ArrayList<PontoMovil> outrosPontos, String comcor, PVector intensiadForcas) { //el comportamento de cada ponto depende dos outros
      nuvem(outrosPontos, intensiadForcas);
      atualiza();
      //    fronteiras();
      desenho(60000);
    }
    public void rolar () { //el comportamento de cada ponto depende dos outros
      atualiza();
      //    fronteiras();
      desenho();
    }
    //Se calcula a aceleração do ponto na nuvem em cada novo frame influenciado pelo grupo de pontos
    void nuvem(ArrayList<PontoMovil> outrosPontos, PVector intensiadForcas) {
      PVector sep = separacao(outrosPontos);   // Separação do ponto
      PVector ali = alinhamento(outrosPontos);      // Alinhamento
      PVector coe = coesao(outrosPontos);   // Coesão
      // estas forças têm definido arbitrariamente pesos
      sep.mult(intensiadForcas.x);//1.5);
      ali.mult(intensiadForcas.y);
      coe.mult(intensiadForcas.z);
      // as forças são aplicadas na aceleração do ponto
      aplicaForca(sep);
      aplicaForca(ali);
      aplicaForca(coe);
    }

    // atualiza a posição do ponto
    void atualiza() {
      velocidade.add(aceleracao); //muda velocidade
      velocidade.limit(maxVel); //limita a velocidade no máximo definido
      posicao.add(velocidade); //desloca a posição segundo a velocidade
      aceleracao.mult(0); //acceleração volta a cero para se atualizar em cada novo frame

      if (posicao.x >= posB.x) {
        posicao.x = posA.x;
      }
    }

    void fronteiras() {
      if (posicao.x < -radio) posicao.x = velocidade.x *-1; // width+r;
      if (posicao.y < -radio) posicao.y = velocidade.y *-1; // height+r;
      if (posicao.x > width+radio) posicao.x = velocidade.x *-1; //posicao.x = -r;
      if (posicao.y > height+radio) posicao.y = velocidade.y *-1; //posicao.y = -r;
    }

    void desenho() {
      // Draw a triangle rotated in the direction of velocity
      float theta = velocidade.heading2D() + radians(90);
 //     p5.fill(255);
      int corP = color(255);
      p5.stroke(255);
      p5.strokeWeight(1);
      p5.pushMatrix();
      p5.translate(posicao.x, posicao.y, posicao.z);
      //    p5.ellipse(0, 0, radio, radio);
      p5.rotate(theta);
    // drawPass(corP);
      drawPass02(corP);
      /*      p5.beginShape(TRIANGLES);
       p5.vertex(0, -radio*2);
       p5.vertex(-radio, radio*2);
       p5.vertex(radio, radio*2);
       p5.endShape();*/
      p5.popMatrix();
    }
    void desenho(int tempo) {
      int tempoFim = baseTempo + tempo;
      float valCor = map ( millis(), baseTempo, tempoFim, 255, 0);
      // Draw a triangle rotated in the direction of velocity
      float theta = velocidade.heading2D() + radians(90);
   //   p5.fill(255, 255, valCor, valCor);//(255-valCor, 0, 255-valCor, valCor);
      int corP = color (255, 255, valCor, valCor);
      p5.stroke(255, valCor, valCor, valCor);
      p5.strokeWeight(.5);
      p5.pushMatrix();
      p5.translate(posicao.x, posicao.y, posicao.z);
      // p5.ellipse(0, 0, radio, radio);
      p5.rotate(theta);
     // drawPass(corP);
       drawPass02(corP);
      /*      p5.beginShape(TRIANGLES);
       p5.vertex(0, -radio*2);
       p5.vertex(-radio, radio*2);
       p5.vertex(radio, radio*2);
       p5.endShape();*/
      p5.popMatrix();
    }
    void aplicaForca (PVector forca) {
      // We could add mass here if we want A = F / M
      aceleracao.add(forca);
    }
    //Evalua a cercania dos potos e os separa quando estiver muto próximos
    PVector separacao (ArrayList<PontoMovil> outrosPontos) {

      PVector separacaoCalculada = new PVector(0, 0, 0);
      int count = 0;

      // Evalua se algum dos outros pontos estiver muito perto
      for (PontoMovil outro : outrosPontos) {
        float d = PVector.dist(posicao, outro.posicao);
        // Se a distancie é maior do que 0 e menor que a quantidade definida.
        if ((d > 0) && (d < separacaoDesejada)) {
          // calcula o novo vetor que vai distanciar o ponto atual com o outro ponto próximo
          PVector diff = PVector.sub(posicao, outro.posicao);
          diff.normalize(); //normaliza ficamdo um vetor que indica direçao
          diff.div(d);        //o valor normalizado variado vai variar a forza da movimentação dependendo do perto que estiver o outro ponto
          separacaoCalculada.add(diff);
          count++;            // Keep track of how many
        }
      }
      // Media -- divição segundo a quantidade de pontos que tinha perto o ponto atual em evaluação
      if (count > 0) {
        separacaoCalculada.div((float)count);
      }

      // Se o vetor é maior do que 0.
      if (separacaoCalculada.mag() > 0) {
        // Implementa Reynolds: separação = desejado - velocidade; (Steering = Desired - Velocity)
        separacaoCalculada.normalize();
        separacaoCalculada.mult(maxVel); //aqui o vetor tem o valor desejado
        separacaoCalculada.sub(velocidade); //se resta a velocidade
        separacaoCalculada.limit(maxForca); //se limita a força
      }
      return separacaoCalculada;
    }

    // Alinhamento
    // Calcula uma media de velocidade entre os pontos vizinhos
    PVector alinhamento (ArrayList<PontoMovil> outrosPontos) {

      PVector sum = new PVector(0, 0, 0);
      int count = 0;
      for (PontoMovil outro : outrosPontos) {
        float d = PVector.dist(posicao, outro.posicao);
        if ((d > 0) && (d < distanciaVizinha)) {
          sum.add(outro.velocidade);
          count++;
        }
      }
      if (count > 0) {
        sum.div((float)count);
        sum.normalize();
        sum.mult(maxVel);
        PVector steer = PVector.sub(sum, velocidade);
        steer.limit(maxForca);
        return steer;
      } else {
        return new PVector(0, 0, 0);
      }
    }

    // Coesão
    // Para uma posição media de todos os pontos cercanos, calcula steering vetos entre as posições
    PVector coesao (ArrayList<PontoMovil> outrosPontos) {
      PVector sum = new PVector(0, 0, 0);   // Start with empty vector to accumulate all locations
      int count = 0;
      for (PontoMovil outro : outrosPontos) {
        float d = PVector.dist(posicao, outro.posicao);
        if ((d > 0) && (d < distanciaVizinha)) {
          sum.add(outro.posicao); // Add location
          count++;
        }
      }
      if (count > 0) {
        sum.div(count);
        return seek(sum);  // Dirijam-se a localização
      } else {
        return new PVector(0, 0, 0);
      }
    }

    // Calcula e aplica uma forza de direção (Steering force) hacie um objetivo
    // STEER = DESIRED MINUS VELOCITY
    PVector seek(PVector objetivo) {
      PVector desejado = PVector.sub(objetivo, posicao);  // A vector pointing from the location to the target
      // Normalize desired and scale to maximum speed
      desejado.normalize();
      desejado.mult(maxVel);
      // Steering = Desired minus Velocity
      PVector steer = PVector.sub(desejado, velocidade);
      steer.limit(maxForca);  // Limit to maximum steering force
      return steer;
    }
    void drawPass(int corP) {
      float len = 10;
      p5.pushMatrix();
      p5.rotateX(PI*.5);
      int count = frameCount;
      p5.rotateZ(TWO_PI * noise(yoff)*.2);//id+count*.05);

      p5.fill(corP);
      p5.pushMatrix();
      p5.translate(0, 0, 22);
      p5.rotateY(-PI*.5);
      //      for (int i=0; i<2; i++) {
      p5.pushMatrix();
      p5.translate(1, 0);//sin(count*0.0001) );
      p5.scale(2, 0.4);
      p5.sphere(2);
      p5.popMatrix();
      //     }
      p5.popMatrix();

      float accAsa = map(mouseX, 0, width, 0, 10);
      velAsa += accAsa;
      int c1=0;
      p5.beginShape();
      p5.vertex(0, 0, 21);
      p5.bezierVertex(0, 0, 21, 0, 0, 2, 0, 0, 2);
      int q = 7;
      //    println("q: " + q);    
      float angle = cos(radians(len-q + velAsa )+ id) * q*8;    
      float x = sin(radians(-90-angle))*(q*3);
      float y = cos(radians(-90-angle))*(q*3);

      p5.bezierVertex(x/2, y/2, q*2, x/2, y/2, q*2, x, y, q*1);
      p5.bezierVertex(x/2, y/2, q*2, x/2, y/2, q*2, 0, 0, 21);
      p5.endShape();
      p5.beginShape();
      p5.vertex(0, 0, 21);
      p5.bezierVertex(0, 0, 21, 0, 0, 2, 0, 0, 2);
      float x2 = cos(radians(-angle))*(q*3);
      float y2 = sin(radians(-angle))*(q*3);

      p5.bezierVertex(x2/2, y2/2, q*2, x2/2, y2/2, q*2, x2, y2, q*1);
      p5.bezierVertex(x2/2, y2/2, q*2, x2/2, y2/2, q*2, 0, 0, 21);
      p5.endShape();

      float mov = .5-(x*.1)/3; //ajusta da variavel para o movimento da cola, afeita o mov no eixo Y
      p5.bezier(0, 0, 0, -c1, 0, 0, -9+q, mov, -4+c1, -9+q, mov, -6+c1 );
      p5.bezier(0, 0, 0, c1, 0, 0, 9-q, mov, -4+c1, 9-q, mov, -6+c1 );
      velAsa+=3;
      p5.popMatrix();
    }
    void drawPass02(int corP) {
      float len = 10;
      p5.pushMatrix();
      p5.rotateX(PI*.5);
      int count = frameCount;
      p5.rotateZ(TWO_PI * noise(yoff)*.5);//id+count*.05);
      
      p5.pushMatrix();
      p5.translate(0, 0, 20);
      p5.rotateY(-PI*.5);
  //    for (int i=0; i<2; i++) {
        p5.pushMatrix();
        p5.translate(2, 0 +(sin(count*0.1)));
        p5.scale(2, 0.4);
        p5.sphere(2);
        p5.popMatrix();
   //   }
      p5.popMatrix();
      float accAsa = 10;//map(mouseX, 0, width, 0, 10);
      velAsa += accAsa;
      int c1=0;
      for (int q = 0; q < len; q++) {
        /* The angle is to make the movement */
        float angle = cos(radians(len-q + velAsa)+id) * q*5;
        /* Left wing */
        float x = sin(radians(-90-angle))*(q*3);
        float y = cos(radians(-90-angle))*(q*3);

        /* Right wing */
        float x2 = cos(radians(-angle))*(q*3);
        float y2 = sin(radians(-angle))*(q*3);

        /* The fill in the middle of the wings. More realistic view */
        p5.fill(corP,20+q*20);

        /* Right Wing */
        p5.bezier(0, 0, q*2, x/2, y/2, q*2, x/2, y/2, q*2, x, y, q*1);
        /* Left Wing */
        p5.bezier(0, 0, q*2, x2/2, y2/2, q*2, x2/2, y2/2, q*2, x2, y2, q*1);

        //cola
        /* Right Wing */
        float mov = .5-(x*.1)/3; //ajusta da variavel para o movimento da cola, afeita o mov no eixo Y
      //  p5.bezier(0, 0, 0, -c1, 0, 0, -9+q, mov, -4+c1, -9+q, mov, -6+c1 );
     //   p5.bezier(0, 0, 0, c1, 0, 0, 9-q, mov, -4+c1, 9-q, mov, -6+c1 );
        p5.line(0, 0, 0, -9+q, mov, -6+c1 );
        p5.line(0, 0, 0, 9-q, mov, -6+c1 );
        /* Left Wing */
        //   bezier(20, 0, q*2, x2/2, y2/2, q*2,  x2/2, y2/2, q*2,  x2, y2, q*1);
        c1++;
      }
      velAsa+=3;
      p5.popMatrix();
    }
  }
}

