
#ifndef cbi
#define cbi(sfr, bit) (_SFR_BYTE(sfr) &= ~_BV(bit)) //macro to clear bit in special function register
#endif
#ifndef sbi
#define sbi(sfr, bit) (_SFR_BYTE(sfr) |= _BV(bit)) //macro to clear bit in special function register
#endif

const unsigned int numReadings = 110;
unsigned int input1Vals[numReadings];

//these define the pin connections
int thread1 = A0; //the thread positive terminal will connect to analog pin A0 to be read
int thread2 = A1; //the thread positive terminal will connect to analog pin A1 to be read

//define the pin locations for digital outputs
//int ledPin = 3;


void setup() {
  sbi(ADCSRA, ADPS2);
  cbi(ADCSRA, ADPS1);
  cbi(ADCSRA, ADPS0);

  //sets the baud rate at _____ so we can check the values the microphone
  //is obtaining on the Serial Monitor as fast as possible
  Serial.begin(9600);//(2000000);

  pinMode(thread1, INPUT);
  pinMode(thread2, INPUT);

  //set output pins
  //pinMode(ledPin, OUTPUT);

}

void loop() {
  //for (int i = 0; i < numReadings; i++) {
  //input1Vals[i] = 0;//analogRead(thread1);
  //this loop is for if we need to be taking as many samples as possible
  //to get real time results
  //}

  long angleX;
  //angleX = random(180);
  angleX = analogRead(thread1);
  //430 -- full arm
  //44 -- fully closed
  if (angleX > 435) {
    angleX = 435;
  }
  if (angleX < 45) {
    angleX = 45;
  }
  angleX = (7395 - (angleX * 17)) / 39;
  Serial.println(angleX);
  Serial.println(90);
  Serial.println(0);
  Serial.println(0);

  delay(1000);//right now just sampleing every 2 seconds
}
