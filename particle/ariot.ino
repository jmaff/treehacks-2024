// This #include statement was automatically added by the Particle IDE.
#include "DHT.h"

// This #include statement was automatically added by the Particle IDE.
#include "RotaryEncoder.h"

#define PIN_IN1 D1
#define PIN_IN2 D2

#define DHT_PIN D5

#define LED D7


RotaryEncoder* encoder = nullptr;
long encoder_pos;
double temp, humidity;

bool is_led_on = false;


DHT dht(DHT_PIN, DHT11);



void updatePosition() {
    encoder->tick();
}

int toggle(String cmd) {
    is_led_on = !is_led_on;
    digitalWrite(LED, is_led_on ? HIGH : LOW);
    return 0;
}


void setup() {
    
    encoder = new RotaryEncoder(PIN_IN1, PIN_IN2, RotaryEncoder::LatchMode::TWO03);
    
    attachInterrupt(digitalPinToInterrupt(PIN_IN1), updatePosition, CHANGE);
    attachInterrupt(digitalPinToInterrupt(PIN_IN2), updatePosition, CHANGE);
    
    dht.begin();
    
    
    Particle.variable("Temperature", &temp, DOUBLE);
    Particle.variable("Humidity", &humidity, DOUBLE);
    Particle.variable("Encoder", &encoder_pos, INT);
    
    Particle.function("LED", toggle);
    
    pinMode(LED, OUTPUT);
    digitalWrite(LED, LOW);
    Serial.begin(9600);

}


void loop() {
    
    temp = dht.readTemperature(true, true);
    humidity = dht.readHumidity();
    encoder_pos = encoder->getPosition();
    
    Particle.publish("Temperature", String::format("%.1f", temp));
    Particle.publish("Humidity", String::format("%.1f", humidity));
    Particle.publish("Encoder", String(encoder_pos));
    
    
    Serial.print("Temperature: ");
    Serial.println(temp);
    
    Serial.print("Humidity: ");
    Serial.println(humidity);
    
    
    Serial.print("State: ");
    Serial.println(is_led_on ? "ON" : "OFF");
    
    Serial.println();
    delay(5000);

}