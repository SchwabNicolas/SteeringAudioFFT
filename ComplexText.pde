class ComplexText {
  String text;
  String modifiedText;
  int currentLetter;
  int lastChangeMillis;
  int timePerLetter;
  int changeTime;

  public ComplexText(String text) {
    this.text = text;
    timePerLetter = 200;
    changeTime = 30;
  }

  void update() {
    textFont(font);
    textAlign(CENTER);
    fill(255);
    
    if (currentLetter <= text.length() && currentLetter != -1) {
      if (millis()-currentLetter*timePerLetter >= timePerLetter) {
        String tempText = "";
        for (int i = 0; i < currentLetter-1; i++) {
          tempText += text.charAt(i);
        }
        if (currentLetter > 0) {
          tempText += text.charAt(currentLetter-1);
        }
        modifiedText = tempText;
        if (currentLetter < text.length()) {
          currentLetter++;
        } else {
          currentLetter = -1;
        }
      }

      if (millis()-lastChangeMillis >= changeTime && currentLetter != -1) {
        String tempText = "";
        String chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890éèêáàâíìîóòôõ$£{}[]!¨ëäïö¦@#°§¬|¢´~+`*ç%&/()=?/<>§°,;.:-_¥⅕⅙⅛⅔⅖⅗⅘⅜⅚⅐⅝↉⅓⅑⅒⅞«»®©™¢€";
        int rnd = (int)random(0, chars.length());
        for (int i = 0; i < currentLetter-1; i++) {
          tempText += text.charAt(i);
        }
        tempText += chars.charAt(rnd);
        modifiedText = tempText;

        lastChangeMillis = millis();
      }
    }

    text(modifiedText, width/2, 100);
  }
}
