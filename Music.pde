class Music {
  public SoundFile soundFile;
  public String title;
  public String author;
  public color palette;
  public String colorValueChanging;

  public Music(PApplet pApplet, String soundFilePath, String title, String author) {
    soundFile = new SoundFile(pApplet, soundFilePath);
    this.author = author;
    this.title = title;
  }

  public SoundFile getSoundFile() {
    return soundFile;
  }
}
