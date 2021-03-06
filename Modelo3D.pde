class Modelo3D {

  //VARIAVEIS DE DEFINIÇĀO DA ESPERA
  PVector angulosPosicaoPuntero1; //a posição anterior do puntero, permite se desplazar de uma posição para outra 
  PVector angulosPosicaoPuntero; //a posição atual do puntero, que vai mudando em cada cenário, as câmaras olhan nesse ponto 
  PVector angulosFinalPuntero; //PVector que pega o angulo final do puntero, o angulosPosicaoPuntero vai ir do angulo previo ao final

  int radEsfera; //radio da esfera
  PApplet p5; //Objeto tipo PApplet que vai se preencher com a classe inicial de Processing

  //CLASSES DE CENARIOS
  private boolean apagaCenarioProgramado; //indica que tem um apagado programado
  private boolean ligaCenarioProgramado; //indica que tem um ligado programado
  private int tempoBase, tempoApaga ; //variaveis para calcular o tempo programado
  private int tempoBaseLiga, tempoLiga; //variaveis para calcular o tempo programado de ligacao de cenarios
  private String nomeApaga, nomeLiga; //nome do cenário que vai se programar para ser apagado

  ArrayList <Cenario> cenarios;
  ArrayList <String> listaCenariosLigados;
  /** Variaves que definen a posiçāo do globo
   eles definen o angulo de rotaçāo da esphera, definendo os movimentos na visualizaçāo*/
  float desloqueX, desloqueY, desloqueZ; 

  PMatrix3D matrixPuntero; //Matrix para as coordenadas de giro do puntero de visualizacao
  PMatrix3D matrixCenario; //Matrix para as coordenadas de giro da câmara nos cenarios
  Quaternion quaternionPuntero, quaternionCamara; //quaternion da posicao do Puntero
  PVector posQuaternionPuntero, posQuaternionCamara;
  PVector posRefPuntero, posRefCamara;
  PVector rotacaoDeCamara;
  PVector posFocoCamara;
  float distanciaFoco;
  String nomePai; //string para conhecer de qual projecáo é o objeto
  public ArrayList <PVector> nuvemPontosUserModelo ; //A nuvem de pontos que é enviada desde macmini
  boolean nuevaNuvemPontos = false; //indica quanta tem novos pontos
  public ArrayList <PVector> nuvemPontosTemporal; //para retener o array de pontos desde a kinect antes de entregar para NuvemPont...
  
  Modelo3D (PApplet _p5, String nomePai) {
    p5 = _p5; 
    this.nomePai = nomePai;
    radEsfera = 25000; //radio do globo central

    listaCenariosLigados = new ArrayList <String>();
    cenarios = new ArrayList <Cenario>();
    cenarios.add( new Cenario01(p5, PI*.5, 0, 0, radEsfera, "Borboleta") );
    cenarios.add( new Cenario02(p5, 0, PI*1.5, PI*.5, radEsfera, "Arvores" ) );
    cenarios.add( new Cenario03(p5, PI, 0, 0, radEsfera, "Toroide") );
    if (nomePai.equals("PApp1"))  cenarios.add( new Cenario04(p5, 0, 0, PI*.5, radEsfera, "Nuvem", "WithControls") ); //so o papplet1 tem controles p5
    else cenarios.add( new Cenario04(p5, 0, 0, PI*.5, radEsfera, "Nuvem") );
    cenarios.add( new Cenario05(p5, 0, 0, PI * 1.5, radEsfera, "Final") );
    cenarios.add( new Cenario06(p5, -PI*.1, 0, 0, radEsfera, "Rodape_1"));
    cenarios.add( new Cenario07(p5, PI*.05, 0, 0, radEsfera, "BigBang"));

    desloqueX = desloqueY = desloqueZ = 0; //A posiçāo inicial.

    matrixPuntero = new PMatrix3D();
    matrixCenario = new PMatrix3D();
    quaternionPuntero =   new Quaternion();
    quaternionCamara =   new Quaternion();
    posQuaternionPuntero = new PVector();
    posQuaternionCamara = new PVector();
    posRefPuntero = new PVector(0, -radEsfera, 0); //o radio do modela mais um pouco para que o observador fique com altura
    posRefCamara = new PVector(0, 0, -1); //a distancia e direcao para o centro da imagem
    rotacaoDeCamara = new PVector(0, 0, 0);
    //    posFocoCamara = new PVector(0,0,0);
    angulosPosicaoPuntero = new PVector(0, 0, 0);
    angulosPosicaoPuntero1 = new PVector(0, 0, 0); //Nossa posição por default é x=0,y=0,z=0
    //    angulosFinalPuntero = angulosPosicaoPuntero;
    distanciaFoco = width; //O valro que representa o rango de distanca posivel
    ligaCenarioProgramado = apagaCenarioProgramado = false; //no começo nunca vai ter programado apagar algum cenário
    nuvemPontosUserModelo = new ArrayList <PVector>(); //inicialização da lista que vai ter os pontos que formam ao usuario
    nuvemPontosTemporal = new ArrayList <PVector>();
    println("nova classe Modelo3D");
  }
  public void setPosRefCamara(PVector pos) {
    posRefCamara = pos;
  }
  public void setPosRefPuntero(PVector pos) {
    posRefPuntero = pos;
  }
  public void mousePress() {
    ((Cenario04)cenarios.get(3)).aplicaMudanca(); //cenario nuvem
    ((Cenario01)cenarios.get(0)).cambiaTarget(); //cenario Borboleta
  }
  public void implode() {
    //   ((Cenario07)cenarios.get(6)).implode = !((Cenario07)cenarios.get(6)).implode;
  }
  /*
  public void setDesloques(float dx, float dy, float dz) {
   //Os valores vem desde a classe principal, floats entre 0 e 1.
   desloqueX = dx;
   desloqueY = dy;
   desloqueZ = dz;
   
   angulosPosicaoPuntero0.x = angulosPosicaoPuntero.x + desloqueX; // O novo angulo de inclinaçāo do puntero é 90% angulo anterior e 10% ang novo
   angulosPosicaoPuntero0.y = angulosPosicaoPuntero.y + desloqueY; // O novo angulo de inclinaçāo do puntero é 90% angulo anterior e 10% ang novo
   angulosPosicaoPuntero0.z = angulosPosicaoPuntero.z + desloqueZ;
   }*/

  // ----------------------------------------------------------
  // DESENHO DO MODELO DA ESFERA
  // ----------------------------------------------------------  

  public void desenhaModelo() {
    //    print("angulosPosicaoPuntero: " + angulosPosicaoPuntero);
    int tempoRolando = frameCount - tempoBase; //para desligacao programada
    int tempoRolandoLiga = frameCount - tempoBaseLiga; //para ligacao programada

      float lerpVal = .1 * ( constrain (map (tempoRolando, 0, tempoApaga, 0, 1), 0, 1) );
    lerpVal = abs(lerpVal); //por segurança boto valor absoluto, não tenho certeza se vai ser + ou -
    angulosPosicaoPuntero.lerp(angulosPosicaoPuntero1, lerpVal);

    //    println("  :  " + angulosPosicaoPuntero);
    settingCamera();

    //EVALUA APAGOS PROGRAMADOS  
    if ( apagaCenarioProgramado ) {
      if ( tempoRolando > tempoApaga) {
        desligaCenario(nomeApaga);
        apagaCenarioProgramado = false;
      }
    }
    if ( ligaCenarioProgramado ) {
      if ( tempoRolandoLiga > tempoLiga) {
        ligaCenario(nomeLiga);
        ligaCenarioProgramado = false;
      }
    }
    //DESENHO CENARIOS    
    for ( Cenario c : cenarios ) { //bucle por cada um dos cenarios declarados
      String n = c.getNameCenario(); //pegamos o nome de cada cenário a evaluar
      if (listaCenariosLigados.contains(n)) { //evaluamos se o cenário esta na lista de cenários ligados
        //Filtro para agregar deslocamentos na posicao dos cenários 
        if (n.equals("Nuvem")) { //se esta na lista, evaluamos se o cenário é o "Nuvem", nesse caso é ligado com o seguinte método
          ligaDesenhaCenario( c, new PVector (0, PI*.02f, 0) ); //se desenha o cenario com um offset pra fazer-lho visivel
        } else if (n.equals("Rodape_1")) {
          //ligaNoCenarioNuvemPontos( c );
          ligaDesenhaCenario( c, new PVector (PI*.03, 0, 0));//-PI*.03
        } else if (n.equals("Toroide")) {
          ligaDesenhaCenario( c, new PVector (PI*.01, 0, 0));//
        } else if (n.equals("Arvores")) {
  //        println("Arvores c.getTempoLigado(): "+c.getTempoLigado());
          if (c.getTempoLigado() < 30000) {
            float angX = map (c.getTempoLigado(), 0, 30000, TWO_PI*1.15, TWO_PI);
            setAng_X_Camara(angX);
            
          } else if (c.getTempoLigado() > 30000) {
            
            float pY = abs (map (c.getTempoLigado(), 30000, 55000, 0, TWO_PI));
            pY = 1.57 + (.005 * cos(pY) );
            setAng_Y_Puntero(pY);
            //Os pontos da nuvem vao formar ao usuario
          }

          ligaNoCenarioNuvemPontos( c );
          ligaDesenhaCenario( c );
        } else if (n.equals("BigBang")) {
          if (c.getTempoLigado() > 40000)
            ((Cenario07)cenarios.get(6)).ponto.trocaL();
          if (c.getTempoLigado() > 46150){//) {
            //            println("c.getTempoLigado() BigBang: " + c.getTempoLigado() );
            ((Cenario07)cenarios.get(6)).ponto.trocaM(); //contrae bigbang
          }
          ligaNoCenarioNuvemPontos( c );
          ligaDesenhaCenario( c, new PVector (PI*.01, 0, 0));//-PI*.03
        } else { //Se náo liga sem deslocamentos os cenários
          ligaDesenhaCenario( c );
        }
      }
    }

    if (nuevaNuvemPontos) {
       nuevaNuvemPontos = false; 
       nuvemPontosUserModelo.clear();
       for ( PVector p : nuvemPontosTemporal ) {
         nuvemPontosUserModelo.add(p);
       }
    }
 //      p5.popMatrix();
    //   CALCULO DISTANCIAS
    //   println("distancia cArvores: " + cArvores.getDistanceToUpPosition() + " distancia Borboleta: " + Borboleta.getDistanceToUpPosition());
  }

  public void ligaDesenhaCenario(Cenario c) {
    //    println( "anguloPosCenarioLigando: " + c.getAnguloPosicaoX() + " " + c.getAnguloPosicaoY() + " " + c.getAnguloPosicaoZ() );
    p5.pushMatrix();
    p5.rotateX( c.getAnguloPosicaoX() );
    p5.rotateY( c.getAnguloPosicaoY() ); 
    p5.rotateZ( c.getAnguloPosicaoZ() ); 
    p5.translate(0, -radEsfera, 0 ); //desde o centro da esfera até a superfice
    c.drawCenario();
    p5.popMatrix();
  }

  /** Liga o cenário com um eslocamento a posição */
  public void ligaDesenhaCenario(Cenario c, PVector offset) {
    p5.pushMatrix();
    p5.rotateX( c.getAnguloPosicaoX() + offset.x );
    p5.rotateY( c.getAnguloPosicaoY() + offset.y );
    p5.rotateZ( c.getAnguloPosicaoZ() + offset.z );
    p5.translate(0, -radEsfera, 0 ); //desde o centro da esfera até a superfice
    c.drawCenario();
    p5.popMatrix();
  }
  /** Liga no cenário nuvem de ponto o fruior */
  public void ligaNoCenarioNuvemPontos(Cenario c) {
//     println("nuvemPontosUserModelo.size(): "  + nuvemPontosUserModelo.size() );
    c.setNuvemPontosUser(nuvemPontosUserModelo);
  }
  public void settingCamera() {
    //    println( "angulos posição puntero: " + angulosPosicaoPuntero.x + " " + angulosPosicaoPuntero.y + " " + angulosPosicaoPuntero.z );
    //    p5.pushMatrix();

    matrixPuntero.reset();
    matrixPuntero.rotateZ(angulosPosicaoPuntero.z);//bankModelo);
    matrixPuntero.rotateX(angulosPosicaoPuntero.x);//pitchModelo); 
    matrixPuntero.rotateY(angulosPosicaoPuntero.y);//headingModelo);
    quaternionPuntero.set(matrixPuntero);
    quaternionPuntero.mult(posRefPuntero, posQuaternionPuntero); //obtenemos a posicao do puntero no vector "posQuaternionPuntero"

    //		posQuaternionPuntero = cenarios.get(0).calculaPosCartesiana(posRefPuntero, angulosPosicaoPuntero.x,angulosPosicaoPuntero.y, angulosPosicaoPuntero.z);
    //		println("posQuaternionPuntero> " + posQuaternionPuntero);     

    matrixCenario.reset();
    matrixCenario.rotateZ(rotacaoDeCamara.z);//bankModelo);
    matrixCenario.rotateX(rotacaoDeCamara.x);//pitchModelo); map(mouseX, 0, width, 0, TWO_PI)
    matrixCenario.rotateY(rotacaoDeCamara.y);//headingModelo);
    matrixCenario.apply(matrixPuntero);
    quaternionCamara.set(matrixCenario);

    PVector posRefCamaraAtual = posRefCamara; 
    //    posRefCamaraAtual = new PVector(0, 0, -1); // O vetor de referencia é criado em cada loop para poder variar a distancia do vetor
    posRefCamaraAtual.setMag(distanciaFoco); //a variavel distancia é dada desde ModeloGabinete
    //		println("posRefCamaraAtual: "+ posRefCamaraAtual + "posQuaternionCamara: " + posQuaternionCamara);
    quaternionCamara.mult(posRefCamaraAtual, posQuaternionCamara); //obtenemos a posicao do puntero no vector "posQuaternionCamara"

    //    println("posRefCamara: " + posRefCamara  );
    //    println("posQuaternionPuntero: " + posQuaternionPuntero  );
    //    println("posQuaternionCamara: " + posQuaternionCamara  );

    posFocoCamara = PVector.add(  posQuaternionPuntero, posQuaternionCamara );
    //    println("indexPosicaoCamara"+ indexPosicaoCamara);
    //    println("distanciaFoco: "+distanciaFoco+" Puntero: " + posQuaternionPuntero + " posQuaternionCamara: " + posQuaternionCamara + " posFocoCamara: " + posFocoCamara);
    //    p5.popMatrix();
    camaraMovil(posQuaternionPuntero, posFocoCamara ); //Ponto posicao do olho, ponto do centro da imagem
  }
  public void camaraMovil(PVector punteroCentro, PVector punteroCamara) {

    p5.beginCamera();
    PVector normal = new PVector(-punteroCamara.x, -punteroCamara.y, -punteroCamara.z);
    normal.normalize();
    p5.camera( punteroCentro.x, punteroCentro.y, punteroCentro.z, punteroCamara.x, punteroCamara.y, punteroCamara.z, normal.x, normal.y, normal.z);//0, 1, 0);
    p5.endCamera();
    ((Cenario04)cenarios.get(3)).setPosicaoCamara(punteroCentro); //dados da posição do olho para o censario "Nuvem"
  } 
  public void setDistanciaFoco(float _dist) {   
    distanciaFoco = 20000 * _dist;
  }

  public void setAng_X_Puntero(float _ang) {    
    angulosPosicaoPuntero1.x = _ang;
  } // angulosPosicaoPuntero.x = _ang;  }
  public void setAng_Y_Puntero(float _ang) {     
    angulosPosicaoPuntero1.y = _ang;
  } //angulosPosicaoPuntero.y = _ang;  }
  public void setAng_Z_Puntero(float _ang) {     
    angulosPosicaoPuntero1.z = _ang;
  } //angulosPosicaoPuntero.z = _ang;  }
  public void setAng_X_Camara(float _ang) {    
    rotacaoDeCamara.x = _ang;
  }
  public void setAng_Y_Camara(float _ang) {     
    rotacaoDeCamara.y = _ang;
  }
  public void setAng_Z_Camara(float _ang) {     
    rotacaoDeCamara.z = _ang;
  }

  // ----------------------------------------------------------
  // Get Posicao do pontero, ou seja do olho da câmara
  public PVector getAnglulosDePos() {
    return new PVector(angulosPosicaoPuntero.x, angulosPosicaoPuntero.y, angulosPosicaoPuntero.z);
  }
  public int  getCantCenarios() {
    return cenarios.size();
  }
  public String getCenarioLigado() {
    String resp = null;
    for (String cenarioL : listaCenariosLigados) {
      if (cenarioL != null )
        return cenarioL;
    } 
    return resp;
  }
  public PMatrix3D getMatrixCenarioIndex(int index) {
    return cenarios.get(index).getCenarioMatrix();
  }
  public String getNameCenarioIndex(int index) {
    return cenarios.get(index).getNameCenario();
  }
  public PVector getAngulosCenario( String nome) {
    PVector angP = new PVector(0, 0, 0); 
    for ( Cenario c : cenarios ) {
      String n = c.getNameCenario();
      if ( n.equals(nome) ) {
        angP.x = c.getAnguloPosicaoX() ;
        angP.y = c.getAnguloPosicaoY() ;
        angP.z = c.getAnguloPosicaoZ() ;
      }
    }
    return angP;
  }


  /** ----------------------------------------------------------
   * METODOS De modificação | Esses métodos serão chamados desde a classe principal 'Gabinete Projecao' dependendo dos dados recebidos desdo o macmini, 
   *  ---------------------------------------------------------- */

  public void ligaCenario( String nomeC, int tempoOn) {
    ligaCenarioProgramado = true;
    tempoBaseLiga = frameCount;
    tempoLiga = tempoOn;
    nomeLiga = nomeC;
  }

  /** O nome do cenario a ligar */
  public void ligaCenario(String nomeC) {
    if ( !listaCenariosLigados.contains(nomeC) ) {
      listaCenariosLigados.add(nomeC);
      //Aqui se pode filtrar para mudar a posição da câmara
      if ( nomeC.equals("Final")) {
        if (nomePai.equals("PApp2")) { //muda o centor da camara no cenario
          setPosRefPuntero( new PVector(width/2, -radEsfera, 0) );  
          setPosRefCamara(new PVector (0, 0, -1) );
        }
        //  setPosRefCamara(new PVector (0,0,0) ); //novo Vector de referencia para mudar o angulo anchor da camara
      } else {
         posRefPuntero = new PVector(0, -radEsfera, 0); //o radio do modela mais um pouco para que o observador fique com altura
         posRefCamara = new PVector(0, 0, -1); //a distancia e direcao para o centro da imagem
      }
      if ( nomeC.equals("BigBang")) {
        //       setPosRefCamara(new PVector (0,0, 0) ); //novo Vector de referencia para mudar o angulo anchor da camara
      }

      println("novo cenário ligado: "+ nomeC);

      //Muda a variavel 'ligado' para true
      for ( Cenario c : cenarios ) {
        String n = c.getNameCenario();
        if ( n.equals(nomeC) ) {
          c.cenarioTurnOn();
          if (nomeC.equals("Rodape_1")) {
            c.resetCenario(); //resset cenario de rodape 
            ((Cenario07)cenarios.get(6)).resetCenario(); //e reset e big bang

            //c.resetCenario(); //resset cenario de rodape 
            //((Cenario07)cenarios.get(6)).resetCenario(); //e reset e big bang
          } else if (!nomeC.equals("BigBang")) {
            c.resetCenario();
          }
        }
      }
    }
  }
  /** O nome do cenario a desligar */
  public void desligaCenario(String nomeC) {
    if ( listaCenariosLigados.contains(nomeC) ) {
      listaCenariosLigados.remove(nomeC);
      println("cenário desligado: "+ nomeC);

      //Muda a variavel 'ligado' para false
      for ( Cenario c : cenarios ) {
        String n = c.getNameCenario();
        if ( n.equals(nomeC) ) {
          c.cenarioTurnOff();
        }
      }
    }
  }
  /** O nome do cenario a desligar e o tempo antes de se apagar*/
  public void desligaCenario(String nomeC, int tempoOff) {
    apagaCenarioProgramado = true;
    tempoBase = frameCount;
    tempoApaga = tempoOff;
    nomeApaga = nomeC;
  }
  /** Novos dados para posiçao do puntero que define o punto a visualizar do modelo */
  public void novaPosicaoPuntero(PVector angulosPos) {
    setAng_X_Puntero(angulosPos.x); 
    setAng_Y_Puntero(angulosPos.y); 
    setAng_Z_Puntero(angulosPos.z);
  }
  /** Novos dados para a posiçao da camara */
  public void novaPosicaoCamara(PVector angulosCamara) {
    setAng_X_Camara(angulosCamara.x); 
    setAng_Y_Camara(angulosCamara.y); 
    setAng_Z_Camara(angulosCamara.z);
  }
  /** para o recebimento de dados de interaçao, de maneira continua, */
  public void novosDadosContinuos (float posicao, float movimentacao, float deslocamento) {
    for ( Cenario c : cenarios ) { //bucle por cada um dos cenarios declarados
      String n = c.getNameCenario(); //pegamos o nome de cada cenário a evaluar
      if (listaCenariosLigados.contains(n)) { //evaluamos se o cenário esta na lista de cenários ligados
        c.setValModificadoraA( posicao );
        c.setValModificadoraB( movimentacao );
        c.setValModificadoraC( deslocamento );

        c.ejecutaModificacoes();
      }
    }
  }
  /** para o recebimento dos dados finais depois da interaçao com qualquer cenario interativo */
  public void novosDadosFinais (float posicao, float movimentacao, float deslocamento) {
  }
  /** para o recebimento de dados de interaçao, de maneira continua, desde GabinetePRojeção usando o mouse, poreso receve variaves como -1 */
  public void novosDadosContinuosMouse (float posicao, float movimentacao, float deslocamento) {
    for ( Cenario c : cenarios ) { //bucle por cada um dos cenarios declarados
      String n = c.getNameCenario(); //pegamos o nome de cada cenário a evaluar
      if (listaCenariosLigados.contains(n)) { //evaluamos se o cenário esta na lista de cenários ligados
        if (posicao != -1 ) c.setValModificadoraA( posicao );
        if (movimentacao != -1 ) c.setValModificadoraB( movimentacao );
        if (deslocamento != -1 ) c.setValModificadoraC( deslocamento );

        c.ejecutaModificacoes();
      }
    }
  }

  public void novaNuvemDePontos(ArrayList<PVector> nuvemPontosIn) {
    
    if ( nuvemPontosIn.size() > 0) {
      nuevaNuvemPontos = true;
      nuvemPontosTemporal = nuvemPontosIn;
 //     nuvemPontosUserModelo.clear();
 //     nuvemPontosUserModelo = nuvemPontosIn;
    }

    //    println("nuvemPontosUserModelo.size(): "  + nuvemPontosUserModelo.size() );
  }
}

