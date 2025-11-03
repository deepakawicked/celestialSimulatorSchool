class Trail {
  
  //Fields
  ArrayList<PVector> trailList = new ArrayList<PVector>();
  int maxTrail = 30;
  color trailColor = color(0);
  PVector orgin;
  
  
 
 //Loading with inherited colors
 Trail(float orginX, float orginY, color nC) {
   this.orgin = new PVector(orginX, orginY);
   this.trailColor = nC;
 }
 
 //Metods
 
 //updats trial
  void update(Celestial orginBody) {
     trailList.add(new PVector(orginBody.location.x, orginBody.location.y));
     
     if (trailList.size() > maxTrail) {
       trailList.remove(0); //removes the last trail, allowing for it to appear dynamic and increasing with velicity
     }
  
  }
  //draw the trail
  void display() {
    
    stroke(trailColor);
    strokeWeight(2);
    
    if (trailList.size() < 4) {
      return; //prevents indexerrors
    }
    for(int i = 3; i < trailList.size(); i++) {
      PVector firstPoint = trailList.get(i-3);
      PVector secondPoint = trailList.get(i-2);
      PVector thirdPoint = trailList.get(i-1);
      PVector endPoint = trailList.get(i);
      
      //draws a curve between all combinations of points, with such a small scale it appears smooth
      curve(firstPoint.x, firstPoint.y, secondPoint.x, secondPoint.y, thirdPoint.x, thirdPoint.y, 
      endPoint.x, endPoint.y);
    
    }
  }

}
