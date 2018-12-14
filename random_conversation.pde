/* Random Conversation
 *  by Jiuxin Zhu and Edanur Kuntman, Dec 12, 2018
 */

import processing.serial.*;
import processing.sound.*;

Serial myPort;  // Create object from Serial class
int val = 0;      // Data received from the serial port
boolean is_heading = true; // Display heading or not
boolean is_player1 = true; // Who's turn?
boolean is_left = true;
int left_count = 0;
int right_count = 0;
int left = 0; // the index on the left
int right = 0; // the index on the right
int picked = 0; // the index that player picked
long startTime = 0; // For text to last for 5 seconds
PFont Gill;
SoundFile v0;
SoundFile v1;
SoundFile v2;
SoundFile v3;
SoundFile v4;
SoundFile v5;
SoundFile v6;
SoundFile v7;
SoundFile v8;
SoundFile v9;
SoundFile v10;
SoundFile v11;
SoundFile v12;
SoundFile v13;
SoundFile v14;
SoundFile v15;
SoundFile v16;
SoundFile v17;
SoundFile v18;
SoundFile v19;

int[] map = { 0, 0, 0, 0, 0,
              0, 0, 0, 0, 0,
              0, 0, 0, 0, 0,
              0, 0, 0, 0, 0 }; // 0: available; 1: in use
String[] sentences = { "I can't keep this conversation going if you don't put on pants.",
                       "Why are you looking at me like that?",
                       "Rumor has it, I make you nervous.",
                       "I feel that I'm out of luck these days.",
                       "I can't focus with your damn hand in my, ah-ooh...",
                       "I am alone in the dark.",
                       "Wow I can't believe I said that out loud, please excuse me while I go die of embarrassment.",
                       "Do you not like when I look at you like that?",
                       "You weren't supposed to see me in this, so I'm just gonna go.",
                       "Heh, you're awfully close.",
                       
                       "I'd like to tell you what I know.",
                       "I make the waves.",
                       "You wish! But life is full of surprises.",
                       "Nobody has an objective experience of reality.",
                       "Just be yourself.",
                       "My life has changed, and I'm changing with it.",
                       "Speak less than you know.",
                       "Sometimes you confuse me.",
                       "You like talking, hah.",
                       "A thousand times yes." };

void setup() 
{
  startTime = millis();
  size(1920, 1080);
  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  left = pick_left();
  right = pick_right();
  // Uncomment the following two lines to see the available fonts 
  //String[] fontList = PFont.list();
  //printArray(fontList);
  Gill = createFont("Gill Sans MT", 32);
  textFont(Gill);
  v0 = new SoundFile(this, "0.wav");
  v1 = new SoundFile(this, "1.wav");
  v2 = new SoundFile(this, "2.wav");
  v3 = new SoundFile(this, "3.wav");
  v4 = new SoundFile(this, "4.wav");
  v5 = new SoundFile(this, "5.wav");
  v6 = new SoundFile(this, "6.wav");
  v7 = new SoundFile(this, "7.wav");
  v8 = new SoundFile(this, "8.wav");
  v9 = new SoundFile(this, "9.wav");
  v10 = new SoundFile(this, "10.wav");
  v11 = new SoundFile(this, "11.wav");
  v12 = new SoundFile(this, "12.wav");
  v13 = new SoundFile(this, "13.wav");
  v14 = new SoundFile(this, "14.wav");
  v15 = new SoundFile(this, "15.wav");
  v16 = new SoundFile(this, "16.wav");
  v17 = new SoundFile(this, "17.wav");
  v18 = new SoundFile(this, "18.wav");
  v19 = new SoundFile(this, "19.wav");
}

void draw()
{
  if ( myPort.available() > 0) {  // If data is available,
    val = myPort.read();         // read it and store it in val
  }
  fill(0);
  rect(0, 0, width/2, height);
  fill(255);
  rect(width/2, 0, width/2, height);
  println(millis() - startTime);
  if (millis() - startTime < 5000) {
    if (is_heading) {
      textAlign(CENTER, CENTER);
      fill(255);
      text("Conversation", width/4, height/2);
      fill(0);
      text("by Jiuxin Zhu & Edanur Kuntman", width*3/4, height/2);
      textAlign(LEFT, TOP);
    } else {
      if (is_left) {
        fill(0);
        rect(0, 0, width, height);
        fill(255);
      } else {
        fill(255);
        rect(0, 0, width, height);
        fill(0);
      }
      text(sentences[picked], width/4, height/3);
    }
  } else {
    if (val == 1 && is_player1) {              // If the serial value is 1,
      is_heading = false;
      is_left = true;
      picked = left;
      map[picked] = 1;
      left_count++;
      check_and_pick();
      val = 0;
      is_player1 = false;
      startTime = millis();
      voices(picked);
    } else if (val == 2 &&  is_player1) {              // If the serial value is 2,
      is_heading = false;
      is_left = false;
      picked = right;
      map[picked] = 1;
      right_count++;
      check_and_pick();
      val = 0;
      is_player1 = false;
      startTime = millis();
      voices(picked);
    } else if (val == 3 && !is_player1) {              // If the serial value is 3,
      is_heading = false;
      is_left = true;
      picked = left;
      map[picked] = 1;
      left_count++;
      check_and_pick();
      val = 0;
      is_player1 = true;
      startTime = millis();
      voices(picked);
    } else if (val == 4 && !is_player1) {              // If the serial value is 4,
      is_heading = false;
      is_left = false;
      picked = right;
      map[picked] = 1;
      right_count++;
      check_and_pick();
      val = 0;
      is_player1 = true;
      startTime = millis();
      voices(picked);
    }
  }
  if (keyPressed) {
    if (key == 'a' || key == 'A') {
      val = 1;
    } else if (key == 's' || key == 'S') {
      val = 2;
    } else if (key == 'd' || key == 'D') {
      val = 3;
    } else if (key == 'f' || key == 'F') {
      val = 4;
    }
  }
  if (is_player1) {
    myPort.write('A');
  } else {
    myPort.write('B');
  }
}

int pick_left() {
  int index = int(random(10));
  while (map[index] == 1) {
    index = int(random(10));
  }
  return index;
}

int pick_right() {
  int index = int(random(10, 20));
  while (map[index] == 1) {
    index = int(random(10, 20));
  }
  return index;
}

void check_and_pick() {
  if (left_count == 10) {
    for (int i = 0; i < 10; i++) {
      map[i] = 0;
    }
    left_count = 0;
  }
  if (right_count == 10) {
    for (int i = 10; i < 20; i++) {
      map[i] = 0;
    }
    right_count = 0;
  }
  left = pick_left();
  right = pick_right();
}

void voices(int index) {
  if (index == 0) {
    v0.play();
  } else if (index == 1) {
    v1.play();
  } else if (index == 2) {
    v2.play();
  } else if (index == 3) {
    v3.play();
  } else if (index == 4) {
    v4.play();
  } else if (index == 5) {
    v5.play();
  } else if (index == 6) {
    v6.play();
  } else if (index == 7) {
    v7.play();
  } else if (index == 8) {
    v8.play();
  } else if (index == 9) {
    v9.play();
  } else if (index == 10) {
    v10.play();
  } else if (index == 11) {
    v11.play();
  } else if (index == 12) {
    v12.play();
  } else if (index == 13) {
    v13.play();
  } else if (index == 14) {
    v14.play();
  } else if (index == 15) {
    v15.play();
  } else if (index == 16) {
    v16.play();
  } else if (index == 17) {
    v17.play();
  } else if (index == 18) {
    v18.play();
  } else if (index == 19) {
    v19.play();
  }
}
