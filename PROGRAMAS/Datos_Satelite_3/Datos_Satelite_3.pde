import processing.serial.*;

Serial Xbee;
PImage bg;
float scroll;
float aux;

boolean TieneDatos = false;

int DatosActuales = 0;
int DatosMaximos = 300;
int DatosPaso = 2;

float[] valTemp = new float[DatosMaximos + 1];
int minTemp = 0;
int maxTemp = 0;

float[] valHum = new float[DatosMaximos + 1];
int minHum = 0;
int maxHum = 0;

float[] valPresion = new float[DatosMaximos + 1];
int minPresion = 0;
int maxPresion = 0;

float[] valAltitud = new float[DatosMaximos + 1];
int minAltitud = 0;
int maxAltitud = 0;

float[] valTempD = new float[DatosMaximos + 1];
int minTempD = 0;
int maxTempD = 0;

float[] valHumD = new float[DatosMaximos + 1];
int minHumD = 0;
int maxHumD = 0;

PrintWriter salidaT;
PrintWriter salidaH;
PrintWriter salidaP;
PrintWriter salidaA;

void setup ()
{
  size(800, 800);
  surface.setResizable(true);
  surface.setLocation(100, 100);
  Xbee = new Serial(this, Serial.list()[1], 9600);
  Xbee.bufferUntil(10);
  //bg = loadImage("fondo.png");
  background(51);
  salidaT = createWriter("Datos_Temperatura.txt");
  salidaH = createWriter("Datos_Humedad.txt");
  salidaP = createWriter("Datos_Presion.txt");
  salidaA = createWriter("Datos_Altitud.txt");
}

void dibujarGrafica(String titulo, float[] datos, int minVal, int maxVal, int x, int y, int h, int ls, int fs)
{
  strokeWeight(1);
  noFill();
  stroke(50, 50, 50);
  rect(x, y, (DatosMaximos * DatosPaso) + 50, h + 50);

  strokeWeight(1);
  stroke(90, 90, 90);

  for (float t = minVal; t <= maxVal; t = t + ls)
  {
    float linea = map(t, minVal, maxVal, 0, h);
    line(x + 40, y + h - linea + 16, x + (DatosMaximos * DatosPaso) + 40, y + h - linea + 16);
    fill(200, 200, 200);
    textSize(fs);
    text(int(t), 5 + x, h - linea + 20 + y);
  }

  textSize(14);
  String titulo2 = titulo + " " + nf(datos[DatosActuales - 1], 0, 2);
  text(titulo2, ((DatosMaximos * DatosPaso) / 2) - (textWidth(titulo2) / 2) + 40, h + 40 + y);

  strokeWeight(2);
  stroke(204, 102, 0);

  for (int i = 1; i < DatosActuales; i++)
  {
    float v0 = map(datos[i - 1], minVal, maxVal, 0, h);
    float v1 = map(datos[i], minVal, maxVal, 0, h);
    line(((i - 1)*DatosPaso) + 40 + x, h - v0 + 16 + y, (i * DatosPaso) + 40 + x, h - v1 + 16 + y);
  }
}

void dibujarGrafica2(String titulo, float[] datos, int minVal, int maxVal, int x, int y, int h, int ls, int fs)
{
  strokeWeight(1);
  noFill();
  stroke(50, 50, 50);
  rect(x, y, (DatosMaximos * DatosPaso) + 50, h + 50);

  strokeWeight(1);
  stroke(90, 90, 90);

  for (float t = minVal; t <= maxVal; t = t + ls)
  {
    float linea = map(t, minVal, maxVal, 0, h);
    line(x + 40, y + h - linea + 16, x + (DatosMaximos * DatosPaso) + 40, y + h - linea + 16);
    fill(200, 200, 200);
    textSize(fs);
    text(int(t), 5 + x, h - linea + 20 + y);
  }

  textSize(14);
  String titulo2 = titulo + " " + nf(datos[DatosActuales - 1], 0, 2);
  text(titulo2, ((DatosMaximos * DatosPaso) / 2) - (textWidth(titulo2) / 2) + 40 + x, h + 40 + y);

  strokeWeight(2);
  stroke(204, 102, 0);

  for (int i = 1; i < DatosActuales; i++)
  {
    float v0 = map(datos[i - 1], minVal, maxVal, 0, h);
    float v1 = map(datos[i], minVal, maxVal, 0, h);
    line(((i - 1)*DatosPaso) + 40 + x, h - v0 + 16 + y, (i * DatosPaso) + 40 + x, h - v1 + 16 + y);
  }
}

void draw ()
{
  if (!TieneDatos) return;

  background(51);
  translate(0, scroll);
  dibujarGrafica("Temperatura BME °C", valTemp, minTemp, maxTemp, 10, 10, 100, 1, 14);
  dibujarGrafica2("Humedad Ambiental BME %", valHum, minHum, maxHum, 700, 10, 100, 1, 14);
  dibujarGrafica("Presion Atmosferica BME", valPresion, minPresion, maxPresion, 10, 190, 100, 50, 10);
  dibujarGrafica("Altitud BME", valAltitud, minAltitud, maxAltitud, 10, 350, 140, 1, 10);
  dibujarGrafica2("Temperatura DHT11 °C", valTempD, minTempD, maxTempD, 700, 190, 100, 1, 14);
  dibujarGrafica2("Humedad Ambiental DHT11 %", valHumD, minHumD, maxHumD, 700, 350, 140, 1, 12);
  //dibujarGrafica2("Humedad Ambiental", valHum, minHum, maxHum, 700, 10, 100, 1, 14);
  //dibujarGrafica("Temperatura °F", valTemp, minTemp, maxTemp, 10, 600, 100, 1, 14);
}

void mouseWheel(MouseEvent e) {
  aux += e.getAmount() * 10;
  if (aux < 0.000) {
    scroll = 0.000;
  } else {
    scroll = aux;
  }
}

void keyPressed() {
  salidaT.flush();
  salidaT.close();
  salidaH.flush();
  salidaH.close();
  salidaP.flush();
  salidaP.close();
  salidaA.flush();
  salidaA.close();
  exit();
}
void DatosObtenidos()
{
  if (DatosActuales == DatosMaximos)
  {
    float ultimaTemp = valTemp[DatosMaximos];
    float ultimaHum = valHum[DatosMaximos];
    float ultimaPresion = valPresion[DatosMaximos];
    float ultimaAltitud = valAltitud[DatosMaximos];
    float ultimaTempD = valTempD[DatosMaximos];
    float ultimaHumD = valHumD[DatosMaximos];

    for (int i = 1; i <= (DatosMaximos - 1); i++)
    {
      valTemp[i - 1] = valTemp[i];
      valHum[i - 1] = valHum[i];
      valPresion[i - 1] = valPresion[i];
      valAltitud[i - 1] = valAltitud[i];
      valTempD[i - 1] = valTempD[i];
      valHumD[i - 1] = valHumD[i];
    }

    valTemp[(DatosMaximos - 1)] = ultimaTemp;
    valHum[(DatosMaximos - 1)] = ultimaHum;
    valPresion[(DatosMaximos - 1)] = ultimaPresion;
    valAltitud[(DatosMaximos - 1)] = ultimaAltitud;
    valTempD[(DatosMaximos - 1)] = ultimaTempD;
    valHumD[(DatosMaximos - 1)] = ultimaHumD;
  } else
  {
    DatosActuales++;
  }
}

void serialEvent (Serial Xbee)
{
  String cadenaDatos = Xbee.readStringUntil(10);

  if (cadenaDatos != null)
  {
    cadenaDatos = trim(cadenaDatos);
    String[] lista = split(cadenaDatos, ':');

    String testString = trim(lista[0]);

    if (lista.length != 8) return;

    float temp = float(lista[0]);
    float hum = float(lista[1]);
    float presion = float(lista[2]);
    float altitud = float(lista[3]);
    float tempD = float(lista[4]);
    float humD = float(lista[5]);

    if (DatosActuales == 0)
    {
      for (int i = 0; i <= DatosMaximos; i++)
      {
        valTemp[i] = temp;
        valHum[i] = hum;
        valPresion[i] = presion;
        valAltitud[i] = altitud;
        valTempD[i] = tempD;
        valHumD[i] = humD;
      }
    }

    valTemp[DatosActuales] = temp;
    valHum[DatosActuales] = hum;
    valPresion[DatosActuales] = presion;
    valAltitud[DatosActuales] = altitud;
    valTempD[DatosActuales] = tempD;
    valHumD[DatosActuales] = humD;
    maxTemp = floor(max(valTemp)) + 1;
    minTemp = ceil(min(valTemp)) - 1;

    maxHum = floor(max(valHum)) + 1;
    minHum = ceil(min(valHum)) - 1;

    maxPresion = floor(max(valPresion)) + 200;
    minPresion = ceil(min(valPresion)) - 200;

    maxAltitud = floor(max(valAltitud)) + 2;
    minAltitud = ceil(min(valAltitud)) - 2;

    maxTempD = floor(max(valTempD)) + 1;
    minTempD = ceil(min(valTempD)) - 1;

    maxHumD = floor(max(valHumD)) + 1;
    minHumD = ceil(min(valHumD)) - 1;

    //Obtener Datos
    salidaT.println(temp);
    salidaH.println(hum);
    salidaP.println(presion);
    salidaA.println(altitud);
    if (DatosActuales > 1)
    {
      TieneDatos = true;
    }

    DatosObtenidos();
  }
}
