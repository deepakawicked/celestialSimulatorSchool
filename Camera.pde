//does the math for scaleNum - the logic found in ApplyCamera
void autoScaleCamera(ArrayList<Celestial> bodies) {
    float padding = 100; // extra space around edges
    float dt = 1; // prediction to get that automatic zoom/in out efect

    // Find center of mass
    PVector center = findCenterofMass(bodies);
    
      
    
    

    // Find farthest object from center
    Celestial farthest = bodies.get(0);
    float maxDist = 0;
    
    //Constantly finds the body farthest from the center of mass or center object
    for (Celestial a : bodies) {
        float d = dist(a.location.x, a.location.y, center.x, center.y);
        if (d > maxDist) {
            maxDist = d;
            farthest = a;
        }
    }

    // predicts the future positon by adding velocity times the time - accurate for scaling 
    PVector futurePos = new PVector(farthest.location.x, farthest.location.y);
    futurePos.add(PVector.mult(farthest.velocity, dt));
    float futureDist = dist(futurePos.x, futurePos.y, center.x, center.y);

    // when scaling, the  coodernate system gets smaller, and the target scale must be scale according
    float targetScaleX = (width/2 - padding) / futureDist;
    float targetScaleY = (height/2 - padding) / futureDist;
    float targetScale = min(targetScaleX, targetScaleY); // fit both dimensions

    // smoothly ajust the scale towards the wanted Scale
    scaleNum += (targetScale - scaleNum) * zoomFactor;

    // constain the min max zoom
    scaleNum = constrain(scaleNum, minZoom, maxZoom);
}

 
 


//CAMERA ANCHORING

PVector findCenterofMass(ArrayList<Celestial> bodies) { //finds the center of mass
  float totalmass = 0;
  
  PVector centerOfGrav = new PVector(0,0);
  
  //center of mass = m1*mX1 + m1+mX2... / m1 + m2....
  
  for (Celestial s: bodies) {
    totalmass += s.mass;
    centerOfGrav.x += s.mass * s.location.x;
    centerOfGrav.y += s.mass * s.location.y;
   
  }
  
  return PVector.div(centerOfGrav, totalmass);
  
}


//applies the camera function, moves the camera
void applyCamera(ArrayList<Celestial> bodies) {
  
   PVector anchor = findCenterofMass(bodies);
   
   //move the coodernate system to the middle, makes it easier when doing the physics calculations
   translate(width/2, height/2);
   scale(scaleNum); 
   translate(-anchor.x  , -anchor.y);
   
 }
 
  
