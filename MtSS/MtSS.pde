/* Modelling the Solar System
 * kristof aldenderfer
 * github.com/aldenderfer
 * 2013.05.11
 * A first attempt at both learning Processing and creating an interactive model of the solar system.
 * All values are accurate as of May 2013. The only exceptions are: the initial orbital and rotational
 * values (abandoned due to time contraints); and the radius of the sun, as using the correct value - 
 * which is incredibly large - would render the project unusable.
 */

import java.awt.event.*;
int ASTEROIDCOUNT = 64;
int KUIPERCOUNT = 128;
Planet[] asteroid = new Planet[ASTEROIDCOUNT];
Planet[] kuiper = new Planet[KUIPERCOUNT];
Planet sun, mercury, venus, earth, mars, jupiter, saturn, uranus, neptune;
Satellite luna, phobos, deimos, io, europa, ganymede, callisto, amalthea, mimas, enceladus, tethys, dione, rhea, titan, hyperion, iapetus, phoebe, ariel, umbriel, titania, oberon, triton;
float zoom = 1;
float rotX=0;
float rotY=0;
float AU = 149.6*pow(10, 0); // proper scale is 149.6EE6
float MO=10;
boolean bAxes, bBelts, bLabels, inc, dec, play;
PVector solCenter,userV;
int scaler = 1;
int sunOffset = 100; // axis offset to fit in the sun; remove this later
float speed = 2*scaler;
int topSpeed = 10*scaler;
float decel = 1.1*scaler;
int STARCOUNT=2000;
int pix[][] = new int[STARCOUNT][2];

public void init() {
  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();
  super.init();
}

void setup() {
  size(displayWidth, displayHeight, P3D);
  frame.setLocation(0, 0);
  rectMode(CENTER);
  background(0);
  noStroke();
  for (int k=0; k<STARCOUNT; k++) {
    pix[k][0] = int(random(-displayWidth*5.5,displayWidth*5.5));
    pix[k][1] = int(random(-displayHeight*5.5,displayHeight*5.5));
  }
  solCenter = new PVector(0,0,-displayWidth/2);
  userV = new PVector(0,0,0);
  //                 name       rad,           mass,  semi-major,         per,   ecc,    incl  tilt   sidereal
  //                            EE3km,         %earth,%earth,             %earth,--,     deg   deg    hours
  sun =     new Planet("sun",     69.55*scaler,  5000,  0,                  0.01,  0,      0,    7.25,  609.1); //should be 695.5
  mercury = new Planet("mercury", 2.439*scaler,  0.055, 0.39*AU+sunOffset,  0.24,  0.2056, 6.34, 0,     1407);
  venus =   new Planet("venus",   6.052*scaler,  0.815, 0.72*AU+sunOffset,  0.64,  0.0068, 2.19, 177.4, 5848);
  earth =   new Planet("earth",   6.378*scaler,  1.000, 1.00*AU+sunOffset,  1.00,  0.0167, 1.57, 23.45, 23.93);
  mars =    new Planet("mars",    3.3935*scaler, 0.107, 1.52*AU+sunOffset,  1.88,  0.0934, 1.67, 25.19, 24.62);
  jupiter = new Planet("jupiter", 71.400*scaler, 318,   5.20*AU+sunOffset,  11.86, 0.0483, 0.32, 3.13,  9.925);
  saturn =  new Planet("saturn",  60.000*scaler, 95,    9.54*AU+sunOffset,  29.46, 0.0560, 0.93, 26.73, 10.66);
  uranus =  new Planet("uranus",  25.559*scaler, 15,    19.19*AU+sunOffset, 84.01, 0.0461, 1.02, 97.77, 17.24);
  neptune = new Planet("neptune", 24.764*scaler, 17,    30.06*AU+sunOffset, 164.8, 0.0097, 0.72, 28.32, 16.11);
  
  //                         name        radius            semi-major                 per     ecc     incl  tilt   sidereal
  //                                                       EE5
  luna =      new Satellite("luna",      1.7371*scaler, 0, 3.844*MO+earth.radius(),   27.322, 0.0097, 0.72, 28.32, 16.11, "earth");
  phobos =    new Satellite("phobos",    0.0111*scaler, 0, 0.094*MO+mars.radius(),    0.319,  0.0097, 0.72, 28.32, 16.11, "mars");
  deimos =    new Satellite("deimos",    0.0062*scaler, 0, 0.235*MO+mars.radius(),    1.263,  0.0097, 0.72, 28.32, 16.11, "mars");
  io =        new Satellite("io",        1.8181*scaler, 0, 4.218*MO+jupiter.radius(), 1.769,  0.0097, 0.72, 28.32, 16.11, "jupiter");
  europa =    new Satellite("europa",    1.5607*scaler, 0, 6.711*MO+jupiter.radius(), 3.551,  0.0097, 0.72, 28.32, 16.11, "jupiter");
  ganymede =  new Satellite("ganymede",  2.6341*scaler, 0, 10.70*MO+saturn.radius(),  7.155,  0.0097, 0.72, 28.32, 16.11, "jupiter");
  callisto =  new Satellite("callisto",  2.4804*scaler, 0, 18.83*MO+saturn.radius(),  16.689, 0.0097, 0.72, 28.32, 16.11, "jupiter");
  amalthea =  new Satellite("amalthea",  0.0835*scaler, 0, 1.814*MO+saturn.radius(),  0.498,  0.0097, 0.72, 28.32, 16.11, "jupiter");
  mimas =     new Satellite("mimas",     0.1988*scaler, 0, 1.855*MO+saturn.radius(),  0.942,  0.0097, 0.72, 28.32, 16.11, "saturn");
  enceladus = new Satellite("enceladus", 0.2523*scaler, 0, 2.380*MO+saturn.radius(),  1.370,  0.0097, 0.72, 28.32, 16.11, "saturn");
  tethys =    new Satellite("tethys",    0.5363*scaler, 0, 2.947*MO+saturn.radius(),  1.888,  0.0097, 0.72, 28.32, 16.11, "saturn");
  dione =     new Satellite("dione",     0.5625*scaler, 0, 3.774*MO+saturn.radius(),  2.737,  0.0097, 0.72, 28.32, 16.11, "saturn");
  rhea =      new Satellite("rhea",      0.7645*scaler, 0, 5.271*MO+saturn.radius(),  4.518,  0.0097, 0.72, 28.32, 16.11, "saturn");
  titan =     new Satellite("titan",     2.5755*scaler, 0, 12.22*MO+saturn.radius(),  15.945, 0.0097, 0.72, 28.32, 16.11, "saturn");
  hyperion =  new Satellite("hyperion",  0.1330*scaler, 0, 15.01*MO+saturn.radius(),  21.277, 0.0097, 0.72, 28.32, 16.11, "saturn");
  iapetus =   new Satellite("iapetus",   0.7345*scaler, 0, 35.61*MO+saturn.radius(),  79.322, 0.0097, 0.72, 28.32, 16.11, "saturn");
  phoebe =    new Satellite("phoebe",    0.1066*scaler, 0, 12.95*MO+saturn.radius(),  550.48, 0.0097, 0.72, 28.32, 16.11, "saturn"); //129.5
  ariel =     new Satellite("ariel",     0.5789*scaler, 0, 1.909*MO+uranus.radius(),  2.520,  0.0097, 0.72, 28.32, 16.11, "uranus");
  umbriel =   new Satellite("umbriel",   0.5847*scaler, 0, 2.660*MO+uranus.radius(),  4.144,  0.0097, 0.72, 28.32, 16.11, "uranus");
  titania =   new Satellite("titania",   0.7889*scaler, 0, 4.363*MO+uranus.radius(),  8.706,  0.0097, 0.72, 28.32, 16.11, "uranus");
  oberon =    new Satellite("oberon",    0.7614*scaler, 0, 5.835*MO+uranus.radius(),  13.463, 0.0097, 0.72, 28.32, 16.11, "uranus");
  triton =    new Satellite("triton",    1.3534*scaler, 0, 3.548*MO+neptune.radius(), 5.877,  0.0097, 0.72, 28.32, 16.11, "neptune");
  
  for (int k=0 ; k<asteroid.length ; k++) { //these bodies' radii are too large
    asteroid[k]=new Planet("a"+k, random(0.5, 2.5)*scaler, 0.01, random(2.1, 3.3)*AU+sunOffset, random(3, 6), random(0, 0.35), random(0, 18), random(0, 360), random(1, 24));
    int colour = int(random(16, 192));
    asteroid[k].setColour(colour, colour, colour);
  }
  for (int k=0 ; k<kuiper.length ; k++) { //these bodies' radii are too large
    kuiper[k] = new Planet("k"+k, random(0.5, 2.5)*scaler, 0.01, random(38, 48)*AU+sunOffset, random(219.7, 329.6), random(0, 0.58), random(0, 30), random(0, 360), random(1, 24));
    int colour = int(random(16, 192));
    kuiper[k].setColour(colour, colour, colour);
  }
  //sun.setColour(255, 243, 127);
  sun.setColour(255, 247, 192);
  mercury.setColour(152, 139, 119);
  venus.setColour(188, 83, 13);
  earth.setColour(16, 176, 176);
  mars.setColour(226, 123, 20);
  jupiter.setColour(219, 173, 64);
  saturn.setColour(196, 171, 112);
  uranus.setColour(71, 170, 181);
  neptune.setColour(69, 100, 242);
}

void draw() {
  background(0);
  pushMatrix();
  solCenter.add(userV);
  translate(displayWidth/2, displayHeight/2,0);
  stroke(255);
  for (int k=0; k<STARCOUNT; k++) {
    rect(pix[k][0]+(displayWidth/2-mouseX)*10,pix[k][1]+(displayHeight/2-mouseY)*10,1,1);
  }
  translate(0,0,840); //translate to center of screen
  rotateX(rotX); // rotate around center of screen
  rotateY(rotY); // rotate around center of screen
  
  translate(solCenter.x, solCenter.y, solCenter.z); // move to center of solar system to begin drawing it
  lights();
  pointLight(255, 243, 234, 0, 0, 0);
  pushMatrix();
  noStroke();
  sun.update();
  mercury.update();
  venus.update();
  earth.update();
  mars.update();
  jupiter.update();
  saturn.update();
  //saturn.rings(7*scaler,80*scaler);
  uranus.update();
  neptune.update();
  if (bBelts) {
    for (int k=0 ; k<asteroid.length ; k++) {
      asteroid[k].update();
    }
    for (int k=0 ; k<kuiper.length ; k++) {
      kuiper[k].update();
    }
  }
  fill(127);
  pushMatrix();
  earth.planetTranslate();
  luna.update();
  popMatrix();
  pushMatrix();
  mars.planetTranslate();
  deimos.update();
  phobos.update();
  popMatrix();
  pushMatrix();
  jupiter.planetTranslate();
  io.update();
  europa.update();
  ganymede.update();
  callisto.update();
  amalthea.update();
  popMatrix();
  pushMatrix();
  saturn.planetTranslate();
  mimas.update();
  enceladus.update();
  tethys.update();
  dione.update();
  rhea.update();
  titan.update();
  hyperion.update();
  iapetus.update();
  phoebe.update();
  popMatrix();
  pushMatrix();
  uranus.planetTranslate();
  ariel.update();
  umbriel.update();
  titania.update();
  oberon.update();
  popMatrix();
  pushMatrix();
  neptune.planetTranslate();
  triton.update();
  popMatrix();
  popMatrix();
  popMatrix();
  
  if (bLabels) {
    fill(1,147,154);
    sun.label();
    mercury.label();
    venus.label();
    earth.label();
    mars.label();
    jupiter.label();
    saturn.label();
    uranus.label();
    neptune.label();
    fill(154,147,1);
    luna.label();
    deimos.label();
    phobos.label();
    io.label();
    europa.label();
    ganymede.label();
    callisto.label();
    amalthea.label();
    mimas.label();
    enceladus.label();
    tethys.label();
    dione.label();
    rhea.label();
    titan.label();
    hyperion.label();
    iapetus.label();
    phoebe.label();
    ariel.label();
    umbriel.label();
    titania.label();
    oberon.label();
    triton.label();
    
    fill(154,1,1);
    if (bBelts) {
      for (int k=0 ; k<asteroid.length ; k++) {
        asteroid[k].label();
      }
      for (int k=0 ; k<kuiper.length ; k++) {
        kuiper[k].label();
      }
    }
  }
  overlay();
  userV.div(decel);
  if (userV.mag()<0.5) userV.set(0,0,0);
  inc = dec = false;
}

void overlay() {
  fill(255);
  text("mouse controls", 0, 10);
  text("change perpective:",8,20);                  text("move",240,20);
  text("reset:", 8, 30);                            text("right-click",240,30);
  text("keyboard controls", 0, 50);
  text("play/pause:",8,60);                         text("E",240,60);
  text("(increment/decrement while paused):",8,70); text("Q/W",240,70);
  text("nav (x/z plane):",8,80);                    text("arrow keys",240,80);
  text("altitude (y-axis):",8,90);                  text("spacebar / shift",240,90);
  text("toggle body axes:", 8, 100);                text("Z",240,100);
  text("toggle body labels:", 8, 110);              text("X",240,110);
  text("toggle belts:", 8, 120);                    text("C    [CPU HUNGRY]",240,120);
  
  text("fps: " + frameRate,8,150);
  
  text("position",displayWidth-208,10);
  text("x: " + solCenter.x + "*10³ km",displayWidth-200,20);
  text("y: " + solCenter.y + "*10³ km",displayWidth-200,30);
  text("z: " + -solCenter.z + "*10³ km",displayWidth-200,40);
  text("Σ: " + sqrt(pow(solCenter.x,2) + pow(solCenter.y,2) + pow(solCenter.z,2)) + "*10³ km",displayWidth-200,50);
  text("velocity",displayWidth-208,70);
  text("x: " + userV.x + "*10³ km/s",displayWidth-200,80);
  text("y: " + userV.y + "*10³ km/s",displayWidth-200,90);
  text("z: " + userV.z + "*10³ km/s",displayWidth-200,100);
  text("Σ: " + userV.mag() + "*10³ km/s",displayWidth-200,110);
  text("rotation",displayWidth-208,130);
  text("x:   " + rotX + " rad", displayWidth-200,140);
  text("y:   " + rotY + " rad", displayWidth-200,150);
}

//--------------------------------------------------------------------------------------------------------------------

class Body {
  String name;
  float radius, mass, a, rotO, e, incO, incA, rotA, r, theta, phi, x, y;
  int R, G, B;
  float x3,y3,z3;
  boolean bOnscreen;
  
  void drawBody() {
    if (bOnscreen) {
      fill(R, G, B);
      sphere(radius); // draw the body
    }
  }
  
  void drawAxes() {
    if (bAxes) {
      float p = radius*2;
      if (p<10) p = 10;
      stroke(255,0,0);
      line(0, 0, 0, p, 0, 0);  //
      stroke(0,255,0);
      line(0, 0, 0, 0, -p, 0); // negative because the y pixels are mapped in reverse
      stroke(0,0,255);
      line(0, 0, 0, 0, 0, p);
      noStroke();
    }
  }
  
  void setColour(int rr, int gg, int bb) {
    R = rr;
    G = gg;
    B = bb;
  }
  float x() {
    return x;
  }
  float y() {
    return y;
  }
  float radius() {
    return radius;
  }
  void label() {
    if (bOnscreen) {
      if (bLabels) {
        text(" " + name,x3,y3,z3);
        //text(" " + x3 + " " + y3 + " " + z3, x3,y3+10,z3);
      }
    }
  }
}

//--------------------------------------------------------------------------------------------------------------------


class Planet extends Body {

  Planet(String qname, float qradius, float qmass, float qa, float qperiodO, float qe, float qincO, float qincA, float qperiodA) {
    name = qname;                        // name of the body
    radius = qradius;                    // radius of body
    mass = qmass;                        // mass of body. not implemented yet.
    a = qa;                              // semi-major axis length.
    rotO = 1/qperiodO/60;                // orbital rotation speed. make this more accurate.
    e = qe;                              // orbital eccentricity.
    incO = radians(qincO);               // orbital inclination with respect to invariable plane. not quite right yet.
    incA = radians(qincA);               // axial inclination with respect to orbital plane
    rotA = 1/qperiodA;                   // axial rotation period. make this more accurate
    theta = random(0, 2*PI);             // angle from focus. this should not be random initially.
    phi = random(0, 2*PI);               // axial rotation angle. this should also not be random initially.
  }

  void update() {
    pushMatrix();
    if ((inc)|| (play)) {
      theta += rotO;
      phi += rotA;
    }
    else if ((dec) || (play)) {
      theta -= rotO;
      phi -= rotA;
    }
    if (theta>2*PI) theta-=2*PI; // reset theta at 2PI
    r = a*(1-pow(e, 2))/(1+e*cos(theta));
    x = r * cos(-theta);
    y = r * sin(-theta);
    planetTranslate();
    planetRotate();
    drawBody();
    drawAxes();
    popMatrix();
  }
  
  void planetTranslate() {
    rotateX(incO); // orbital inclination
    x3 = screenX(x+2*a*e+radius,y,0); // get x,y,z positions for labelling!
    y3 = screenY(x+2*a*e,y,0);
    z3 = screenZ(x+2*a*e,y,0);
    if (z3<=1) bOnscreen = true;
    else bOnscreen = false;
    translate(x+(2*a*e), y, 0); // translate to ellipse position
  }
  
  void planetRotate() {
    rotateX(-PI/2); // rotate top of sphere toward screen
    rotateZ(incA); // axial inclination
    rotateY(phi); // axial rotation
  }
  
  void rings(float rIn, float rOut) {
    pushMatrix();
    planetTranslate();
    if (bOnscreen) {
      rotateX(PI/2); // rotate so the rings form around the y-axis instead of the z-axis
      fill(161,136,79,63);
      ellipse(0, 0, 2*(radius+rOut),2*(radius+rOut));
    }
    popMatrix();
  }
}

//--------------------------------------------------------------------------------------------------------

class Satellite extends Body {
  String mother;
  
  public Satellite(String qname, float qradius, float qmass, float qa, float qperiodO, float qe, float qincO, float qincA, float qperiodA, String qmother) {
    name = qname;                        // name of the body
    radius = qradius;                    // radius of body
    mass = qmass;                        // mass of body. not implemented yet.
    a = qa;                              // semi-major axis length.
    rotO = 1/qperiodO/60;                // orbital rotation speed. make this more accurate.
    e = qe;                              // orbital eccentricity.
    incO = radians(qincO);               // orbital inclination with respect to invariable plane. not quite right yet.
    incA = radians(qincA);               // axial inclination with respect to orbital plane
    rotA = 1/qperiodA;                   // axial rotation period. make this more accurate
    theta = random(0, 2*PI);             // angle from focus. this should not be random initially.
    phi = random(0, 2*PI);               // axial rotation angle. this should also not be random initially.
    mother = qmother;
    R=G=B=127;
  }
  
    void update() {
    pushMatrix();
    if ((inc)|| (play)) {
      theta += rotO;
      phi += rotA;
    }
    else if ((dec) || (play)) {
      theta -= rotO;
      phi -= rotA;
    }
    if (theta>2*PI) theta-=2*PI; // reset theta at 2PI
    r = a*(1-pow(e, 2))/(1+e*cos(theta));
    x = r * cos(-theta);
    y = r * sin(-theta);
    satelliteTranslate();
    satelliteRotate();
    drawBody();
    drawAxes();
    popMatrix();
  }
  
  void satelliteTranslate() {
    rotateX(incO); // orbital inclination
    x3 = screenX(x+2*a*e+radius,y,0); // get x,y,z positions for labelling!
    y3 = screenY(x+2*a*e,y,0);
    z3 = screenZ(x+2*a*e,y,0);
    if (z3<=1) bOnscreen = true;
    else bOnscreen = false;
    translate(x+(2*a*e), y, 0); // translate to ellipse position
  }
  
  void satelliteRotate() {
    rotateX(-PI/2); // rotate top of sphere toward screen
    rotateZ(incA); // axial inclination
    rotateY(phi); // axial rotation
  }
  
}


//--------------------------------------------------------------------------------------------------------

void mousePressed() {
  if (mouseButton == RIGHT) {
    //rotX = rotY = 0;
    solCenter.set(0,0,-displayWidth/2);
    userV.set(0,0,0);
  }
}

void mouseMoved() {
  rotX = -(mouseY-displayHeight/2)*PI/(displayHeight/2);
  rotY = (mouseX-displayWidth/2)*PI/(displayWidth/2);
}
//-------------------------------------------------------------------
void keyPressed() {
  if ((keyCode == 'z') || (keyCode == 'Z'))                       bAxes = !bAxes;
  if ((keyCode == 'x') || (keyCode == 'X'))                       bLabels = !bLabels;
  if ((keyCode == 'c') || (keyCode == 'C'))                       bBelts = !bBelts;
  if ((keyCode == UP) || (keyCode == 'p') || (keyCode == 'P'))    userV.add(sin(-rotY)*speed,0,cos(rotY)*speed);
  if ((keyCode == DOWN) || (keyCode == ';') || (keyCode == ':'))  userV.sub(sin(-rotY)*speed,0,cos(rotY)*speed);
  if ((keyCode == LEFT) || (keyCode == 'l') || (keyCode == 'L'))  userV.add(cos( rotY)*speed,0,sin(rotY)*speed);
  if ((keyCode == RIGHT) || (keyCode == 222))                     userV.sub(cos( rotY)*speed,0,sin(rotY)*speed); // apostrophe
  if (keyCode == ' ')                                             userV.add(0,speed,0);
  if (keyCode == SHIFT)                                           userV.sub(0,speed,0);
  if ((keyCode == 'q') || (keyCode == 'Q'))                       inc = true;
  if ((keyCode == 'w') || (keyCode == 'W'))                       dec = true;
  if ((keyCode == 'e') || (keyCode == 'E'))                       play = !play;
  userV.limit(topSpeed);
}
