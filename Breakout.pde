//v1.3 started adding mulitplayer; cleaned up text and paddle collision parameters


//call all global variables


int nx = 10;             //number of columns, must not be divisible by number of rows, otherwise safe to change
int ny = 3;             //number of rows, safe to change
int level = 0;
int i=0;
int combo=0;
int score=0;
int balls =3;          //starting lives, safe to change
int can_lose_lives = 1; //ability to lose lives. safe to change, cheater
float x = 50;           //starting x-position, safe to change
float x_initial = x;
float y= 400;           //starting y-position, important to change if resolution is changed dramatically.
float y_initial = y;
float starting_speed = 6;    //starting speed, safe to change
float base_speed = starting_speed;
float dx = 0;
float dy = 0;
float diam =30;         //ball diameter, safe to change
int input_mode = 3;      //0 for mouse, 1 for keyboard, 2 for AI Demo, 3 for VS AI
float left_corner = 100;    //default paddle start location
float left_corner_multi = 100;
float paddle_speed = 0;
float AI_speed = 0.5;
float AI_delay = 40;
float paddle_target =random(40,80);
float AI_intelligence = 2;     //currently works from 0 to 2
int[] boxes =  new int[nx*ny+1];
int[] boxes_x = new int[nx*ny+1];
int[] boxes_y = new int[nx*ny+1];
float[] x_corner = new float[nx*ny+1];
float[] y_corner = new float[nx*ny+1];
int number_of_boxes = 0;
int target_block = nx*ny;
int initialized = 0;
boolean paused = false; float dx_pause = 1; float dy_pause = 1; int pause_delay = 0;
boolean ball_location_initialized = false;
int ball_owner = 0;
int start_countdown = 40;//checks how far your are through the settings menu
//int collided_y = 0; int collided_x = 0; //old workaround for multi-collisions
//int zeroth_box_broken = 0;    //workaround for zeroth box bug, but doesn't seem to work.


void setup() {
  size(1440,900);      //this game should be fairly resolution-independent

//populate box matricies so that their positions and sizes can be drawn
  for (int i=0; i<nx*ny+1; i++) {
    boxes[i]=1;
    boxes_x[i]=(i-1+nx) % nx;          //column number
    boxes_y[i]=(i-1+ny) % ny;          //row number
  }
}

//click the mouse to start the ball at a new level or life, or reset game
void mousePressed() {
  if (paused==false){
if (start_countdown <=0){
  if (x == x_initial&&y==y_initial&&balls>=1) {        //launch ball
    dx=base_speed*random(0.5,0.9);
    dy=base_speed*1.2;
  }}
  if (balls==0){ score=0; balls = 3; level=0;                    //reset
  base_speed = starting_speed;
  for (int i=0; i<nx*ny+1;i++)boxes[i]=1;                         //the game
  left_corner = 500; paddle_speed = 0;

  start_countdown = 40;
  cursor();
  
  //zeroth_box_broken=0;
  //if the number of boxes grows at each level, i need to reset them to their inital values and rebuild the arrays here too
  }}
  
}

void keyPressed() {
  if(keyCode == ENTER){
    if (paused==false){
if (start_countdown <=0){
  if (x == x_initial&&y==y_initial&&balls>=1) {        //launch ball
    dx=base_speed*random(0.5,0.9);
    dy=base_speed*1.2;
  }}
  if (balls==0){ score=0; balls = 3; level=0;                    //reset
  base_speed = starting_speed;
  for (int i=0; i<nx*ny+1;i++)boxes[i]=1;                         //the game
  left_corner = 500; paddle_speed = 0;
  initialized = 0;
  start_countdown = 50;
  cursor();
  
  //zeroth_box_broken=0;
  //if the number of boxes grows at each level, i need to reset them to their inital values and rebuild the arrays here too
  }}}
if(key == ' '){
if (paused == false&& pause_delay==0){ dy_pause = dy; dx_pause = dx; dx= 0; dy= 0; paused = true;pause_delay = 40;}

if (paused == true&&pause_delay == 0){dx = dx_pause; dy = dy_pause; paused = false;pause_delay = 40;}


}
  
}

void draw() {
  background(200, 100, 0);
  number_of_boxes = 0;             //for bookkeeping and to be sure when the level is finished
  
  
  
  
  //settings menu
  if (initialized <=1&&start_countdown>=41)start_countdown--;
  if (initialized <=1&&start_countdown<=40){
    textSize(64); fill(255);textAlign(CENTER, CENTER);
    text("Select Mode:",width/2, height/8);
    if (initialized == 0){rect(width/2-3*width/14-20, height/4, width/7, height/12);              //show all top row boxes if no initialization
    rect(width/2-width/14, height/4, width/7, height/12);
  rect(width/2+width/14+20, height/4, width/7, height/12);}
    
     if (initialized == 1){rect(width/2-3*width/14-20, height/4+height/12+20, width/7, height/12);                        //show second row if on 2nd step
    rect(width/2-width/14, height/4+height/12+20, width/7, height/12);
  if(input_mode>=2)rect(width/2+width/14+20, height/4+height/12+20, width/7, height/12);                          //2nd row, 3rd box only for vs AI and AI Demo modes
if(input_mode ==2)rect(width/2+width/14+20, height/4, width/7, height/12);                                             //keep AI Demo box                         
if(input_mode<=1)rect(width/2-3*width/14-20, height/4, width/7, height/12);                                            //keep Solo box
if(input_mode==3)rect(width/2-width/14, height/4, width/7, height/12);}                                  //keep vs AI box
    
    fill(0); textSize(32); 
    
    if(initialized == 0){text("Solo", width/2-3*width/14-20+width/14, height/4+height/24);
    text("VS AI", width/2-width/15+width/14, height/4+height/24);
  text ("AI Demo", width/2+width/7+20, height/4+height/24);}
    
    if(initialized == 1&&input_mode ==2){text("Basic", width/2-3*width/14-20+width/14, height/4+height/12+20+height/24);                          //text for AI Demo
    text("Smart", width/2-width/15+width/14, height/4+height/12+20+height/24);
  text("Smarter", width/2+width/7+20, height/4+height/12+20+height/24);
text ("AI Demo", width/2+width/7+20, height/4+height/24);}
  
      if(initialized == 1&&input_mode == 3){text("Easy", width/2-3*width/14-20+width/14, height/4+height/12+20+height/24);                    //text for vs AI
    text("Medium", width/2-width/15+width/14, height/4+height/12+20+height/24);
  text("Hard", width/2+width/7+20, height/4+height/12+20+height/24);
text("VS AI", width/2-width/15+width/14, height/4+height/24);}

if(initialized == 1&&input_mode<=1){text("Mouse", width/2-3*width/14-20+width/14, height/4+height/12+20+height/24);                            //text for solo; choose mouse or keyboard
text("Keyboard", width/2-width/15+width/14, height/4+height/12+20+height/24);
text("Solo", width/2-3*width/14-20+width/14, height/4+height/24);}
  
    
    
    if (mousePressed==true&&initialized ==0){                                                                            //initial selection
    if (mouseX < width/2-width/14-20&&mouseY<height/4+height/12){input_mode=0; initialized =1;}
    if (mouseX > width/2-width/14-20 && mouseX < width/2+width/14 && mouseY< height/4+height/12){input_mode =3; initialized = 1;}
    if (mouseX > width/2+width/14+20 && mouseY < height/4+height/12){input_mode = 2; initialized = 1;}
    }
    if(mousePressed==true&&initialized==1&&input_mode>=2){                                                                  //AI settings
    if(mouseX < width/2-width/14-20&&mouseY>height/4+height/12+20){AI_intelligence = 0; initialized = 2;}
    if (mouseX > width/2-width/14-20 && mouseX < width/2+width/14 && mouseY> height/4+height/12+20){AI_intelligence =1; initialized = 2;}
    if (mouseX > width/2+width/14+20 && mouseY > height/4+height/12+20){AI_intelligence = 2; initialized = 2;}
    }
      if(mousePressed==true&&initialized==1&&input_mode<=1){
    if(mouseX < width/2-width/14-20&&mouseY>height/4+height/12+20){input_mode = 0; initialized = 2;}                          //mouse or keyboard for solo
    if (mouseX > width/2-width/14-20 && mouseX < width/2+width/14 && mouseY> height/4+height/12+20){input_mode = 1; initialized = 2;}
    
    }
  }
  
  
  
  
  //start actual game
  if (initialized ==2){
    if(start_countdown>=1)start_countdown -=1;
    if(pause_delay>=1)pause_delay -=1;
    if(ball_location_initialized ==false){y_initial=2*height/3+10; y= y_initial;left_corner = width/8;ball_location_initialized = true;}
    noCursor();
    textAlign(LEFT,BOTTOM);
  textSize(32); fill(255);
  float text_offset = 0;
  if(input_mode>=3)text_offset = height/10;
  if (balls>=1) {if(input_mode<=2){
    text("Balls:", 157, 34);
    text(balls, 237, 34);}
    if(input_mode>=3){
    text("Balls:", 2, 74+text_offset);
    text(balls, 82, 74+text_offset);}
      text("Level:", 2, 34+text_offset);
  text(level+1, 95, 34+text_offset);
  } else {
    textSize(40);
    textAlign(LEFT,TOP);
    text("Game Over", 2, 2);
    textSize(32);
    textAlign(LEFT,BOTTOM);
  }
  text("Score:", width-300, 34+text_offset);
  text(score, width-200, 34+text_offset);
  if (x==x_initial&&y==y_initial&&start_countdown<=0&&input_mode!=2){
    if(input_mode<=1){
    if (balls==0)text("Click anywhere or press enter to reset game", 2, 74); 
    else text("Click anywhere or press enter to launch ball", 2, 74);}
if(input_mode>=3){  
    if (balls==0)text("Click anywhere or press enter to reset game", 2, 114+text_offset); 
    else text("Click anywhere or press enter to launch ball", 2, 114+text_offset);}
}
 
 
  //display for speed
  //text("Speed:", width-210, height-100);
  //text (sqrt(dy*dy+dx*dx), width-110, height-100);
  
  
  float box_height = 0;
  float box_width = 0;
  
  //draw boxes - single player
  if(input_mode<=2){
  box_width=(width*7/8-10*(nx-1))/nx;
  box_height=((height/3-width/16)-10*(ny-1))/ny;
  for (i=0; i<nx*ny+1; i++) {                       //previously i = zeroth_box_broken
    if (boxes[i]==1) {
      if (i==0){x_corner[i]=width+100; y_corner[i]=height+100;}
      //since zeroth box is unbreakable, draw it as such
      else{x_corner[i]=width/16+(box_width+10)*boxes_x[i];              
      y_corner[i]=width/16+(box_height+10)*boxes_y[i]; }            
      number_of_boxes += 1; 
      rect(x_corner[i], y_corner[i], box_width, box_height);

    
    if (number_of_boxes ==0) {
      dx=0;
      dy=0;
    }}
  }
  }
  
  //draw boxes - multiplayer
  if(input_mode>=3){
  box_width = (width*5/6-10*(nx-1))/nx;
  box_height = ((height/5)-10*(ny-1))/ny;
  for (i=0; i<nx*ny+1; i++) {                       //previously i = zeroth_box_broken
    if (boxes[i]==1) {
      if (i==0){x_corner[i]=width+100; y_corner[i]=height+100;}
      //since zeroth box is unbreakable, draw it as such
      else{x_corner[i]=width/12+(box_width+10)*boxes_x[i];              
      y_corner[i]=3*height/10+(box_height+10)*boxes_y[i]; }            
      number_of_boxes += 1; 
      rect(x_corner[i], y_corner[i], box_width, box_height);

    
    if (number_of_boxes ==0) {
      dx=0;
      dy=0;
    }}
  }  
  
  
  }









//collision with boxes
float dy_final = dy;                  //establish final x and y speed, to implement after collision
float dx_final = dx;
boolean in_collision_zone = false;
if (y-diam-abs(dy) <= height/3&&input_mode<=2)in_collision_zone = true;     //ensure the ball is in the part of the screen where the boxes are (to save on processing)
if (y-diam-abs(dy)<= height/2&&input_mode>=3)in_collision_zone = true;
if (in_collision_zone ==true){

  
//vertical  
//if (collided_y>=1) collided_y -=1; else{ //ensure collisions don't happen more than once every 5 frames, seems to be unnecessary
//from below
if (dy<0){
for (i=0; i<nx*ny+1; i++){           //loop through each box individually to see if it's a hit, previously i = zeroth_box_broken
  if (boxes[i]==1){                               //but only check boxes that are drawn
if (y-diam/2+dy <= y_corner[i] + box_height&& y >=y_corner[i]+box_height){                                          //identify boxes in the right row
  if (x_corner[i]-(x+diam/3)>=0||(x-diam/3)- (x_corner[i]+box_width)>=0){}else{       //identify balls in the right column
  
  
dy_final = abs(dy);              //queue change of direction, to be executed after all collisions have been checked for. this method should keep the ball from clipping into boxes.


//collided_y = 5;                         //a collision happened! don't process another one for a little bit.
if (i==0);else{                      //this line used to set zeroth_box_broken to zero
boxes[i]=0;}                          //delete the box that was hit
score += 100*(combo+1)*(level+1);    //get points. increases with level and combo (blocks hit in a row)
combo += 1; target_block = nx*ny;

}}}}}
//}


//from above
//if (collided_y<=0){
if (dy>0){
for (i=0; i<nx*ny+1; i++){                            //previously i=zeroth_box_broken
  if (boxes[i]==1){
if (y+diam/2+dy >= y_corner[i] && y<= y_corner[i]){
  if (x_corner[i]-(x+diam/3)>=0||(x-diam/3)- (x_corner[i]+box_width)>=0){}else{
  
dy_final = -abs(dy);

//collided_y = 5;
if (i==0);else{
  boxes[i]=0;}
score += 100*(combo+1)*(level+1);
combo += 1; target_block = nx*ny;

  }}}}}
//}

 



//horizontal
//if (collided_x>=1) collided_x -=1; else{ //prevent multi-hits, as above
//from the left
if (dx>0){
  for (i=0; i<nx*ny+1;i++){
if (boxes[i]==1){
if(x+diam/2+dx >= x_corner[i]&&x<=x_corner[i] ){
if(y_corner[i]<=y+diam/3 && y_corner[i]+box_height>=y - diam/3){
  
  dx_final = -abs(dx);
//  collided_x = 5;
  if (i==0);else{
    boxes[i]=0;}
  score += 100*(combo+1)*(level+1);
  combo +=1; target_block = nx*ny;

}}}}}
//}



//from the right
//if (collided_x<=0){
if (dx<0){
  for (i=0; i<nx*ny+1;i++){
if (boxes[i]==1){
if(x-diam/2+dx<=x_corner[i]+box_width&&x>=x_corner[i]+box_width){
if(y_corner[i]<=y+diam/3 && y_corner[i]+box_height>=y - diam/3){
  
  dx_final = abs(dx);
//  collided_x = 5;
  if (i==0);else{
    boxes[i]=0;}
  score += 100*(combo+1)*(level+1);
  combo +=1; target_block = nx*ny;
}}}}}
//}



//end collision testing; change speeds
} dy=dy_final; dx = dx_final;








 //draw ball 
   if(ball_owner == 0){fill(0,255,0);
  ellipse(x, y, diam, diam);
  x += dx;
  y += dy;}
  if(ball_owner == 1){fill(0,0,255);
  ellipse(x, y, diam, diam);
  x += dx;
  y += dy;}
  fill(255);
//falling through the bottom
  if (y >= height - 5) {
    y = y_initial; 
    x= x_initial;
    dx=0;
    dy=0;
    if(can_lose_lives==1)balls -=1; AI_delay = 40; 
  if(input_mode==2){left_corner = width/8;paddle_speed = 0;}}
  
  //collision with walls
  if (x >= width -diam/2){dx=-abs(dx); if (dx <=-0.75*base_speed)dx += 0.01*base_speed;}
if(x<= diam/2){ dx = abs(dx);if (dx >= 0.75*base_speed)dx -=0.01*base_speed;} 

  if(input_mode<=2){if (y<= diam/2){ dy = abs(dy); if (dy >= 0.75*base_speed)dy -= 0.01*base_speed;}}   //collide with top in single-player
  if(input_mode>=3){if (y<=diam/2){ y = y_initial; x = x_initial; dx=0; dy=0; score += 1000*(level + 1);}}        //fall off top (and give pts) in multiplayer

//keyboard controls
if(input_mode ==1){
  if (keyPressed==true) { 
    if (key == CODED) {
      if (keyCode == LEFT&& paddle_speed >=-14)paddle_speed -= 2;

      if (keyCode ==  RIGHT&& paddle_speed <=14)paddle_speed += 2;
    }
  }
  if(keyPressed == false){if (paddle_speed <0) paddle_speed +=2; if (paddle_speed >0) paddle_speed -=2;}
//if(left_corner>=0 && left_corner + 120 <= width)
if (left_corner <= -60)paddle_speed = abs(paddle_speed);
if (left_corner >= width-60)paddle_speed = -abs(paddle_speed);
left_corner += paddle_speed;}






//easy AI predicts ball's location, damps movement to reduce overshoot
if (input_mode == 2 && AI_intelligence == 0){ 
float x_target=x; float y_target = y;
if (dx!=0){ boolean rebound = false;
while (y_target+diam/2 <= height - 60&& y_target+diam/2>=0){                                                      //calculate where it will hit    
  y_target += dy;
  if (dy>0){                                                                              //consider rebounds
  if (rebound == false)x_target += dx;
  if (rebound == true) x_target -= dx;
  if (x_target <0){x_target -= 2*dx; rebound = true;}
  if (x_target > width){x_target -= 2*dx; rebound = true;}}
    if (dy<0){x_target += dx;}                                                         
  } rebound = false;
  if (x_target > left_corner + paddle_target&& paddle_speed <20*AI_speed) paddle_speed += AI_speed;          //accelerate towards
  if (x_target < left_corner+paddle_target - 20&&paddle_speed >-20*AI_speed) paddle_speed -=AI_speed;       //the balls' predicted location, aiming for randomized part of paddle
  if(x_target >= left_corner +paddle_target - 20&& x_target <= left_corner + paddle_target){
  if(abs(paddle_speed)<= 3*AI_speed)paddle_speed=0;else{                                                  //if you're there, slow down, to reduce overshoot
  if (paddle_speed>0)paddle_speed -=3*AI_speed;if (paddle_speed<0)paddle_speed+=3*AI_speed;}}

    
 
  }

if (left_corner <= -60)paddle_speed = AI_speed;                                //keep from going off the screen
if (left_corner >= width-60)paddle_speed = -1*AI_speed;  
left_corner += paddle_speed;


}

//medium AI predicts location of ball and paddle, tries to correct bad ball movement patterns
if (input_mode == 2 && AI_intelligence == 1){ 
float x_target=x; float y_target = y;int simulated_frames = 0;
if (dx!=0){ boolean rebound = false; 
while (y_target+diam/2 <= height - 60&& y_target+diam/2>=0){                                                      //calculate where it will hit    
  y_target += dy; simulated_frames += 1;
  if (dy>0){                                                                              //consider rebounds for a downward-moving ball
  if (rebound == false)x_target += dx;
  if (rebound == true) x_target -= dx;
  if (x_target <0){x_target -= 2*dx; rebound = true;}
  if (x_target > width){x_target -= 2*dx; rebound = true;}}
    if (dy<0){x_target += dx;}                                                         //ignore rebounds for an upward-moving ball
  } rebound = false;
  if (abs(dx)<0.25*base_speed){if (dx>0)paddle_target = random(110,115);if(dx<0)paddle_target = random(20,25);}           //correct overly vertical movement
  if(abs(dx)>=1.4*base_speed){if (dx<0)paddle_target = random(110,115);if(dx>0)paddle_target = random(20,25);}                    //correct overly horizontal movement
  if (x_target > left_corner +paddle_speed*simulated_frames +paddle_target&& paddle_speed <20*AI_speed) paddle_speed += AI_speed;            //if you'll undershoot the target, speed up
  if (x_target < left_corner+paddle_speed*simulated_frames+paddle_target - 20&&paddle_speed >-20*AI_speed) paddle_speed -=AI_speed;         //if you'll overshoot the target, slow down

  
  }

if (left_corner <= -60)paddle_speed = AI_speed;                                //keep from going off the screen
if (left_corner >= width-60)paddle_speed = -1*AI_speed;  
left_corner += paddle_speed;


}


//hard AI predicts location of ball and paddle, is faster, tries to correct bad ball movement patterns, actively seeks out last few boxes
if (input_mode == 2 && AI_intelligence == 2){ 
float x_target=x; float y_target = y;int simulated_frames = 0;
if (dx!=0){ boolean rebound = false; boolean rebound_L = false; boolean rebound_R = false;
while (y_target+diam/2 <= height - 60&& y_target+diam/2>=0){                                                      //calculate where it will hit    
  y_target += dy; simulated_frames += 1;
  if (dy>0){                                                                              //consider rebounds for a downward-moving ball
  if (rebound == false)x_target += dx;
  if (rebound == true) x_target -= dx;
  if (x_target <0){x_target -= 2*dx; rebound = true;}
  if (x_target > width){x_target -= 2*dx; rebound = true;}}
    if (dy<0){x_target += dx;}                                                         //ignore rebounds for an upward-moving ball
  } rebound = false;
  if(number_of_boxes >= 0.2*nx*ny+1){                                                //run medium AI protocol for many boxes left
  if(abs(dx)/abs(dy)>4){if (dx<0)paddle_target = 120;if(dx>0)paddle_target = 20;}      //correct overly horizontal movement
  else{if (abs(dx)<0.25*base_speed){if (dx>0)paddle_target = 115;if(dx<0)paddle_target = 20;}} //correct overly vertical movement
  }
  if(number_of_boxes<0.2*nx*ny+1&&number_of_boxes>=2){                                   //target a specific box if few are left

    float x_target_block = x_target;                                        //track a new x-coordinate without changing the old one
float nearest_block = width;

for (i = 1; i < nx*ny+1;i++){
  if (boxes[i]==1)if (abs(x - x_corner[i])<nearest_block){target_block = i; nearest_block = abs(x - x_corner[i]);
}}

  while (y_target - diam/2 >= y_corner[target_block]+box_height){          //run a second simulation of after the ball hits the paddle
  y_target -= abs(dy);                                            //move up by magnitude of y-speed, so we can ignore y-direction
  if (rebound == false)x_target_block += dx;
  if (rebound == true) x_target_block -= dx;
  if (x_target_block <0){x_target_block -= 2*dx; rebound_L = true;}
  if (x_target_block > width){x_target_block -= 2*dx; rebound_R = true;}}


  if (abs(dx)<0.25*base_speed){if (dx>0)paddle_target = random(110,115);if(dx<0)paddle_target = random(20,25);}           //correct overly vertical movement
  if(abs(dx)>=1.4*base_speed){if (dx<0)paddle_target = random(110,115);if(dx>0)paddle_target = random(20,25);}                    //correct overly horizontal movement

  
if (x_target_block + diam/3  < x_corner[target_block]){                           //if ball will miss to the left at current rate  
paddle_target = random(115,120);}
//if (rebound_L == false)paddle_target = random(110,120); if (rebound_L == true)paddle_target = random(20,30);}
if (x_target_block - diam/3 > x_corner[target_block]+box_width){                  //if ball will miss to the right at current rate
paddle_target = random(20,25);}
//if (rebound_R == false)paddle_target = random(20,30); if (rebound_R == true)paddle_target = random(110,120);}
if(x_target_block - diam/3 <= x_corner[target_block]+box_width && x_target + diam/3 >= x_corner[target_block])paddle_target = random(40,100);      //if block will hit, don't mess with it


}
  if (x_target  > left_corner +paddle_speed*simulated_frames +paddle_target&& paddle_speed <25*AI_speed) paddle_speed += AI_speed;         //if you'll be left of the ball, accelerate right
  if (x_target  < left_corner+paddle_speed*simulated_frames+paddle_target - 20&&paddle_speed >-25*AI_speed) paddle_speed -=AI_speed;      //if you'll be right of the ball, accelerate left

  
  }

if (left_corner <= -60)paddle_speed = AI_speed;                                //keep from going off the screen
if (left_corner >= width-60)paddle_speed = -1*AI_speed;  
left_corner += paddle_speed;


}





  //draw paddle
  if (input_mode == 0||input_mode>=3)left_corner = mouseX-60;        //mouse mode
  //left_corner_multi = mouseX - 60;        //to test multiplayer w/o AI
  float right_corner = left_corner + 120;            //keyboard mode
  float right_corner_multi = left_corner_multi + 120;        
  fill(0,255,0);rect(left_corner, height-60, 120, 30); 

  if (input_mode >=3){fill(0,0,255);rect(left_corner_multi, 30, 120, 30);}
  fill(255);
 
  //collisions with paddle
  if (dy>0 && y > height/2){                                                   //only check for paddle collisions in the bottom half of the screen
    if (y + diam/2 + dy >= height-60 && y <= height-60+dy){                                  //check ball's y-coordinate
  
      if (x + dx + diam/2 >= left_corner && x + dx -diam/2 <= right_corner){            //check ball's x-coordinate
          dy_final = -abs(dy);
          dy = dy_final;
          paddle_target =random(35,105);
          target_block = nx*ny;
          combo = 0;
          ball_owner = 0;
          
          if (dx>=base_speed*-1.5){
            if (right_corner - x >= 90){                                            //bounce off of corners in the opposite direction
              dx -= (right_corner - x - 60)*base_speed/100;                         //and slightly accelerate upwards
              if (abs(dy)<=base_speed*1.5)dy -= base_speed/20;}
          }
          if(dx<=base_speed*1.5){
            if(x - left_corner >= 90){
              dx += (x - left_corner - 60)*base_speed/100;
              if (abs(dy)<=base_speed*1.5)dy -= base_speed/20;} 
          }

}}}
        //collisions with upper paddle
  if (dy<0 && y<height/2&&input_mode>=3){
  if (y-diam/2+dy<= 60 && y>= 60+dy){
    if (x + dx + diam/2 >= left_corner_multi && x + dx -diam/2 <= right_corner_multi){ 
  dy = abs(dy);
  paddle_target = random(35,105);
  target_block = nx*ny;
  combo = 0;
  ball_owner = 1;
  

          if (dx>=base_speed*-1.5){
            if (right_corner - x >= 90){                                            //bounce off of corners in the opposite direction
              dx -= (right_corner - x - 60)*base_speed/100;                         //and slightly accelerate upwards
              if (abs(dy)<=base_speed*1.5)dy -= base_speed/20;}
          }
          if(dx<=base_speed*1.5){
            if(x - left_corner >= 90){
              dx += (x - left_corner - 60)*base_speed/100;
              if (abs(dy)<=base_speed*1.5)dy -= base_speed/20;} 
          }

  
    }}}   
      
//move on to next level
if (number_of_boxes <= 1){            //if (number_of_boxes <= 0&&zeroth_box_broken==1){
textSize(64);
if(input_mode !=2)text("Click to go on to level", width/16, height/2);
text(level+2, width/16+685, height/2); dx=0;dy=0; AI_delay = 50; paddle_speed = 0;

if (mousePressed == true){
level +=1;
if (level % 3 == 0) balls +=1;
  base_speed += 0.7;

//I'd love to be able to implement an increase in boxes as level increases.
//nx += 1;
//if (level % 4 == 0) ny +=1;
//if (nx <= 3*ny) nx+=1;

number_of_boxes = 2;
left_corner = 500; paddle_speed = 0;
//zeroth_box_broken=0;
 for (int i=0; i<nx*ny+1; i++) {
    boxes[i]=1;}
x = x_initial; y = y_initial;}






//next level in AI mode
if (input_mode == 2){
level +=1;
AI_delay -=1;
if (level % 3 == 0) balls +=1;
  base_speed += 0.7;
  AI_speed += 0.1;
  left_corner = 500;
  
  


//I'd love to be able to implement an increase in boxes as level increases.
//nx += 1;
//if (level % 4 == 0) ny +=1;
//if (nx <= 3*ny) nx+=1;

number_of_boxes = 2;
left_corner = 500;
//zeroth_box_broken=0;
 for (int i=0; i<nx*ny+1; i++) {
    boxes[i]=1;}
x = x_initial; y = y_initial;}
}

//AI auto-launching ball
  if(input_mode ==2){if (x == x_initial&&y==y_initial&&balls>=1) {        //launch ball
      AI_delay -=1;
     if(AI_delay == 0){
     dx=base_speed;
    dy=base_speed;}
  }

  }

//end post-initialization protocol
}
//end draw, move on to next frame
}
