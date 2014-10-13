class Modelo3D {
 
//VARIAVEIS DE DEFINIÇĀO DA ESPERA
  PVector angulosPosicaoPuntero;
  PVector angulosFinalPuntero; //PVector que pega o angulo final do puntero, o angulosPosicaoPuntero vai ir do angulo previo ao final
  
  int radEsfera; //radio da esfera
  PApplet p5; //Objeto tipo PApplet que vai se preencher com a classe inicial de Processing
  
//CLASSES DE CENARIOS
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
 
  Modelo3D (PApplet _p5, String nomePai) {
    p5 = _p5; 
    
    radEsfera = 25000; //radio do globo central
    
    listaCenariosLigados = new ArrayList <String>();
    cenarios = new ArrayList <Cenario>();
    cenarios.add( new Cenario01(p5, PI*.25, 0 , PI*.5, radEsfera, "Revoada") );
    cenarios.add( new Cenario02(p5, 0,  PI*1.5, PI*.5, radEsfera,  "Atraccao" ) );
    cenarios.add( new Cenario03(p5, PI*.25, 0,  0 , radEsfera, "Ser01") );
    if (nomePai.equals("PApp1"))  cenarios.add( new Cenario04(p5, PI*1.98, PI*1.5,  PI*.5, radEsfera, "Nuvem", "WithControls") ); //so o papplet1 tem controles p5
    else cenarios.add( new Cenario04(p5,  PI*1.98, PI*1.5,  PI*.5, radEsfera, "Nuvem") );
    cenarios.add( new Cenario05(p5, 0, 0,  0 , radEsfera, "Rodape_0") );
    cenarios.add( new Cenario06(p5, 0, 0, 0, radEsfera, "Rodape_1"));
    
    desloqueX = desloqueY = desloqueZ = 0; //A posiçāo inicial.
    
    matrixPuntero = new PMatrix3D();
    matrixCenario = new PMatrix3D();
    quaternionPuntero =   new Quaternion();
    quaternionCamara =   new Quaternion();
    posQuaternionPuntero = new PVector();
    posQuaternionCamara = new PVector();
    posRefPuntero = new PVector(0, -radEsfera, 0); //o radio do modela mais um pouco para que o observador fique com altura
    posRefCamara = new PVector(0, 0 ,-1); //a distancia e direcao para o centro da imagem
    rotacaoDeCamara = new PVector(0,0,0);
//    posFocoCamara = new PVector(0,0,0);
    angulosPosicaoPuntero = new PVector(0, 0, 0);
    angulosFinalPuntero = angulosPosicaoPuntero;
    distanciaFoco = width; //O valro que representa o rango de distanca posivel
    println("nova classe Modelo3D");
  }
  public void setPosRefCamara(PVector pos) {
    posRefCamara = pos; 
  }
  public void mousePress() {
    ((Cenario04)cenarios.get(3)).aplicaMudanca(); //cenario nuvem
    ((Cenario01)cenarios.get(0)).cambiaTarget(); //cenario revoada
  }
  
  public void setDesloques(float dx, float dy, float dz) {
    //Os valores vem desde a classe principal, floats entre 0 e 1.
   desloqueX = dx;
   desloqueY = dy;
   desloqueZ = dz;
   
   angulosFinalPuntero.x = angulosPosicaoPuntero.x + desloqueX; // O novo angulo de inclinaçāo do puntero é 90% angulo anterior e 10% ang novo
   angulosFinalPuntero.y = angulosPosicaoPuntero.y + desloqueY; // O novo angulo de inclinaçāo do puntero é 90% angulo anterior e 10% ang novo
   angulosFinalPuntero.z = angulosPosicaoPuntero.z + desloqueZ;
  }

  // ----------------------------------------------------------
  // DESENHO DO MODELO DA ESFERA
  // ----------------------------------------------------------  
  
  public void desenhaModelo() {
//    angulosPosicaoPuntero.lerp(angulosFinalPuntero, .1);
    
    settingCamera();
//    p5.pushMatrix();
    
    //ponto centro da imagem
/*    p5.pushMatrix();
    p5.pushStyle();
    p5.translate(posFocoCamara.x, posFocoCamara.y, posFocoCamara.z);
    matrixCenario.invert();
    p5.applyMatrix(matrixCenario);
    p5.noFill(); p5.stroke(255,255,0);
    p5.rectMode(CENTER);
    p5.rect(0,0, 50,20);
    p5.sphere(4);
    p5.popStyle();
    p5.popMatrix();*/
    
/*      p5.fill(50);
    p5.stroke(255);//uv255, 100);
    p5.sphereDetail(80);
    p5.sphere(radEsfera); //desenha esfera 
*/   
//DESENHO CENARIOS    
    for ( Cenario c : cenarios ){ //bucle por cada um dos cenarios declarados
      String n = c.getNameCenario(); //pegamos o nome de cada cenário a evaluar
      if (listaCenariosLigados.contains(n)) { //evaluamos se o cenário esta na lista de cenários ligados
				//Filtro para agregar deslocamentos na posicao dos cenários 
        if (n.equals("Nuvem")) { //se esta na lista, evaluamos se o cenário é o "Nuvem", nesse caso é ligado com o seguinte método
          ligaCenario( c , new PVector (0, PI*.01f, 0) ); //se desenha o cenario com um offset pra fazer-lho visivel
	} else if (n.equals("Rodape_1")) {
          ligaCenario( c , new PVector (PI*.03,0 , 0));//-PI*.03
	} else { //Se náo liga sem deslocamentos os cenários 
          ligaCenario( c );  
        }
      }
    }
//   p5.popMatrix();
//   CALCULO DISTANCIAS
//   println("distancia cAtraccao: " + cAtraccao.getDistanceToUpPosition() + " distancia revoada: " + revoada.getDistanceToUpPosition());
 }
  
  public void ligaCenario(Cenario c){
//    println( "anguloPosCenarioLigando: " + c.getAnguloPosicaoX() + " " + c.getAnguloPosicaoY() + " " + c.getAnguloPosicaoZ() );
    p5.pushMatrix();
    p5.rotateX( c.getAnguloPosicaoX() );
    p5.rotateY( c.getAnguloPosicaoY() ); 
    p5.rotateZ( c.getAnguloPosicaoZ() ); 
    p5.translate(0, -radEsfera, 0 ); //desde o centro da esfera até a superfice
    c.drawCenario();
    p5.popMatrix();
  }
  public void ligaCenario(Cenario c, PVector offset){
    p5.pushMatrix();
    p5.rotateX( c.getAnguloPosicaoX() + offset.x );
    p5.rotateY( c.getAnguloPosicaoY() + offset.y );
    p5.rotateZ( c.getAnguloPosicaoZ() + offset.z );
    p5.translate(0, -radEsfera, 0 ); //desde o centro da esfera até a superfice
    c.drawCenario();
    p5.popMatrix();
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
    
    posFocoCamara = PVector.add(  posQuaternionPuntero , posQuaternionCamara );
//    println("indexPosicaoCamara"+ indexPosicaoCamara);
//    println("distanciaFoco: "+distanciaFoco+" Puntero: " + posQuaternionPuntero + " posQuaternionCamara: " + posQuaternionCamara + " posFocoCamara: " + posFocoCamara);
//    p5.popMatrix();
    camaraMovil(posQuaternionPuntero, posFocoCamara ); //Ponto posicao do olho, ponto do centro da imagem
    
  }
  public void camaraMovil(PVector punteroCentro, PVector punteroCamara){
    
   p5.beginCamera();
   PVector normal = new PVector(-punteroCamara.x, -punteroCamara.y, -punteroCamara.z);
   normal.normalize();
   p5.camera( punteroCentro.x, punteroCentro.y, punteroCentro.z, punteroCamara.x, punteroCamara.y, punteroCamara.z,normal.x, normal.y, normal.z);//0, 1, 0);
   p5.endCamera();
   ((Cenario04)cenarios.get(3)).setPosicaoCamara(punteroCentro); //dados da posição do olho para o censario "Nuvem"
  } 
  public void setDistanciaFoco(float _dist) {   
    distanciaFoco = 20000 * _dist;
  }
 
  public void setAng_X_Puntero(float _ang) {    angulosPosicaoPuntero.x = _ang;  }
  public void setAng_Y_Puntero(float _ang){     angulosPosicaoPuntero.y = _ang;  }
  public void setAng_Z_Puntero(float _ang){     angulosPosicaoPuntero.z = _ang;  }
  public void setAng_X_Camara(float _ang) {    rotacaoDeCamara.x = _ang;  }
  public void setAng_Y_Camara(float _ang){     rotacaoDeCamara.y = _ang;  }
  public void setAng_Z_Camara(float _ang){     rotacaoDeCamara.z = _ang;  }
  
  // ----------------------------------------------------------
  // Get Posicao do pontero, ou seja do olho da câmara
  public PVector getAnglulosDePos(){
   return new PVector(angulosPosicaoPuntero.x, angulosPosicaoPuntero.y, angulosPosicaoPuntero.z); 
  }
  public int  getCantCenarios() {
    return cenarios.size();
  }
  public PMatrix3D getMatrixCenarioIndex(int index) {
     return cenarios.get(index).getCenarioMatrix();
  }
  public String getNameCenarioIndex(int index) {
     return cenarios.get(index).getNameCenario(); 
  }
  public PVector getAngulosCenario( String nome){
    PVector angP = new PVector(0,0,0); 
    for ( Cenario c : cenarios ){
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
  
  /** O nome do cenario a ligar */
  public void ligaCenario(String nomeC) {
    if ( !listaCenariosLigados.contains(nomeC) ) {
       listaCenariosLigados.add(nomeC);
			//Aqui se pode filtrar para mudar a posição da câmara
       if ( nomeC.equals("Rodape_0")) {
				 setPosRefCamara(new PVector (0, .3, -1) ); //novo Vector de referencia para mudar o angulo anchor da camara
       }
       println("novo cenário ligado: "+ nomeC);
    } 
  }
  /** O nome do cenario a desligar */
  public void desligaCenario(String nomeC) {
    if ( listaCenariosLigados.contains(nomeC) ) {
       listaCenariosLigados.remove(nomeC);
       println("cenário desligado: "+ nomeC);
    } 
  }
  /** Novos dados para posiçao do puntero que define o punto a visualizar do modelo */
  public void novaPosicaoPuntero(PVector angulosPos){
    setAng_X_Puntero(angulosPos.x); 
    setAng_Y_Puntero(angulosPos.y); 
    setAng_Z_Puntero(angulosPos.z); 

  }
  /** Novos dados para a posiçao da camara */
  public void novaPosicaoCamara(PVector angulosCamara){
    setAng_X_Camara(angulosCamara.x); 
    setAng_Y_Camara(angulosCamara.y); 
    setAng_Z_Camara(angulosCamara.z); 
  }
  /** para o recebimento de dados de interaçao, de maneira continua, */
  public void novosDadosContinuos (float posicao, float movimentacao, float deslocamento){
    
  }
  /** para o recebimento dos dados finais depois da interaçao com qualquer cenario interativo */
  public void novosDadosFinais (float posicao, float movimentacao, float deslocamento){
    
  }
  
}
    
