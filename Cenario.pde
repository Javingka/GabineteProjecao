
class Cenario {
  public PVector originalRef, temporalRef;
  public float anguloPos_X, anguloPos_Y, anguloPos_Z;
  public PVector posGlobal;
  public int radEsfera;
  public String nome;
  public float [] varFromKinect;
  public float valModificadoraA, valModificadoraB, valModificadoraC;
  public boolean ligado;
  public int tempoDeInicio;
//  public ArrayList <PVector> nuvemPontosUser ;
  public boolean verNuvemPontosUser = false;
  
  public Cenario(float angX, float angY, float angZ, int _radEsfera, String _nome){ 
    anguloPos_X = angX;
    anguloPos_Y = angY;
    anguloPos_Z = angZ;
    radEsfera = _radEsfera;
    nome = _nome;
 //   println("angX: " + angX);
    originalRef = new PVector(0, radEsfera, 0); //define a posiçāo de referencia para posiçāo dos cenários
    temporalRef = originalRef; //posiçāo temporal que na imagen é a cima da esfera que se movimenta
//CALCULO DA POSIÇĀO DO CENARIO EM RELAÇĀO COM O VETOR DO EIXO 'Y' NO CENTRO DA ESFERA 
    posGlobal = calculaPosCartesiana( originalRef, anguloPos_X, anguloPos_Y, anguloPos_Z );
    valModificadoraA = valModificadoraB = valModificadoraC = .5;
    ligado = false;
//    nuvemPontosUser = new ArrayList <PVector>();
  }   
  
  public PVector calculaPosCartesiana( PVector original , float ax, float ay, float az){
    float rX0, rX1, rX2;
    float rY0, rY1, rY2;
    float rZ0, rZ1, rZ2;
    
//rotaçāo eixo X    
    rX0 = original.x;
    rX1 = cos (ax) * original.y - sin (ax) * original.z;
    rX2 = sin (ax) * original.y + cos (ax) * original.z;
//rotaçāo eixo y
    rY1 = rX1;
    rY2 = cos (ay) * rX2 - sin (ay) * rX0;
    rY0 = sin (ay) * rX2 + cos (ay) * rX0;
//rotaçāo eixo z
    rZ0 = cos (az) * rY0 - sin (az) * rY1;
    rZ1 = sin (az) * rY0 + cos (az) * rY1;
    rZ2 = rY2;
    
    return new PVector( rZ0, rZ1, rZ2);
  }
  
  // ----------------------------------------------------------
  // setters
  // ----------------------------------------------------------
  
  public void setValModificadoraA (float va) {
    valModificadoraA = va;
  }
  public void setValModificadoraB (float vb) {
    valModificadoraB = vb;
  }
  public void setValModificadoraC (float vc) {
    valModificadoraC = vc;
  }
  public void setNuvemPontosUser( ArrayList <PVector> npu ) {
 /*   if (npu.size() > 1 ) {
      println("nuvemPontosUser.size(): " + npu.size());
      nuvemPontosUser.clear();
      for (PVector p : npu) {
        nuvemPontosUser.add( new PVector (p.x *.1  , - p.y *.1 , p.z *.1 ) );
      }
    }
    verNuvemPontosUser = true;*/
  }
/*  public void originalRef( PVector pos){
   originalRef = pos; //new PVector(0, -radEsfera, 0); 
  }*/
  
  // ----------------------------------------------------------
  // getters
  // ----------------------------------------------------------
  
  public float getDistanceToUpPosition(){
   float dist = PVector.dist ( posGlobal, temporalRef ); 
   return dist;
  }
  public PVector getPosGlob(){
   return posGlobal; 
  }
  public PVector getPosOriginal(){
   return originalRef;
  }
  public PVector getPosTemporalRef() {
   return temporalRef; 
  }
  public float getAnguloPosicaoX(){
    return anguloPos_X;
  }
  public float getAnguloPosicaoY(){
    return anguloPos_Y;
  }
  public float getAnguloPosicaoZ(){
    return anguloPos_Z;
  }
  public String getNameCenario() {
    return nome; 
  }
  public PMatrix3D getCenarioMatrix() {
     PMatrix3D cenarioM = new PMatrix3D();
     cenarioM.reset();
     cenarioM.rotateY(anguloPos_Y);
     cenarioM.rotateX(anguloPos_X);
     
     cenarioM.rotateZ(anguloPos_Z);
     return cenarioM;
  }
  public int getTempoLigado() {
    int t = 0;
    if (ligado) {
     t = millis() - tempoDeInicio;
     return t; 
   } else {
     return t;
   }
  }
  
  // ----------------------------------------------------------
  // metodos comunes entre todos os cenários
  // ----------------------------------------------------------  
  
  public void drawCenario(){}
  public void resetCenario(){}
  public void ejecutaModificacoes(){}
  /** valMod - valor normalizado da variabel de entrada. limA - O limite menor posible da variabel que vai pegar esse dado, limB - valor maior
    * return - o valor mapeado segundo os dados recebedos
    */
  public int aplicaModificacoesNoVal( float valMod, int limA, int limB) {
    int val = (int) constrain ( map( valMod, 0, 1, limA, limB), limA, limB);
    return val;
  }
  public float aplicaModificacoesNoVal( float valMod, float limA, float limB) {
    float val =  constrain ( map( valMod, 0, 1, limA, limB), limA, limB);
    return val;
  }
  public void cenarioTurnOn(){
    ligado = true;
    tempoDeInicio = millis();
  }
  public void cenarioTurnOff(){
    ligado = false;
    verNuvemPontosUser = false; 
    tempoDeInicio = 0;
  }
  
  // ----------------------------------------------------------
  // CLASSE Nuvem de pontos
  // ----------------------------------------------------------  
  class NuvemPontos {
    private ArrayList <PVector> PontosFormaUsuario;
    private ArrayList <PVector> PontosEspalhados;
    
    public NuvemPontos () {
      PontosFormaUsuario = new ArrayList <PVector>();
      PontosEspalhados = new ArrayList <PVector>(); 
    }
    
    public void setListaPontosUsuario( ArrayList <PVector> novaListaPontos ) {
      PontosFormaUsuario = novaListaPontos;
      
      if ( PontosEspalhados == null ) {
        for (PVector p : PontosFormaUsuario) {
          PontosEspalhados.add( new PVector ( random(-width, width), random(-width, width), random(-width, width) ) ); 
        }
      } else {
        int diff = PontosEspalhados.size() - PontosFormaUsuario.size();  
        if (diff < 0 ) { //Se tem mais pontos de usuario que pontos espalhados, porque aumento a quantidades de pontos de usuarios
          for (int d=diff ; d < 0 ; d++) {
             PontosEspalhados.add( new PVector ( random(-width, width), random(-width, width), random(-width, width) ) ); 
          } 
        } else if (diff > 0) { //Se disminuiu a quantidade de pontos de usuario, temos que disminuir s pontos espalhados
          for (int d=diff ; d > 0 ; d--) {
             PontosEspalhados.remove( PontosEspalhados.size()-1 ); 
          } 
        }
      }
      
    } 
  } 
}
