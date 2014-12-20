class NuvemDePontos {
  private ArrayList <PVector> PontosFormaUsuario;
  private ArrayList <PVector> PontosEspalhados;
  private ArrayList <PVector> PontosEspalhadosVel;
  PApplet p5;
  boolean novosPontos = false;
  float yoff;
  int catPontosU = 1;
  
  public NuvemDePontos (PApplet _p5) {
    p5 = _p5;
    PontosFormaUsuario = new ArrayList <PVector>();
    PontosEspalhados = new ArrayList <PVector>();
    PontosEspalhadosVel = new ArrayList <PVector>();
    for (int pe=0; pe < 4000; pe++) {
      PontosEspalhados.add( new PVector (random(-width*.5, width*.5),random(-height*10,0), 0 ) );
      PontosEspalhadosVel.add( new PVector (random(-2,2),random(1,3), random(-5,5) ) );
    }
  }
  public void desenhaEspalhadosCaindo() {
   // println("PontosEspalhados.size(): " + PontosEspalhados.size() );
    float xoff=0;
    int c=0;
    for (PVector pm : PontosEspalhados) {
      float noiseM = noise (xoff, yoff);
      p5.stroke(255);
      p5.strokeWeight(3);
      p5.point(pm.x, pm.y, pm.z);
      pm.add(PontosEspalhadosVel.get(c));//new PVector( (.5-noiseM)*10 ,  , (.5-noiseM)*10 )); //
      if (pm.y > 0) {
        pm = new PVector (p5.random(-width*.5, width*.5),p5.random(-height*10,0), 0 );
        PontosEspalhadosVel.set (c, new PVector (p5.random(-5,5),p5.random(1,3), p5.random(-5,5)) ) ;
      }
      xoff+=.01;
      c++;
    }
    yoff+=.05;
  }
  public void desenhaEspalhadosCaindoAoUsuario( ) {
   // println("PontosEspalhados.size(): " + PontosEspalhados.size() );
    float xoff=0;
    int c=0;
    for (PVector pm : PontosEspalhados) {
      float noiseM = noise (xoff, yoff);
      p5.stroke(255);
      p5.strokeWeight(3);
      p5.point(pm.x, pm.y, pm.z);
      if (pm.y < -height *.6) {
        pm.add(PontosEspalhadosVel.get(c));
      } else if (PontosFormaUsuario != null && c < PontosFormaUsuario.size()-1) { 
        
        PVector objetivo = new PVector (PontosFormaUsuario.get(c).x,PontosFormaUsuario.get(c).y,PontosFormaUsuario.get(c).z) ;
        objetivo.sub(pm);
        objetivo.normalize();
        objetivo.mult(10);
        pm.add(objetivo);//new PVector( (.5-noiseM)*10 ,  , (.5-noiseM)*10 )); 
      }
      if (pm.y > 0) {
        pm = new PVector (p5.random(-width*.5, width*.5),p5.random(-height*10,0), 0 );
        PontosEspalhadosVel.set (c, new PVector (p5.random(-5,5),p5.random(1,3), p5.random(-5,5)) ) ;
      }
      xoff+=.01;
      c++;      
    }
    yoff+=.05;
  }
  public void desenhaPontosLinhas( float escada) {
    p5.stroke (255);
    int l =0;
    float separacaoDesejada = 100.0 * escada;
    for (PVector p : PontosFormaUsuario) {
      p5.strokeWeight(3);
      p5.point(p.x, p.y, p.z);
      p5.strokeWeight(2);
      
      for (PVector outro : PontosFormaUsuario) { //desenha linha
        float d = PVector.dist(p, outro);
        // Se a distancie é maior do que 0 e menor que a quantidade definida.
        if ((d > 0) && (d < separacaoDesejada)) {
          p5.stroke(map(d, 0, separacaoDesejada, 200, 100));
          p5.line(p.x, p.y, p.z, outro.x, outro.y, outro.z);
          l++;
        }
        if (l > 1000) {
          break;  
        }
      }
      p.sub(0, 1, 0);
    }
  }
  

  public void desenhaPontos( float escada) {
    p5.stroke (255);

    float separacaoDesejada = 100.0 * escada;
    for (PVector p : PontosFormaUsuario) {
      p5.strokeWeight(3);
      p5.point(p.x, p.y, p.z);
      p.sub(0, 1, 0);
    }
  }

  public void setListaPontosUsuario( ArrayList <PVector> novaListaPontos ) {
    novosPontos = true;

    PontosFormaUsuario.clear();
    for ( PVector p : novaListaPontos) {
      PontosFormaUsuario.add(new PVector (p.x, p.y, p.z));
    }
    
    catPontosU = PontosFormaUsuario.size();
/*
    if ( PontosEspalhados == null ) {
      for (PVector p : PontosFormaUsuario) { //Por cada ponto de usuario se cria uma posição de ponto espalhado
        PontosEspalhados.add( new PVector ( p.x, p.y, p.z ) );
      }
    } else {
      int diff = PontosEspalhados.size() - PontosFormaUsuario.size();  
      if (diff < 0 ) { //Se tem mais pontos de usuario que pontos espalhados, porque aumento a quantidades de pontos de usuarios
        int pfu = PontosFormaUsuario.size() + diff;
        for (int d=pfu; d < PontosFormaUsuario.size (); d++) {
          PVector novoPonto = PontosFormaUsuario.get(d);
          PontosEspalhados.add( new PVector (novoPonto.x, novoPonto.y, novoPonto.z ) );
        }
      } else if (diff > 0) { //Se disminuiu a quantidade de pontos de usuario, temos que disminuir s pontos espalhados
        for (int d=diff; d > 0; d--) {
          PontosEspalhados.remove( PontosEspalhados.size()-1 );
        }
      }
    }*/
  } 

  public boolean temMudancaNosPontosNuvem() {
    if (novosPontos) {
      novosPontos = false;
      return true;
    } else 
      return false;
  }
  /*
  public void nuvemPontosRolando() {
   for ( PontoMovil pm : PontosEspalhados) {
   pm.rolar(PontosEspalhados);
   }
   }
   public void buscaPos() {
   for ( int p=0; p < PontosEspalhados.size (); p++) {
   PontoMovil pm = PontosEspalhados.get(p);
   PVector pu = PontosFormaUsuario.get(p);
   pm.aplicaForca( pm.seek(pu) );
   pm.rolar(PontosEspalhados);
   }
   }*/
  /**
   ===========================================================================================================================================
   CLASE PONTOS 
   ==========================================================================================================================================*/

}

