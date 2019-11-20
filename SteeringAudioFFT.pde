import processing.sound.*;

public boolean debug = true;

public Sound sound;
public FFT fft;
public Amplitude amplitude;

public ArrayList<Music> musics;
public Music musicPlaying;
public int musicPlayingIndex;
public AudioIn audioIn;

// FFT curve
public float[] fftArray;
public float[] fftSum;
public float[] scaledSum;
public float smoothFactor = 0.25f;
public float scale = 1;

public ArrayList<Vehicle> vehicles;
public ArrayList<Particle> particles;
public ArrayList<RectangleParticle> rectParticles;

public boolean turnOnParticles = false;

public ComplexText musicTitle;
public PFont font;
public PImage cursor;

void settings() {
  fullScreen();
}

void setup() {
  sound = new Sound(this);
  fft = new FFT(this);
  amplitude = new Amplitude(this);
  fftArray = new float[256];
  fftSum = new float[256];
  scaledSum = new float[256];
  musics = new ArrayList<Music>();
  audioIn = new AudioIn(this, 0);
  font = createFont(sketchPath("fonts") + "\\Raleway-Regular.ttf", 36); // Font link : https://fonts.google.com/specimen/Raleway
  musics.add(new Music(this, sketchPath("music") + "\\001.wav", "TEST", "DJ Processing")); // Copy this line to add more musics (.wav is the best format)

  cursor = loadImage(sketchPath("cursor")+"\\blank.png");

  cursor(cursor);

  musicTitle = new ComplexText("");

  vehicles = new ArrayList<Vehicle>();
  for (int i = 0; i < fftArray.length; i++) {
    Vehicle v = new Vehicle(i);
    vehicles.add(v);
  }

  particles = new ArrayList<Particle>();
  rectParticles = new ArrayList<RectangleParticle>();

  playMusic(0);
}

void draw() {
  background(0);

  noStroke();

  fftAnalysis();
  amplitudeAnalysis();

  updateParticles();
  updateVehicles();
  musicTitle.update();
}

public void updateVehicles() {
  for (Vehicle v : vehicles) {
    v.update();
  }
}

public void updateParticles() {
  for (int i = 0; i < rectParticles.size(); i++) {
    rectParticles.get(i).update();
    if (rectParticles.get(i).dead) {
      rectParticles.remove(i);
      i--;
    }
  }

  if (turnOnParticles) {
    for (int i = 0; i < particles.size(); i++) {
      particles.get(i).update();
      if (particles.get(i).dead) {
        particles.remove(i);
        i--;
      }
    }
  }
}

void fftAnalysis() {
  fft.analyze(fftArray);

  for (int i = 0; i < fftArray.length; i++) {
    fftSum[i] += (fftArray[i] - fftSum[i]) * smoothFactor;
    scaledSum[i] = (height - height/20*2) * fftSum[i] * scale;
  }
}

void amplitudeAnalysis() {
  float amp = amplitude.analyze();
  if (turnOnParticles) {
    if (amp >= 0.7f) {
      particles.add(new Particle());
    }
  }

  if (amp >= 0.8) {
    rectParticles.add(new RectangleParticle());
  }

  stroke(57, 255, 220);
  strokeWeight(3);
  fill(0);
  ellipse(mouseX, mouseY, amp*75, amp*75);
}

void playMusic(int musicIndex) {
  if (musicIndex > musics.size()-1) musicIndex = 0;
  if (musicIndex < 0) musicIndex = musics.size()-1;

  musicPlayingIndex = musicIndex;

  for (Music m : musics) {
    m.getSoundFile().stop();
  }
  audioIn.stop();

  musicPlaying = musics.get(musicIndex);
  musicPlaying.getSoundFile().play();
  fft.input(musicPlaying.getSoundFile());
  amplitude.input(musicPlaying.getSoundFile());
  musicTitle = new ComplexText(musicPlaying.title + " - " + musicPlaying.author);
}

void playAudioIn() {
  for (Music m : musics) {
    m.getSoundFile().stop();
  }
  audioIn.play();
  musicPlayingIndex = 0;
  musicPlaying = null;
  fft.input(audioIn);
  amplitude.input(audioIn);
  musicTitle = new ComplexText("Son ambient");
}

void keyPressed() {
  switch(key) {
  case CODED: 
    if (keyCode == UP) {
      playMusic(musicPlayingIndex+1);
    } else if (keyCode == DOWN) {
      playMusic(musicPlayingIndex-1);
    }
    break;
  case 'A':
    playAudioIn();
    break;
  case 'a':
    playAudioIn();
    break;
  case 'P':
    turnOnParticles = !turnOnParticles;
    particles.clear();
    break;
  case 'p':
    turnOnParticles = !turnOnParticles;
    particles.clear();
    break;
  }
}
