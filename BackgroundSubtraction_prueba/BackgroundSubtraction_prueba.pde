import processing.video.*;

Capture video;

int camPixels;
PImage antesPixels;


void setup() {
  size(1280, 720); 
  
  String[] cameras = Capture.list();
  printArray(cameras);
  
  //Empezar la captura
  video = new Capture(this, width, height);
  
   //Capturar imágenes de la cámara
  video.start();
  
  camPixels = video.width * video.height;
  // Almacenar la imagen anterior (el fondo) en un array
  antesPixels = new PImage (video.width, video.height);
  // Cargar los pixeles para poder manipularlos
  loadPixels();
}

void draw() {
   if (video.available()) {
    // Leer nuevo frame de video
    video.read(); 
    // Hacer disponibles los pixels del video
    video.loadPixels(); 
    
    // Diferencia entre el frame actual y el fondo almacenado
    // Límite para comparar si el cambio entre las dos imágenes es mayor a...
    int threshold = 210000000;
    int presenceSum = 0;
    
    // Para cada pixel de video de la cámara, tomar el color actual y el anterior de ese pixel
    for (int i = 0; i < camPixels; i++) { 
      color currentColor = video.pixels[i];
      color backgroundColor = antesPixels.pixels[i];
      
      // Extraer los colores de los píxeles del frame actual
      int currentR = (currentColor >> 16) & 0xFF;
      int currentG = (currentColor >> 8) & 0xFF;
      int currentB = currentColor & 0xFF;
      
      // Extraer los colores de los píxeles del fondo
      int backgroundR = (backgroundColor >> 16) & 0xFF;
      int backgroundG = (backgroundColor >> 8) & 0xFF;
      int backgroundB = backgroundColor & 0xFF;
    
      // Computar la diferencia entre los colores
      int diffR = abs(currentR - backgroundR);
      int diffG = abs(currentG - backgroundG);
      int diffB = abs(currentB - backgroundB);
      
      // Sumar las diferencias a la cuenta
      presenceSum += diffR + diffG + diffB;
      
      // Renderizar la imagen diferente en la pantalla
      pixels[i] = color(diffR, diffG, diffB);
      
     
      
    }
    
     if (presenceSum > threshold) {
       //Ver los pixeles del array que cambiaron y escribir la diferencia
       updatePixels();
       println(presenceSum);
      fill(255,255,0);
      ellipse(200,200,200,200); 
   } else {
      updatePixels();
       println(presenceSum);
   }
   }
   
  }
  

// Al presionar una tecla capturar la imagen del fondo en la imagen antesPixels, copiar cada pixel de los frames en ella
void keyPressed() {
 
  video.loadPixels();
  antesPixels.copy(video, 0, 0, video.width, video.height, 
        0, 0, video.width, video.height);
}