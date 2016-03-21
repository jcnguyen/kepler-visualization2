/**
 * Controls.pde
 *
 * GUI controls. Originally added by Lon Riesberg (lon@ieee.org) of the 
 * Laboratory for Atmospheric and Space Physics. Modified by Huu Le and Jennifer
 * Nguyen. Replaced key bindings with on-screen buttons. Users are still able 
 * to toggle slider with 'c' key.
 *
 * @author Huu Le and Jennifer Nguyen
 * @version May 2015
 *
 * @author Jer Thorp
 * @version April 2012
 */

class Controls {
   
   int barWidth;   
   int barX;                          // x-coordinate of zoom control
   int minY, maxY;                    // y-coordinate range of zoom control
   float minZoomValue, maxZoomValue;  // values that map onto zoom control
   float valuePerY;                   // zoom value of each y-pixel 
   int sliderY;                       // y-coordinate of current slider position
   float sliderValue;                 // value that corresponds to y-coordinate of slider
   int sliderWidth, sliderHeight;
   int sliderX;                       // x-coordinate of left-side slider edge                     
   
   Controls () {
      barX = 40;
      barWidth = 15;
 
      minY = 40;
      maxY = minY + height/3 - sliderHeight/2;
           
      minZoomValue = 0.0;
      maxZoomValue = 3.0;   // 300 percent
      valuePerY = (maxZoomValue - minZoomValue) / (maxY - minY);
      
      sliderWidth = 25;
      sliderHeight = 10;
      sliderX = (barX + (barWidth/2)) - (sliderWidth/2);      
      sliderValue = minZoomValue; 
      sliderY = minY;     
   }
   
   void render() {
      rectMode(CENTER);

      strokeWeight(0.5);     
      stroke(105, 105, 105); 
      
      // zoom control bar
      fill(0, 0, 0, 0);
      rect(barX+barWidth/2, minY+(maxY-minY)/2, barWidth, maxY-minY);
      
      // slider
      fill(105, 105, 105);
      rect(sliderX+sliderWidth/2, sliderY+sliderHeight/2, sliderWidth, sliderHeight);
   }
   
   float getZoomValue(int y) {
      if ((y >= minY) && (y <= (maxY - sliderHeight/2))) {
         sliderY = (int) (y - (sliderHeight/2));     
         if (sliderY < minY) { 
            sliderY = minY; 
         } 
         sliderValue = (y - minY) * valuePerY + minZoomValue;
      }     
      return sliderValue;
   }
    
   void updateZoomSlider(float value) {
      int tempY = (int) (value / valuePerY) + minY;
      if ((tempY >= minY) && (tempY <= (maxY-sliderHeight))) {
         sliderValue = value;
         sliderY = tempY;
      }
   }
   
   boolean isZoomSliderEvent(int x, int y) {
      int slop = 50;  // number of pixels above or below slider that's acceptable.  provided for ease of use.
      int sliderTop = (int) (sliderY - (sliderHeight/2)) - slop;
      int sliderBottom = sliderY + sliderHeight + slop;
      return ((x >= sliderX) && (x <= (sliderX    + sliderWidth)) && (y >= sliderTop)  && (y <= sliderBottom));
   }
   
}



