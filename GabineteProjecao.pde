import java.awt.Frame;
import java.awt.event.KeyEvent;
import java.text.*;
import controlP5.*;  
import hypermedia.net.*; //UDP

// the UDP object
//  UDP udp;  
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
//  udp.listen( true ); //   wait constantly for incomming data
  
  println("fim setup() PApplet base");
}

void draw () {
  background(0);
  
 // modelo3D.setDistanciaFoco( map(mouseX, 0, width, 0,1) );
  
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
  String nomeCenario = "Rodape_1";
  PVector pos = modelo3D.getAngulosCenario(nomeCenario);
  PVector cam = new PVector(0, 0, 0);
  
// É preciso fazer a resta de TWO_PI - valor angulo. tem relação com a definição dos angulos que definem a câmara na clase Modelo, 
// mas não tenho clareza de porque cheguei nessa conclusão,  mas rola.
	println("setAng_x_Puntero: " + pos + " x: " + (TWO_PI - pos.x) + " y: " + (TWO_PI - pos.y ) + " z: " + (TWO_PI - pos.z) );

  modelo3D.setAng_X_Puntero( TWO_PI - pos.x );
  modelo3D.setAng_Y_Puntero( TWO_PI - pos.y );
  modelo3D.setAng_Z_Puntero( TWO_PI - pos.z );
  modelo3D.setAng_X_Camara( cam.x );
  modelo3D.setAng_Y_Camara( cam.y );
  modelo3D.setAng_Z_Camara( cam.z );    
//  modelo3D.setDistanciaFoco( 1 );
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

//===========================================================================================================================================
// UDP | Metodos para receber os dados
//===========================================================================================================================================
/**
 * This is the program receive handler. To perform any action on datagram reception, you need to implement this method in your code. She will be 
 * automatically called by the UDP object each time he receive a nonnull message.
 */

void receive( byte[] data ) {
  String dataEntrante = new String (data); 
  
  
  //VARIAVEIS
  String nomeCenario = "";
  PVector angulosPos = new PVector();
  PVector angulosCamara = new PVector();
  float posicao, movimentacao, deslocamento;
  posicao = movimentacao = deslocamento = 0;
  
  //MÉTODOS DE MODELOS  
  /** String:  O nome do cenario a ligar */
  modelo3D.ligaCenario( nomeCenario);
  /** String:  O nome do cenario a desligar */
  modelo3D.desligaCenario( nomeCenario);
  /** PVector: Novos dados para posiçao do puntero que define o punto a visualizar do modelo */
  modelo3D.novaPosicaoPuntero(angulosPos);
  /** PVector: Novos dados para a posiçao da camara */
  modelo3D.novaPosicaoCamara(angulosCamara);
  /** 3 floats: para o recebimento de dados de interaçao, de maneira continua, */
  modelo3D.novosDadosContinuos ( posicao, movimentacao, deslocamento);
  /** 3 floats: para o recebimento dos dados finais depois da interaçao com qualquer cenario interativo */
  modelo3D.novosDadosFinais ( posicao, movimentacao, deslocamento);
}
		
//===========================================================================================================================================
// INTERACTION TEMPORAL | Por quanto não tiver conexção com o macmini, os testes de interação serão criados a continuação 
//===========================================================================================================================================

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
  }
//  println(mudancaPosicao);
  modelo3D.novaPosicaoPuntero(mudancaPosicao);

}

