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
int input_mode = 0;      //0 for mouse, 1 for keyboard
float left_corner = 500;    //default paddle start location
float paddle_speed = 0;
int[] boxes =  new int[nx*ny+1];
int[] boxes_x = new int[nx*ny+1];
int[] boxes_y = new int[nx*ny+1];
float[] x_corner = new float[nx*ny+1];
float[] y_corner = new float[nx*ny+1];
int number_of_boxes = 0;
//int collided_y = 0; int collided_x = 0; //old workaround for multi-collisions
//int zeroth_box_broken = 0;    //workaround for zeroth box bug, but doesn't seem to work.


void setup() {
  size(1440, 900);      //this game should be fairly resolution-independent
  
//populate box matricies so that their positions and sizes can be drawn
  for (int i=0; i<nx*ny+1; i++) {
    boxes[i]=1;
    boxes_x[i]=(i-1+nx) % nx;          //column number
    boxes_y[i]=(i-1+ny) % ny;          //row number
  }
}

//click the mouse to start the ball at a new level or life, or reset game
void mousePressed() {

  if (x == x_initial&&y==y_initial&&balls>=1) {        //launch ball
    dx=base_speed;
    dy=base_speed;
  }
  if (balls==0){ score=0; balls = 3; level=0;                    //reset
  base_speed = starting_speed;
  for (int i=0; i<nx*ny+1;i++)boxes[i]=1;                         //the game
  left_corner = 500;
  //zeroth_box_broken=0;
  //if the number of boxes grows at each level, i need to reset them to their inital values and rebuild the arrays here too
  }
  
}


//the draw loop, starting with background and HUD
void draw() {
  noCursor();
  background(200, 100, 0);
  number_of_boxes = 0;             //for bookkeeping and to be sure when the level is finished
  textSize(32);
  if (balls>=1) {
    text("Balls:", 157, 34);
    text(balls, 237, 34);
     text("Level:", 2, 34);
  text(level+1, 95, 34);
  } else {
    textSize(40);
    text("Game Over", 0, 34);
    textSize(32);
  }
  text("Score:", width-300, 34);
  text(score, width-200, 34);
  if (x==x_initial&&y==y_initial){
    if (balls==0)text("Click anywhere to reset game", 2, 74); 
    else text("Click anywhere to launch ball", 2, 74);}
 
  text("Speed:", width-210, height-100);
  text (sqrt(dy*dy+dx*dx), width-110, height-100);
  
  
  
  
  //draw boxes
  float box_width=(width*7/8-10*(nx-1))/nx;
  float box_height=((height/3-width/8)-10*(ny-1))/ny;
  for (i=0; i<nx*ny+1; i++) {                       //previously i = zeroth_box_broken
    if (boxes[i]==1) {
      if (i==0){x_corner[i]=width+100; y_corner[i]=height+100;}
      //since zeroth box is unbreakable, draw it as such
      else{x_corner[i]=width/16+(box_width+10)*boxes_x[i];              
      y_corner[i]=width/8+(box_height+10)*boxes_y[i]; }            
      number_of_boxes += 1; 
      rect(x_corner[i], y_corner[i], box_width, box_height);

    
    if (number_of_boxes ==0) {
      dx=0;
      dy=0;
    }}
  }

  i=0;







//collision with boxes
float dy_final = dy;                  //establish final x and y speed, to implement after collision
float dx_final = dx;
if (y-diam-abs(dy) <= height/3){     //ensure the ball is in the part of the screen where the boxes are (to save on processing)


  
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
combo += 1;

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
combo += 1;

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
  combo +=1;

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
  combo +=1;
}}}}}
//}



//end collision testing; change speeds
} dy=dy_final; dx = dx_final;








 //drawball 

  ellipse(x, y, diam, diam);
  x += dx;
  y += dy;
  
  
//falling through the bottom
  if (y >= height - 5) {
    y = y_initial; 
    x= x_initial;
    dx=0;
    dy=0;
    if(can_lose_lives==1)balls -=1; }
  
  //collision with walls
  if (x >= width -diam/2||x<= diam/2) dx = -dx;
  if (y<= diam/2) dy = -dy;


  if (keyPressed==true) { 
    if (key == CODED) {
      if (keyCode == LEFT&& paddle_speed >=-14)paddle_speed -= 2F;

      if (keyCode ==  RIGHT&& paddle_speed <=14)paddle_speed += 2;
    }
  }
  if(keyPressed == false){if (paddle_speed <0) paddle_speed +=2; if (paddle_speed >0) paddle_speed -=2;}
//if(left_corner>=0 && left_corner + 120 <= width)
if (left_corner <= -60)paddle_speed = abs(paddle_speed);
if (left_corner >= width-60)paddle_speed = -abs(paddle_speed);
left_corner += paddle_speed;




  //draw paddle
  if (input_mode == 0)left_corner = mouseX-60;        //mouse mode
  float right_corner = left_corner + 120;            //keyboard mode
          
  rect(left_corner, height-60, 120, 30);

  
 
  //collisions with paddle
  if (dy>0 && y > height/2){                                                   //only check for paddle collisions in the bottom half of the screen
    if (y + diam/2 + dy >= height-60 && y <= height-60){                                  //check ball's y-coordinate
  
      if (x + dy + diam/2 >= left_corner && x + dy -diam/2 <= right_corner){            //check ball's x-coordinate
          dy_final = -abs(dy);
          dy = dy_final;
          combo = 0;
          
          if (abs(dx)<=base_speed*1.5){
            if (right_corner - x >= 100){                                            //bounce off of corners in the opposite direction
              dx -= (right_corner - x - 60)*base_speed/100;                         //and slightly accelerate upwards
              if (abs(dy)<=base_speed*1.5)dy -= base_speed/20;}
            
            if(x - left_corner >= 100){
              dx += (x - left_corner - 60)*base_speed/100;
              if (abs(dy)<=base_speed*1.5)dy -= base_speed/20;} 
          }
          if(abs(dy)>=2/3*base_speed && abs(dx) >= base_speed/2){
            if(x - left_corner >= 45 && x - left_corner <= 90){      //slightly decelerate if the center of the paddle is hit
              dy += base_speed/5;}}
}}}
  
  
  /*        //old collisions mode
  float distanceX = x-mouseX;
  if (y+diam/2+dy>=height-60 && abs(distanceX)<=60+diam/2 && y<=height-60) {   //check if the ball hit the paddle
    float dy_up = abs(dy);                                                          //reverse direction
    dy = -dy_up;                                                                   //hopefully without clipping
    combo = 0;
    if (abs(distanceX)<=15&&abs(dx)>=0.5*base_speed){                          //if it hits the middle of the paddle, slow down
    if (dx<0) dx += base_speed/5;                                              
    if (dx>0) dx -= base_speed/5;
    
    }
    if (abs(distanceX)>=40) {                                                   //if it hits the edge, accelerate in that direction
      combo = 0;
      if (abs(dx)<=base_speed*1.5) dx += distanceX*base_speed/100; 
      if (abs(dx)>= base_speed&&dy <= base_speed*1.5) dy -= base_speed/20;    //and sligtly increase y-speed as well
      else{ if (dy >= 3*base_speed/4) dy += base_speed/50;}                                              //unless it's already at its maximum allowed value for the level
    }
  }
  
  
  */


  
  
  

  
  
  
  
//move on to next level
if (number_of_boxes <= 1){            //if (number_of_boxes <= 0&&zeroth_box_broken==1){
textSize(64);
text("Click to go on to level", width/16, height/2);
text(level+2, width/16+685, height/2); dx=0;dy=0;

if (mousePressed == true){
level +=1;
if (level % 3 == 0) balls +=1;
  base_speed += 0.5;

//I'd love to be able to implement an increase in boxes as level increases.
//nx += 1;
//if (level % 4 == 0) ny +=1;
//if (nx <= 3*ny) nx+=1;


//reset level
number_of_boxes = 2;
left_corner = 500;
//zeroth_box_broken=0;
 for (int i=0; i<nx*ny+1; i++) {
    boxes[i]=1;}
x = x_initial; y = y_initial;}
}




//end draw, move on to next frame
}
