//Change if wanted
float g = 400; //gravity
float dt = 0.05; //simulation speed
float scaleNum = 1; //starting zoom
float minZoom = 0.5; //how far out you can go
float maxZoom = 1.5; //how close you can go
float zoomFactor = 0.01; //the speed factor of the zoom
int starCount = 100; //stars in the backdrop


//DO NOT TOUCH THESE
PVector cameraPos = new PVector(0,0);
int simulationCount = 0;
Scenerio newScn = null;
Scenerio currentSim;
ArrayList<Scenerio> simulations = new ArrayList<Scenerio>();
boolean backgroundDraw = false;
float simTime = 0;         // total simulation time (seconds)
float timeScale = 1.0;     // adjust how fast simulation time passes relative to real time
boolean paused = false;


//FOR ANIMTIONS
int celestialDuration = 0;
boolean collisionAnimationActive = false;
PVector animationPos;
float celestialEffectStartRadius;
color animationColor;
PVector [] backgroundStars = new PVector[starCount];




void setup() {
 size(800, 900);
 //load all scenerios and bodies from an outside text document 
 String[] scenerioData = loadStrings("sceneriosData.txt"); //NOTE: IF YOU WANT TO PLAY WITH THE BODY POSITONS, THE TEXT MUST BE EDITED
 

  for (int i = 0; i < scenerioData.length; i++) {
   //contains the "SCEN" part, indicating the creation of a new scenero
     String currentLine = scenerioData[i];
     
     // if the line is empty, the previous scenerio is done, and the program can continue itterating until a new line with "SCEN" pops up
     if (currentLine.equals("")) {
       newScn = null;

   }
   
   //indicates the creation of a new scenerio, and puts all following bodies into it's arrayList
   if (currentLine.contains("SCEN")) {
     
     String scenerioName = currentLine.substring(currentLine.indexOf(":") +1, currentLine.length());
     newScn = new Scenerio(scenerioName);
     simulations.add(newScn);
     
     
     }
     
    else if (newScn != null){
      
      //loads all info from the bodies listed 
       String[] celestialInfo = split(currentLine, " ");
       String celestialClass = celestialInfo[0];
       String celestialName = celestialInfo[1];
       PVector celestialPostion = new PVector(float(celestialInfo[2]), float(celestialInfo[3]));
       PVector celestialVelocity = new PVector(float(celestialInfo[4]), float(celestialInfo[5]));
       float celestialMass = float(celestialInfo[6]);
       float celestialRadius = float(celestialInfo[7]);
       color celestialColor = color(int(celestialInfo[8]), int(celestialInfo[9]), int(celestialInfo[10]));
       
       //make a new celestial body
       Celestial newBody = new Celestial(celestialClass, celestialName, celestialPostion, celestialVelocity, celestialMass, celestialRadius, celestialColor);
       newScn.addBody(newBody);
    
    }
     
     
  }
  

  
}

void draw() {
  
  currentSim = simulations.get(simulationCount);
    if (!paused) {
   currentSim.addTime();
  }
  background(0);
  currentSim.displayScenarioHUD(currentSim);
  
  if (currentSim.showBodyInfo) {
    currentSim.drawBodyInfoPanel(currentSim.selectedBody);
  }
  
  //apply all functions
  
  autoScaleCamera(currentSim.bodies);
  currentSim.drawBackground();
  applyCamera(currentSim.bodies);
  currentSim.DrawSim();
  
  
  
  

} 
  

 
  
