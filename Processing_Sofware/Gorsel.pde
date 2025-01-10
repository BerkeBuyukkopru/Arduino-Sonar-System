import processing.serial.*; // Seri iletişim için gerekli kütüphaneyi içe aktarır
import java.awt.event.KeyEvent; // Klavye olaylarını işlemek için kütüphaneyi içe aktarır
import java.io.IOException; // Giriş/Çıkış işlemleri için gerekli kütüphane

Serial myPort; // Seri iletişim için bir obje tanımlars
String angle = ""; // Sensörden gelen açıyı tutacak string değişken
String distance = ""; // Sensörden gelen mesafeyi tutacak string değişken
String data = ""; // Seri porttan okunan ham veri
String noObject; // Objenin algılanıp algılanmadığını ifade eden metin
float pixsDistance; // Piksel biriminde mesafe hesaplaması için değişken
int iAngle, iDistance; // Açıyı ve mesafeyi tamsayı olarak tutan değişkenler
int index1 = 0; // Veriler arasında ayırıcı olan ',' karakterinin indeksi
PFont orcFont; // Yazı tipi için tanımlanan font

void setup() {
  size(1200, 700); // Ekran boyutunu belirler
  smooth(); // Çizimlerin daha düzgün olmasını sağlar
  myPort = new Serial(this, "COM7", 9600); // Seri iletişimi başlatır (Arduino bağlı port)
  myPort.bufferUntil('.'); // Nokta (.) karakterine kadar veriyi okur
}

void draw() {
  fill(98, 245, 31); // Çizim renklerini belirler (yeşil)
  noStroke();
  fill(0, 4); 
  rect(0, 0, width, height - height * 0.065); // Yavaş yavaş kaybolan bir efekt yaratır

  fill(98, 245, 31); // Radar çizimi için yeşil renk
  drawRadar(); // Radar çizer
  drawLine(); // Çizgiyi çizer (Sensör açısı doğrultusunda)
  drawObject(); // Obje varsa ekrana çizer
  drawText(); // Ekranda bilgilendirme metinlerini çizer
}

void serialEvent(Serial myPort) { // Seri porttan veri geldiğinde tetiklenir
  data = myPort.readStringUntil('.'); // '.' karakterine kadar olan veriyi okur
  data = data.substring(0, data.length() - 1); // Son karakteri temizler (çünkü noktayı istemiyoruz)
  
  index1 = data.indexOf(","); // ',' karakterinin yerini bulur
  angle = data.substring(0, index1); // ',' karakterine kadar olan kısmı açıyı tutar
  distance = data.substring(index1 + 1, data.length()); // ',' karakterinden sonraki kısmı mesafeyi tutar
  
  iAngle = Integer.parseInt(angle); // String açıyı tamsayıya çevirir
  iDistance = Integer.parseInt(distance); // String mesafeyi tamsayıya çevirir
}

void drawRadar() {
  pushMatrix(); // Mevcut koordinat sistemini kaydeder
  translate(width / 2, height - height * 0.074); // Başlangıç noktasını merkeze kaydırır
  noFill();
  strokeWeight(2);
  stroke(98, 245, 31); // Yeşil çizgi

  // Radar dairelerini çizer
  arc(0, 0, (width - width * 0.0625), (width - width * 0.0625), PI, TWO_PI);
  arc(0, 0, (width - width * 0.27), (width - width * 0.27), PI, TWO_PI);
  arc(0, 0, (width - width * 0.479), (width - width * 0.479), PI, TWO_PI);
  arc(0, 0, (width - width * 0.687), (width - width * 0.687), PI, TWO_PI);

  // Radar açılarının çizgilerini çizer
  line(-width / 2, 0, width / 2, 0); // Merkezden yatay çizgi
  line(0, 0, (-width / 2) * cos(radians(30)), (-width / 2) * sin(radians(30))); // 30°
  line(0, 0, (-width / 2) * cos(radians(60)), (-width / 2) * sin(radians(60))); // 60°
  line(0, 0, (-width / 2) * cos(radians(90)), (-width / 2) * sin(radians(90))); // 90°
  line(0, 0, (-width / 2) * cos(radians(120)), (-width / 2) * sin(radians(120))); // 120°
  line(0, 0, (-width / 2) * cos(radians(150)), (-width / 2) * sin(radians(150))); // 150°
  popMatrix(); // Önceki koordinat sistemine döner
}

void drawObject() {
  pushMatrix();
  translate(width / 2, height - height * 0.074); // Başlangıç noktasını merkeze kaydırır
  strokeWeight(9);
  stroke(255, 10, 10); // Kırmızı renk
  pixsDistance = iDistance * ((height - height * 0.1666) * 0.025); // Mesafeyi piksel birimine çevirir

  if (iDistance < 40) { // Mesafe 40 cm'den küçükse çizer
    line(pixsDistance * cos(radians(iAngle)), -pixsDistance * sin(radians(iAngle)),
        (width - width * 0.505) * cos(radians(iAngle)), -(width - width * 0.505) * sin(radians(iAngle)));
  }
  popMatrix();
}

void drawLine() {
  pushMatrix();
  strokeWeight(9);
  stroke(30, 250, 60); // Çizgi rengi yeşil
  translate(width / 2, height - height * 0.074); // Başlangıç noktasını merkeze kaydırır
  line(0, 0, (height - height * 0.12) * cos(radians(iAngle)), -(height - height * 0.12) * sin(radians(iAngle))); // Çizgiyi çizer
  popMatrix();
}

void drawText() {
  pushMatrix();
  if (iDistance > 40) { // Mesafe 40 cm'den büyükse "Out of Range" yaz
    noObject = "Out of Range";
  } else {
    noObject = "In Range"; // Mesafe uygun aralıktaysa "In Range" yaz
  }

  fill(0, 0, 0); // Yazının arkaplanını siyah yapar
  noStroke();
  rect(0, height - height * 0.0648, width, height); // Yazı alanını belirler
  fill(98, 245, 31); // Yeşil renk
  textSize(25);

  // Mesafe bilgilerini ekrana yazar
  text("10cm", width - width * 0.3854, height - height * 0.0833);
  text("20cm", width - width * 0.281, height - height * 0.0833);
  text("30cm", width - width * 0.177, height - height * 0.0833);
  text("40cm", width - width * 0.0729, height - height * 0.0833);
  textSize(40);
 
  text("Açı: " + iAngle + " °", width - width * 0.48, height - height * 0.0277);
  text("Mesafe: ", width - width * 0.26, height - height * 0.0277);

  if (iDistance < 40) {
    text("            " + iDistance + " cm", width - width * 0.225, height - height * 0.0277);
  }
  textSize(25);
  popMatrix();
}
