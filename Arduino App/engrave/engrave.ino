#include <SoftwareSerial.h>

#include "module.cpp"


Motor motorX(8,9);
Motor motorY(10,11);
Laser laser(12);
Joystick joystick(A4,A5);
SoftwareSerial ble(2, 3);

void setup() {
  //Serial.begin(9600);
  //Serial.println("start");
  ble.begin(115220);
  
  digitalWrite(12,HIGH);
  
}

String readInstruction()
{
  String op = "";
  while( ble.available() > 0 )
  {
    op += char(ble.read());
    delay(2);
  }
  return op;
}

void move(long x,long y,bool enableLaser)
{
    if(enableLaser)
    {
      laser.on();
      ble.println("open laser");
    }

    //total 20000*20000

    long dX = x - motorX.position;
    long dY = y - motorY.position;
    float m = float(dY)/float(dX);
    ble.println("dX : "+String(dX) +" dY : "+String(dY)+" m : "+String(m));
    motorX.changeDirection((dX > 0));
    motorY.changeDirection((dY > 0));
    
    if (m <= 1)
    {
      float detal = 0;
      for(long i = 0; i < abs(dX); i++)
      {
        //ble.print("x move");
        motorX.step();
        detal += m;
        if (detal >= 0.5)
        {
          //ble.print("y move");
          motorY.step();
          detal -= 1;
        }else
        {
        }
      } 
    }else
    {
      float detal = 0;
      for(long i = 0; i < abs(dY); i++)
      {
        //ble.print("y move");
        motorY.step();
        detal += m;
        if (detal >= 0.5)
        {
          //ble.print("x move");
          motorX.step();
          detal -= 1;
        }else
        {
        }
      } 
    }

    if(enableLaser)
    {
      laser.off();
      ble.println("close laser");
    }
    ble.println("move finish x:"+String(motorX.position)+" y : "+String(motorX.position));
}
void loop() {

  /*
  if (ble.available())  
    Serial.write(ble.read());  
  if (Serial.available())  
    ble.write(Serial.read());  
  */
  
  String op     = readInstruction();
  String action = op.substring(0,1);
  
  switch(joystick.moveAction())
  {
    case 1:break;
    case 2:break;
    case 3:break;
    case 4:break;
    default:break;
    }


  
  if (action == "m")
  {
    ble.println(op);
    int x      = op.substring(1,6).toInt();
    int y      = op.substring(6,11).toInt();
    bool laser = op.substring(11,12).toInt() == 1;
    
    ble.println(x);
    ble.println(y);

    move(x,y,laser);
  }

  if (action == "x")
  {
    ble.println(op);
    bool direction = op.substring(1,2).toInt() == 1;
    motorX.changeDirection(direction);

    for(int i=0;i<1000;i++)
    {
      motorX.step();
    }

  }
  if (action == "y")
  {
    ble.println(op);
    bool direction = op.substring(1,2).toInt() == 1;
    motorY.changeDirection(direction);
    for(int i=0;i<1000;i++)
    {
      motorY.step();
    }
  }

}











