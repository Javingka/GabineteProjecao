import java.awt.Frame;
import java.awt.event.KeyEvent;
import java.text.*;
import controlP5.*; 
import hypermedia.net.*; //UDP
import geomerative.*;

//para receber os dados de nuvem de pontos da kinect
import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
/**
=====================================================================================================
PRIMEIRA JANELA PROJEÇÃO
	O codigo nesse PAplet base do Processing, vai ser projetado nos projetores 1 e 2
====================================================================================================
*/

/** Objeto de tipo UDP usado para a comunicação com o outro computador */
UDP udp;  
UDP udpAudio;
 
/**Variaveis para a criação da segunda janela de projeção*/
PApplet2 PApp2;
PFrame2 frame2;

/** Objetos e variaveis pertencentes á primeira janela*/
Modelo3D modelo3D; //Modelo que gestiona os cenários sob um mesmo espaço 3D
boolean modoPresentacao; //tem um modo de presentacao e um outro de edicao
boolean verTelas; //Para visualizar os margens da imagem. É evaluada pelos  PApp1 e PApp2
boolean verPrint = false;
/** Variavel só de teste*/
String [] listaNomeCenarios = {"Arvores", "Final",  "BigBang", "Rodape_1", "Borboleta", "Toroide", "Nuvem"};
int indexCenariosTeste = 0;
String nomeCenarioTeste;

boolean Modo4Projetores = true;

//Variaveis para o control do tempo dos 
int tempoBaseSom;
int tempoBloquear = 3000;
boolean switchViraKinect = false; //inverte o valor de posicao da pessoa no caso que nao coincida 
// o movimento da pessoa com o movimento dos pontos que a representa na projeção

public void init() {
  println("frame: processing e PApplet: processing / primeira janela de projecao. frame e PApplet por default");
  // to make a frame not displayable, you can
  // use frame.removeNotify()

  frame.removeNotify();
  frame.setUndecorated(true);
//  frame.setBounds(0,0,  int (( 1024 * 1.5 )   ), 768 );
  // addNotify, here i am not sure if you have 
  // to add notify again.  
  frame.addNotify();
  super.init();
}

void setup () {
  if (Modo4Projetores)
    size(int (( 1024 * 2 )), int ( 768  ) , P3D);
  else
    size(int (1024 * 2/3 ), int ( 768/3), P3D);  
    
  println("inicio setup() PApplet base");
  frame.setLocation(0, 0 ); //posicionamento da janela	
  frame2 = new PFrame2(); //criação do frame que conterão o codigo PApplet2 da segunda janela
  
  RG.init(this);  //Inicio da biblioteca usana no cenario07 bigbang
  modelo3D = new Modelo3D(this, "PApp1_sem_control"); 
  
  rectMode(CENTER);
  textSize(50);
  textAlign(CENTER, CENTER);
  
  verTelas = modoPresentacao = false;
  
  udp = new UDP( this, 6000);
  udp.listen( true ); //   wait constantly for incomming data
  // udp.log( true ); // para debuuging
  udpAudio = new UDP( this, 6200 );
  println("fim setup() PApplet base");
  smooth();
  frameRate(25);
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
  
/*  camera();
  rectMode(CORNER);
  fill(255,0,0);
  translate(mouseX,0,height);
  rect(0,0,200,height);*/
}

public void desenhaTela() {
  int w = width / 2;
  int h = height;

  pushStyle();
  rectMode(CENTER);
  stroke(255, 0, 0);
  strokeWeight(10);
  fill(255, 200);
  rect(width*.25f, h/2, w, h );
  rect(width*.75f, h/2, w, h );
  line(0, height/2, width, height/2);
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
    
/*  PARA SIZE EM 4 TELAS */
    if (Modo4Projetores) {
      int alturaProjecao = 768; 
      setBounds(0,0,  int (( 1024 * 2)   ), alturaProjecao );
      setLocation( width, 0);
    } else {
      int alturaProjecao = int ( 768/3); //size em uma tela só
      setBounds(0,0,  int (1024 * 2/3 ) , alturaProjecao );
      setLocation(0, alturaProjecao + 10); 
    }  
   
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
    if (Modo4Projetores) {
      size(int (( 1024 * 2 ) ), int ( 768 ) , P3D); //size em 4 telas
    } else {
      size(int (1024 * 2/3 ), int ( 768/3), P3D);     //size em uma tela só
    }
    noCursor();
    modelo3Db = new Modelo3D(this, "PApp2"); 
    frameRate(25);
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
    strokeWeight(10);
    fill(255);
    rect(width*.25f, h/2, w, h );
    rect(width*.75f, h/2, w, h );
    line(0, height/2, width, height/2);
    fill(0);
    textSize(250);
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
String ultimoCenarioLigado = "inicial";
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
  case 'c': //dados tipo cenario
    //println("tipoDado: Dados Cenario");
    switch(metodoDado) {
    case 'n': //liga cenario sem delay
      if (verPrint) {
        print("liga Cenario ");
        print(" tipo dado: " + tipoDado);    
        print(" metodo dado: " +metodoDado);
        println( " recebido: "+message);// print the result
      }
      println("UltimoLigado: "+ultimoCenarioLigado+" atual: "+message);
      if ( !ultimoCenarioLigado.equals(message) ) {
        modelo3D.ligaCenario( message );
        PApp2.modelo3Db.ligaCenario( message );
        if ( !message.equals("BigBang")) 
          tocaAudioCenario(message, 6300); //so toca auio se não for bigbang
        ultimoCenarioLigado = message;
      }
      
      break;
    case 'm': //liga cenario com tempo
      if (verPrint) {
        print("liga Cenario com tempo");
        print(" tipo dado: " + tipoDado);    
        print(" metodo dado: " +metodoDado);
        println( " recebido: "+message);// print the result
      }
      modelo3D.ligaCenario( message , 60);
      PApp2.modelo3Db.ligaCenario( message , 60);
      if ( !message.equals("BigBang"))  tocaAudioCenario(message, 6300);
      break;
    case 'f': //desliga cenario
      if (verPrint) {
        print("desliga Cenario com tempo ");
        print(" tipo dado: " + tipoDado);    
        print(" metodo dado: " +metodoDado);
        println( " recebido: "+message);// print the result
      }
      modelo3D.desligaCenario( message , 50);//, 100);
      PApp2.modelo3Db.desligaCenario( message , 50);//, 100);
      if ( !message.equals("Rodape_1"))  tocaAudioCenario("stop", 6300);
      ultimoCenarioLigado = "nenhum";
      break;
    case 'h': //desliga cenario na hora sem tempo de delay
      if (verPrint) {
        print("desliga Cenario na hora ");
        print(" tipo dado: " + tipoDado);    
        print(" metodo dado: " +metodoDado);
        println( " recebido: "+message);// print the result
      }
      modelo3D.desligaCenario( message );//, 100);
      PApp2.modelo3Db.desligaCenario( message );//, 100);
      if ( !message.equals("Rodape_1"))
        tocaAudioCenario("stop", 6300);
      ultimoCenarioLigado = "nenhum";
      break;
    }
    break;
  case 'd': //tipo dados continuos
    if (verPrint) {
      println("tipoDado: Dados Continuos");
      println(tipoDado);    
      println(metodoDado);
      //println( "recebido: "+message);// print the result
      //println( "recebido: "+listVals);// print the result
      println("valor posicao fruidor: "+ listVals[0]);
      println("valor movimentacao: "+ listVals[1]);
      println("valor deslocamento: "+ listVals[2]);
    }
    
    if (!switchViraKinect) {
      modelo3D.novosDadosContinuosMouse(1 - listVals[0], listVals[1], listVals[2]); //-1 ,-1);
      PApp2.modelo3Db.novosDadosContinuosMouse(listVals[0], listVals[1], listVals[2]);
    } else {
      modelo3D.novosDadosContinuosMouse(listVals[0], listVals[1], listVals[2]); //-1 ,-1);
      PApp2.modelo3Db.novosDadosContinuosMouse(1 - listVals[0], listVals[1], listVals[2]);
    }
     //-1,-1);
    if (listVals[1] > .75 && (millis() > tempoBaseSom + tempoBloquear) ) {
      if (modelo3D.getCenarioLigado() != null) 
        tocaAudioInteracao(modelo3D.getCenarioLigado() );
    }
    break;
  case 'p': //tipo dados posicao cenario
    if (verPrint) { 
      println("tipoDado: Dados Posicao Cenario");
      println(tipoDado);    
      println(metodoDado);
      
      //println( "recebido: "+message);// print the result
      //println( "recebido: "+listVals);// print the result
      println("anguloXpuntero: "+ listVals[0]);
      println("anguloYpuntero: "+ listVals[1]);
      println("anguloZpuntero: "+ listVals[2]);
      println("anguloXcamera: "+ listVals[3]);
      println("anguloYcamera: "+ listVals[4]);
      println("anguloZcamera: "+ listVals[5]);
      println("distanciaFoco: "+ listVals[6]);
      println("verTelas: "+ listVals[7]); 
    }
    
    PVector pos = new PVector(listVals[0], listVals[1], listVals[2]);
    modelo3D.novaPosicaoPuntero(pos);
    PApp2.modelo3Db.novaPosicaoPuntero(pos);
    
    PVector posC = new PVector(listVals[3], listVals[4], listVals[5]);
    modelo3D.novaPosicaoCamara(posC);
    PApp2.modelo3Db.novaPosicaoCamara(posC);
    
    if (verPrint) { 
      println(posC);
    }
    if( listVals[7] == 1.0 ) {
      verTelas = true;
    } else {
      verTelas = false;
    }
    if (listVals[8] == 1.0) {
      switchViraKinect = true;//println("switchViraKinect: "+ switchViraKinect);
    } else {
      switchViraKinect = false;//println("switchViraKinect: "+ switchViraKinect);
    }
//    println("verTelas: "+ boolean(int(listVals[7])));
    break;
  case 'f'://tipo dados finais
//    println("tipoDado: Dados Finais");
    break;
  default:
    ByteArrayInputStream bais = new ByteArrayInputStream(data);
    DataInputStream in = new DataInputStream(bais);
    try {
      ArrayList<PVector> nuvemPontos = new ArrayList<PVector>();
      int cont = 0;
      String dadoSenha;
      while (in.available() > 0) {
        String elemento = in.readUTF();
 //       System.out.println(elemento); 
        if (cont > 0) { // O primeiro elemento da lista vai ser "kx" então pegamos ese o segundo
            //lista onde vai ficar temporalmente os dados 'x', 'y' e 'z', pegados dese o String, como float
            float[] dadosPosicaoPonto = float(split(elemento, ','));
            int px = (int) dadosPosicaoPonto[0];
            int py = (int) dadosPosicaoPonto[1];
            int pz = (int) dadosPosicaoPonto[2];
            //PVector ponto = new PVector (dadosPosicaoPonto[0], dadosPosicaoPonto[1], dadosPosicaoPonto[2]);
            PVector ponto = new PVector (px, py, pz);
            nuvemPontos.add(ponto);
        } else {
          dadoSenha = elemento;
        }
        cont++;
      }
       if ( nuvemPontos.size() > 1) {
        modelo3D.novaNuvemDePontos( nuvemPontos );
        PApp2.modelo3Db.novaNuvemDePontos( nuvemPontos );
       }
      
 //     println("Quantiade de pontos: "  + nuvemPontos.size() );
      
    } catch (Exception e) {}
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
        case 'i':
                indexCenariosTeste++;
                indexCenariosTeste = indexCenariosTeste % listaNomeCenarios.length;
                break;
        case 'q':
                modelo3D.implode();
                PApp2.modelo3Db.implode();
                break;
        case 's':
                tocaAudioInteracao("Revoada");
                break;
  }
//  println(mudancaPosicao);
  modelo3D.novaPosicaoPuntero(mudancaPosicao);
  PApp2.modelo3Db.novaPosicaoPuntero(mudancaPosicao);
}
/**
===========================================================================================================================================
INTERACAO TEMPORAL | Por quanto não tiver conexção com o macmini, os testes de interação serão criados a continuação 
==========================================================================================================================================*/


String playAudio (String nome) {
  int numeroAudio = -1;
  
  if ( nome.equals("Rodape_1")) {
    numeroAudio = 1;
  } else if ( nome.equals("Borboleta")) {
    numeroAudio = 2;
  } else if ( nome.equals("Nuvem")) {
    numeroAudio = 3;
  } else if ( nome.equals("Arvores")) {
    numeroAudio = 6;
  } else if ( nome.equals("Final")) {
    numeroAudio = 7;
  } else if ( nome.equals("stop")) {
    numeroAudio = 0;
  } else if ( nome.equals("som1")) {
    numeroAudio = 1;
  }
  String numero = "" + numeroAudio;
  return numero;
}

void tocaAudioCenario(String cenario, int porta) {
  if (verPrint)
    println("tocaAudioCenario: "+cenario+" porta "+ porta);
  String ip       = "localhost";
  int port        = porta;

  // formato de mensagem para o Pd ";\n"
  udpAudio.send( "0;\n", ip, port );
  
  String message = playAudio(cenario)+";\n";
  udpAudio.send( message, ip, port );
}

String playSample (String nome) {
  int numeroAudio = -1;
  
  if ( nome.equals("Borboleta")) {
    numeroAudio = 2;
  } else if ( nome.equals("Arvores")) {
    numeroAudio = 3;
  } else if ( nome.equals("Nuvem")) {
    numeroAudio = 1;
  } else if ( nome.equals("stop")) {
    numeroAudio = 0;
  } 
  String numero = "" + numeroAudio;
  return numero;
}

void tocaAudioInteracao(String nomeCenario) {
  if (verPrint) 
     println("toca Audio Interacao em: " + nomeCenario ); 
  tempoBaseSom = millis();
  String ip       = "localhost";
  int port        = 6400;

  // formato de mensagem para o Pd ";\n"
  udpAudio.send( "0;\n", ip, port );
  
  String message = playSample(nomeCenario)+";\n";
  udpAudio.send( message, ip, port );
}

