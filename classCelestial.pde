class Celestial {
  
  //define the fields
  String name,type;
  PVector location, velocity;
  Float mass,radius;
  color bodyColor;
  Trail bodyTrail;
  
  
  //constructors
  Celestial (String bodytype, String name , PVector pos , PVector vel, float m, float r, color nC) {
    this.type = bodytype;
    this.name = name;
    this.location = pos;
    this.velocity = vel;
    this.mass = m;
    this.radius = r;
    this.bodyColor = nC;
    this.bodyTrail = new Trail(pos.x, pos.y, color(255));
  
  }
  
//------------------------APPLYING FORCES/DRAWING--------------------------------------------|
  
  //methodss
  // semi-implicit (symplectic) Euler / Leapfrog- allows for dt (slowing down)
void applyForce(PVector force) {
                  // physics timestep (try 0.02 — smaller = more stable)
  PVector acceleration = PVector.div(force, this.mass);
  // update velocity (half or full step symplectic is fine here)
  this.velocity.add(PVector.mult(acceleration, dt));
  // update position using the physics velocity (no visual scaling)
  this.location.add(PVector.mult(this.velocity, dt));
}
  
  
  //constantly draws the circle
  void update() {
    fill(this.bodyColor);
    circle(this.location.x, this.location.y, radius);
  }
  


//------------------------COLLISION--------------------------------------------|

  //checks collsion between all bodies in one frame
//checks collision between all bodies in one frame
  boolean iscolliding(ArrayList<Celestial> bodies) {
    Celestial newBody;
    ArrayList<Celestial> toDelete  = new ArrayList<Celestial>();
    ArrayList<Celestial> toAdd = new ArrayList<Celestial>();

    for (int i = 0; i < bodies.size(); i++) {
      Celestial a = bodies.get(i);
      if (a == null) continue;
    
      // Only stars can merge - enabling full collsion often end simulaitons to early
      if (!a.type.equals("Star")) continue;

      for (int j = i + 1; j < bodies.size(); j++) {
        Celestial b = bodies.get(j);
        if (b == null) continue;

      

      float distBetween = dist(a.location.x, a.location.y, b.location.x, b.location.y);
      if (distBetween <= (a.radius / 2 + b.radius / 2)) {
        newBody = newCelestial(a, b);

        // marks objects to be destroyed after the loop (prevent errors)
        toAdd.add(newBody);
        toDelete.add(a);
        toDelete.add(b);
      }
    }
  }

 // Remove bodies marked for deletion in reverse order
  for (int i = bodies.size() - 1; i >= 0; i--) {
      Celestial c = bodies.get(i);
      if (toDelete.contains(c)) {
         bodies.remove(i);
      }
   }

  // Add the merged bodies
  for (int i = 0; i < toAdd.size(); i++) {
      bodies.add(toAdd.get(i));
   }
    return toAdd.size() > 0;
  }
    
    
   Celestial newCelestial(Celestial objOne, Celestial objTwo) {
     

     //calculate mass-weight average so heighvier bodies dominate (Similar to the average atomic mass)
     PVector addlocation = PVector.add(PVector.mult(objOne.location, objOne.mass), PVector.mult(objTwo.location, objTwo.mass));
     PVector newLocation = PVector.div(addlocation, (objOne.mass + objTwo.mass));
     
     //assuming density stays the same
     float newRadius = pow(pow(objOne.radius, 3) + pow(objTwo.radius, 3), 1.0/3.0); 
     
     //calculate the new velocity inherited by the previous bodies, spliting for readability 
     PVector addMovement = PVector.add(PVector.mult(objOne.velocity, objOne.mass), PVector.mult(objTwo.velocity, objTwo.mass));
     //integrate the division for the momentum conversation formula
     PVector newMovement = PVector.div(addMovement, (objOne.mass + objTwo.mass));
     
     //new mass is the combined mass of both objects - uses the conversation of mass rule
     float newMass = (objOne.mass + objTwo.mass);
     
     //makes color inheritance among mass
     float r = (red(objOne.bodyColor)*objOne.mass + red(objTwo.bodyColor)*objTwo.mass)/newMass;
     float g = (green(objOne.bodyColor)*objOne.mass + green(objTwo.bodyColor)*objTwo.mass)/newMass;
     float b = (blue(objOne.bodyColor)*objOne.mass + blue(objTwo.bodyColor)*objTwo.mass)/newMass;
     
     color newColor = color(r,g,b); //t
     

     
     //determining the new Celestial type
     String celestialType;
     
     //class inheritance
     if (objOne.type.equals(objTwo.type)) {
    celestialType = objOne.type;
    }  else if (objOne.type.equals("Star") && !objTwo.type.equals("Star")) {
    celestialType = "Star";
    } else if (objOne.type.equals("Planet") && !objTwo.type.equals("Sun")) {
    celestialType = "Planet";
    } else if (objOne.type.equals("Moon") && !objTwo.type.equals("Sun") && !objTwo.type.equals("Planet")) {
    celestialType = "Moon";
    } else {
      celestialType = "Asteroid";
    
    }
    
    
    triggerCelestialCollision(newLocation, newRadius, newColor);
    
    
    //make a new Celestial object
    return new Celestial(celestialType, "Merged" , newLocation, newMovement, newMass, newRadius, newColor); 
   
     
   }
   
    //drawing the trail
    void DrawTrail() {
     bodyTrail.update(this);
     bodyTrail.display();
   }
   
   
   
   
}
