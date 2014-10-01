class Cenario {
  public PVector originalRef, temporalRef;
  public float anguloPos_X, anguloPos_Y, anguloPos_Z;
  public PVector posGlobal;
  public int radEsfera;
  public String nome;
  public float [] varFromKinect;
  
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
    
  }   
  
  private PVector calculaPosCartesiana( PVector original , float ax, float ay, float az){
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
  
  public void originalRef( PVector pos){
   originalRef = pos; //new PVector(0, -radEsfera, 0); 
  }
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
  public void drawCenario(){}
}
