int nx = 10;             //number of columns, must not be divisible by number of rows, otherwise safe to change
int ny = 3;             //number of rows, safe to change
int level = 0; 
int i=0; 
int combo=0; 
int score=0;
int lives =3;          //starting lives, safe to change
int can_lose_lives = 1; //ability to lose lives. safe to change, cheater
float x = 50;           //starting x-position, safe to change
float x_initial = x;
float y= 400;           //starting y-position, important to change if resolution is changed dramatically.
float y_initial = y;
float starting_speed = 9;    //starting speed, safe to change
float base_speed = starting_speed;
float dx = 0; 
float dy = 0;
float diam =30;         //ball diameter, safe to change
String input_mode = "AI";
float left_corner = 500;    //default paddle start location
float paddle_speed = 0; 
float AI_speed = 0.8; 
float AI_delay = 40;
float paddle_target =random(40, 80);
float AI_intelligence = 2;     //2 is smartest AI. other AI levels have been removed
int[] boxes =  new int[nx*ny+1]; 
int[] boxes_x = new int[nx*ny+1]; 
int[] boxes_y = new int[nx*ny+1];
float[] x_corner = new float[nx*ny+1]; 
float[] y_corner = new float[nx*ny+1];
int number_of_boxes = 0;
int target_block = nx*ny;
boolean initialized = false;
int start_countdown = 40;
float box_width;
float box_height;
float right_corner;
float dy_final;
float dx_final;
boolean nextLevelReady = false;

void setup() {
  fullScreen();
  populateBoxes();
  box_width=(width*7/8-10*(nx-1))/nx;
  box_height=((height/3-width/8)-10*(ny-1))/ny;
}

void mousePressed() {
  if (initialized ==false) {
    setMode();
    initialized=true;
  } else if (start_countdown<=0) {
    if (x == x_initial&&y==y_initial&&lives>=1) {
      launchBall();
    }
    if (lives==0)
      resetGame();
  }
  if (nextLevelReady ==true) {
    goToNextLevel();
    nextLevelReady = false;
  }
}
void keyPressed() {
  if (keyCode == ENTER&&start_countdown<=0) {
    if (x == x_initial&&y==y_initial&&lives>=1)
      launchBall();
    if (lives==0)
      resetGame();
    if (nextLevelReady ==true) {
      goToNextLevel();
      nextLevelReady = false;
    }
  }
}

void draw() {
  background(200, 100, 0);
  number_of_boxes = 0;
  if (initialized==false) {
    if (start_countdown>=41)
      start_countdown--;
    else drawMenu();
  } else if (initialized ==true) 
    playGame();
}

void playGame() {
  number_of_boxes = 0;
  if (start_countdown>=1)
    start_countdown -=1;
  noCursor();
  //accept user input (or run AI)
  if (input_mode == "AI" && AI_intelligence == 2)
    runSmartAI();
  else if (input_mode =="Keyboard")
    keyboardControl();
  else if (input_mode=="Mouse")
    left_corner = mouseX-60; //mouse control
  //check for collisions
  if (y-diam-abs(dy) <= height/3)
    boxCollisions();
  if (dy>0&&y>height/2)
    paddleCollisions();
  wallCollisions();
  if (y>=height-5)
    nextLife();
  //draw everything onscreen
  drawAndMoveBall();
  drawHeadsUpDisplay();
  drawBoxes();
  rect(left_corner, height-60, 120, 30); //draw paddle
  if (number_of_boxes<=1)
    prepareForNextLevel();
}

void prepareForNextLevel() {
  textSize(64);
  dx=0;
  dy=0; 
  AI_delay = 50; 
  paddle_speed = 0;
  if (input_mode =="AI")
    goToNextLevel(); 
  else {
    text("Click or press enter to go on to next level", width/16, height/2);
    nextLevelReady = true;
  }
}
void goToNextLevel() {
  level +=1;
  if (level % 3 == 0) lives +=1;
  base_speed += 0.5; 
  AI_speed += 0.1;
  AI_delay -=1;
  number_of_boxes = 2;
  left_corner = 500; 
  paddle_speed = 0;
  for (int i=0; i<nx*ny+1; i++)
    boxes[i]=1;
  x = x_initial; 
  y = y_initial;
  nextLevelReady = false;
}

void paddleCollisions() {
  right_corner =  left_corner + 120; 
  if (y + diam/2 + dy >= height-60 && y <= height-45+dy) {                                  //check ball's y-coordinate
    if (x + dx + diam/2 >= left_corner && x + dx -diam/2 <= right_corner) {            //check ball's x-coordinate
      dy_final = -abs(dy);
      dy = dy_final;
      paddle_target =random(35, 105);
      target_block = nx*ny;
      combo = 0;
      if (dx>=base_speed*-1.5) {
        if (right_corner - x >= 90) {                                            //bounce off of corners in the opposite direction
          dx -= (right_corner - x - 60)*base_speed/100;                         //and slightly accelerate upwards
          if (abs(dy)<=base_speed*1.5)dy -= base_speed/20;
        }
      }
      if (dx<=base_speed*1.5) {
        if (x - left_corner >= 90) {
          dx += (x - left_corner - 60)*base_speed/100;
          if (abs(dy)<=base_speed*1.5)dy -= base_speed/20;
        }
      }
    }
  }
}
void keyboardControl() {
  if (keyPressed==true) { 
    if (key == CODED) {
      if (keyCode == LEFT&& paddle_speed >=-AI_speed*27)paddle_speed -= AI_speed*3;

      if (keyCode ==  RIGHT&& paddle_speed <=AI_speed*27)paddle_speed += AI_speed*3;
    }
  }
  if (keyPressed == false) {
    if (paddle_speed <0) paddle_speed +=AI_speed*3; 
    if (paddle_speed >0) paddle_speed -=AI_speed*3;
  }
  if (left_corner <= -60)paddle_speed = abs(paddle_speed);
  if (left_corner >= width-60)paddle_speed = -abs(paddle_speed);
  left_corner += paddle_speed;
}
void runSmartAI() {
  if (x == x_initial&&y==y_initial&&lives>=1)
    launchBall();
  if (lives==0)
    resetGame();
  float x_target=x; 
  float y_target = y;
  int simulated_frames = 0;
  if (dx!=0) { 
    boolean rebound = false; 
    boolean rebound_L = false; 
    boolean rebound_R = false;
    while (y_target+diam/2 <= height - 60&& y_target+diam/2>=0) {              //simulate the game to determine where the ball will hit the paddle
      y_target += dy; 
      simulated_frames += 1;
      if (dy>0) {                                                    //consider rebounds for a downward-moving ball
        if (rebound == false)x_target += dx;
        if (rebound == true) x_target -= dx;
        if (x_target <0) {
          x_target -= 2*dx; 
          rebound = true;
        }
        if (x_target > width) {
          x_target -= 2*dx; 
          rebound = true;
        }
      }
      if (dy<0) {
        x_target += dx;
      }                                                         //ignore rebounds for an upward-moving ball
    } 
    rebound = false;
    if (number_of_boxes >= 0.2*nx*ny+1) {                           //run medium AI protocol for many boxes left
      if (abs(dx)/abs(dy)>4) {
        if (dx<0)paddle_target = 120;
        if (dx>0)paddle_target = 20;
      }      //correct overly horizontal movement
      else {
        if (abs(dx)<0.25*base_speed) {
          if (dx>0)paddle_target = 115;
          if (dx<0)paddle_target = 20;
        }
      } //correct overly vertical movement
    }
    if (number_of_boxes<0.2*nx*ny+1&&number_of_boxes>=2) {                     //target a specific box if few are left

      float x_target_block = x_target;                                        //track a new x-coordinate without changing the old one
      float nearest_block = width;

      for (i = 1; i < nx*ny+1; i++) {
        if (boxes[i]==1)if (abs(x - x_corner[i])<nearest_block) {
          target_block = i; 
          nearest_block = abs(x - x_corner[i]);
        }
      }
      while (y_target - diam/2 >= y_corner[target_block]+box_height) {          //run a second simulation of after the ball hits the paddle
        y_target -= abs(dy);                                            //move up by magnitude of y-speed, so we can ignore y-direction
        if (rebound == false)x_target_block += dx;
        if (rebound == true) x_target_block -= dx;
        if (x_target_block <0) {
          x_target_block -= 2*dx; 
          rebound_L = true;
        }
        if (x_target_block > width) {
          x_target_block -= 2*dx; 
          rebound_R = true;
        }
      }
      if (abs(dx)<0.25*base_speed) {
        if (dx>0)paddle_target = random(110, 115);
        if (dx<0)paddle_target = random(20, 25);
      }           //correct overly vertical movement
      if (abs(dx)>=1.4*base_speed) {
        if (dx<0)paddle_target = random(110, 115);
        if (dx>0)paddle_target = random(20, 25);
      }                    //correct overly horizontal movement

      if (x_target_block + diam/3  < x_corner[target_block]) {                           //if ball will miss to the left at current rate  
        paddle_target = random(115, 120);
      }
      if (x_target_block - diam/3 > x_corner[target_block]+box_width) {                  //if ball will miss to the right at current rate
        paddle_target = random(20, 25);
      }
      if (x_target_block - diam/3 <= x_corner[target_block]+box_width && x_target + diam/3 >= x_corner[target_block])paddle_target = random(40, 100);      //if block will hit, don't mess with it
    }
    if (x_target  > left_corner +paddle_speed*simulated_frames +paddle_target&& paddle_speed <25*AI_speed)
      paddle_speed += AI_speed;         //if you'll be left of the ball, accelerate right
    if (x_target  < left_corner+paddle_speed*simulated_frames+paddle_target - 20&&paddle_speed >-25*AI_speed)
      paddle_speed -=AI_speed;      //if you'll be right of the ball, accelerate left
  }
  if (left_corner <= -60)paddle_speed = AI_speed;                                //keep from going off the screen
  if (left_corner >= width-60)paddle_speed = -1*AI_speed;  
  left_corner += paddle_speed;
}

void wallCollisions() {
  if (x >= width -diam/2) {
    dx=-abs(dx); 
    if (dx <=-0.75*base_speed)dx += 0.01*base_speed;
  }
  if (x<= diam/2) { 
    dx = abs(dx);
    if (dx >= 0.75*base_speed)dx -=0.01*base_speed;
  } 
  if (y<= diam/2) { 
    dy = abs(dy); 
    if (dy >= 0.75*base_speed)dy -= 0.01*base_speed;
  }
}

void nextLife() {
  y = y_initial; 
  x= x_initial;
  dx=0;
  dy=0;
  if (can_lose_lives==1)lives -=1; 
  AI_delay = 40; //lose a life :(
  if (input_mode=="AI") {
    left_corner = 500;
    paddle_speed = 0;
  } //reset AI paddle Location
}
void drawAndMoveBall() {
  ellipse(x, y, diam, diam);
  x += dx;
  y += dy;
}
void boxCollisions() {
  dy_final = dy;                  //establish final x and y speed, to implement after collision
  dx_final = dx;
  if (dy<0) {
    for (i=0; i<nx*ny+1; i++) {           //loop through each box individually to see if it's a hit
      if (boxes[i]==1) {                               //but only check boxes that are drawn
        if (y-diam/2+dy <= y_corner[i] + box_height&& y >=y_corner[i]+box_height) {             //identify boxes in the right row
          if (x_corner[i]-(x+diam/3)>=0||(x-diam/3)- (x_corner[i]+box_width)>=0) {
          } else {       //identify lives in the right column
            dy_final = abs(dy); //queue change of direction, to be executed after all collisions have been checked for. this method should keep the ball from clipping into boxes.

            if (i==0);
            else {                      //don't break the unbreakable 0th box
              boxes[i]=0;
            }                          //delete the box that was hit
            score += 100*(combo+1)*(level+1);    //get points. increases with level and combo (blocks hit in a row)
            combo += 1; 
            target_block = nx*ny;
          }
        }
      }
    }
  }



  //from above
  if (dy>0) {
    for (i=0; i<nx*ny+1; i++) {                           
      if (boxes[i]==1) {
        if (y+diam/2+dy >= y_corner[i] && y<= y_corner[i]) {
          if (x_corner[i]-(x+diam/3)>=0||(x-diam/3)- (x_corner[i]+box_width)>=0) {
          } else {

            dy_final = -abs(dy);

            //collided_y = 5;
            if (i==0);
            else {
              boxes[i]=0;
            }
            score += 100*(combo+1)*(level+1);
            combo += 1; 
            target_block = nx*ny;
          }
        }
      }
    }
  }


  //horizontal
  //from the left
  if (dx>0) {
    for (i=0; i<nx*ny+1; i++) {
      if (boxes[i]==1) {
        if (x+diam/2+dx >= x_corner[i]&&x<=x_corner[i] ) {
          if (y_corner[i]<=y+diam/3 && y_corner[i]+box_height>=y - diam/3) {

            dx_final = -abs(dx);
            if (i==0);
            else {
              boxes[i]=0;
            }
            score += 100*(combo+1)*(level+1);
            combo +=1; 
            target_block = nx*ny;
          }
        }
      }
    }
  }

  //from the right
  if (dx<0) {
    for (i=0; i<nx*ny+1; i++) {
      if (boxes[i]==1) {
        if (x-diam/2+dx<=x_corner[i]+box_width&&x>=x_corner[i]+box_width) {
          if (y_corner[i]<=y+diam/3 && y_corner[i]+box_height>=y - diam/3) {

            dx_final = abs(dx);
            //  collided_x = 5;
            if (i==0);
            else {
              boxes[i]=0;
            }
            score += 100*(combo+1)*(level+1);
            combo +=1; 
            target_block = nx*ny;
          }
        }
      }
    }
  }


  //end collision testing; now change speeds
  dy=dy_final; 
  dx = dx_final;
}



void setMode() {
  if (mouseX < width/2-width/14-20&&mouseY<height/4+height/12) {
    input_mode="Mouse"; 
    initialized =true;
  }
  if (mouseX > width/2-width/14-20 && mouseX < width/2+width/14 && mouseY< height/4+height/12) {
    input_mode ="Keyboard"; 
    initialized = true;
  }
  if (mouseX > width/2+width/14+20 && mouseY < height/4+height/12) {
    input_mode = "AI"; 
    initialized = true;
  }
}

void drawBoxes() {
  for (i=0; i<nx*ny+1; i++) {  
    if (boxes[i]==1) {
      if (i==0) { //since zeroth box is unbreakable, draw it offscreen
        x_corner[i]=width+100; 
        y_corner[i]=height+100;
      }  

      else {
        x_corner[i]=width/16+(box_width+10)*boxes_x[i];              
        y_corner[i]=width/8+(box_height+10)*boxes_y[i];
      }            
      number_of_boxes += 1; 
      rect(x_corner[i], y_corner[i], box_width, box_height);

      if (number_of_boxes ==0) {
        dx=0;
        dy=0;
      }
    }
  }
  i = 0;
}
void drawHeadsUpDisplay() {
  textSize(32); 
  fill(255);     
  textAlign(LEFT, BOTTOM);
  if (lives>=1) {          //if you still have lives left
    text("Lives:", 157, 34);
    text(lives, 247, 34);
    text("Level:", 2, 34);
    text(level+1, 95, 34);
    if (can_lose_lives == 0)text("INFINITE LIVES", width/2, 34);
  } else {     //game over screen
    textSize(40);
    textAlign(LEFT, TOP);
    text("Game Over", 2, 2);
    textSize(32);
    textAlign(LEFT, BOTTOM);
  }
  text("Score:", width-300, 34);
  text(score, width-200, 34);
  if (x==x_initial&&y==y_initial&&start_countdown<=0&&input_mode!="AI") {
    if (lives==0)text("Click anywhere or press enter to reset game", 2, 74); 
    else text("Click anywhere or press enter to launch ball", 2, 74);
  }
}

void drawMenu() {
  textSize(64); 
  fill(255); 
  textAlign(CENTER, CENTER);
  text("Select Mode:", width/2, height/8);
  rect(width/2-3*width/14-20, height/4, width/7, height/12);
  rect(width/2-width/14, height/4, width/7, height/12);
  rect(width/2+width/14+20, height/4, width/7, height/12);
  fill(0); 
  textSize(32);
  text("Mouse", width/2-3*width/14-20+width/14, height/4+height/24);
  text("Keyboard", width/2-width/15+width/14, height/4+height/24);
  text ("AI Demo", width/2+width/7+20, height/4+height/24);
}

void launchBall() {
  if (input_mode=="AI"&&AI_delay>=1)AI_delay -=1;
  if (AI_delay == 0||input_mode!="AI") {
    dx=base_speed*random(0.5, 1.1);
    dy=base_speed;
  }
}


void resetGame() {
  score=0; 
  lives = 3; 
  level=0;
  base_speed = starting_speed;
  for (int i=0; i<nx*ny+1; i++)boxes[i]=1;                         
  left_corner = 500; 
  paddle_speed = 0;
  initialized = false;
  start_countdown = 50;
  cursor();
}

void populateBoxes() {
  for (int i=0; i<nx*ny+1; i++) {
    boxes[i]=1;
    boxes_x[i]=(i-1+nx) % nx;          //column number
    boxes_y[i]=(i-1+ny) % ny;          //row number
  }
}