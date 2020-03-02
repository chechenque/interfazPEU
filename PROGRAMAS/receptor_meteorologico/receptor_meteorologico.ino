#include <SPI.h>
#include <nRF24L01.h>
#include <RF24.h>

const uint64_t pipeIn = 0xE8E8F0F0E1LL;     
RF24 radio(9, 10);  


float DATOS_MT[7];
void setup()
{
  Serial.begin(9600);
  radio.begin();
  radio.setAutoAck(false);
  radio.setDataRate(RF24_250KBPS);
  radio.openReadingPipe(1, pipeIn);

  radio.startListening();

}

/**************************************************/

unsigned long last_Time = 0;

void receive_the_data()
{
  while ( radio.available() ) {
    radio.read(&DATOS_MT, sizeof(DATOS_MT));
    last_Time = millis(); 
  }
}

/**************************************************/

void loop()
{
  receive_the_data();

  Serial.print(DATOS_MT[0]);
  Serial.print(":" );
  Serial.print(DATOS_MT[1]);
  Serial.print(":" );
  Serial.print(DATOS_MT[2]);
  Serial.print(":" );
  Serial.print(DATOS_MT[3]);
  Serial.print(":" );
  Serial.print(DATOS_MT[4]);
  Serial.print(":" );
  Serial.print(DATOS_MT[5]);
  Serial.print(":" );
  Serial.print(DATOS_MT[6]);
  Serial.println(":" );


}
