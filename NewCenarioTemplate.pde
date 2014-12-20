/**
* Para crtiam um novo cenário, copia e cola essa abba e troca o nome da classe. Logo em 'Modelo3D' se coloca no setup como um novo cenário
*/

class NewCenarioTemplate extends Cenario {
  PApplet p5;
  PVector posIni;
  
  NewCenarioTemplate (PApplet _p5, float angX, float angY, float angZ, int _radEsfera, String _nome) {
    super(angX, angY, angZ, _radEsfera, _nome);
    p5 = _p5;
    posIni = new PVector(0, height * 1.97, 0);
  }
  
   public void drawCenario() {
    p5.pushStyle();
    p5.translate(posIni.x, posIni.y, posIni.z);
    
    p5.popStyle();
    
   }
}
