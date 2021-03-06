//Beta angle aka Slip Indicator,
//Speed and Gear force against ground 
//for TIY simulator OH-794 from X-Plane 11

//LOKI
//22.02.2020 Tällä toimii suristin, servo ja tuuletin
//21.12.2020 Lisätty Fan2 
//14.1.2021  Korjattu muuttujien nimiä ja säädetty kertoimia
//3.3.2021   Jos UDP paketteja ei tule, puhaltimet ja servo seis

#include <SPI.h>        
#include <Ethernet.h>
#include <EthernetUdp.h>
#include <Servo.h>

Servo BetaServo;  //Slip indicator aka Villalanka servo

byte mac[] = {  0xAE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
IPAddress ip(192, 168, 10, 177);      // local IP = 192.168.10.177
unsigned int localPort = 49001;       // local port to listen
byte DataBuf[200];   // 

float Dataref_Value; // Float result

// Variables
int Beta = 0;             //Plane beta-angle aka plane side slip
int BetaAVG = 0;          //moving average of beta-angle to slow down shake
int SlipIndic = 0;        //Angle of servo slip indicator, villalanka
float Speed = 0;          //Speed in knots 1,609 km/h
float GearForce = 0;      //if > 0 , plane touches ground
float GearPWM = 0;        //between 0 and 255
float Fan1PWM = 0;        //between 0 and 255
float Fan2PWM = 0;        //between 0 and 255
unsigned long UDPmillis = 0; //Previous time when UDP packet was received
const int ServoPin = 3;   // Slip indicator
const int Fan1Pin = 5;    // Front Fan
const int Fan2Pin = 6;    // Back Fan
const int GearPin = 13;   // A.Shaker motor

// Translate 4-byte to floating 
union u_tag {
byte b[4];
float fval;
} u;

EthernetUDP Udp; 

void setup() 
{
  BetaServo.attach(ServoPin);
  Ethernet.begin(mac,ip);   // start the Ethernet 
  Udp.begin(localPort);  
  Serial.begin(9600);
  delay(1000);
}

void loop() {
      
  delay(5);   // Test if this is needed?
  
  int packetSize = Udp.parsePacket();   //  read a packet coming from X-plane
  if(packetSize)
  {
     UDPmillis = millis();
     Udp.read ( DataBuf, packetSize );    // read all packet to Data buffer 
     for (int i = 5; i < packetSize; i += 36)   // check each 36-th byte for group index number
 
       if ( DataBuf[i] == 18) {        // NOTE: Turn ON X-Plane 11 Data Output index 3, 18 and 66     
            u.b[0] = DataBuf[i+8];     // read 4 bytes
            u.b[1] = DataBuf[i+9];
            u.b[2] = DataBuf[i+10];
            u.b[3] = DataBuf[i+11];
            
            Dataref_Value = u.fval;       // -- translate 4-byte to float ( dataref value)
            Beta = Dataref_Value;         // read beta angle
        

      }  else if ( DataBuf[i] == 3) 
          {             
            u.b[0] = DataBuf[i+32];     
            u.b[1] = DataBuf[i+33];
            u.b[2] = DataBuf[i+34];
            u.b[3] = DataBuf[i+35];
            
            Dataref_Value = u.fval;       
            Speed = Dataref_Value;
       } else if ( DataBuf[i] == 66) 
          {             
            u.b[0] = DataBuf[i+4];     
            u.b[1] = DataBuf[i+5];
            u.b[2] = DataBuf[i+6];
            u.b[3] = DataBuf[i+7];
            
            Dataref_Value = u.fval;       
            GearForce = Dataref_Value;
        }
           
            BetaAVG = 0.5 * BetaAVG + 0.5 * Beta;       //slow down servo movement
            SlipIndic = 3 * BetaAVG;                    //
            if ( SlipIndic > 88 ) { SlipIndic = 88;}    //servo can handle +-90deg, leave 2 deg margin
            else if ( SlipIndic < -88 )  { SlipIndic = -88;}
            if ( Speed < 10 ) { SlipIndic = 0;}     //prevents shake on ground

            Fan1PWM = Speed * 2 + 30;               //2 * 181 kmh / 1,609 + 30 = 255 = full PWM
            if ( Speed < 20 ) { Fan1PWM = 0;}       //prevents Fan1 running on ground and stall
            if ( Fan1PWM > 255 ) { Fan1PWM = 255;}  //prevent PMW overflow

            Fan2PWM = Speed * 4 + 70;               // 4 * 75 kmh / 1,609 + 70 = 255
            if ( Speed < 25 ) { Fan2PWM = 0;}       //prevents Fan2 running on ground and stall
            if ( Fan2PWM > 255 ) { Fan2PWM = 255;}  //prevent PMW overflow
            
            GearPWM = Speed * 3 + 80;             // 3 * 93 kmh / 1,609 + 80 = 255. Below 80/255 will not run 
            if ( Speed < 1 ) { GearPWM = 0;}        //prevents fan running on ground
            if ( GearPWM > 255 ) { GearPWM = 255;}  //prevents PMW overflow
            if ( GearForce < 2 ) { GearPWM = 0;}    //run only on ground
            
           
            
            BetaServo.write(90+SlipIndic);
            analogWrite(Fan1Pin, Fan1PWM);
            analogWrite(Fan2Pin, Fan2PWM);
            analogWrite(GearPin, GearPWM);
       
       } 
      if ( millis() > UDPmillis + 2000 )      //If no UDP packet isreceived in 5 sec, stop all
           {BetaServo.write(90);
            analogWrite(Fan1Pin, 0);
            analogWrite(Fan2Pin, 0);
            analogWrite(GearPin, 0);
           } 
    }
    
