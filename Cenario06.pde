class Cenario06 extends Cenario {
	PApplet p5;
	PVector posIni;

	Cenario06 (PApplet _p5, float angX, float angY, float angZ, int _radEsfera, String _nome) {
    super(angX, angY, angZ, _radEsfera, _nome);
		p5 = _p5;
		posIni = new PVector(0, height*3, 0);
	}
	public void drawCenario(){
		p5.pushStyle();
		p5.translate(posIni.x, posIni.y, posIni.z);
		p5.fill(25,255,25);
		p5.stroke(255);
		p5.line(-width*2, 0,0, width*2, 0,0);
    p5.stroke(255,0,0); p5.line(-p5.width*.5,0,0, p5.width*.5,0,0);
    p5.stroke(0,255,0); p5.line(0,-p5.width*.5,0, 0,p5.width*.5,0);
    p5.stroke(0,0,255); p5.line(0,0,-p5.width*.5, 0,0,p5.width*.5);
		p5.popStyle();
	}
}
