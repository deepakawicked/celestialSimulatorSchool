//------------------------GRAVITY FORMULA---------------------------------------|
PVector applyGravityforce(Celestial a, Celestial b) {

  // Distance Vector
  PVector distance = new PVector(b.location.x - a.location.x, b.location.y - a.location.y);

  // r^2 (distance squared)
  float r_squared = sq(distance.x) + sq(distance.y);

  // avoid division by zero
  if (r_squared == 0) return new PVector(0, 0);

  // unit vector
  PVector rHat = new PVector(distance.x, distance.y);
  rHat.normalize();

  // force magnitude
  float f = (g * a.mass * b.mass) / r_squared;

  // make into a force vector
  PVector forcevec = PVector.mult(rHat, f);

  // return
  return forcevec;
}


//------------------------MOUSECLICK/KEYBOARD FUNCTIONS--------------------------|

//keep presses for moving between scenerios and pausing/resuming
void keyPressed() {
  if (key == 'a' || key == 'A') {
    simulationCount--;
  }
  if (key == 'd' || key == 'D') {
    simulationCount++;
  }
   if (key == 'p' || key == 'P') {
    noLoop();
    
    
  }
    if (key == 'r' || key == 'R') {
    loop();
  }
  

  // wrap around the count so the last goes to the first and vice verca
  if (simulationCount >= simulations.size()) {
    simulationCount = 0;
  }
  if (simulationCount < 0) {
    simulationCount = simulations.size() - 1;
  }

}

void mousePressed() {
  boolean clickedBody = false;

  //get the current center of mass or "anchor"
  PVector anchor = findCenterofMass(currentSim.bodies);

  // because camera scaling is used, using world coodernates does not scale with the camera scale, and there for the scaleNum
  // must be divided in for a return to proper function
  float worldX = (mouseX - width/2) / scaleNum + anchor.x;
  float worldY = (mouseY - height/2) / scaleNum + anchor.y;

  // check if the body is clicked
  for (Celestial c : currentSim.bodies) {
    float d = dist(worldX, worldY, c.location.x, c.location.y);
    if (d < c.radius) {
      currentSim.selectedBody = c;
      currentSim.showBodyInfo = true;
      clickedBody = true;
      println("Clicked on: " + currentSim.selectedBody.name);
      break;
    }
  }

  //if the oustide is clicked, deslect
  if (!clickedBody) {
    currentSim.selectedBody = null;
    currentSim.showBodyInfo = false;
  }
}

//------------------------POLISH/ANIMATION----------------------------------------|


//draws the sun glow
void drawSunGlow(Celestial sun) {
  noStroke();

  if (sun.type.equals("Star")){
   for (int i = 1; i <= 5; i++) { 
    float fadeOut = 100 - 40*i; // faint to fainter
    fill(red(sun.bodyColor), green(sun.bodyColor), blue(sun.bodyColor), fadeOut);
    float glowRadius = sun.radius * (1 + i*0.3); // slightly bigger circles
    ellipse(sun.location.x, sun.location.y, glowRadius, glowRadius);
  }


}
}


void triggerCelestialCollision(PVector pos, float startRadius, color c) {
  animationPos = new PVector(pos.x, pos.y);
  celestialEffectStartRadius = startRadius;
  animationColor = c;
  celestialDuration = 0;
  collisionAnimationActive = true;
  //triggers the drawCelestialCollision animation
} 


//can not be part of the celestial class because the animation would be processed in one frame
// this function gets turned on and off, like a floodgate, meaning the animation can work without
// a loop
void drawCelestialCollision() {
  if (!collisionAnimationActive) return; //terminates early if not true

  int totalFrames = 200; // frames of animation, assuming 60, will give around 3 secodns
  float progress = celestialDuration/ (float)totalFrames;

  // Ring expands
  float radius = celestialDuration * (1 + 10 * progress); 

  //
  float fading = 255 * (1 - progress); // fade it linearly without a loop, overitme through the nature of the draw() function 

  noFill();
  stroke(red(animationColor), green(animationColor), blue(animationColor), fading);
  strokeWeight(3);
  ellipse(animationPos.x, animationPos.y, radius*2, radius*2);

  celestialDuration++;
  
  //after done, turn off effect untl triggered again
  if (celestialDuration> totalFrames) {
    collisionAnimationActive = false; // end effect
  }
}
