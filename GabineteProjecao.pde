import java.awt.Frame;
import java.awt.event.KeyEvent;
import java.text.*;
import controlP5.*; 
import hypermedia.net.*; //UDP
import geomerative.*;

/**
=====================================================================================================
PRIMEIRA JANELA PROJEÇÃO
	O codigo nesse PAplet base do Processing, vai ser projetado nos projetores 1 e 2
====================================================================================================
*/

/** Objeto de tipo UDP usado para a comunicação com o outro computador */
UDP udp;  
 
/**Variaveis para a criação da segunda janela de projeção*/
PApplet2 PApp2;
PFrame2 frame2;

/** Objetos e variaveis pertencentes á primeira janela*/
Modelo3D modelo3D; //Modelo que gestiona os cenários sob um mesmo espaço 3D
boolean modoPresentacao; //tem um modo de presentacao e um outro de edicao
boolean verTelas; //Para visualizar os margens da imagem. É evaluada pelos  PApp1 e PApp2

/** Variavel só de teste*/
String [] listaNomeCenarios = {"Revoada", "Ser01", "Nuvem", "Rodape_0", "Rodape_1"};
int indexCenariosTeste = 0;
String nomeCenarioTeste;

public void init() {
  println("frame: processing e PApplet: processing / primeira janela de projecao. frame e PApplet por default");
  // to make a frame not displayable, you can
  // use frame.removeNotify()

  frame.removeNotify();
  frame.setUndecorated(true);

  // addNotify, here i am not sure if you have 
  // to add notify again.  
  frame.addNotify();
  super.init();
}

void setup () {
  size(int (( 1024 * 2 )), int ( 768  ) , P3D);
 // size(int (( 1366 * 2 ) * .4 ), int ( 768 * .4), P3D);  
  println("inicio setup() PApplet base");
  frame.setLocation(0, 0 ); //posicionamento da janela	
  frame2 = new PFrame2(); //criação do frame que conterão o codigo PApplet2 da segunda janela

  modelo3D = new Modelo3D(this, "PApp1_sem_control"); 
  
  rectMode(CENTER);
  textSize(50);
  textAlign(CENTER, CENTER);
  
  verTelas = modoPresentacao = false;
  
  udp = new UDP( this, 6000);
  udp.listen( true ); //   wait constantly for incomming data
  // udp.log( true ); // para debuuging

  println("fim setup() PApplet base");
}

void draw () {
  background(0);
  
 // modelo3D.setDistanciaFoco( map(mouseX, 0, width, 0,1) );
  
  if (verTelas) {
    camera();
    desenhaTela(); // desenha as telas com os números
  } else {
    modelo3D.desenhaModelo(); //desenha a esfera e todo o que em ela estiver visível
  }
}

public void desenhaTela() {
  int w = width / 2;
  int h = height;

  pushStyle();
  rectMode(CENTER);
  stroke(255, 0, 0);
  strokeWeight(3);
  fill(255, 200);
  rect(width*.25f, h/2, w, h );
  rect(width*.75f, h/2, w, h );
  fill(0);
  textSize(150);
  text("1", width*.25f, h/2);
  text("2", width*.75f, h/2);
  popStyle();
}
public void setDistanciaFocoCamara(float d){
modelo3D.setDistanciaFoco(d);
}
public void ligaCenarioNome(String nome){
modelo3D.ligaCenario(nome);
}
public void desligaCenarioNome(String nome){
modelo3D.desligaCenario(nome);
}
public PVector getAngulosCenario(String nome) {
return modelo3D.getAngulosCenario(nome);
}

/**
=====================================================================================================
SEGUNDA JANELA PROJEÇÃO
	O codigo para o desenho das projeções 3 e 4
====================================================================================================
*/
/** Criação da clase que vai implementar o frame onde vai se desenhar o codigo do PApplet2 */
public class PFrame2 extends Frame {
  public PFrame2 ()  {
    println("construtor da classe PFrame2");
    setUndecorated(true);
    int alturaProjecao = int ( 768  );
    setBounds(0,0,	int (( 1024 * 2 )   ), alturaProjecao );
    setLocation( width, 0);  //setLocation( (int) (width), alturaProjecao); 
    PApp2 = new PApplet2();
    add (PApp2);
    PApp2.init();
    show();
  }
}
/** Criação da classe que vai implementar o código necessario para desenhar as animaçóes*/
public class PApplet2 extends PApplet {
  Modelo3D modelo3Db; //Modelo que gestiona os cenários sob um mesmo espaço 3D
  boolean modoPresentacao; //tem um modo de presentacao e um outro de edicao

  public void setup(){
    size(int (( 1024 * 2 ) ), int ( 768 ) , P3D);
  //size(int ( 1366 * 2 * .4) , int (768 * .4), P3D );
    modelo3Db = new Modelo3D(this, "PApp2"); 
  }
  public void draw () {
    background(0);
    if (verTelas) {
      camera();
      desenhaTelab(); //desenha as telas com os números
    } else {
      modelo3Db.desenhaModelo(); //desenha a esfera e todo o que em ela estiver visível
    }
  }
  public void desenhaTelab() {
    int w = width / 2;
    int h = height;
  
    pushStyle();
    rectMode(CENTER);
    stroke(255, 0, 0);
    strokeWeight(3);
    fill(255, 200);
    rect(width*.25f, h/2, w, h );
    rect(width*.75f, h/2, w, h );
    fill(0);
    textSize(150);
    text("3", width*.25f, h/2);
    text("4", width*.75f, h/2);
    popStyle();
  }	
}


/**
===========================================================================================================================================
 UDP | Metodos para receber os dados
===========================================================================================================================================
 This is the program receive handler. To perform any action on datagram reception, you need to implement this method in your code. She will be 
 automatically called by the UDP object each time he receive a nonnull message.
*/

void receive( byte[] data ) {       // <-- default handler
  //void receive( byte[] data, String otherip, int port ) {  // <-- extended handler

  //data = subset(data, 0, data.length-2);
  char[] tipoDadoIni = char(subset(data, 0, 1)); //peda o primeiro char
  char tipoDado = tipoDadoIni[0]; //o char fica como char simples
  char[] metodoDadoIni = char(subset(data, 1, 1)); //segundo char é o metodo para onde enviar os valores
  char metodoDado = metodoDadoIni[0];
  String message = new String( subset(data, 2, data.length-2) );
  float[] listVals = float(split(message, ','));

  switch(tipoDado) {
  case 'c': //tipo cenario
    //println("tipoDado: Dados Cenario");
    switch(metodoDado) {
    case 'n': //liga cenario
      println("Metodo ligaCenario");
      println(tipoDado);    
      println(metodoDado);
      println( "recebido: "+message);// print the result
      modelo3D.ligaCenario( message );
      PApp2.modelo3Db.ligaCenario( message );
      break;
    case 'f': //desliga cenario
      println("Metodo desligaCenario");
      println(tipoDado);    
      println(metodoDado);
      println( "recebido: "+message);// print the result
      modelo3D.desligaCenario( message , 100);
      PApp2.modelo3Db.desligaCenario( message , 100);
      break;
    }
    break;
  case 'd': //tipo dados continuos
    println("tipoDado: Dados Continuos");
    println(tipoDado);    
    println(metodoDado);
    //println( "recebido: "+message);// print the result
    //println( "recebido: "+listVals);// print the result
    println("valor posicao fruidor: "+ listVals[0]);
    println("valor movimentacao: "+ listVals[1]);
    println("valor deslocamento: "+ listVals[2]);
    
    modelo3D.novosDadosContinuosMouse(listVals[0], -1 ,-1);
    PApp2.modelo3Db.novosDadosContinuosMouse(listVals[0], -1,-1);
    
    break;
  case 'p': //tipo dados posicao cenario
    println("tipoDado: Dados Posicao Cenario");
    println(tipoDado);    
    println(metodoDado);
    
    //println( "recebido: "+message);// print the result
    //println( "recebido: "+listVals);// print the result
    println("anguloXpuntero: "+ listVals[0]);
    println("anguloYpuntero: "+ listVals[1]);
    println("anguloZpuntero: "+ listVals[2]);
    
    PVector pos = new PVector(listVals[0], listVals[1], listVals[2]);
    modelo3D.novaPosicaoPuntero(pos);
    PApp2.modelo3Db.novaPosicaoPuntero(pos);
    
    println("anguloXcamera: "+ listVals[3]);
    println("anguloYcamera: "+ listVals[4]);
    println("anguloZcamera: "+ listVals[5]);
    
    PVector posC = new PVector(listVals[3], listVals[4], listVals[5]);
    modelo3D.novaPosicaoCamara(posC);
    PApp2.modelo3Db.novaPosicaoCamara(posC);
    
    println(posC);
 //   println("distanciaFoco: "+ listVals[6]);
    
    println("verTelas: "+ listVals[7]); 
    if( listVals[7] == 1.0 ) {
      verTelas = true;
    } else {
      verTelas = false;
    }
     
//    println("verTelas: "+ boolean(int(listVals[7])));
    break;
  case 'f'://tipo dados finais
    println("tipoDado: Dados Finais");
    break;
  }
}
		
/**
===========================================================================================================================================
INTERACAO TEMPORAL | Por quanto não tiver conexção com o macmini, os testes de interação serão criados a continuação 
==========================================================================================================================================*/
/** metodo temporal para visualizar os cenarios */
public void mousePressed(){
  
  if ( key == 't') { 
    if (nomeCenarioTeste != null) {
      modelo3D.desligaCenario(nomeCenarioTeste, 100);
      PApp2.modelo3Db.desligaCenario(nomeCenarioTeste, 100);
    }
    nomeCenarioTeste = listaNomeCenarios[indexCenariosTeste];
   /* 
    String infoDado = "cn"; //indica que se trata de cenario (c) off (f)
    String nome = infoDado + nomeCenario;
    byte[] data = nome.getBytes();
    
    receive(data);*/
    montaModeloNaTela ( nomeCenarioTeste, modelo3D, true);
    montaModeloNaTela ( nomeCenarioTeste, PApp2.modelo3Db, true);
    
    indexCenariosTeste++;
    indexCenariosTeste = indexCenariosTeste % listaNomeCenarios.length;
  }
 
}

/** Função para testar as mudanças de dados desde mac-mini sem cam-mini */
public void mouseDragged() {
  float mod = map (mouseX, 0, width, 0, 1);
  if ( key == 'a') {
    modelo3D.novosDadosContinuosMouse(mod,-1,-1);
    PApp2.modelo3Db.novosDadosContinuosMouse(mod,-1,-1);
  } else if ( key == 's') {
    modelo3D.novosDadosContinuosMouse(-1,mod,-1);
    PApp2.modelo3Db.novosDadosContinuosMouse(-1,mod,-1);
  } else if ( key == 'd') {
    modelo3D.novosDadosContinuosMouse(-1,-1,mod);
    PApp2.modelo3Db.novosDadosContinuosMouse(-1,-1,mod);
  } 
}
public void montaModeloNaTela( String nomeC, Modelo3D m , boolean ladoCamara) {
  String nomeCenario = nomeC;
  PVector pos = m.getAngulosCenario(nomeCenario);
  PVector cam = new PVector(0, 0, 0);
  
// É preciso fazer a resta de TWO_PI - valor angulo. tem relação com a definição dos angulos que definem a câmara na clase Modelo, 
// mas não tenho clareza de porque cheguei nessa conclusão,  mas rola.
//  println("setAng_x_Puntero: " + pos + " x: " + (TWO_PI - pos.x) + " y: " + (TWO_PI - pos.y ) + " z: " + (TWO_PI - pos.z) );

  m.setAng_X_Puntero( TWO_PI - pos.x );
  m.setAng_Y_Puntero( TWO_PI - pos.y );
  m.setAng_Z_Puntero( TWO_PI - pos.z );
  m.setAng_X_Camara( cam.x );
  if (ladoCamara)
    m.setAng_Y_Camara( cam.y );
  else  
    m.setAng_Y_Camara( cam.y - PI); //gira a cãmara ficando frontal à outra posição posivel   
  m.setAng_Z_Camara( cam.z );    
//  modelo3D.setDistanciaFoco( 1 );
  verTelas = false  ;
  
  m.ligaCenario(nomeCenario);
}
public void keyPressed (){
  float anguloMudanca = 0;
  PVector mudancaPosicao = modelo3D.getAnglulosDePos();	
  switch (key) {
	case 'j':	//moviemento para atras
		anguloMudanca = (mudancaPosicao.x - 0.005) % TWO_PI; //modificação do angulo e restrição para ficar em valores dentro de TWO_PI 
		mudancaPosicao = new PVector(anguloMudanca,mudancaPosicao.y,mudancaPosicao.z);
		break;
	case 'k':	//movimento para frente
		anguloMudanca = (mudancaPosicao.x + 0.005) % TWO_PI;//modificação do angulo e restrição para ficar em valores dentro de TWO_PI 
		mudancaPosicao = new PVector(anguloMudanca,mudancaPosicao.y,mudancaPosicao.z);
		break;
	case 'h':	//movimento para esquerda
		anguloMudanca = (mudancaPosicao.z - 0.005) % TWO_PI;//modificação do angulo e restrição para ficar em valores dentro de TWO_PI 
		mudancaPosicao = new PVector(mudancaPosicao.x, mudancaPosicao.y, anguloMudanca);
		break;
	case 'l': //movimento para dereita
		anguloMudanca = (mudancaPosicao.z + 0.005) % TWO_PI;//modificação do angulo e restrição para ficar em valores dentro de TWO_PI 
		mudancaPosicao = new PVector(mudancaPosicao.x, mudancaPosicao.y, anguloMudanca);
		break;
        case 'v':
                verTelas = !verTelas;
                break;
  }
//  println(mudancaPosicao);
  modelo3D.novaPosicaoPuntero(mudancaPosicao);
  PApp2.modelo3Db.novaPosicaoPuntero(mudancaPosicao);
}

