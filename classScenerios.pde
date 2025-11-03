//Scenerio class, handles and updates their own respectiveb odies
class Scenerio {
  //Fields
  String name;
  ArrayList<Celestial> bodies = new ArrayList<Celestial>();
  float timePassed;
  Celestial selectedBody = null; // currently selected body
  boolean showBodyInfo = false;

  
  //Constructiors
  Scenerio(String n) {
    this.name = n;
  }
  
  //adds a new body to the ArrayList
  void addBody(Celestial object) {
    this.bodies.add(object);
  }
 void addTime() {
   this.timePassed += dt;
 }
 

//------------------------LABELS/VISUALS---------------------------------------------------------|

 
 //draws the star like background - for visuals only
  void drawBackground() {
  
    if (backgroundDraw) {
      for(PVector starBG: backgroundStars) {
        float transparency = random(150, 255); // slight transparency variation
        stroke(255, 244, 238, transparency);
        strokeWeight(starBG.z);
        point(starBG.x, starBG.y);
      
    
    }
  }
  
  else {
   // more stars for depth
    for (int i = 0; i < starCount; i++) {
      float x = random(width);
      float y = random(height);
      float size = random(1, 3); // vary star sizes for depth
      backgroundStars[i] = new PVector(x,y, size); //keep track of stardata in a array
    }

    backgroundDraw = true;
  }
    
    
 }

  
  void displayScenarioHUD(Scenerio s) {
    // HUD background box
    noStroke();
    fill(0, 150);
    rect(30, 55, 360, 150, 12);

    fill(255);
    textAlign(LEFT);
    textSize(20);
    text("Current Scenario: " + s.name, 60, 40);

    textSize(14);
    fill(200);
    text("Time Elapsed: " + nf(s.timePassed, 0, 2) + " s", 60, 60);
    text("Press [P] to Pause | [R] to Resume", 60, 80);
    text("Use [A] / [D] to Change Scenarios", 60, 100);
    text("Bodies: " + s.bodies.size(), 60, 120);
    text("Click on a body to get it's info ",  60, 140);
  
    // Optional: show dt and gravity
    fill(255);
    text("dt = " + nf(dt, 0, 3) + "   G = " + nf(g, 0, 2), 60, height - 50);
  }


  void drawBodyInfoPanel(Celestial body) {
    fill(20, 20, 20, 200);
    noStroke();
    rect(40, 140, 260, 180, 10);
  
    fill(255);
    textSize(18);
    text("Selected Body Info", width-180, 40);
  
    fill(200);
    textSize(14);
    text("Name: " + body.name, width-180, 60);
    text("Type: " + body.type, width-180, 80);
    text("Mass: " + nf(body.mass, 1, 2), width-180, 100);
    text("Radius: " + nf(body.radius, 1, 2), width-180, 120);
    text("Velocity: (" + nf(body.velocity.x, 1, 2) + ", " + nf(body.velocity.y, 1, 2) + ")", width-180, 140);
    text("Position: (" + nf(body.location.x, 1, 2) + ", " + nf(body.location.y, 1, 2) + ")", width-180, 160);
    text("Speed: " + nf(body.velocity.mag(), 1, 2), width-180, 180);
  }

//------------------------SIMULATION DRAWING--------------------------------------------|

 void DrawSim() {      
   // clear frame first
  
   
    // apply gravity between all bodies in one frame (allows mutliple body simulations)
    for (int i = 0; i < bodies.size(); i++) {
        Celestial a = bodies.get(i);
        for (int j = i + 1; j < bodies.size(); j++) {
            Celestial b = bodies.get(j);
            PVector force = applyGravityforce(a, b);
            //applies force through euleur integration
            a.applyForce(force);
            //applies force to the other body the opposite way - newtons third law
            b.applyForce(PVector.mult(force, -1));
        }
    }

    //updates and draws nww bodies with then new positons
    for (Celestial c : new ArrayList<Celestial>(bodies)) {
        c.DrawTrail();
        c.update();
        
        drawSunGlow(c);
        c.iscolliding(this.bodies); //check for collision between all bodies, feeding in the list
        drawCelestialCollision();
        
    }
  }
}
