/*
 * Proyecto mini-Estacion meteorologica
 * Autor: Misael Saenz Flores
 * No: 307164515
 * Version: 18/11/2019
 */

 #include <Wire.h>
 #include <SPI.h>
 #include <nRF24L01.h>
 #include <RF24.h>
 #include <Adafruit_Sensor.h>
 #include <Adafruit_BME280.h>
 #include <DHT.h>

 #define DHTPIN 2
 #define DHTTYPE DHT11
 Adafruit_BME280 bme;
 DHT dht(DHTPIN, DHTTYPE);
 const uint64_t my_radio_pipe = 0xE8E8F0F0E1LL;
 RF24 radio(9, 10);

 #define NIVELMARPRESION_HPA (1013.25)

 #define ANEMOMETRO A0

 float VAL_ANEMOMETRO;
 float DATOS_MT[7];

 void setup(){
 	radio.begin();
 	radio.setAutoAck(false);
 	radio.setDataRate(RF24_250KBPS);
 	radio.openWritingPipe(my_radio_pipe);
 	pinMode(ANEMOMETRO, INPUT);
 	bool ESTADO_BME;
 	ESTADO_BME = bme.begin();
 	dht.begin();
 }

 void loop(){
 	VAL_ANEMOMETRO = analogRead(ANEMOMETRO);
 	DATOS_MT[0] = bme.readTemperature();
 	DATOS_MT[1] = bme.readHumidity();
 	DATOS_MT[2] = bme.readPressure() / 100.0F; 
 	DATOS_MT[3] = bme.readAltitude(NIVELMARPRESION_HPA); 
 	DATOS_MT[4] = dht.readTemperature(); 
 	DATOS_MT[5] = dht.readHumidity(); 
 	DATOS_MT[6] = VAL_ANEMOMETRO;
 	radio.write(&DATOS_MT, sizeof(DATOS_MT));
 	delay(1);
 }