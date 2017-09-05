#include "module.cpp"


Motor motorX(8,9);
Motor motorY(10,11);
Laser laser(12);
Joystick joystick(A4,A5);


void setup() {
  Serial.begin(9600);
  Serial.println("start");

}

String readInstruction()
{
  String op = "";
  while( Serial.available() > 0 )
  {
    op += char(Serial.read());
    delay(2);
  }
  return op;
}

void move(long x,long y,bool laser)
{
    if(laser)
    {
      Serial.println("open laser");
    }

    //total 20000*20000

    long dX = x - motorX.position;
    long dY = y - motorY.position;
    float m = float(dY)/float(dX);

    motorX.changeDirection((dX > 0));
    motorY.changeDirection((dY > 0));
    
    if (m <= 1)
    {
      float detal = 0;
      for(long i = 0; i < dX; i++)
      {
        Serial.println("x move");
        motorX.step();
        detal += m;
        if (detal >= 0.5)
        {
          Serial.println("y move");
          motorY.step();
          detal -= 1;
        }else
        {
        }
      } 
    }else
    {
      float detal = 0;
      for(long i = 0; i < dY; i++)
      {
        Serial.println("y move");
        motorY.step();
        detal += m;
        if (detal >= 0.5)
        {
          Serial.println("x move");
          motorX.step();
          detal -= 1;
        }else
        {
        }
      } 
    }

    if(laser)
    {
      Serial.println("close laser");
    }
    Serial.println("move finish");
}
void loop() {
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
    Serial.println(op);
    int x      = op.substring(1,6).toInt();
    int y      = op.substring(6,11).toInt();
    bool laser = op.substring(11,12).toInt() == 1;
    
    Serial.println(x);
    Serial.println(y);

    move(x,y,laser);
  }

  if (action == "x")
  {
    Serial.println(op);
    bool direction = op.substring(1,2).toInt() == 1;
    motorX.changeDirection(direction);

    for(int i=0;i<1000;i++)
    {
      motorX.step();
    }

  }
  if (action == "y")
  {
    Serial.println(op);
    bool direction = op.substring(1,2).toInt() == 1;
    motorY.changeDirection(direction);
    for(int i=0;i<1000;i++)
    {
      motorY.step();
    }
  }

}











