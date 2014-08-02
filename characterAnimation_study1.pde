import java.util.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;

/*
 *
 * androidMultiTouch.pde
 * Shows the basic use of MultiTouch Events
 *
 */

//-----------------------------------------------------------------------------------------
// IMPORTS
import android.view.MotionEvent;
//-----------------------------------------------------------------------------------------
// VARIABLES

static int tempp;
int TouchEvents;
float xTouch[], playX;
float yTouch[], playY;
int currentPointerId = 0;
boolean printFPS;

int it=0, iter=0;

float x0, y0, x1, y1, a_x0, a_y0, a_x1, a_y1;
double yellow_x[], yellow_xL[];
double yellow_y[], yellow_yL[];
double jYellow_x[], jYellow_xL[];
char charColor[];
int outWidth = 2560;
int outHeight = 1600;

float rightHandJoint0, rightHandJoint1, leftHandJoint0, leftHandJoint1;
float sqrtL[], isLengthEqualL[], sqrtR[], isLengthEqualR[];
boolean first = true;
boolean touchEvent = false;
boolean noZero = false;

//centroid
float area, sumArea;
float centroidFrac;

boolean animate = false;
boolean record = false;
boolean template2 = false;
boolean template1 = true;
boolean template3 = false;
//face
int yellowFaceSize = 300;

//hands
int whiteSkeletonXincr = 150;

int whiteRightHandJointX = 150+whiteSkeletonXincr;
int whiteRightHandJointY = 304;
int whiteLeftHandJointX = whiteRightHandJointX-110;
int whiteLeftHandJointY = 304;
int whiteRightHandEndX = 300+100;
int whiteRightHandEndY = 200;
int whiteLeftHandEndX = 300-200;
int whiteLeftHandEndY = 200;
int animatingFaceX = 700;
int animatingFaceY = 720/2;
int whiteSkeletonX = 100+whiteSkeletonXincr;
int whiteSkeletonY = 720/2;

int yellowJointX;
int jointYellow_x, jointYellow_xL;


int jLx; // joint Left hand
int eLx; // end left hand
int jRx; // joint right hand
int eRx; // end right hand

int itt;
int bufferArea = 75;

float xTouc;
float yTouc;


float yellow_x_ = (whiteRightHandEndX-whiteRightHandJointX)+(animatingFaceX+whiteSkeletonXincr);
float yellow_y_ = whiteRightHandEndY-15;

float yellow_xL_ = (animatingFaceX-whiteSkeletonXincr) - (whiteLeftHandJointX - whiteLeftHandEndX);
float yellow_yL_ = whiteRightHandEndY-15;

int jYellow_x_ = animatingFaceX-whiteSkeletonXincr+yellowFaceSize;
int jYellow_xL_ = animatingFaceX-whiteSkeletonXincr;

boolean touchEvent1 = false, touchEvent2 = false;
boolean touchEvent_[];

color[] animColor = {
  color(255, 255, 0)/*yellow*/, color(125, 193, 255)/*pink*/, color(184, 20, 103)/*blue*/
};

public class xandy
{
  public double x;
  public double y;
}


int whiteHandLength = 150;
int yellowHandLength = 200;

float dx1 = 300+100 - whiteRightHandJointX;
float dy1 = 200 - whiteRightHandJointY;
float dx2 = 300-200 - whiteRightHandJointX;
float dy2 = 200 - whiteRightHandJointY;
float angle1_ = atan2(dy1, dx1);  
float angle2_ = atan2(dy2, dx2);  
float angle[], angle1[], angle2[];
//-----------------------------------------------------------------------------------------

void setup() {
  //size(displayWidth, displayHeight);
  size(1280, 720);
  //size(2560,1600);
  orientation(LANDSCAPE);
  background(0);
  fill(0, 0, 244);
  //rect(100, 100, 100, 100);
  stroke(255);
  rectMode(CENTER);
  //ellipseMode(CORNERS);

  // Initialize Multitouch x y arrays
  xTouch = new float [10];
  yTouch = new float [10]; // Don't use more than ten fingers!
  yellow_x = new double[100000];
  yellow_xL = new double[100000];
  yellow_y = new double[100000];
  yellow_yL = new double[100000];
  jYellow_x = new double[100000];
  jYellow_xL = new double[100000];
  charColor = new char[100000];
  angle = new float[100000];
  angle1 = new float[100000];
  angle2 = new float[100000];

  touchEvent_ = new boolean[100000];

  sqrtL = new float[4]; 
  isLengthEqualL = new float[4];
  sqrtR = new float[4];
  isLengthEqualR = new float[4];
//
//
//  dataLoggerInit("/Users/LK/Documents/Processing/characterAnimation_study1/Repeat.csv");
//  dataLog("Trial Started", 0);
//  dataLog("Trial Ended", 0);
//  dataLoggerClose();

dataLoggerInit();
}

//-----------------------------------------------------------------------------------------

void draw() {
  if(studyDone == true)
  {
     saveLoggedData();
  }
  if (animate == false)
  {
    iter=0;// variable to store the actions
    background(0);

    if (record == true)
      drawRecordButton_afterClicked();
    if (record == false)
      drawRecordButton_unClicked();

    template1Button();
    template2Button();
    template3Button();

    drawAnimatingChar();
    drawWhiteChar();
    //drawBlueCirclesOnTouch();
    if (TouchEvents == 1)
      ifTouchEventIs1();
    if (TouchEvents == 2)
      ifTouchEventIs2();
    recordButton();
    stopButton();
    playButton();
  }

  else if (animate == true)
  {
    record = false;
    if (it != 0)
    {
      background(255);
      iter++;
      if (!((yellow_x[iter] == 0.0)||(yellow_y[iter] == 0.0)))
      {
        drawAnimatedChar(iter);

        if (touchEvent_[iter] == true)
        {
          if ((yellow_x[iter] != 0.0)&&(yellow_y[iter] != 0.0))
            drawAnimatedHand(iter, (int)yellow_x[iter], (int)yellow_y[iter], (int)jYellow_x[iter], angle[iter]);
        }
        else if (touchEvent_[iter] == false)
        {
          if ((yellow_x[iter] != 0.0)&&(yellow_y[iter] != 0.0))
            drawAnimatedHand(iter, (int)yellow_x[iter], (int)yellow_y[iter], (int)jYellow_x[iter], angle1[iter]);
          if ((yellow_xL[iter] != 0.0)&&(yellow_yL[iter] != 0.0))
            drawAnimatedHand(iter, (int)yellow_xL[iter], (int)yellow_yL[iter], (int)jYellow_xL[iter], angle2[iter]);
        }
      }
      if (iter == it)
      {
        animate = false;
        it = 0;
      }
    }

    else if (it == 0)
    {
      animate = false;
    }
  }
}



//-------------------------------------------------------------------------------

void ifTouchEventIs1()
{
  rightHandJoint0 = sqrt(pow(xTouch[0]-(whiteRightHandEndX), 2) + pow(yTouch[0]-(whiteRightHandEndY), 2));
  leftHandJoint0 = sqrt(pow(xTouch[0]-(whiteLeftHandEndX), 2) + pow(yTouch[0]-(whiteLeftHandEndY), 2));
  rightHandJoint1 = sqrt(pow(xTouch[0]-(whiteRightHandJointX), 2) + pow(yTouch[0]-(whiteRightHandJointY), 2));
  leftHandJoint1 = sqrt(pow(xTouch[0]-(whiteLeftHandJointX), 2) + pow(yTouch[0]-(whiteLeftHandJointY), 2));
  strokeWeight(25);
  stroke(255);
  segment(whiteRightHandJointX, whiteRightHandJointY, angle1_, whiteHandLength);
  segment(whiteLeftHandJointX, whiteLeftHandJointY, angle2_, whiteHandLength);
  if (template1 == true)
    stroke(animColor[0]);
  if (template2 == true)
    stroke(animColor[1]);
  if (template3 == true)
    stroke(animColor[2]);
  segment(jYellow_x_, whiteRightHandJointY-15, angle1_, yellowHandLength);
  segment(jYellow_xL_, whiteRightHandJointY-15, angle2_, yellowHandLength);

  if ((rightHandJoint0<bufferArea)&&(rightHandJoint1<whiteHandLength+50)&&(rightHandJoint1>whiteHandLength-50)) // right joint id touchId[0]
  {
    logData((int)xTouch[0], (int)yTouch[0]);
    whiteRightHandEndX = (int)xTouch[0];
    whiteRightHandEndY = (int)yTouch[0];
    dx1 = xTouch[0] - whiteRightHandJointX;
    dy1 = yTouch[0] - whiteRightHandJointY;
    angle[it] = atan2(dy1, dx1);
    strokeWeight(25);
    stroke(255);
    //segment(whiteRightHandJointX, whiteRightHandJointY, angle1, whiteHandLength);
    //  the ink cretaes 2 points at a predefined distance on the tangible and hence this distance will always remain const.
    touchEvent = true;
    touchEvent_[it] = true;
    yellow_x[it] = (whiteRightHandEndX-whiteRightHandJointX)+(animatingFaceX+whiteSkeletonXincr);
    //x1 = xTouch[1]+animatingFaceX-whiteSkeletonXincr;
    yellow_y[it] = whiteRightHandEndY-15;
    jYellow_x[it] = animatingFaceX-whiteSkeletonXincr+yellowFaceSize;
    yellow_x_ = (float)yellow_x[it];
    yellow_y_ = (float)yellow_y[it];
    jYellow_x_ = (int)jYellow_x[it];
    //angle[it] = angle1[it];
    angle1_ = angle[it];
    ifTouchEventIs1_drawAnimatingHand(it, angle1_);
    if (record == true)
    {
      it++;
    }
  }

  else if ((leftHandJoint0<bufferArea)&&(leftHandJoint1<whiteHandLength+50)&&(leftHandJoint1>whiteHandLength-50)) // right joint id touchId[0]
  {
    logData((int)xTouch[0], (int)yTouch[0]);
    whiteLeftHandEndX = (int)xTouch[0];
    whiteLeftHandEndY = (int)yTouch[0];
    dx2 = xTouch[0] - whiteLeftHandJointX;
    dy2 = yTouch[0] - whiteLeftHandJointY;
    angle[it] = atan2(dy2, dx2);
    //angle[it] = angle2[it];
    //segment(whiteLeftHandJointX, whiteLeftHandJointY, angle2, whiteHandLength);
    //  the ink cretaes 2 points at a predefined distance on the tangible and hence this distance will always remain const.
    touchEvent = true;
    touchEvent_[it] = true;
    yellow_x[it] = (animatingFaceX-whiteSkeletonXincr) - (whiteLeftHandJointX - whiteLeftHandEndX);
    yellow_y[it] = whiteLeftHandEndY-15;
    jYellow_x[it] = animatingFaceX-whiteSkeletonXincr;
    yellow_xL_ =(float)yellow_x[it];
    yellow_yL_ = (float)yellow_y[it];
    jYellow_xL_ = (int)jYellow_x[it];
    angle2_ = angle[it];
    ifTouchEventIs1_drawAnimatingHand(it, angle2_);
    if (record == true)
    {
      it++;
    }
  }
}

void ifTouchEventIs2()
{
  touchEvent2 = true;
  touchEvent1 = false;
  int i, j;
  //  strokeWeight(25);
  //  stroke(255);
  //  line(whiteRightHandJointX, whiteRightHandJointY, whiteRightHandEndX, whiteRightHandEndY);
  //  strokeWeight(25);
  //  stroke(255);
  //  line(whiteLeftHandJointX, whiteLeftHandJointY, whiteLeftHandEndX, whiteLeftHandEndY);
  strokeWeight(25);
  stroke(255);
  segment(whiteRightHandJointX, whiteRightHandJointY, angle1_, whiteHandLength);
  segment(whiteLeftHandJointX, whiteLeftHandJointY, angle2_, whiteHandLength);
  for (i=0;i<2;i++)
  {
    sqrtR[i] = sqrt(pow(xTouch[i]-(whiteRightHandEndX), 2) + pow(yTouch[i]-(whiteRightHandEndY), 2));
    if (sqrtR[i] < bufferArea)// check for right joint --- touchid[i] is the right joint
    {
      jRx = i;
      touchEvent = true;
      touchEvent_[it] = false;
      whiteRightHandEndX = (int)xTouch[i];
      whiteRightHandEndY = (int)yTouch[i];
      dx1 = xTouch[i] - whiteRightHandJointX;
      dy1 = yTouch[i] - whiteRightHandJointY;
      angle1[it] = atan2(dy1, dx1);
      yellow_x[it] = (whiteRightHandEndX-whiteRightHandJointX)+(animatingFaceX+whiteSkeletonXincr);
      yellow_y[it] = whiteRightHandEndY-15;
      jYellow_x[it] = animatingFaceX-whiteSkeletonXincr+yellowFaceSize;
      yellow_x_ = (float)yellow_x[it];
      yellow_y_ = (float)yellow_y[it];
      jYellow_x_ = (int)jYellow_x[it];
      angle1_ = angle1[it];
      ifTouchEventIs2_drawAnimatingHand(it, (float)yellow_x[it], (float) yellow_y[it], (int)jYellow_x[it]);
    }
  }


  for (i=0;i<2;i++)
  {
    if (i != jRx)
    {
      //sqrtL[i] = sqrt(pow(xTouch[i]-(whiteLeftHandJointX), 2) + pow(yTouch[i]-(whiteLeftHandJointY), 2));
      //if (sqrtL[i] < bufferArea)// check for right joint --- touchid[i] is the right joint
      { 
        touchEvent = true;
        touchEvent_[it] = false;
        whiteLeftHandEndX = (int)xTouch[i];
        whiteLeftHandEndY = (int)yTouch[i];
        dx2 = xTouch[i] - whiteLeftHandJointX;
        dy2 = yTouch[i] - whiteLeftHandJointY;
        angle2[it] = atan2(dy2, dx2);
        yellow_xL[it]  = (animatingFaceX-whiteSkeletonXincr) - (whiteLeftHandJointX - whiteLeftHandEndX);
        yellow_yL[it]  = whiteLeftHandEndY-15;
        jYellow_xL[it] = animatingFaceX-whiteSkeletonXincr;
        yellow_xL_ =(float)yellow_xL[it];
        yellow_yL_ = (float)yellow_yL[it];
        jYellow_xL_ = (int)jYellow_xL[it];
        angle2_ = angle2[it];
        ifTouchEventIs2_drawAnimatingHand(it, (float)yellow_xL[it], (float) yellow_yL[it], (int)jYellow_xL[it]);
        if (record == true)
        {
          it++;
        }
      }
    }
  }
}

void redHighlight()
{
  stroke(255, 0, 0);
  noFill();
  rect(whiteSkeletonX, whiteSkeletonY, 167+50, 167+50, 15);//white left skeleton highlighted in red to show the correct placement
}


void recordButton()
{
  textSize(20);
  fill(255);
  text("RECORD", 875-122, 105);
  if ((xTouch[0]<950-120)&&(xTouch[0]>850-120)&&(yTouch[0]>75)&&(yTouch[0]<125))
  {
    record = true;
  }
}

void stopButton()
{
  noStroke();
  fill(0, 255, 180);
  rect(900, 100, 100, 50, 15);//STOP BUTTON
  textSize(20);
  fill(255);
  text("STOP", 900-20, 105);
  if ((xTouch[0]<950)&&(xTouch[0]>850)&&(yTouch[0]>75)&&(yTouch[0]<125))
  {
    record = false;
  }
}

void template1Button()
{
  if (template1 ==  true)
  {
    strokeWeight(5);
    stroke(255, 0, 0);
  }
  else
    noStroke();
  fill(animColor[0]);
  rect(1000, 600, 100, 100, 15);
  if ((xTouch[0]<1050)&&(xTouch[0]>950)&&(yTouch[0]<650)&&(yTouch[0]>550))
  {
    template1 = true;
    template2 = false;
    template3 = false;
  }
  else
    noStroke();
}

void template2Button()
{
  if (template2 ==  true)
  {
    strokeWeight(5);
    stroke(255, 0, 0);
  }
  else
    noStroke();
  fill(animColor[1]);
  rect(1200, 600, 100, 100, 15);
  if ((xTouch[0]<1250)&&(xTouch[0]>1150)&&(yTouch[0]<650)&&(yTouch[0]>550))
  {
    template2 = true;
    template1 = false;
    template3 = false;
  }
  else
    noStroke();
}

void template3Button()
{
  if (template3 ==  true)
  {
    strokeWeight(5);
    stroke(255, 0, 0);
  }
  else
    noStroke();
  //fill(232, 44, 12);
  fill(animColor[2]);
  rect(1100, 600, 100, 100, 15);
  if ((xTouch[0]<1150)&&(xTouch[0]>1050)&&(yTouch[0]<650)&&(yTouch[0]>550))
  {
    template3 = true;
    template1 = false;
    template2 = false;
  }
  else
    noStroke();
}

void playButton()
{
  noStroke();
  fill(0, 255, 180);
  rect(900+130, 100, 100, 50, 15);//PLAY BUTTON
  textSize(20);
  fill(255);
  text("PLAY", 875+122+10, 105);
  // if play clicked
  playX = xTouch[0];
  playY = yTouch[0];
  if ((playX<950+130)&&(playX>850+130)&&(playY>75)&&(playY<125))
  {
    playX = 0.0;
    playY = 0.0;
    animate = true;
    xTouch[0] = 0.0;
    yTouch[0] = 0.0;
    println("xTouch[0] " + xTouch[0]);
    println("yTouch[0] " + yTouch[0]);
    studyDone = true;
  }
}

void drawRecordButton_unClicked()
{
  noStroke();
  fill(0, 255, 180);
  rect(900-110, 100, 100, 50, 15);// REOCRD BUTTON
}

void drawRecordButton_afterClicked()
{
  noStroke();
  fill(255, 0, 0);
  rect(900-110, 100, 100, 50, 15);// REOCRD BUTTON
}

void drawWhiteChar() //white left body
{
  fill(255);
  rect(whiteSkeletonX, whiteSkeletonY, 160, 160, 15);

  if ((xTouch[0] == 0)&&(yTouch[0] == 0)&&(first == true))
  {
    strokeWeight(25);
    stroke(255);
    line(whiteRightHandJointX, whiteRightHandJointY, 300+100, 200); //white right hand skeleton
    line(whiteLeftHandJointX, whiteRightHandJointY, 300-200, 200); //white left hand skeleton
    first = false;
  }
}


void drawBlueCirclesOnTouch()
{
  if ((xTouch[0]!=0)&&(yTouch[0]!=0)) 
  {
    for (int i = 0; i < xTouch.length; i++) {
      ellipse(xTouch[i], yTouch[i], 150, 150);
    }
  }
}


//-----------------------------------------------------------------------------------------

public boolean surfaceTouchEvent(MotionEvent event) {
  xandy centroid =  new xandy();
  xandy centroidInter =  new xandy();
  // Number of places on the screen being touched:
  TouchEvents = event.getPointerCount();
  //println("TouchEvents  "+TouchEvents);
  // If no action is happening, listen for new events else 
  for (int i = 0; i < TouchEvents; i++) {
    int pointerId = event.getPointerId(i);

    xTouch[pointerId] = event.getX(i); 
    yTouch[pointerId] = event.getY(i);
    float siz = event.getSize(i);
    //println("pointerId  "+pointerId);
  }

  // ACTION_DOWN 
  if (event.getActionMasked() == 0 ) {
    print("Initial action detected. (ACTION_DOWN)");
    print("Action index: " +str(event.getActionIndex()));
  } 
  // ACTION_UP 
  else if (event.getActionMasked() == 1) {
    print("ACTION_UP");
    print("Action index: " +str(event.getActionIndex()));
  }
  //  ACTION_POINTER_DOWN 
  else if (event.getActionMasked() == 5) {
    print("Secondary pointer detected: ACTION_POINTER_DOWN");
    print("Action index: " +str(event.getActionIndex()));
  }
  // ACTION_POINTER_UP 
  else if (event.getActionMasked() == 6) {
    print("ACTION_POINTER_UP");
    print("Action index: " +str(event.getActionIndex()));
  }
  // 
  else if (event.getActionMasked() == 4) {
  }

  // If you want the variables for motionX/motionY, mouseX/mouseY etc.
  // to work properly, you'll need to call super.surfaceTouchEvent().
  return super.surfaceTouchEvent(event);
}
void drawAnimatingChar()
{
  noStroke();
  if (template1 == true)
    fill(animColor[0]);
  if (template2 == true)
    fill(animColor[1]);
  if (template3 == true)
    fill(animColor[2]);
  rect(animatingFaceX, animatingFaceY, 300, 300, 15);// animating face

  fill(0); 
  ellipse(animatingFaceX-75, animatingFaceY+25, 30, 40);//eye left
  ellipse(animatingFaceX+75, animatingFaceY+25, 30, 40);//eye right

  //mouth
  noFill();
  strokeWeight(5);
  stroke(0);
  arc(animatingFaceX-75+75, animatingFaceY+25+25, 75, 75, 0, PI, OPEN);
}

void ifTouchEventIs1_drawAnimatingHand(int itIncr, float angle) {
  strokeWeight(25);
  if (template1 == true)
  {
    charColor[itIncr] = 'y';
    stroke(animColor[0]);
  }
  if (template2 == true)
  {
    charColor[itIncr] = 'p';
    stroke(animColor[1]);
  }
  if (template3 == true)
  {
    charColor[itIncr] = 'b';
    stroke(animColor[2]);
  }
  //line((int)jYellow_x[itIncr], whiteRightHandJointY-15, (float)yellow_x[itIncr], (float)yellow_y[itIncr]);// hand
  segment((int)jYellow_x[itIncr], whiteRightHandJointY-15, angle, yellowHandLength);
}

void ifTouchEventIs2_drawAnimatingHand(int itIncr, float yxx, float yyy, int join) {
  strokeWeight(25);
  if (template1 == true)
  {
    charColor[itIncr] = 'y';
    stroke(animColor[0]);
  }
  if (template2 == true)
  {
    charColor[itIncr] = 'p';
    stroke(animColor[1]);
  }
  if (template3 == true)
  {
    charColor[itIncr] = 'b';
    stroke(animColor[2]);
  }
  strokeWeight(25);
  line(join, whiteRightHandJointY-15, yxx, yyy); //hand
}

void drawAnimatedChar(int iter)
{
  noStroke();
  if (charColor[iter] == 'y')
    fill(animColor[0]);
  if (charColor[iter] == 'p')
    fill(animColor[1]);
  if (charColor[iter] == 'b')
    fill(animColor[2]);
  rect(animatingFaceX, animatingFaceY, 300, 300, 15);// animating face

  fill(0); 
  ellipse(animatingFaceX-75, animatingFaceY+25, 30, 40);//eye left
  ellipse(animatingFaceX+75, animatingFaceY+25, 30, 40);//eye right

  //mouth
  noFill();
  strokeWeight(5);
  stroke(0);
  arc(animatingFaceX-75+75, animatingFaceY+25+25, 75, 75, 0, PI, OPEN);
}

void drawAnimatedHand(int iter, float yxx, float yyy, int join, float angle)
{
  if (charColor[iter] == 'y')
    stroke(animColor[0]);
  if (charColor[iter] == 'p')
    stroke(animColor[1]);
  if (charColor[iter] == 'b')
    stroke(animColor[2]);

  strokeWeight(25);
  //line(join, whiteRightHandJointY-15, yxx, yyy); //hand
  segment(join, whiteRightHandJointY-15, angle, yellowHandLength);
}

void drawAnimatedHand1(int iter, float yxx, float yyy, int join)
{
  if (charColor[iter] == 'y')
    stroke(animColor[0]);
  if (charColor[iter] == 'p')
    stroke(animColor[1]);
  if (charColor[iter] == 'b')
    stroke(animColor[2]);

  strokeWeight(25);
  line(join, whiteRightHandJointY-15, yxx, yyy); //hand
  //segment(join, whiteRightHandJointY-15, angle, yellowHandLength);
}


void segment(float x, float y, float a, int handLength) {
  pushMatrix();
  translate(x, y);
  rotate(a);
  line(0, 0, handLength, 0);
  popMatrix();
}


