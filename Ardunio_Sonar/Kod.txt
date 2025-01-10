// Servo motoru kontrol etmek için gerekli kütüphane
#include <Servo.h> 

// Ultrasonik Sensör için pinleri tanımlıyoruz.
const int trigPin = 10; // Ultrasonik sensörün Trigger pini
const int echoPin = 11; // Ultrasonik sensörün Echo pini

// Süre ve mesafe değişkenlerini tanımlıyoruz.
long duration; // Ses dalgasının geri dönme süresini tutar
int distance;  // Hesaplanan mesafeyi tutar

Servo myServo; // Servo motoru kontrol etmek için bir Servo nesnesi oluşturuyoruz

void setup() {
  pinMode(trigPin, OUTPUT); // Trigger pinini çıkış (OUTPUT) olarak ayarlıyoruz
  pinMode(echoPin, INPUT);  // Echo pinini giriş (INPUT) olarak ayarlıyoruz
  Serial.begin(9600);       // Seri haberleşmeyi başlatıyoruz (9600 baud hızıyla)
  myServo.attach(12);       // Servo motorunu Arduino'nun 12. pinine bağlıyoruz
}

void loop() {
  // Servo motorunu 15 dereceden 165 dereceye kadar döndür
  for(int i = 15; i <= 165; i++) {  
    myServo.write(i); // Servo motoru belirtilen açıya hareket ettir
    delay(30);        // Hareketin tamamlanması için bekleme süresi
    distance = calculateDistance(); // Ultrasonik sensör ile mesafeyi ölç

    Serial.print(i); // Geçerli açıyı seri porta yaz
    Serial.print(","); // Açının yanında bir virgül ekle (Processing IDE için gerekli)
    Serial.print(distance); // Ölçülen mesafeyi seri porta yaz
    Serial.print("."); // Mesafenin yanına bir nokta ekle (Processing IDE için gerekli)
  }

  // Servo motorunu 165 dereceden 15 dereceye kadar döndür
  for(int i = 165; i > 15; i--) {  
    myServo.write(i); // Servo motoru belirtilen açıya hareket ettir
    delay(30);        // Hareketin tamamlanması için bekleme süresi
    distance = calculateDistance(); // Ultrasonik sensör ile mesafeyi ölç

    Serial.print(i); // Geçerli açıyı seri porta yaz
    Serial.print(","); // Açının yanında bir virgül ekle (Processing IDE için gerekli)
    Serial.print(distance); // Ölçülen mesafeyi seri porta yaz
    Serial.print("."); // Mesafenin yanına bir nokta ekle (Processing IDE için gerekli)
  }
}

// Ultrasonik sensör ile mesafe ölçümünü yapan fonksiyon
int calculateDistance() { 
  digitalWrite(trigPin, LOW); // Trigger pinini LOW yap
  delayMicroseconds(2);       // Kısa bir süre bekle
  digitalWrite(trigPin, HIGH); // Trigger pinini HIGH yap
  delayMicroseconds(10);       // 10 mikro saniye boyunca HIGH tut
  digitalWrite(trigPin, LOW);  // Trigger pinini tekrar LOW yap

  duration = pulseIn(echoPin, HIGH); // Echo pinine gelen sinyal süresini ölç
  distance = duration * 0.034 / 2;   // Mesafeyi hesapla (ses hızına göre)
  return distance; // Hesaplanan mesafeyi döndür
}