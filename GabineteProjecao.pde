import java.awt.Frame;
import java.awt.event.KeyEvent;
import java.text.*;
import controlP5.*;  
import hypermedia.net.*; //UDP

// the UDP object
UDP udp;  
//MODELO.
Modelo3D modelo3D;

boolean modoPresentacao; //tem um modo de presentacao e um outro de edicao
boolean verTelas; //Para visualizar os margens da imagem

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
  size(int (( 1366 * 2 ) * .4 ), int ( 768 * .4), P3D);
  println("inicio setup() PApplet base");
  frame.setLocation((int)(width*.25), 0 );

  modelo3D = new Modelo3D(this, "PApp1");

  rectMode(CENTER);
  textSize(50);
  textAlign(CENTER, CENTER);
  
  verTelas = modoPresentacao = false;
  
//  udp = new UDP( this, 6000, "127.0.0.1" );
//  udp.listen( true ); // wait constantly for incomming data
  
  println("fim setup() PApplet base");
}

void draw () {
  background(0);

  if (verTelas) {
    camera();
    desenhaTela();
    println("rolando ver telas PApp1");
  } else {
    modelo3D.desenhaModelo(); //desenha a esfera e todo o que em ela estiver visível
  }
}

/** metodo temporal para visualizar os cenarios */
public void mousePressed(){
  String nomeCenario = "Revoada";
  PVector pos = new PVector(PI*.25, 0, PI*.5);
  PVector cam = new PVector(0, 0, 0);
  
  println("ver cenario: " + nomeCenario + " pos: " + pos);
  modelo3D.setAng_X_Puntero( pos.x );
  modelo3D.setAng_Y_Puntero( pos.y );
  modelo3D.setAng_Z_Puntero( pos.z );
  modelo3D.setAng_X_Camara( cam.x );
  modelo3D.setAng_Y_Camara( cam.y );
  modelo3D.setAng_Z_Camara( cam.z );    
  modelo3D.setDistanciaFoco( 1 );
  verTelas = false  ;
  
  modelo3D.ligaCenario(nomeCenario);
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
  textSize(50);
  text("1", width*.25f, h/2);
  text("2", width*.75f, h/2);
  popStyle();
}

//===========================================================================================================================================
// UDP | Metodos para receber os dados
//===========================================================================================================================================
/**
 * This is the program receive handler. To perform any action on datagram reception, you need to implement this method in your code. She will be 
 * automatically called by the UDP object each time he receive a nonnull message.
 */
String [] indicadorDadosEnviados = { 
  "CenarioOn", "cenarioOff", "cenarioPosicao", "dadosContinuos", "dadosFinais"
};
boolean novoDado = false;
String proximoDadoEntrante;
void receive( byte[] data ) {

  String dataEntrante = new String (data); 
  println("dataEntrante: "  + dataEntrante);

  for ( int i = 0; i < indicadorDadosEnviados.length; i++) {
    String indicador = indicadorDadosEnviados[i];
    if (dataEntrante.equals(indicador)) { //Se algum dos nomes coincide então esta se definindo qual é o proximo dado a receber.
      novoDado = true; //novoDado vira true
      proximoDadoEntrante = indicador; //guardamos o index para indicar que tipo de dado vai se receber
      return; //e saimos do método para esperar o novo dado a ser enviado
    }
  }
  if (novoDado) {
    if ( proximoDadoEntrante.equals( indicadorDadosEnviados[0] ) ) { // CenarioOn | Recebe o nome do cenario a ligar
      String nomeC = new String (data); 
      println("liga Cenario: "  + nomeC);
      modelo3D.ligaCenario(nomeC);
      
    } else if ( proximoDadoEntrante.equals( indicadorDadosEnviados[1] ) ) {
    } else if ( proximoDadoEntrante.equals( indicadorDadosEnviados[2] ) ) {
    } else if ( proximoDadoEntrante.equals( indicadorDadosEnviados[3] ) ) {
    } else if ( proximoDadoEntrante.equals( indicadorDadosEnviados[4] ) ) {
    }
    novoDado = false;
  }
}

