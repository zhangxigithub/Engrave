#include <Arduino.h>

class Motor
{
    public:
    Motor(int d,int s):directionPort(d),stepPort(s){
    pinMode(d,OUTPUT);
    pinMode(s,OUTPUT);
  }

  int stepPort;
  int directionPort;
  int position = 0;
  bool direction = false;
  
  void changeDirection(bool d)
  {
    direction = d;
    digitalWrite(directionPort, d);
  }

  void step()
  {
    position += direction ? 1 : -1;
    
    if ((position <= 0) || (position >= 10000))
    {
      return;
    }
    
    digitalWrite(stepPort, HIGH);
    delayMicroseconds(450);
    digitalWrite(stepPort, LOW);
    delayMicroseconds(450);

    
  }
};

class Laser
{
    public:
    Laser(){}
    Laser(int p):port(p){
    pinMode(p,OUTPUT);
  }

  int port;

  void on()
  {
    digitalWrite(port, HIGH);
  }
  void off()
  {
    digitalWrite(port, LOW);
  }
};
class Joystick
{
  public:
    Joystick(int x,int y):xPort(x),yPort(y){
    pinMode(x,INPUT);
    pinMode(y,INPUT);
  }
  int xPort;
  int yPort;

  int moveAction()
  {
    int x = analogRead(A4);
    int y = analogRead(A5);
    if(x < 100) {return 1;}
    if(x > 900) {return 2;}
    if(y < 100) {return 3;}
    if(y < 900) {return 4;}
    return 0;
  }
};






