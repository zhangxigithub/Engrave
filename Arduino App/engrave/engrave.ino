
#include <SoftwareSerial.h>

#include "module.cpp"


Motor motorX(2,3);
Motor motorY(4,5);
Laser laser(6);

SoftwareSerial ble(9,8);

void setup() {
  //Serial.begin(9600);
  //Serial.println("start");
  ble.begin(9600);
  
  digitalWrite(12,HIGH);
  
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
    float m = abs(float(dY)/float(dX));
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
String op = "";

void loop() {
 if( ble.available() > 0 ){
    op += char(ble.read());
    delay(3);
  }
  if(op.endsWith("#") == false)
  {
    return;
  }



  String action = op.substring(0,1);


  if (action == "m")
  {
    ble.println(op);
    int x      = op.substring(1,6).toInt();
    int y      = op.substring(6,11).toInt();
    bool laser = op.substring(11,12).toInt() == 1;
    
    ble.println(x);
    ble.println(y);

    move(x,y,laser);
    ble.println("svgfinish");
  }
  else if (action == "x")
  {
    ble.println(op);
    bool direction = op.substring(1,2) == "1";
    motorX.changeDirection(direction);

    for(int i=0;i<5000;i++)
    {
      motorX.step();
    }
    motorX.duration = 1000;
    delay(10);
  }else if (action == "y")
  {
    ble.println(op);
    bool direction = op.substring(1,2) == "0";
    motorY.changeDirection(direction);
    for(int i=0;i<5000;i++)
    {
      motorY.step();
    }
    motorY.duration = 1000;
    delay(10);
  }else if (action == "l")
  {
    ble.println(op);
    int l = op.substring(1,4).toInt();
    laser.light(l);
  }else if (action == "r")
  { 
    ble.println("r start");
    bool d = op.substring(1,2) == "1";
    motorX.changeDirection(d);

    
    for(int i=2;i< 52;i++)
    {
      int value   = op.substring(i,i+1).toInt();
      if (value > 3)
      {
        laser.on();
        delay(100);
      }else
      {
        laser.off();
      }
      
      for(int j=0;j< 30;j++){ motorX.step(); }
      ble.println("x move");
    }
    for(int j=0;j< 30;j++){ motorY.step(); }
    laser.off();
    ble.println("linefinish");
  } if (action == "n")
  {
    motorY.changeDirection(true);
    for(int j=0;j< 20;j++){ motorY.step(); }
  }

 op = "";
}











