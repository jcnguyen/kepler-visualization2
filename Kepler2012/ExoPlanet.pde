/**
 * Exoplanet.pde
 *
 * The exoplanets. The dataset Spring 2011-Spring 2012 dataset added by 
 * Jer Thorp is replaced by the Spring 2011-Spring 2015 dataset. Note that this 
 * implementation is specific to the '20150504KOI' data sheet found in the
 * 'data' directory. The documentation of the data sheet can be found in 
 * 'README_20150504KOI'.
 *
 * @author Jennifer Nguyen and Huu Le
 * @version May 2015
 *
 * @author Jer Thorp
 * @version April 2012
 */

class ExoPlanet {
  // Data from the imported files
  String KOI;
  float period;
  float radius;
  float axis;
  float incl;
  float temp;
  int vFlag = 1;
  
  // Real movement/render properties
  float theta = 0;
  float thetaSpeed = 0;
  float PixelDiam = 0;
  float pixelAxis;

  float z = 0;
  float tz = 0;

  color col;

  boolean feature = false;
  String label = "";
  
  boolean isSelected = false;
  
  float x;
  float y;
  
  float eggN = random(2);
  color eggC;

  // Constructor function
  ExoPlanet() {};
  
  ExoPlanet(boolean marker) {isSelected = marker;}
  
  // Load exoplanet data from 20150504KOI (see key at top of class)
  ExoPlanet from(String[] sa) {
    KOI = sa[2];
    period = float(sa[6]);
    radius = float(sa[12]);
    axis = float(sa[15]);
    incl = float(sa[18]);
    temp = float(sa[21]);
    return(this);
  }

  // Initialize pixel-based motion data, color, etc. from exoplanet data
  ExoPlanet init() {
    PixelDiam = radius * ER;
    pixelAxis = axis * AU;

    float periodInYears = period/365;
    float periodInFrames = periodInYears * YEAR;
    theta = random(2 * PI);
    thetaSpeed = (2 * PI) / periodInFrames;

    return(this);
  }

  // Update
  void update() {
    theta += thetaSpeed;
    z += (tz - z) * 0.1;
  }
  
  void markPlanet() {
    markedPlanet = this;
  }

  // Draw
  void render(SidePanel panel) {
    if (markedPlanet != null && markedPlanet == this) {
      isSelected = true;
    } else {
      isSelected = false;
    }
    
    float apixelAxis = pixelAxis;
    
    if (axis > 1.06 && feature) {
      apixelAxis = ((1.06 + ((axis - 1.06) * ( 1 - flatness))) * AU) + axis * 10;
    }
    
    x = sin(theta * (1 - flatness)) * apixelAxis;
    y = cos(theta * (1 - flatness)) * apixelAxis;
    
    float dist = 0;
    boolean mouseOnTop = false;
    dist = sqrt(pow(mX-x,2)+pow(mY-y,2)+pow(mZ-z,2));
    if (dist <= PixelDiam/2) {
      mouseOnTop = true;
    }
    
    if(mouseOnTop && mouseClicked && !isSelected) {
      if (panel.getPlanet() != null) {
        panel.refreshPanel();
      }
      
      panel.setPlanet(this);
      markPlanet();
      mouseClicked = false;
    }
    
    pushMatrix();
    translate(x, y, z);
    // Billboard
    rotateZ(-rot.z);
    rotateX(-rot.x);
    noStroke();
    if (feature) {
      translate(0, 0, 1);
      stroke(255, 255);
      strokeWeight(2);
      noFill();
      ellipse(0, 0, PixelDiam + 10, PixelDiam + 10); 
      strokeWeight(1);
      pushMatrix();
      if (label.equals("Earth")) {
        stroke(#01FFFD, 50);
        line(0, 0, -pixelAxis * flatness, 0);
      }
      
      rotate((1 - flatness) * PI/2);
      stroke(255, 100);
      float r = max(50, 100 + ((1 - axis) * 200));
      r *= sqrt(1/zoom);
      if (zoom > 0.5 || label.charAt(0) != '3') {
        line(0, 0, 0, -r);
        translate(0, -r - 5);
        rotate(-PI/2);
        scale(1/zoom);
        fill(255, 200);
        text(label, 0, 4);
      }
      
      popMatrix();
    }
    
    fill(col);
    eggC = col;
    noStroke();
    if (isSelected && panel.getPlanet() != null && panel.getPlanet() == this) {    
      fill(220,blink);
      eggC = color(220,blink);
      strokeWeight(1);
      stroke(255);
    }
    
    if (mouseOnTop || isSelected) {
      strokeWeight(1);
      stroke(255);
    }
    
    if (easterEgg) {
      tint(eggC);
      imageMode(CENTER);
      if (eggN < 1) {
        image(egg1,0,0,PixelDiam,PixelDiam);
      } else {
        image(egg2,0,0,PixelDiam,PixelDiam);
      }
      eggN = (eggN+0.05)%2;
    } else {
      ellipse(0, 0, PixelDiam, PixelDiam);
    }
    popMatrix();
  }
  
}

